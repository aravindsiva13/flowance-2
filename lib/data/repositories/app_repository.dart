
// lib/data/repositories/app_repository.dart

import '../models/user_model.dart';
import '../models/project_model.dart';
import '../models/task_model.dart';
import '../models/comment_model.dart';
import '../models/notification_model.dart';
import '../models/time_entry_model.dart';
import '../services/mock_api_service.dart';
import '../../core/enums/project_status.dart';
import '../../core/enums/task_status.dart';
import '../../core/enums/task_priority.dart';

class AppRepository {
  static final AppRepository _instance = AppRepository._internal();
  factory AppRepository() => _instance;
  AppRepository._internal();

  final MockApiService _apiService = MockApiService();

  // AUTH METHODS
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      return await _apiService.login(email, password);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      return await _apiService.register(name, email, password);
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  // USER METHODS
  Future<UserModel> getCurrentUser() async {
    try {
      return await _apiService.getCurrentUser();
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  Future<List<UserModel>> getUsers() async {
    try {
      return await _apiService.getUsers();
    } catch (e) {
      throw Exception('Failed to get users: ${e.toString()}');
    }
  }

  Future<UserModel> getUserById(String id) async {
    try {
      return await _apiService.getUserById(id);
    } catch (e) {
      throw Exception('Failed to get user: ${e.toString()}');
    }
  }

  Future<UserModel> updateUser(String id, Map<String, dynamic> data) async {
    try {
      return await _apiService.updateUser(id, data);
    } catch (e) {
      throw Exception('Failed to update user: ${e.toString()}');
    }
  }

  // PROJECT METHODS
  Future<List<ProjectModel>> getProjects({
    ProjectStatus? status,
    String? ownerId,
  }) async {
    try {
      return await _apiService.getProjects(status: status, ownerId: ownerId);
    } catch (e) {
      throw Exception('Failed to get projects: ${e.toString()}');
    }
  }

  Future<ProjectModel> getProjectById(String id) async {
    try {
      return await _apiService.getProjectById(id);
    } catch (e) {
      throw Exception('Failed to get project: ${e.toString()}');
    }
  }

  Future<ProjectModel> createProject(
    String name,
    String description, {
    required DateTime startDate,
    DateTime? endDate,
    DateTime? dueDate,
    List<String> memberIds = const [],
    ProjectStatus status = ProjectStatus.planning,
  }) async {
    try {
      final projectData = {
        'name': name,
        'description': description,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'dueDate': dueDate?.toIso8601String(),
        'memberIds': memberIds,
        'status': status.name,
      };
      return await _apiService.createProject(projectData);
    } catch (e) {
      throw Exception('Failed to create project: ${e.toString()}');
    }
  }

  Future<ProjectModel> updateProject(
    String projectId, {
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? dueDate,
    List<String>? memberIds,
    ProjectStatus? status,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (description != null) updateData['description'] = description;
      if (startDate != null) updateData['startDate'] = startDate.toIso8601String();
      if (endDate != null) updateData['endDate'] = endDate.toIso8601String();
      if (dueDate != null) updateData['dueDate'] = dueDate.toIso8601String();
      if (memberIds != null) updateData['memberIds'] = memberIds;
      if (status != null) updateData['status'] = status.name;

      return await _apiService.updateProject(projectId, updateData);
    } catch (e) {
      throw Exception('Failed to update project: ${e.toString()}');
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      await _apiService.deleteProject(id);
    } catch (e) {
      throw Exception('Failed to delete project: ${e.toString()}');
    }
  }

  // TASK METHODS
  Future<List<TaskModel>> getTasks({
    String? projectId,
    TaskStatus? status,
    TaskPriority? priority,
    String? assigneeId,
  }) async {
    try {
      return await _apiService.getTasks(
        projectId: projectId,
        status: status,
        priority: priority,
        assigneeId: assigneeId,
      );
    } catch (e) {
      throw Exception('Failed to get tasks: ${e.toString()}');
    }
  }

  Future<TaskModel> getTaskById(String id) async {
    try {
      return await _apiService.getTaskById(id);
    } catch (e) {
      throw Exception('Failed to get task: ${e.toString()}');
    }
  }

  Future<TaskModel> createTask(Map<String, dynamic> taskData) async {
    try {
      return await _apiService.createTask(taskData);
    } catch (e) {
      throw Exception('Failed to create task: ${e.toString()}');
    }
  }

  Future<TaskModel> updateTask(String taskId, Map<String, dynamic> updateData) async {
    try {
      return await _apiService.updateTask(taskId, updateData);
    } catch (e) {
      throw Exception('Failed to update task: ${e.toString()}');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _apiService.deleteTask(id);
    } catch (e) {
      throw Exception('Failed to delete task: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getTasksForExport({String? projectId}) async {
    try {
      final tasks = await _apiService.getTasks(projectId: projectId);
      return tasks.map((task) => {
        'ID': task.id,
        'Title': task.title,
        'Description': task.description,
        'Status': task.status.displayName,
        'Priority': task.priority.displayName,
        'Project ID': task.projectId,
        'Assignee ID': task.assigneeId ?? '',
        'Due Date': task.dueDate?.toIso8601String() ?? '',
        'Created At': task.createdAt.toIso8601String(),
        'Updated At': task.updatedAt.toIso8601String(),
      }).toList();
    } catch (e) {
      throw Exception('Failed to export tasks: ${e.toString()}');
    }
  }

  // TIME ENTRY METHODS
  Future<List<TimeEntryModel>> getTimeEntries({
    String? projectId,
    String? taskId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      return await _apiService.getTimeEntries(
        projectId: projectId,
        taskId: taskId,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      throw Exception('Failed to get time entries: ${e.toString()}');
    }
  }

  Future<TimeEntryModel> getTimeEntryById(String id) async {
    try {
      return await _apiService.getTimeEntryById(id);
    } catch (e) {
      throw Exception('Failed to get time entry: ${e.toString()}');
    }
  }

  Future<TimeEntryModel> createTimeEntry({
    required String description,
    required DateTime startTime,
    DateTime? endTime,
    String? projectId,
    String? taskId,
    bool isActive = false,
  }) async {
    try {
      final currentUser = await _apiService.getCurrentUser();
      return await _apiService.createTimeEntry(
        userId: currentUser.id,
        projectId: projectId,
        taskId: taskId,
        description: description,
        startTime: startTime,
        endTime: endTime,
        isActive: isActive,
      );
    } catch (e) {
      throw Exception('Failed to create time entry: ${e.toString()}');
    }
  }

  Future<TimeEntryModel> updateTimeEntry(
    String timeEntryId, {
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    bool? isActive,
  }) async {
    try {
      return await _apiService.updateTimeEntry(
        timeEntryId,
        description: description,
        startTime: startTime,
        endTime: endTime,
      );
    } catch (e) {
      throw Exception('Failed to update time entry: ${e.toString()}');
    }
  }

  Future<void> deleteTimeEntry(String id) async {
    try {
      await _apiService.deleteTimeEntry(id);
    } catch (e) {
      throw Exception('Failed to delete time entry: ${e.toString()}');
    }
  }

  Future<TimeEntryModel?> getActiveTimeEntry() async {
    try {
      return await _apiService.getActiveTimeEntry();
    } catch (e) {
      throw Exception('Failed to get active time entry: ${e.toString()}');
    }
  }

  Future<TimeEntryModel> startTimeEntry({
    required String taskId,
    required String projectId,
    required String description,
  }) async {
    try {
      return await _apiService.startTimer(
        taskId: taskId,
        projectId: projectId,
        description: description,
      );
    } catch (e) {
      throw Exception('Failed to start time entry: ${e.toString()}');
    }
  }

  Future<TimeEntryModel> stopTimeEntry(String timeEntryId) async {
    try {
      return await _apiService.stopTimer(timeEntryId);
    } catch (e) {
      throw Exception('Failed to stop time entry: ${e.toString()}');
    }
  }

  Future<TimeEntryModel> createManualTimeEntry({
    required String taskId,
    required String projectId,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      return await _apiService.createManualTimeEntry(
        taskId: taskId,
        projectId: projectId,
        description: description,
        startTime: startTime,
        endTime: endTime,
      );
    } catch (e) {
      throw Exception('Failed to create manual time entry: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getTimeEntriesForExport({
    DateTime? startDate,
    DateTime? endDate,
    String? projectId,
    String? taskId,
  }) async {
    try {
      final entries = await _apiService.getTimeEntries(
        startDate: startDate,
        endDate: endDate,
        projectId: projectId,
        taskId: taskId,
      );
      return entries.map((entry) => {
        'ID': entry.id,
        'User ID': entry.userId,
        'Task ID': entry.taskId,
        'Project ID': entry.projectId,
        'Description': entry.description,
        'Start Time': entry.startTime.toIso8601String(),
        'End Time': entry.endTime?.toIso8601String() ?? '',
        'Duration Hours': entry.durationHours.toStringAsFixed(2),
        'Type': entry.type.displayName,
        'Is Active': entry.isActive.toString(),
        'Created At': entry.createdAt.toIso8601String(),
      }).toList();
    } catch (e) {
      throw Exception('Failed to export time entries: ${e.toString()}');
    }
  }

  // COMMENT METHODS
  Future<List<CommentModel>> getComments(String taskId) async {
    try {
      return await _apiService.getComments(taskId);
    } catch (e) {
      throw Exception('Failed to get comments: ${e.toString()}');
    }
  }

  Future<CommentModel> createComment(Map<String, dynamic> commentData) async {
    try {
      return await _apiService.createComment(commentData);
    } catch (e) {
      throw Exception('Failed to create comment: ${e.toString()}');
    }
  }

  Future<CommentModel> updateComment(String commentId, String content) async {
    try {
      return await _apiService.updateComment(commentId, content);
    } catch (e) {
      throw Exception('Failed to update comment: ${e.toString()}');
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      await _apiService.deleteComment(commentId);
    } catch (e) {
      throw Exception('Failed to delete comment: ${e.toString()}');
    }
  }

  // NOTIFICATION METHODS
  Future<List<NotificationModel>> getNotifications({
    String? userId,
    bool? isRead,
  }) async {
    try {
      return await _apiService.getNotifications();
    } catch (e) {
      throw Exception('Failed to get notifications: ${e.toString()}');
    }
  }

  Future<NotificationModel> markNotificationAsRead(String id) async {
    try {
      return await _apiService.markNotificationAsRead(id);
    } catch (e) {
      throw Exception('Failed to mark notification as read: ${e.toString()}');
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      await _apiService.markAllNotificationsAsRead();
    } catch (e) {
      throw Exception('Failed to mark notifications as read: ${e.toString()}');
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _apiService.deleteNotification(id);
    } catch (e) {
      throw Exception('Failed to delete notification: ${e.toString()}');
    }
  }

  // DASHBOARD METHODS
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      return await _apiService.getDashboardStats();
    } catch (e) {
      throw Exception('Failed to get dashboard stats: ${e.toString()}');
    }
  }

  // ANALYTICS METHODS
  Future<Map<String, dynamic>> getProjectAnalytics(String projectId) async {
    try {
      return await _apiService.getProjectAnalytics(projectId);
    } catch (e) {
      throw Exception('Failed to get project analytics: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getUserAnalytics(String userId) async {
    try {
      return await _apiService.getUserAnalytics(userId);
    } catch (e) {
      throw Exception('Failed to get user analytics: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getTimeAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    String? projectId,
    String? userId,
  }) async {
    try {
      return await _apiService.getTimeAnalytics(
        startDate: startDate,
        endDate: endDate,
        projectId: projectId,
        userId: userId,
      );
    } catch (e) {
      throw Exception('Failed to get time analytics: ${e.toString()}');
    }
  }

  // SEARCH METHODS
  Future<Map<String, List<dynamic>>> search(String query) async {
    try {
      return await _apiService.search(query);
    } catch (e) {
      throw Exception('Failed to search: ${e.toString()}');
    }
  }

  Future<List<ProjectModel>> searchProjects(String query) async {
    try {
      return await _apiService.searchProjects(query);
    } catch (e) {
      throw Exception('Failed to search projects: ${e.toString()}');
    }
  }

  Future<List<TaskModel>> searchTasks(String query) async {
    try {
      return await _apiService.searchTasks(query);
    } catch (e) {
      throw Exception('Failed to search tasks: ${e.toString()}');
    }
  }

  Future<List<UserModel>> searchUsers(String query) async {
    try {
      return await _apiService.searchUsers(query);
    } catch (e) {
      throw Exception('Failed to search users: ${e.toString()}');
    }
  }
}