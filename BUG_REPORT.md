# Software Audit and Bug Report

## 1. Executive Summary

This audit has identified several systemic, high-severity architectural flaws that are the root cause of numerous bugs, performance issues, and potential security vulnerabilities throughout the application. The core issues can be summarized as follows:

*   **Violation of Single Source of Truth:** Multiple view models (`TaskViewModel`, `TimeTrackingViewModel`) maintain their own copies of project and user lists instead of sourcing this data from a central authority (`ProjectViewModel`). This leads to redundant API calls, a high risk of data inconsistency, and inefficient memory usage.
*   **Poor State Management Practices:** Many UI screens manage their own local state for loading and errors instead of relying on the provided view models. This results in boilerplate code, a lack of reactivity to state changes, and inconsistent error handling.
*   **Insecure Data Storage:** Sensitive information, such as the user's authentication token, is stored in plaintext using `SharedPreferences`, posing a significant security risk.
*   **Inefficient Client-Side Logic:** Filtering, sorting, and data validation are frequently and incorrectly performed on the client-side UI layer instead of being centralized in the business logic layer (the view models). This leads to performance bottlenecks and bugs.
*   **Unsafe Data Handling:** The code frequently uses unsafe methods like `firstWhere` without proper checks, leading to a high risk of crashes if data is not in the expected state.

Addressing these foundational architectural problems is critical. Fixing the individual bugs without correcting the underlying design flaws will result in a fragile and difficult-to-maintain codebase.

---

## 2. Authentication Flow Bugs

### 2.1. `auth_viewmodel.dart`

*   **Security Vulnerability (High Severity):**
    *   **Description:** The authentication token is stored in `SharedPreferences`, which is not secure. This data can be easily extracted on rooted/jailbroken devices or by attackers with physical access.
    *   **Recommendation:** Use `flutter_secure_storage` to store all sensitive data.

*   **Bug: Unnecessary Logout on Network Error (Medium Severity):**
    *   **Description:** The `initialize()` method logs the user out on any exception, including temporary network errors, leading to a poor user experience.
    *   **Recommendation:** The repository should differentiate between auth errors (401/403) and other network errors. The view model should only clear auth data on a specific authentication failure.

*   **Bug: Stale Error Messages (Low Severity):**
    *   **Description:** The `_errorMessage` state is not cleared on successful login or registration, which can cause a stale error message to appear on other screens.
    *   **Recommendation:** Clear the error message by calling `_clearError()` upon a successful login or registration.

### 2.2. `login_screen.dart`

*   **Bug: Persistent Error Message (Medium Severity):**
    *   **Description:** An error message from a failed login does not disappear when the user starts typing again.
    *   **Recommendation:** Add listeners to the text controllers to call `authViewModel.clearError()` when the input changes.

*   **Bug: Incorrect Navigation to Register Screen (Low Severity):**
    *   **Description:** The "Sign Up" button uses `pushReplacementNamed`, preventing the user from navigating back to the login screen.
    *   **Recommendation:** Use `pushNamed` to allow for standard back navigation.

*   **Missing Feature: "Forgot Password" (Low Severity):**
    *   **Description:** There is no password reset functionality.
    *   **Recommendation:** Implement a "Forgot Password" flow.

### 2.3. `register_screen.dart`

*   **Bug: Persistent Error Message (Medium Severity):**
    *   **Description:** Similar to the login screen, the error message persists after the user starts correcting their input.
    *   **Recommendation:** Add listeners to the text controllers to clear the error on input change.

---

## 3. Project Management Flow Bugs

### 3.1. `project_viewmodel.dart`

*   **Performance Issue: N+1 Problem (High Severity):**
    *   **Description:** `loadProjects()` fetches a list of projects and then makes N additional API calls (one per project) to get analytics data, causing extreme inefficiency.
    *   **Recommendation:** The backend API should be optimized to return this data in a single call. Failing that, analytics should be loaded lazily on the project detail screen, not in the main list.

*   **Bug: State Not Cleared on Error (Medium Severity):**
    *   **Description:** If `loadProjects()` fails, the UI shows stale data from a previous successful fetch along with an error message.
    *   **Recommendation:** In the `catch` block, clear the projects list (`_projects = []`) before setting the error.

*   **Bug: Silent Analytics Failures (Medium Severity):**
    *   **Description:** The `_loadProjectSpecificAnalytics` method catches and hides errors, causing projects to display incorrect "zero" data instead of an error state.
    *   **Recommendation:** Errors should be stored and exposed to the UI so that an error state can be shown for the specific project card that failed to load.

### 3.2. `projects_list_screen.dart`

*   **Bug: Redundant and Conflicting Filtering Logic (High Severity):**
    *   **Description:** The screen ignores the view model's filtering system and implements its own inefficient and buggy filtering logic in the `build` method.
    *   **Recommendation:** Remove all filtering logic from the UI. The UI should only call the filtering methods on the `ProjectViewModel` and render the list provided by it.

### 3.3. `create_project_screen.dart`

*   **Bug: Inefficient User Loading (Medium Severity):**
    *   **Description:** The screen calls `loadUsers()` in `initState`, resulting in a redundant API call, as the user list is likely already loaded by the previous screen.
    *   **Recommendation:** Remove the `loadUsers()` call. The screen should consume the user list that is already available in the `ProjectViewModel`.

*   **Bug: Missing Date Validation (Medium Severity):**
    *   **Description:** The form allows an end date to be set before a start date.
    *   **Recommendation:** Add validation in the `showDatePicker` dialogs and in the form submission logic to prevent invalid date ranges.

### 3.4. `project_detail_screen.dart`

*   **Architectural Flaw: Local State Management (High Severity):**
    *   **Description:** The screen uses its own local state (`_isLoading`, `_error`, `_project`) instead of consuming state from the `ProjectViewModel`. This makes the screen non-reactive and prone to showing stale data.
    *   **Recommendation:** Refactor the screen to be stateless and use a `Consumer<ProjectViewModel>` to build the UI based on the view model's state.

*   **Bug: Unsafe `firstWhere` Call (High Severity):**
    *   **Description:** The screen uses `firstWhere` to get the project from the view model's list, which will crash the app if the project is not found.
    *   **Recommendation:** Use a safe getter from the view model that can return `null`, and handle the "not found" case gracefully in the UI.

---

## 4. Task Management Flow Bugs

### 4.1. `task_viewmodel.dart`

*   **Architectural Flaw: Duplicate State (High Severity):**
    *   **Description:** The view model maintains its own lists of projects and users, duplicating state from `ProjectViewModel` and causing redundant API calls and data inconsistency.
    *   **Recommendation:** Remove the project and user lists and the methods that load them. This data should be sourced from other view models.

*   **Bug: Unsafe `firstWhere` with Misleading Fallback (Medium Severity):**
    *   **Description:** `getAssigneeName()` and `getProjectName()` use `firstWhere` with an `orElse` that returns dummy "Unknown" data, hiding the real bug of stale data and misleading the user.
    *   **Recommendation:** These methods should return `null` or throw an error if the data is not found, so the UI can handle the state explicitly.

### 4.2. `tasks_list_screen.dart`

*   **Architectural Flaw: Redundant Data Loading (High Severity):**
    *   **Description:** The screen calls `loadTasks`, `loadProjects`, and `loadUsers`, triggering the architectural flaw in the view model and causing a cascade of unnecessary API calls.
    *   **Recommendation:** The `_loadTasks()` method should only call `taskViewModel.loadTasks()`.

*   **Bug: Incorrect and Redundant Filtering Logic (High Severity):**
    *   **Description:** The screen implements its own multi-stage filtering in the `build` method, which is buggy and inefficient.
    *   **Recommendation:** Remove all filtering logic from the UI and delegate it to the `TaskViewModel`.

### 4.3. `create_task_screen.dart` & `edit_task_screen.dart`

*   **Architectural Flaw: Redundant Data Loading (High Severity):**
    *   **Description:** Both screens call `loadProjects()` and `loadUsers()` in `initState`, causing redundant API calls.
    *   **Recommendation:** Remove these calls. The dropdowns should be populated from an already-loaded central state object.

*   **Bug: Inconsistent and Poor Error Handling (Medium Severity):**
    *   **Description:** Both screens use `SnackBar` to show form errors, which is inconsistent with other parts of the app and a poor UX choice for form validation.
    *   **Recommendation:** Use a `Consumer` to listen to `taskViewModel.errorMessage` and display a persistent error message within the form.

---

## 5. Time Tracking Flow Bugs

### 5.1. `time_tracking_viewmodel.dart`

*   **Architectural Flaw: Duplicate State (High Severity):**
    *   **Description:** The view model maintains its own lists of projects and tasks, duplicating state and causing redundant API calls.
    *   **Recommendation:** This data should be sourced from `ProjectViewModel` and `TaskViewModel`.

*   **Race Condition in Time Entry Creation (High Severity):**
    *   **Description:** The check for overlapping time entries is performed on the client, which is not atomic. Two users can create overlapping entries simultaneously.
    *   **Recommendation:** Overlap validation must be handled atomically on the backend.

*   **Bug: Unsafe `firstWhere` Crash (High Severity):**
    *   **Description:** `startTimer` uses `firstWhere` to find a task in a potentially stale list, which can crash the app.
    *   **Recommendation:** The required task/project data should be passed directly to the method or fetched safely before use.

### 5.2. `timesheet_screen.dart`

*   **Architectural Flaw: Redundant Data Loading (High Severity):**
    *   **Description:** The screen calls `loadTimeEntries` and `loadSupportingData`, triggering redundant API calls for projects and tasks.
    *   **Recommendation:** The `_loadData` method should only call `loadTimeEntries`.

*   **Bug: Inefficient Client-Side Filtering (Medium Severity):**
    *   **Description:** The "Today" and "Week" tabs perform their own filtering in the `build` method instead of relying on the view model.
    *   **Recommendation:** The view model should provide pre-filtered lists for the UI to consume directly.

*   **Usability Issue: Date Picker Doesn't Update Data (Medium Severity):**
    *   **Description:** Selecting a new date in the date picker updates the UI header but does not reload the time entries for that date.
    *   **Recommendation:** The `onChanged` callback for the date picker should trigger a call to `timeTrackingVM.loadTimeEntries()` with the newly selected date.