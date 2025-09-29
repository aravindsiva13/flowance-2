# Application Flow Documentation

This document outlines the architectural and navigational flow of the Flowence project management application.

## 1. Application Entry Point and Initialization

The application's entry point is the `main()` function in `lib/main.dart`. This file is responsible for setting up the root widget of the application and initializing essential components.

### Key Components:

-   **`runApp(const MyApp())`**: This function inflates the root widget, `MyApp`, and attaches it to the screen.

-   **`MyApp` Widget**: This is a `StatelessWidget` that serves as the foundation of the application. Its primary role is to set up the state management and theme.

-   **`MultiProvider`**: The entire application is wrapped in a `MultiProvider` widget from the `provider` package. This makes multiple view models (state management classes) available to the entire widget tree. The initialized view models are:
    -   `AuthViewModel`: Manages authentication state and logic.
    -   `DashboardViewModel`: Manages data for the dashboard.
    -   `ProjectViewModel`: Handles project-related state.
    -   `TaskViewModel`: Manages task state.
    -   `UserViewModel`: Manages user data.
    -   `TimeTrackingViewModel`: Handles state for time tracking features.

-   **`MaterialApp`**: This is the core widget that sets up the application's material design structure. It is configured with:
    -   **`title`**: "Flowence - Project Manager".
    -   **`theme`**: A custom `ThemeData` object that defines the application-wide styling for colors, buttons, text fields, and more. Colors are centralized in `lib/core/constants/app_colors.dart`.
    -   **`initialRoute`**: The application starts at the `AppRoutes.splash` route, which is defined as `'/'`.
    -   **`onGenerateRoute`**: The `RouteGenerator.generateRoute` method is specified as the callback for handling all named routes. This centralizes navigation logic.

## 2. Routing and Navigation

Navigation in the application is managed by a centralized and well-structured routing system, which is composed of two main files located in the `lib/routes/` directory.

### `app_routes.dart`

-   **Purpose**: This file defines all the unique string constants for the named routes used in the application.
-   **Structure**: It contains a class `AppRoutes` with static constant strings for each route (e.g., `AppRoutes.login`, `AppRoutes.projectDetail`).
-   **Benefits**: Using static constants instead of raw strings prevents typos, makes route names easy to manage, and allows for autocompletion in the IDE. The class also includes helper methods for route validation and generating routes with parameters.

### `route_generator.dart`

-   **Purpose**: This file acts as the central hub for mapping route names to their corresponding screen widgets.
-   **Structure**: It contains a static method `generateRoute(RouteSettings settings)` that is called by the `MaterialApp`'s `onGenerateRoute` property.
-   **Logic**: The method uses a `switch` statement on the `settings.name` (the route name) to determine which screen to display. It creates and returns a `MaterialPageRoute` for the requested route.
-   **Argument Passing**: It handles passing arguments to screens. For example, when navigating to a project detail screen, it extracts the `projectId` from the `settings.arguments` and passes it to the `ProjectDetailScreen` constructor.
-   **Error Handling**: If a route is not found, it returns a generic error screen, preventing the app from crashing due to an invalid route.

## 3. User Authentication Flow

The application ensures that only authenticated users can access the main features. This flow begins as soon as the app starts.

1.  **`SplashScreen`**:
    -   When the app is launched, the `SplashScreen` (`lib/presentation/views/common/splash_screen.dart`) is the first screen displayed, as it is mapped to the initial route (`'/'`).
    -   Its primary responsibility is to determine the user's authentication state by checking for a valid session or token, likely by communicating with the `AuthViewModel`.

2.  **Conditional Navigation**:
    -   **Authenticated**: If the user is already logged in, the `SplashScreen` navigates them directly to the `MainNavigationScreen` (`AppRoutes.main`), which is the main hub of the application.
    -   **Unauthenticated**: If the user is not logged in, they are redirected to the `LoginScreen` (`AppRoutes.login`).

3.  **Login and Registration**:
    -   On the `LoginScreen`, the user can enter their credentials to log in or navigate to the `RegisterScreen` to create a new account.
    -   Upon successful login or registration, the `AuthViewModel` updates the authentication state, and the user is then navigated to the `MainNavigationScreen`.

## 4. Main Application Structure

Once authenticated, the user is directed to the `MainNavigationScreen` (`lib/presentation/views/common/main_navigation_screen.dart`), which serves as the primary user interface.

### `MainNavigationScreen`

This `StatefulWidget` is the core of the post-login user experience. It contains a `Scaffold` with a `BottomNavigationBar` to allow users to switch between the main sections of the application.

-   **`BottomNavigationBar`**: This widget provides navigation to five key areas:
    1.  **Dashboard**: (`DashboardScreen`) - The landing page, showing an overview of projects and tasks.
    2.  **Projects**: (`ProjectsListScreen`) - A list of all user-accessible projects.
    3.  **Tasks**: (`TasksListScreen`) - A list of all user-accessible tasks.
    4.  **Time**: (`TimesheetScreen`) - The section for time tracking and reporting.
    5.  **Profile**: (`ProfileScreen`) - User profile and settings.

-   **`IndexedStack`**: The body of the `Scaffold` is an `IndexedStack`. This widget holds the list of all five main screens and displays only the one corresponding to the selected tab. The primary advantage of `IndexedStack` is that it preserves the state of each screen, so the user's scroll position and other states are not lost when switching tabs.

-   **Dynamic UI Elements**:
    -   **`AppBar`**: The `AppBar` is dynamically built based on the selected tab. For example, the Dashboard has its own custom app bar, while other screens have a standard app bar with a title and context-specific action buttons (e.g., a search button on the Projects screen).
    -   **`FloatingActionButton` (FAB)**: The FAB also changes based on the selected tab and user permissions. For instance, a FAB to create a new project appears on the Projects tab, and a FAB to add a new task appears on the Tasks tab.

-   **Data Loading**: In the `initState` method, the screen pre-fetches initial data for the dashboard and time tracking sections using the `DashboardViewModel` and `TimeTrackingViewModel`. This ensures that data is ready to be displayed as soon as the user navigates to those sections.