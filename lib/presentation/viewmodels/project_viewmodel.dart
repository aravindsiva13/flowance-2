
import 'package:flutter/foundation.dart';
import '../../data/models/project_model.dart';
import '../../data/models/task_model.dart';
import '../../data/models/user_model.dart';
import '../../data/models/time_entry_model.dart';
import '../../data/repositories/app_repository.dart';
import '../../core/enums/project_status.dart';
import '../../core/enums/task_status.dart';
import '../../core/exceptions/app_exception.dart';

class ProjectViewModel extends ChangeNotifier {
  final AppRepository _repository = AppRepository();
  
  List<ProjectModel> _projects = [];
  List<UserModel> _availableUsers = [];
  bool _isLoading = false;
  bool _isCreating = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  String? _errorMessage;
  
  // Enhanced analytics data
  Map<String, dynamic> _projectAnalytics = {};
  Map<String, List<TimeEntryModel>> _projectTimeEntries = {};
  Map<String, double> _projectBudgets = {};
  Map<String, double> _projectProgress = {};
  
  // Filter and search
  ProjectStatus? _statusFilter;
  String? _searchQuery;
  String? _ownerFilter;
  
  // Getters
  List<ProjectModel> get projects => _filteredProjects;
  List<UserModel> get availableUsers => _availableUsers;
  List<UserModel> get users => _availableUsers; // Added for backward compatibility
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic> get projectAnalytics => _projectAnalytics;
  
  // Filtered projects based on current filters
  List<ProjectModel> get _filteredProjects {
    var filtered = _projects.where((project) {
      // Status filter
      if (_statusFilter != null && project.status != _statusFilter) {
        return false;
      }
      
      // Search query filter
      if (_searchQuery != null && _searchQuery!.isNotEmpty) {
        final query = _searchQuery!.toLowerCase();
        if (!project.name.toLowerCase().contains(query) &&
            !project.description.toLowerCase().contains(query)) {
          return false;
        }
      }
      
      // Owner filter
      if (_ownerFilter != null && project.ownerId != _ownerFilter) {
        return false;
      }
      
      return true;
    }).toList();
    
    // Sort by status priority and then by updated date
    filtered.sort((a, b) {
      final statusOrder = {
        ProjectStatus.active: 0,
        ProjectStatus.planning: 1,
        ProjectStatus.onHold: 2,
        ProjectStatus.completed: 3,
        ProjectStatus.cancelled: 4,
      };
      
      final statusComparison = statusOrder[a.status]!.compareTo(statusOrder[b.status]!);
      if (statusComparison != 0) return statusComparison;
      
      return b.updatedAt.compareTo(a.updatedAt);
    });
    
    return filtered;
  }

  // Search projects method for backward compatibility
  List<ProjectModel> searchProjects(String query) {
    return _projects.where((project) {
      final searchQuery = query.toLowerCase();
      return project.name.toLowerCase().contains(searchQuery) ||
             project.description.toLowerCase().contains(searchQuery);
    }).toList();
  }

  // Load users method for backward compatibility
  Future<void> loadUsers() async {
    await _loadAvailableUsers();
  }

  // Load projects with enhanced analytics
  Future<void> loadProjects({bool refresh = false}) async {
    if (_isLoading && !refresh) return;
    
    _setLoading(true);
    _clearError();
    
    try {
      _projects = await _repository.getProjects();
      await _loadProjectAnalytics();
      await _loadAvailableUsers();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load projects: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Load specific project by ID
  Future<void> loadProjectById(String projectId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final project = await _repository.getProjectById(projectId);
      
      // Update or add to projects list
      final index = _projects.indexWhere((p) => p.id == projectId);
      if (index >= 0) {
        _projects[index] = project;
      } else {
        _projects.add(project);
      }
      
      await _loadProjectSpecificAnalytics(projectId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load project: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Enhanced project analytics loading
  Future<void> _loadProjectAnalytics() async {
    for (final project in _projects) {
      await _loadProjectSpecificAnalytics(project.id);
    }
  }

  Future<void> _loadProjectSpecificAnalytics(String projectId) async {
    try {
      // Load tasks for this project
      final tasks = await _repository.getTasks(projectId: projectId);
      
      // Load time entries for this project
      final timeEntries = await _repository.getTimeEntries(projectId: projectId);
      _projectTimeEntries[projectId] = timeEntries;
      
      // Calculate analytics
      final analytics = _calculateProjectAnalytics(projectId, tasks, timeEntries);
      _projectAnalytics[projectId] = analytics;
      
      // Update project progress
      _projectProgress[projectId] = analytics['progress'] ?? 0.0;
      
    } catch (e) {
      debugPrint('Failed to load analytics for project $projectId: $e');
    }
  }

  Map<String, dynamic> _calculateProjectAnalytics(
    String projectId,
    List<TaskModel> tasks,
    List<TimeEntryModel> timeEntries,
  ) {
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((t) => t.status == TaskStatus.completed).length;
    final inProgressTasks = tasks.where((t) => t.status == TaskStatus.inProgress).length;
    
    final totalTime = timeEntries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + _getEntryDuration(entry),
    );
    
    final budgetHours = _projectBudgets[projectId] ?? 160.0; // Default 160 hours
    final budgetUsed = totalTime.inHours / budgetHours;
    
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
    
    // Calculate velocity (tasks completed per week)
    final project = _projects.firstWhere((p) => p.id == projectId);
    final weeksElapsed = DateTime.now().difference(project.startDate).inDays / 7;
    final velocity = weeksElapsed > 0 ? completedTasks / weeksElapsed : 0.0;
    
    // Calculate team productivity
    final teamProductivity = _calculateTeamProductivity(tasks, timeEntries);
    
    return {
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
      'inProgressTasks': inProgressTasks,
      'progress': progress,
      'totalTimeHours': totalTime.inHours,
      'budgetUsed': budgetUsed,
      'velocity': velocity,
      'teamProductivity': teamProductivity,
      'estimationAccuracy': _calculateEstimationAccuracy(tasks, timeEntries),
      'taskDistribution': _calculateTaskDistribution(tasks),
      'dailyProgress': _calculateDailyProgress(tasks),
    };
  }

  // Helper method to get duration from time entry
  Duration _getEntryDuration(TimeEntryModel entry) {
    if (entry.endTime != null) {
      return entry.endTime!.difference(entry.startTime);
    } else if (entry.isActive) {
      return DateTime.now().difference(entry.startTime);
    }
    return Duration.zero;
  }

  Map<String, double> _calculateTeamProductivity(
    List<TaskModel> tasks,
    List<TimeEntryModel> timeEntries,
  ) {
    final productivity = <String, double>{};
    
    // Group time entries by user
    final userTimeMap = <String, Duration>{};
    for (final entry in timeEntries) {
      userTimeMap[entry.userId] = (userTimeMap[entry.userId] ?? Duration.zero) + _getEntryDuration(entry);
    }
    
    // Calculate tasks completed per user
    final userTaskMap = <String, int>{};
    for (final task in tasks) {
      if (task.status == TaskStatus.completed && task.assigneeId != null) {
        userTaskMap[task.assigneeId!] = (userTaskMap[task.assigneeId!] ?? 0) + 1;
      }
    }
    
    // Calculate productivity as tasks/hour
    for (final userId in userTimeMap.keys) {
      final timeHours = userTimeMap[userId]!.inHours;
      final tasksCompleted = userTaskMap[userId] ?? 0;
      productivity[userId] = timeHours > 0 ? tasksCompleted / timeHours : 0.0;
    }
    
    return productivity;
  }

  double _calculateEstimationAccuracy(
    List<TaskModel> tasks,
    List<TimeEntryModel> timeEntries,
  ) {
    // This would calculate how accurate time estimates are vs actual time
    // For now, return a placeholder value
    return 0.78;
  }

  Map<String, int> _calculateTaskDistribution(List<TaskModel> tasks) {
    final distribution = <String, int>{};
    for (final status in TaskStatus.values) {
      distribution[status.name] = tasks.where((t) => t.status == status).length;
    }
    return distribution;
  }

  List<Map<String, dynamic>> _calculateDailyProgress(List<TaskModel> tasks) {
    // Calculate daily progress over the last 30 days
    final dailyProgress = <Map<String, dynamic>>[];
    final now = DateTime.now();
    
    for (int i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final tasksCompletedThatDay = tasks.where((task) {
        return task.status == TaskStatus.completed &&
               task.updatedAt.year == date.year &&
               task.updatedAt.month == date.month &&
               task.updatedAt.day == date.day;
      }).length;
      
      dailyProgress.add({
        'date': date,
        'tasksCompleted': tasksCompletedThatDay,
      });
    }
    
    return dailyProgress;
  }

  // Create project with enhanced features
  Future<void> createProject({
    required String name,
    required String description,
    required DateTime startDate,
    DateTime? endDate,
    DateTime? dueDate,
    List<String>? memberIds,
    double? budgetHours,
    ProjectStatus status = ProjectStatus.planning,
  }) async {
    _setCreating(true);
    _clearError();
    
    try {
      final project = await _repository.createProject(
  name,
  description,
  startDate: startDate,
  dueDate: dueDate,
        memberIds: memberIds ?? [],
        status: status,
      );
      
      _projects.add(project);
      
      // Set budget if provided
      if (budgetHours != null) {
        _projectBudgets[project.id] = budgetHours;
      }
      
      // Initialize analytics
      await _loadProjectSpecificAnalytics(project.id);
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to create project: ${e.toString()}');
      rethrow;
    } finally {
      _setCreating(false);
    }
  }

  // Update project with enhanced tracking
  Future<void> updateProject({
    required String projectId,
    String? name,
    String? description,
    ProjectStatus? status,
    DateTime? startDate,  // Add this parameter if missing
  DateTime? dueDate,
    DateTime? endDate,
    List<String>? memberIds,
    double? budgetHours,
  }) async {
    _setUpdating(true);
    _clearError();
    
    try {
      final updatedProject = await _repository.updateProject(
  projectId,
  name: name,
  description: description,
  startDate: startDate, // This should be the parameter from the method
  dueDate: dueDate,     // This should be the parameter from the method
  memberIds: memberIds,
  status: status,
);

      
      // Update in local list
      final index = _projects.indexWhere((p) => p.id == projectId);
      if (index >= 0) {
        _projects[index] = updatedProject;
      }
      
      // Update budget if provided
      if (budgetHours != null) {
        _projectBudgets[projectId] = budgetHours;
      }
      
      // Refresh analytics
      await _loadProjectSpecificAnalytics(projectId);
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to update project: ${e.toString()}');
      rethrow;
    } finally {
      _setUpdating(false);
    }
  }

  // Archive project
  Future<void> archiveProject(String projectId) async {
    _setUpdating(true);
    _clearError();
    
    try {
      await updateProject(
        projectId: projectId,
        status: ProjectStatus.completed,
      );
    } catch (e) {
      _setError('Failed to archive project: ${e.toString()}');
      rethrow;
    } finally {
      _setUpdating(false);
    }
  }

  // Duplicate project
  Future<String> duplicateProject(String projectId, {String? newName}) async {
    _setCreating(true);
    _clearError();
    
    try {
      final originalProject = _projects.firstWhere((p) => p.id == projectId);
      
      final duplicatedProject = await _repository.createProject(
  '${originalProject.name} (Copy)',
  originalProject.description,
  startDate: DateTime.now(),
  dueDate: originalProject.dueDate,
  memberIds: originalProject.memberIds,
  status: ProjectStatus.planning,
);
      
      _projects.add(duplicatedProject);
      
      // Copy budget settings
      if (_projectBudgets.containsKey(projectId)) {
        _projectBudgets[duplicatedProject.id] = _projectBudgets[projectId]!;
      }
      
      // Initialize analytics for new project
      await _loadProjectSpecificAnalytics(duplicatedProject.id);
      
      notifyListeners();
      return duplicatedProject.id;
    } catch (e) {
      _setError('Failed to duplicate project: ${e.toString()}');
      rethrow;
    } finally {
      _setCreating(false);
    }
  }

  // Project template creation
  Future<void> createProjectFromTemplate({
    required String templateId,
    required String name,
    required DateTime startDate,
    DateTime? endDate,
    List<String>? memberIds,
  }) async {
    _setCreating(true);
    _clearError();
    
    try {
      // This would load template data and create project
      // For now, create a basic project
      await createProject(
        name: name,
        description: 'Project created from template',
        startDate: startDate,
        endDate: endDate,
        memberIds: memberIds,
      );
    } catch (e) {
      _setError('Failed to create project from template: ${e.toString()}');
      rethrow;
    } finally {
      _setCreating(false);
    }
  }

  // Enhanced project insights
  Map<String, dynamic> getProjectInsights(String projectId) {
    final analytics = _projectAnalytics[projectId] ?? {};
    final timeEntries = _projectTimeEntries[projectId] ?? [];
    
    // Calculate additional insights
    final insights = <String, dynamic>{
      ...analytics,
      'riskLevel': _calculateProjectRisk(projectId),
      'recommendedActions': _getRecommendedActions(projectId),
      'teamWorkload': _calculateTeamWorkload(projectId),
      'timeUtilization': _calculateTimeUtilization(timeEntries),
      'milestoneStatus': _calculateMilestoneStatus(projectId),
    };
    
    return insights;
  }

  String _calculateProjectRisk(String projectId) {
    final analytics = _projectAnalytics[projectId] ?? {};
    final progress = analytics['progress'] ?? 0.0;
    final budgetUsed = analytics['budgetUsed'] ?? 0.0;
    
    if (budgetUsed > 0.9 && progress < 0.8) return 'High';
    if (budgetUsed > 0.7 && progress < 0.6) return 'Medium';
    return 'Low';
  }

  List<String> _getRecommendedActions(String projectId) {
    final actions = <String>[];
    final analytics = _projectAnalytics[projectId] ?? {};
    final progress = analytics['progress'] ?? 0.0;
    final budgetUsed = analytics['budgetUsed'] ?? 0.0;
    final velocity = analytics['velocity'] ?? 0.0;
    
    if (budgetUsed > 0.8) {
      actions.add('Review budget allocation');
    }
    if (velocity < 2.0) {
      actions.add('Consider increasing team capacity');
    }
    if (progress < 0.3) {
      actions.add('Review project scope and priorities');
    }
    
    return actions;
  }

  Map<String, double> _calculateTeamWorkload(String projectId) {
    // Calculate workload distribution among team members
    final project = _projects.firstWhere((p) => p.id == projectId);
    final workload = <String, double>{};
    
    for (final memberId in project.memberIds) {
      workload[memberId] = 0.8; // Placeholder calculation
    }
    
    return workload;
  }

  Map<String, dynamic> _calculateTimeUtilization(List<TimeEntryModel> timeEntries) {
    if (timeEntries.isEmpty) return {};
    
    final totalTime = timeEntries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + _getEntryDuration(entry),
    );
    
    final activeTime = timeEntries
        .where((entry) => !entry.description.toLowerCase().contains('break'))
        .fold<Duration>(Duration.zero, (sum, entry) => sum + _getEntryDuration(entry));
    
    return {
      'totalHours': totalTime.inHours,
      'activeHours': activeTime.inHours,
      'utilizationRate': totalTime.inHours > 0 ? activeTime.inHours / totalTime.inHours : 0.0,
    };
  }

  Map<String, dynamic> _calculateMilestoneStatus(String projectId) {
    // This would calculate milestone completion status
    return {
      'totalMilestones': 4,
      'completedMilestones': 2,
      'upcomingMilestones': 1,
      'overdueMilestones': 0,
    };
  }

  // Export project data
  Future<Map<String, dynamic>> exportProjectData(String projectId) async {
    try {
      final project = _projects.firstWhere((p) => p.id == projectId);
      final tasks = await _repository.getTasks(projectId: projectId);
      final timeEntries = _projectTimeEntries[projectId] ?? [];
      final analytics = _projectAnalytics[projectId] ?? {};
      
      return {
        'project': project.toJson(),
        'tasks': tasks.map((t) => t.toJson()).toList(),
        'timeEntries': timeEntries.map((t) => t.toJson()).toList(),
        'analytics': analytics,
        'exportDate': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      throw Exception('Failed to export project data: ${e.toString()}');
    }
  }

  // Filter and search methods
  void setStatusFilter(ProjectStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setSearchQuery(String? query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setOwnerFilter(String? ownerId) {
    _ownerFilter = ownerId;
    notifyListeners();
  }

  void clearFilters() {
    _statusFilter = null;
    _searchQuery = null;
    _ownerFilter = null;
    notifyListeners();
  }

  // Project budget management
  void setProjectBudget(String projectId, double budgetHours) {
    _projectBudgets[projectId] = budgetHours;
    notifyListeners();
  }

  double? getProjectBudget(String projectId) {
    return _projectBudgets[projectId];
  }

  double getProjectBudgetUsage(String projectId) {
    final timeEntries = _projectTimeEntries[projectId] ?? [];
    final totalHours = timeEntries.fold<Duration>(
      Duration.zero,
      (sum, entry) => sum + _getEntryDuration(entry),
    ).inHours;
    
    final budget = _projectBudgets[projectId] ?? 160.0;
    return budget > 0 ? totalHours / budget : 0.0;
  }

  // Load available users for project assignment
  Future<void> _loadAvailableUsers() async {
    try {
      _availableUsers = await _repository.getUsers();
    } catch (e) {
      debugPrint('Failed to load available users: $e');
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setCreating(bool creating) {
    _isCreating = creating;
    notifyListeners();
  }

  void _setUpdating(bool updating) {
    _isUpdating = updating;
    notifyListeners();
  }

  void _setDeleting(bool deleting) {
    _isDeleting = deleting;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Get project by ID
  ProjectModel? getProjectById(String projectId) {
    try {
      return _projects.firstWhere((p) => p.id == projectId);
    } catch (e) {
      return null;
    }
  }

  // Get project analytics
  Map<String, dynamic>? getProjectAnalytics(String projectId) {
    return _projectAnalytics[projectId];
  }

  // Get project time entries
  List<TimeEntryModel> getProjectTimeEntries(String projectId) {
    return _projectTimeEntries[projectId] ?? [];
  }

  // Calculate project health score
  double calculateProjectHealthScore(String projectId) {
    final analytics = _projectAnalytics[projectId];
    if (analytics == null) return 0.0;
    
    final progress = analytics['progress'] ?? 0.0;
    final budgetUsed = analytics['budgetUsed'] ?? 0.0;
    final velocity = analytics['velocity'] ?? 0.0;
    
    // Simple health score calculation
    double score = 100.0;
    
    // Deduct points for budget overrun
    if (budgetUsed > 1.0) {
      score -= (budgetUsed - 1.0) * 50;
    }
    
    // Deduct points for low velocity
    if (velocity < 2.0) {
      score -= (2.0 - velocity) * 10;
    }
    
    // Add points for good progress
    score += progress * 20;
    
    return score.clamp(0.0, 100.0);
  }

  // Delete project
  Future<void> deleteProject(String projectId) async {
    _setDeleting(true);
    _clearError();
    
    try {
      await _repository.deleteProject(projectId);
      
      // Remove from local list
      _projects.removeWhere((p) => p.id == projectId);
      
      // Clean up analytics data
      _projectAnalytics.remove(projectId);
      _projectTimeEntries.remove(projectId);
      _projectBudgets.remove(projectId);
      _projectProgress.remove(projectId);
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete project: ${e.toString()}');
      rethrow;
    } finally {
      _setDeleting(false);
    }
  }

  // Get projects by status
  List<ProjectModel> getProjectsByStatus(ProjectStatus status) {
    return _projects.where((p) => p.status == status).toList();
  }

  // Get projects by owner
  List<ProjectModel> getProjectsByOwner(String ownerId) {
    return _projects.where((p) => p.ownerId == ownerId).toList();
  }

  // Get user's projects (owned or member)
  List<ProjectModel> getUserProjects(String userId) {
    return _projects.where((p) => 
        p.ownerId == userId || p.memberIds.contains(userId)
    ).toList();
  }

  // Get project statistics
  Map<String, dynamic> getProjectStatistics() {
    final totalProjects = _projects.length;
    final activeProjects = _projects.where((p) => p.status == ProjectStatus.active).length;
    final completedProjects = _projects.where((p) => p.status == ProjectStatus.completed).length;
    final overdueProjects = _projects.where((p) => 
        p.dueDate != null && p.dueDate!.isBefore(DateTime.now()) && p.status != ProjectStatus.completed
    ).length;
    
    return {
      'totalProjects': totalProjects,
      'activeProjects': activeProjects,
      'completedProjects': completedProjects,
      'overdueProjects': overdueProjects,
      'completionRate': totalProjects > 0 ? completedProjects / totalProjects : 0.0,
    };
  }

  // Refresh project data
  Future<void> refreshProject(String projectId) async {
    await loadProjectById(projectId);
  }

  // Bulk operations
  Future<void> bulkUpdateProjectStatus(List<String> projectIds, ProjectStatus status) async {
    _setUpdating(true);
    _clearError();
    
    try {
      for (final projectId in projectIds) {
        await updateProject(projectId: projectId, status: status);
      }
    } catch (e) {
      _setError('Failed to bulk update projects: ${e.toString()}');
      rethrow;
    } finally {
      _setUpdating(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}