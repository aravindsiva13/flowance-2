



// // lib/data/services/mock_api_service.dart - Part 1 (Complete with Time Tracking - FIXED)

// import 'dart:math';
// import '../models/user_model.dart';
// import '../models/project_model.dart';
// import '../models/task_model.dart';
// import '../models/comment_model.dart';
// import '../models/notification_model.dart';
// import '../models/time_entry_model.dart';
// import '../../core/enums/user_role.dart';
// import '../../core/enums/project_status.dart';
// import '../../core/enums/task_status.dart';
// import '../../core/enums/task_priority.dart';

// class MockApiService {
//   static final MockApiService _instance = MockApiService._internal();
//   factory MockApiService() => _instance;
//   MockApiService._internal();

//   // In-memory data storage
//   final List<UserModel> _users = [];
//   final List<ProjectModel> _projects = [];
//   final List<TaskModel> _tasks = [];
//   final List<CommentModel> _comments = [];
//   final List<NotificationModel> _notifications = [];
//   final List<TimeEntryModel> _timeEntries = [];
  
//   String? _currentUserId;
//   bool _isDataInitialized = false;

//   // Initialize sample data
//   void _initializeData() {
//     if (_isDataInitialized) return;
    
//     _users.clear();
//     _projects.clear();
//     _tasks.clear();
//     _comments.clear();
//     _notifications.clear();
//     _timeEntries.clear();
    
//     _initializeUsers();
//     _createSampleProjects();
//     _createSampleTasks();
//     _createSampleComments();
//     _createSampleNotifications();
//     _createSampleTimeEntries();
    
//     _isDataInitialized = true;
//   }

//   // void _createSampleUsers() {
//   //   final now = DateTime.now();
//   //   _users.addAll([
//   //     UserModel(
//   //       id: '1',
//   //       name: 'Admin User',
//   //       email: 'admin@example.com',
//   //       role: UserRole.admin,
//   //       createdAt: now.subtract(const Duration(days: 100)),
//   //     ),
//   //     UserModel(
//   //       id: '2',
//   //       name: 'Jane Manager',
//   //       email: 'jane@example.com',
//   //       role: UserRole.projectManager,
//   //       createdAt: now.subtract(const Duration(days: 90)),
//   //     ),
//   //     UserModel(
//   //       id: '3',
//   //       name: 'Bob Developer',
//   //       email: 'bob@example.com',
//   //       role: UserRole.teamMember,
//   //       createdAt: now.subtract(const Duration(days: 80)),
//   //     ),
//   //     UserModel(
//   //       id: '4',
//   //       name: 'Alice Designer',
//   //       email: 'alice@example.com',
//   //       role: UserRole.teamMember,
//   //       createdAt: now.subtract(const Duration(days: 70)),
//   //     ),
//   //   ]);

//   //   _currentUserId ??= '3'; // Default to Bob Developer
//   // }



// //2

// void _initializeUsers() {
//   if (_users.isNotEmpty) return;
  
//   final now = DateTime.now();
  
//   _users.addAll([
//     UserModel(
//       id: '1',
//       name: 'John Doe',
//       email: 'john@flowence.com',
//       role: UserRole.admin,
//       createdAt: now.subtract(const Duration(days: 30)),
//       updatedAt: now.subtract(const Duration(days: 1)),
//       avatarUrl: null,
//     ),
//     UserModel(
//       id: '2',
//       name: 'Jane Smith',
//       email: 'jane@flowence.com',
//       role: UserRole.projectManager,
//       createdAt: now.subtract(const Duration(days: 25)),
//       updatedAt: now.subtract(const Duration(days: 2)),
//       avatarUrl: null,
//     ),
//     UserModel(
//       id: '3',
//       name: 'Bob Johnson',
//       email: 'bob@flowence.com',
//       role: UserRole.teamMember,
//       createdAt: now.subtract(const Duration(days: 20)),
//       updatedAt: now.subtract(const Duration(days: 3)),
//       avatarUrl: null,
//     ),
//     UserModel(
//       id: '4',
//       name: 'Alice Brown',
//       email: 'alice@flowence.com',
//       role: UserRole.teamMember,
//       createdAt: now.subtract(const Duration(days: 15)),
//       updatedAt: now.subtract(const Duration(days: 4)),
//       avatarUrl: null,
//     ),
//   ]);
// }



//   void _createSampleProjects() {
//     final now = DateTime.now();
//     _projects.addAll([
//       ProjectModel(
//         id: '1',
//         name: 'Mobile App Development',
//         description: 'Developing a cross-platform mobile application',
//         status: ProjectStatus.active,
//         ownerId: '2',
//         memberIds: ['2', '3', '4'],
//         startDate: now.subtract(const Duration(days: 30)),
//         dueDate: now.add(const Duration(days: 60)),
//         createdAt: now.subtract(const Duration(days: 30)),
//         updatedAt: now.subtract(const Duration(days: 1)),
//         progress: 0.45,
//       ),
//       ProjectModel(
//         id: '2',
//         name: 'Website Redesign',
//         description: 'Complete overhaul of company website',
//         status: ProjectStatus.active,
//         ownerId: '2',
//         memberIds: ['2', '4'],
//         startDate: now.subtract(const Duration(days: 15)),
//         dueDate: now.add(const Duration(days: 45)),
//         createdAt: now.subtract(const Duration(days: 15)),
//         updatedAt: now.subtract(const Duration(hours: 5)),
//         progress: 0.25,
//       ),
//       ProjectModel(
//         id: '3',
//         name: 'API Integration',
//         description: 'Integrate third-party APIs',
//         status: ProjectStatus.planning,
//         ownerId: '2',
//         memberIds: ['2', '3'],
//         startDate: now.add(const Duration(days: 7)),
//         dueDate: now.add(const Duration(days: 90)),
//         createdAt: now.subtract(const Duration(days: 5)),
//         updatedAt: now.subtract(const Duration(days: 2)),
//         progress: 0.0,
//       ),
//     ]);
//   }

//   void _createSampleTasks() {
//     final now = DateTime.now();
//     _tasks.addAll([
//       TaskModel(
//         id: '1',
//         title: 'Setup Flutter Project',
//         description: 'Initialize Flutter project with proper structure',
//         status: TaskStatus.inProgress,
//         priority: TaskPriority.high,
//         projectId: '1',
//         creatorId: '2',
//         assigneeId: '3',
//         dueDate: now.add(const Duration(days: 2)),
//         createdAt: now.subtract(const Duration(days: 5)),
//         updatedAt: now.subtract(const Duration(hours: 2)),
//       ),
//       TaskModel(
//         id: '2',
//         title: 'Design User Interface',
//         description: 'Create mockups and wireframes for main screens',
//         status: TaskStatus.inProgress,
//         priority: TaskPriority.medium,
//         projectId: '1',
//         creatorId: '2',
//         assigneeId: '4',
//         dueDate: now.add(const Duration(days: 7)),
//         createdAt: now.subtract(const Duration(days: 4)),
//         updatedAt: now.subtract(const Duration(hours: 1)),
//       ),
//       TaskModel(
//         id: '3',
//         title: 'Implement Authentication',
//         description: 'Set up user authentication with JWT',
//         status: TaskStatus.toDo,
//         priority: TaskPriority.high,
//         projectId: '1',
//         creatorId: '2',
//         assigneeId: '3',
//         dueDate: now.add(const Duration(days: 10)),
//         createdAt: now.subtract(const Duration(days: 3)),
//         updatedAt: now.subtract(const Duration(days: 1)),
//       ),
//       TaskModel(
//         id: '4',
//         title: 'Database Schema Design',
//         description: 'Design and implement database schema',
//         status: TaskStatus.done,
//         priority: TaskPriority.medium,
//         projectId: '1',
//         creatorId: '2',
//         assigneeId: '3',
//         dueDate: now.subtract(const Duration(days: 2)),
//         createdAt: now.subtract(const Duration(days: 10)),
//         updatedAt: now.subtract(const Duration(days: 3)),
//       ),
//       TaskModel(
//         id: '5',
//         title: 'Content Migration',
//         description: 'Migrate content from old website to new design',
//         status: TaskStatus.toDo,
//         priority: TaskPriority.low,
//         projectId: '2',
//         creatorId: '2',
//         assigneeId: '4',
//         dueDate: now.add(const Duration(days: 14)),
//         createdAt: now.subtract(const Duration(days: 2)),
//         updatedAt: now.subtract(const Duration(days: 1)),
//       ),
//     ]);
//   }

//   void _createSampleComments() {
//     final now = DateTime.now();
//     _comments.addAll([
//       CommentModel(
//         id: '1',
//         taskId: '1',
//         authorId: '3',
//         content: 'Started working on the project structure. Will have initial setup done by tomorrow.',
//         createdAt: now.subtract(const Duration(hours: 6)),
//       ),
//       CommentModel(
//         id: '2',
//         taskId: '3',
//         authorId: '3',
//         content: '@Jane Manager need help',
//         createdAt: now.subtract(const Duration(hours: 4)),
//         mentions: ['2'],
//       ),
//       CommentModel(
//         id: '3',
//         taskId: '3',
//         authorId: '2',
//         content: 'I can help you with that. Let\'s have a call tomorrow.',
//         createdAt: now.subtract(const Duration(hours: 2)),
//       ),
//     ]);
//   }

//   void _createSampleNotifications() {
//     final now = DateTime.now();
//     _notifications.addAll([
//       NotificationModel(
//         id: '1',
//         userId: '3',
//         type: NotificationType.taskAssigned,
//         title: 'New Task Assigned',
//         message: 'You have been assigned to "Implement Authentication"',
//         createdAt: now.subtract(const Duration(hours: 6)),
//         metadata: {'taskId': '3'},
//       ),
//       NotificationModel(
//         id: '2',
//         userId: '2',
//         type: NotificationType.mention,
//         title: 'You were mentioned',
//         message: 'Bob mentioned you in a comment',
//         createdAt: now.subtract(const Duration(hours: 4)),
//         metadata: {'taskId': '3', 'commentId': '2'},
//       ),
//       NotificationModel(
//         id: '3',
//         userId: '4',
//         type: NotificationType.deadlineReminder,
//         title: 'Deadline Approaching',
//         message: 'Task "Design User Interface" is due in 7 days',
//         createdAt: now.subtract(const Duration(hours: 1)),
//         metadata: {'taskId': '2'},
//       ),
//     ]);
//   }


//   // lib/data/services/mock_api_service.dart - Part 2 (FIXED - Time Entries and Auth Methods)

//   void _createSampleTimeEntries() {
//     final now = DateTime.now();
//     _timeEntries.addAll([
//       // Time entries for today
//       TimeEntryModel(
//         id: '1',
//         userId: '3',
//         taskId: '1',
//         projectId: '1',
//         description: 'Setting up initial project structure',
//         startTime: now.subtract(const Duration(hours: 3, minutes: 30)),
//         endTime: now.subtract(const Duration(hours: 1, minutes: 45)),
//         durationSeconds: 6300, // 1h 45m
//         type: TimeEntryType.tracked,
//         isActive: false,
//         createdAt: now.subtract(const Duration(hours: 3, minutes: 30)),
//         updatedAt: now.subtract(const Duration(hours: 1, minutes: 45)),
//       ),
      
//       TimeEntryModel(
//         id: '2',
//         userId: '4',
//         taskId: '2',
//         projectId: '1',
//         description: 'Working on wireframe designs',
//         startTime: now.subtract(const Duration(minutes: 45)),
//         endTime: null, // Active timer
//         durationSeconds: 0,
//         type: TimeEntryType.tracked,
//         isActive: true,
//         createdAt: now.subtract(const Duration(minutes: 45)),
//         updatedAt: now.subtract(const Duration(minutes: 45)),
//       ),
      
//       // Yesterday's entries
//       TimeEntryModel(
//         id: '3',
//         userId: '3',
//         taskId: '3',
//         projectId: '1',
//         description: 'JWT authentication research',
//         startTime: now.subtract(const Duration(days: 1, hours: 4)),
//         endTime: now.subtract(const Duration(days: 1, hours: 2)),
//         durationSeconds: 7200, // 2h
//         type: TimeEntryType.manual,
//         isActive: false,
//         createdAt: now.subtract(const Duration(days: 1, hours: 4)),
//         updatedAt: now.subtract(const Duration(days: 1, hours: 2)),
//       ),
      
//       TimeEntryModel(
//         id: '4',
//         userId: '4',
//         taskId: '2',
//         projectId: '1',
//         description: 'UI mockup creation',
//         startTime: now.subtract(const Duration(days: 1, hours: 6)),
//         endTime: now.subtract(const Duration(days: 1, hours: 3, minutes: 30)),
//         durationSeconds: 9000, // 2h 30m
//         type: TimeEntryType.tracked,
//         isActive: false,
//         createdAt: now.subtract(const Duration(days: 1, hours: 6)),
//         updatedAt: now.subtract(const Duration(days: 1, hours: 3, minutes: 30)),
//       ),
      
//       // This week's entries
//       TimeEntryModel(
//         id: '5',
//         userId: '3',
//         taskId: '1',
//         projectId: '1',
//         description: 'Flutter configuration',
//         startTime: now.subtract(const Duration(days: 2, hours: 3)),
//         endTime: now.subtract(const Duration(days: 2, hours: 1)),
//         durationSeconds: 7200, // 2h
//         type: TimeEntryType.tracked,
//         isActive: false,
//         createdAt: now.subtract(const Duration(days: 2, hours: 3)),
//         updatedAt: now.subtract(const Duration(days: 2, hours: 1)),
//       ),
      
//       TimeEntryModel(
//         id: '6',
//         userId: '2',
//         taskId: '5',
//         projectId: '2',
//         description: 'Planning content migration',
//         startTime: now.subtract(const Duration(days: 3, hours: 2)),
//         endTime: now.subtract(const Duration(days: 3, hours: 1)),
//         durationSeconds: 3600, // 1h
//         type: TimeEntryType.manual,
//         isActive: false,
//         createdAt: now.subtract(const Duration(days: 3, hours: 2)),
//         updatedAt: now.subtract(const Duration(days: 3, hours: 1)),
//       ),
//     ]);
//   }

//   // Auth Methods
//   // Future<Map<String, dynamic>> login(String email, String password) async {
//   //   await Future.delayed(const Duration(milliseconds: 500));
//   //   _initializeData();
    
//   //   final user = _users.firstWhere(
//   //     (user) => user.email == email,
//   //     orElse: () => throw Exception('Invalid credentials'),
//   //   );

//   //   _currentUserId = user.id;
    
//   //   return {
//   //     'token': 'mock_jwt_token_${user.id}',
//   //     'user': user.toJson(),
//   //     'expiresAt': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
//   //   };
//   // }


//   //2


//   Future<Map<String, dynamic>> login(String email, String password) async {
//   await Future.delayed(const Duration(milliseconds: 500));
//   _initializeData();
  
//   // Handle default demo credentials
//   if (email == 'admin@example.com' && password == 'password') {
//     _currentUserId = '1'; // Set to admin user
//     final user = _users.firstWhere((user) => user.id == '1');
    
//     return {
//       'token': 'mock_jwt_token_${user.id}',
//       'user': user.toJson(),
//       'expiresAt': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
//     };
//   }
  
//   // Try to find user by email
//   try {
//     final user = _users.firstWhere(
//       (user) => user.email == email,
//     );
    
//     _currentUserId = user.id;
    
//     return {
//       'token': 'mock_jwt_token_${user.id}',
//       'user': user.toJson(),
//       'expiresAt': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
//     };
//   } catch (e) {
//     throw Exception('Invalid credentials');
//   }
// }

//   Future<Map<String, dynamic>> register(String name, String email, String password) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     _initializeData();
    
//     if (_users.any((user) => user.email == email)) {
//       throw Exception('Email already exists');
//     }

//     final newUser = UserModel(
//   id: (_users.length + 1).toString(),
//   name: name,
//   email: email,
//   role: UserRole.teamMember,
//   createdAt: DateTime.now(),
//   updatedAt: DateTime.now(),
//   avatarUrl: null,
// );
//     _users.add(newUser);
//     _currentUserId = newUser.id;

//     return {
//       'token': 'mock_jwt_token_${newUser.id}',
//       'user': newUser.toJson(),
//       'expiresAt': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
//     };
//   }

//   Future<void> logout() async {
//     await Future.delayed(const Duration(milliseconds: 200));
//     _currentUserId = null;
//   }

//   Future<UserModel> getCurrentUser() async {
//     await Future.delayed(const Duration(milliseconds: 100));
//     _initializeData();
    
//     if (_currentUserId == null) {
//       throw Exception('User not authenticated');
//     }

//     return _users.firstWhere(
//       (user) => user.id == _currentUserId,
//       orElse: () => throw Exception('User not found'),
//     );
//   }

//   // User Methods
//   Future<List<UserModel>> getUsers() async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     _initializeData();
//     return List.from(_users);
//   }

//   Future<UserModel> getUserById(String id) async {
//     await Future.delayed(const Duration(milliseconds: 200));
//     _initializeData();
    
//     return _users.firstWhere(
//       (user) => user.id == id,
//       orElse: () => throw Exception('User not found'),
//     );
//   }

//   // Project Methods
//   Future<List<ProjectModel>> getProjects({
//     ProjectStatus? status,
//     String? ownerId,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 400));
//     _initializeData();
    
//     final currentUser = await getCurrentUser();
    
//     var projects = _projects.where((project) => 
//       project.memberIds.contains(currentUser.id) || 
//       project.ownerId == currentUser.id
//     ).toList();

//     if (status != null) {
//       projects = projects.where((project) => project.status == status).toList();
//     }

//     if (ownerId != null) {
//       projects = projects.where((project) => project.ownerId == ownerId).toList();
//     }

//     return projects..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
//   }

//   Future<ProjectModel> getProjectById(String id) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     _initializeData();
    
//     return _projects.firstWhere(
//       (project) => project.id == id,
//       orElse: () => throw Exception('Project not found'),
//     );
//   }

// Future<ProjectModel> createProject(Map<String, dynamic> projectData) async {
//   await Future.delayed(const Duration(milliseconds: 600));
//   _initializeData();
  
//   final currentUser = await getCurrentUser();
//   if (!currentUser.role.canCreateProjects) {
//     throw Exception('Permission denied');
//   }
  
//   final newProject = ProjectModel(
//     id: (_projects.length + 1).toString(),
//     name: projectData['name'],
//     description: projectData['description'] ?? '',
//     status: ProjectStatus.values.firstWhere(
//       (e) => e.name == (projectData['status'] ?? 'planning'),
//       orElse: () => ProjectStatus.planning,
//     ),
//     ownerId: currentUser.id,
//     memberIds: List<String>.from(projectData['memberIds'] ?? [currentUser.id]),
//     startDate: projectData['startDate'] != null ? DateTime.parse(projectData['startDate']) : DateTime.now(),
//     dueDate: projectData['dueDate'] != null ? DateTime.parse(projectData['dueDate']) : null,
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//   );
  
//   _projects.add(newProject);
//   return newProject;
// }


//   Future<ProjectModel> updateProject(String projectId, Map<String, dynamic> updateData) async {
//   await Future.delayed(const Duration(milliseconds: 500));
//   _initializeData();
  
//   final index = _projects.indexWhere((project) => project.id == projectId);
//   if (index == -1) throw Exception('Project not found');
  
//   final project = _projects[index];
//   final updatedProject = project.copyWith(
//     name: updateData['name'],
//     description: updateData['description'],
//     status: updateData['status'] != null ? 
//       ProjectStatus.values.firstWhere((e) => e.name == updateData['status']) : null,
//     memberIds: updateData['memberIds'] != null ? List<String>.from(updateData['memberIds']) : null,
//     dueDate: updateData['dueDate'] != null ? DateTime.parse(updateData['dueDate']) : null,
//     updatedAt: DateTime.now(),
//   );
  
//   _projects[index] = updatedProject;
//   return updatedProject;
// }

//   Future<void> deleteProject(String id) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     _initializeData();
    
//     final index = _projects.indexWhere((project) => project.id == id);
//     if (index == -1) throw Exception('Project not found');

//     _projects.removeAt(index);
    
//     // Also delete associated tasks
//     _tasks.removeWhere((task) => task.projectId == id);
    
//     // Delete associated time entries
//     _timeEntries.removeWhere((entry) => entry.projectId == id);
//   }

// Future<void> addProjectMember(String projectId, String userId) async {
//   await Future.delayed(const Duration(milliseconds: 300));
//   _initializeData();
  
//   final index = _projects.indexWhere((project) => project.id == projectId);
//   if (index == -1) throw Exception('Project not found');
  
//   final project = _projects[index];
//   if (!project.memberIds.contains(userId)) {
//     final updatedProject = project.copyWith(
//       memberIds: [...project.memberIds, userId],
//       updatedAt: DateTime.now(),
//     );
//     _projects[index] = updatedProject;
//   }
// }

// Future<void> removeProjectMember(String projectId, String userId) async {
//   await Future.delayed(const Duration(milliseconds: 300));
//   _initializeData();
  
//   final index = _projects.indexWhere((project) => project.id == projectId);
//   if (index == -1) throw Exception('Project not found');
  
//   final project = _projects[index];
//   final updatedMemberIds = project.memberIds.where((id) => id != userId).toList();
  
//   final updatedProject = project.copyWith(
//     memberIds: updatedMemberIds,
//     updatedAt: DateTime.now(),
//   );
//   _projects[index] = updatedProject;
// }

// Future<void> deleteNotification(String id) async {
//   await Future.delayed(const Duration(milliseconds: 300));
//   _initializeData();
  
//   final index = _notifications.indexWhere((notification) => notification.id == id);
//   if (index == -1) throw Exception('Notification not found');
  
//   _notifications.removeAt(index);
// }

//   // lib/data/services/mock_api_service.dart - Part 3 (FIXED - Task and Comment Methods)

//   // Task Methods
//   Future<List<TaskModel>> getTasks({
//     String? projectId,
//     TaskStatus? status,
//     TaskPriority? priority,
//     String? assigneeId,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 400));
//     _initializeData();
    
//     var tasks = List<TaskModel>.from(_tasks);

//     if (projectId != null) {
//       tasks = tasks.where((task) => task.projectId == projectId).toList();
//     }

//     if (status != null) {
//       tasks = tasks.where((task) => task.status == status).toList();
//     }

//     if (priority != null) {
//       tasks = tasks.where((task) => task.priority == priority).toList();
//     }

//     if (assigneeId != null) {
//       tasks = tasks.where((task) => task.assigneeId == assigneeId).toList();
//     }

//     return tasks..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
//   }

//   Future<TaskModel> getTaskById(String id) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     _initializeData();
    
//     return _tasks.firstWhere(
//       (task) => task.id == id,
//       orElse: () => throw Exception('Task not found'),
//     );
//   }

// //   Future<TaskModel> createTask(TaskModel task) async {
// //     await Future.delayed(const Duration(milliseconds: 600));
// //     _initializeData();
    
// //     final newTask = TaskModel(
// //       id: (_tasks.length + 1).toString(),
// //       title: task.title,
// //       description: task.description,
// //       status: task.status,
// //       priority: task.priority,
// //       projectId: task.projectId,
// //       creatorId: task.creatorId,
// //       assigneeId: task.assigneeId,
// //       dueDate: task.dueDate,
// //       createdAt: DateTime.now(),
// //       updatedAt: DateTime.now(),
// //     );

// //     _tasks.add(newTask);
    
// //     // Create notification for assignee
// //     if (newTask.assigneeId != null) {
// //       _createNotification(
// //         newTask.assigneeId!,
// //         NotificationType.taskAssigned,
// //         'New Task Assigned',
// //         'You have been assigned to "${newTask.title}"',
// //         {'taskId': newTask.id},
// //       );
// //     }

// //     return newTask;
// //   }

// //   Future<TaskModel> updateTask(String id, TaskModel updates) async {
// //     await Future.delayed(const Duration(milliseconds: 500));
// //     _initializeData();
    
// //     final index = _tasks.indexWhere((task) => task.id == id);
// //     if (index == -1) throw Exception('Task not found');

// //     final originalTask = _tasks[index];
// //     final updatedTask = originalTask.copyWith(
// //   id: (_tasks.length + 1).toString(),
// //   title: '${originalTask.title} (Copy)',
// //   createdAt: DateTime.now(),
// //   updatedAt: DateTime.now(),
// // );

// //     _tasks[index] = updatedTask;
    
// //     // Create notification for new assignee
// //     if (updates.assigneeId != null && updates.assigneeId != originalTask.assigneeId) {
// //       _createNotification(
// //         updates.assigneeId!,
// //         NotificationType.taskAssigned,
// //         'Task Assigned',
// //         'You have been assigned to "${updatedTask.title}"',
// //         {'taskId': updatedTask.id},
// //       );
// //     }

// //     return updatedTask;
// //   }



// //2


// Future<TaskModel> createTask(Map<String, dynamic> taskData) async {
//   await Future.delayed(const Duration(milliseconds: 600));
//   _initializeData();
  
//   final currentUser = await getCurrentUser();
  
//   final newTask = TaskModel(
//     id: (_tasks.length + 1).toString(),
//     title: taskData['title'],
//     description: taskData['description'] ?? '',
//     status: TaskStatus.values.firstWhere(
//       (e) => e.name == (taskData['status'] ?? 'toDo'),
//       orElse: () => TaskStatus.toDo,
//     ),
//     priority: TaskPriority.values.firstWhere(
//       (e) => e.name == (taskData['priority'] ?? 'medium'),
//       orElse: () => TaskPriority.medium,
//     ),
//     projectId: taskData['projectId'],
//     creatorId: currentUser.id,
//     assigneeId: taskData['assigneeId'],
//     dueDate: taskData['dueDate'] != null ? DateTime.parse(taskData['dueDate']) : null,
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     tags: List<String>.from(taskData['tags'] ?? []),
//     progress: 0.0,
//   );
  
//   _tasks.add(newTask);
//   return newTask;
// }

// Future<TaskModel> updateTask(String taskId, Map<String, dynamic> updateData) async {
//   await Future.delayed(const Duration(milliseconds: 500));
//   _initializeData();
  
//   final index = _tasks.indexWhere((task) => task.id == taskId);
//   if (index == -1) throw Exception('Task not found');
  
//   final task = _tasks[index];
//   final updatedTask = task.copyWith(
//     title: updateData['title'],
//     description: updateData['description'],
//     status: updateData['status'] != null ? 
//       TaskStatus.values.firstWhere((e) => e.name == updateData['status']) : null,
//     priority: updateData['priority'] != null ?
//       TaskPriority.values.firstWhere((e) => e.name == updateData['priority']) : null,
//     assigneeId: updateData['assigneeId'],
//     dueDate: updateData['dueDate'] != null ? DateTime.parse(updateData['dueDate']) : null,
//     progress: updateData['progress']?.toDouble(),
//     tags: updateData['tags'] != null ? List<String>.from(updateData['tags']) : null,
//     updatedAt: DateTime.now(),
//   );
  
//   _tasks[index] = updatedTask;
//   return updatedTask;
// }

// Future<CommentModel> createComment(Map<String, dynamic> commentData) async {
//   await Future.delayed(const Duration(milliseconds: 400));
//   _initializeData();
  
//   final currentUser = await getCurrentUser();
  
//   final newComment = CommentModel(
//     id: (_comments.length + 1).toString(),
//     content: commentData['content'],
//     authorId: currentUser.id,
//     taskId: commentData['taskId'],
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     mentions: List<String>.from(commentData['mentions'] ?? []),
//   );
  
//   _comments.add(newComment);
//   return newComment;
// }

//   Future<void> deleteTask(String id) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     _initializeData();
    
//     final index = _tasks.indexWhere((task) => task.id == id);
//     if (index == -1) throw Exception('Task not found');

//     _tasks.removeAt(index);
    
//     // Also delete associated comments and time entries
//     _comments.removeWhere((comment) => comment.taskId == id);
//     _timeEntries.removeWhere((entry) => entry.taskId == id);
//   }

//   // Comment Methods
//   Future<List<CommentModel>> getComments(String taskId) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     _initializeData();
    
//     return _comments.where((comment) => comment.taskId == taskId).toList()
//       ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
//   }

//   // Notification Methods
//   Future<List<NotificationModel>> getNotifications() async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     _initializeData();
    
//     final currentUser = await getCurrentUser();
    
//     return _notifications.where((notification) => 
//       notification.userId == currentUser.id).toList()
//       ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
//   }

//   Future<NotificationModel> markNotificationAsRead(String id) async {
//     await Future.delayed(const Duration(milliseconds: 200));
//     _initializeData();
    
//     final index = _notifications.indexWhere((notification) => notification.id == id);
//     if (index == -1) throw Exception('Notification not found');
    
//     final updatedNotification = _notifications[index].copyWith(isRead: true);
//     _notifications[index] = updatedNotification;
    
//     return updatedNotification;
//   }

//   Future<void> markAllNotificationsAsRead() async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     _initializeData();
    
//     final currentUser = await getCurrentUser();
    
//     for (int i = 0; i < _notifications.length; i++) {
//       if (_notifications[i].userId == currentUser.id && !_notifications[i].isRead) {
//         _notifications[i] = _notifications[i].copyWith(isRead: true);
//       }
//     }
//   }

//   // TIME TRACKING METHODS

//   // Get time entries with optional filters
//   Future<List<TimeEntryModel>> getTimeEntries({
//     DateTime? startDate,
//     DateTime? endDate,
//     String? projectId,
//     String? taskId,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 400));
//     _initializeData();
    
//     final currentUser = await getCurrentUser();
//     var entries = _timeEntries.where((entry) => entry.userId == currentUser.id).toList();
    
//     if (startDate != null) {
//       entries = entries.where((entry) => 
//         entry.startTime.isAfter(startDate.subtract(const Duration(days: 1)))
//       ).toList();
//     }
    
//     if (endDate != null) {
//       final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
//       entries = entries.where((entry) => 
//         entry.startTime.isBefore(endOfDay.add(const Duration(days: 1)))
//       ).toList();
//     }
    
//     if (projectId != null) {
//       entries = entries.where((entry) => entry.projectId == projectId).toList();
//     }
    
//     if (taskId != null) {
//       entries = entries.where((entry) => entry.taskId == taskId).toList();
//     }
    
//     return entries..sort((a, b) => b.startTime.compareTo(a.startTime));
//   }

//   // Start a new time entry
//   Future<TimeEntryModel> startTimeEntry({
//     required String taskId,
//     required String projectId,
//     required String description,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     _initializeData();
    
//     final currentUser = await getCurrentUser();
    
//     // Stop any existing active timer for this user
//     for (int i = 0; i < _timeEntries.length; i++) {
//       if (_timeEntries[i].userId == currentUser.id && _timeEntries[i].isActive) {
//         final duration = DateTime.now().difference(_timeEntries[i].startTime).inSeconds;
//         _timeEntries[i] = _timeEntries[i].copyWith(
//           isActive: false,
//           endTime: DateTime.now(),
//           durationSeconds: duration,
//         );
//       }
//     }
    
//     final newEntry = TimeEntryModel.createTimer(
//       id: (_timeEntries.length + 1).toString(),
//       userId: currentUser.id,
//       taskId: taskId,
//       projectId: projectId,
//       description: description,
//     );
    
//     _timeEntries.add(newEntry);
//     return newEntry;
//   }

//   // Stop an active time entry
//   Future<TimeEntryModel> stopTimeEntry(String entryId) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     _initializeData();
    
//     // lib/data/services/mock_api_service.dart - Part 4 (FIXED - Final Part)

//     final index = _timeEntries.indexWhere((entry) => entry.id == entryId);
//     if (index == -1) throw Exception('Time entry not found');
    
//     final entry = _timeEntries[index];
//     if (!entry.isActive) throw Exception('Time entry is not active');
    
//     final endTime = DateTime.now();
//     final duration = endTime.difference(entry.startTime).inSeconds;
    
//     final stoppedEntry = entry.copyWith(
//       isActive: false,
//       endTime: endTime,
//       durationSeconds: duration,
//     );
    
//     _timeEntries[index] = stoppedEntry;
//     return stoppedEntry;
//   }

//   // Create a manual time entry
//   Future<TimeEntryModel> createManualTimeEntry({
//     required String taskId,
//     required String projectId,
//     required String description,
//     required DateTime startTime,
//     required DateTime endTime,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     _initializeData();
    
//     final currentUser = await getCurrentUser();
    
//     final newEntry = TimeEntryModel.createManual(
//       id: (_timeEntries.length + 1).toString(),
//       userId: currentUser.id,
//       taskId: taskId,
//       projectId: projectId,
//       description: description,
//       startTime: startTime,
//       endTime: endTime,
//     );
    
//     _timeEntries.add(newEntry);
//     return newEntry;
//   }

//   // Update an existing time entry
//   Future<TimeEntryModel> updateTimeEntry(
//     String entryId, {
//     String? description,
//     DateTime? startTime,
//     DateTime? endTime,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 400));
//     _initializeData();
    
//     final index = _timeEntries.indexWhere((entry) => entry.id == entryId);
//     if (index == -1) throw Exception('Time entry not found');
    
//     final entry = _timeEntries[index];
    
//     final updatedEntry = entry.copyWith(
//       description: description,
//       startTime: startTime,
//       endTime: endTime,
//       durationSeconds: endTime != null && (startTime ?? entry.startTime) != null
//           ? endTime.difference(startTime ?? entry.startTime).inSeconds
//           : entry.durationSeconds,
//     );
    
//     _timeEntries[index] = updatedEntry;
//     return updatedEntry;
//   }

//   // Delete a time entry
//   Future<void> deleteTimeEntry(String entryId) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     _initializeData();
    
//     final index = _timeEntries.indexWhere((entry) => entry.id == entryId);
//     if (index == -1) throw Exception('Time entry not found');
    
//     _timeEntries.removeAt(index);
//   }

//   // Get active time entry for current user
//   Future<TimeEntryModel?> getActiveTimeEntry() async {
//     await Future.delayed(const Duration(milliseconds: 200));
//     _initializeData();
    
//     final currentUser = await getCurrentUser();
    
//     try {
//       return _timeEntries.firstWhere((entry) => 
//         entry.userId == currentUser.id && entry.isActive);
//     } catch (e) {
//       return null;
//     }
//   }

//   // Get time tracking statistics
//   Future<Map<String, dynamic>> getTimeTrackingStats({
//     DateTime? startDate,
//     DateTime? endDate,
//     String? projectId,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     _initializeData();
    
//     final currentUser = await getCurrentUser();
//     var entries = _timeEntries.where((entry) => entry.userId == currentUser.id).toList();
    
//     // Apply filters
//     if (startDate != null) {
//       entries = entries.where((entry) => 
//         entry.startTime.isAfter(startDate.subtract(const Duration(days: 1)))
//       ).toList();
//     }
    
//     if (endDate != null) {
//       final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
//       entries = entries.where((entry) => 
//         entry.startTime.isBefore(endOfDay.add(const Duration(days: 1)))
//       ).toList();
//     }
    
//     if (projectId != null) {
//       entries = entries.where((entry) => entry.projectId == projectId).toList();
//     }
    
//     // Calculate statistics
//     final totalSeconds = entries.fold<int>(0, (sum, entry) => sum + entry.durationSeconds);
//     final totalHours = totalSeconds / 3600.0;
    
//     final projectHours = <String, double>{};
//     final taskHours = <String, double>{};
//     final dailyHours = <String, double>{};
    
//     for (final entry in entries) {
//       final project = _projects.firstWhere((p) => p.id == entry.projectId);
//       final task = _tasks.firstWhere((t) => t.id == entry.taskId);
//       final dayKey = '${entry.startTime.year}-${entry.startTime.month.toString().padLeft(2, '0')}-${entry.startTime.day.toString().padLeft(2, '0')}';
      
//       projectHours[project.name] = (projectHours[project.name] ?? 0.0) + entry.durationHours;
//       taskHours[task.title] = (taskHours[task.title] ?? 0.0) + entry.durationHours;
//       dailyHours[dayKey] = (dailyHours[dayKey] ?? 0.0) + entry.durationHours;
//     }
    
//     return {
//       'totalHours': totalHours,
//       'totalEntries': entries.length,
//       'averageHoursPerDay': dailyHours.isEmpty ? 0.0 : totalHours / dailyHours.length,
//       'projectHours': projectHours,
//       'taskHours': taskHours,
//       'dailyHours': dailyHours,
//       'workingDays': dailyHours.length,
//     };
//   }

//   // Export time entries for reporting
//   Future<List<Map<String, dynamic>>> getTimeEntriesForExport({
//     DateTime? startDate,
//     DateTime? endDate,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 400));
//     _initializeData();
    
//     final currentUser = await getCurrentUser();
//     var entries = _timeEntries.where((entry) => entry.userId == currentUser.id).toList();
    
//     if (startDate != null) {
//       entries = entries.where((entry) => 
//         entry.startTime.isAfter(startDate.subtract(const Duration(days: 1)))
//       ).toList();
//     }
    
//     if (endDate != null) {
//       final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
//       entries = entries.where((entry) => 
//         entry.startTime.isBefore(endOfDay.add(const Duration(days: 1)))
//       ).toList();
//     }
    
//     final result = <Map<String, dynamic>>[];
    
//     for (final entry in entries) {
//       final task = _tasks.firstWhere((t) => t.id == entry.taskId);
//       final project = _projects.firstWhere((p) => p.id == entry.projectId);
      
//       result.add({
//         'Date': entry.startTime.toIso8601String().substring(0, 10),
//         'Start Time': entry.startTime.toIso8601String().substring(11, 16),
//         'End Time': entry.endTime?.toIso8601String().substring(11, 16) ?? '',
//         'Duration': entry.formattedDuration,
//         'Project': project.name,
//         'Task': task.title,
//         'Description': entry.description,
//         'Type': entry.type.displayName,
//         'User': currentUser.name,
//         'Hours': entry.durationHours.toStringAsFixed(2),
//       });
//     }
    
//     return result..sort((a, b) => 
//       DateTime.parse('${a['Date']}T${a['Start Time']}:00').compareTo(
//         DateTime.parse('${b['Date']}T${b['Start Time']}:00')
//       )
//     );
//   }

//   // Dashboard/Analytics Methods
//   Future<Map<String, dynamic>> getDashboardStats() async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     _initializeData();
    
//     final currentUser = await getCurrentUser();
//     final userProjects = await getProjects();
//     final allTasks = <TaskModel>[];
    
//     for (final project in userProjects) {
//       final projectTasks = await getTasks(projectId: project.id);
//       allTasks.addAll(projectTasks);
//     }
    
//     final myTasks = allTasks.where((task) => task.assigneeId == currentUser.id).toList();
    
//     final taskStats = {
//       'total': myTasks.length,
//       'toDo': myTasks.where((task) => task.status == TaskStatus.toDo).length,
//       'inProgress': myTasks.where((task) => task.status == TaskStatus.inProgress).length,
//       'done': myTasks.where((task) => task.status == TaskStatus.done).length,
//     };
    
//     final projectStats = {
//       'total': userProjects.length,
//       'active': userProjects.where((project) => project.status == ProjectStatus.active).length,
//       'planning': userProjects.where((project) => project.status == ProjectStatus.planning).length,
//       'completed': userProjects.where((project) => project.status == ProjectStatus.completed).length,
//     };
    
//     final overdueTasks = myTasks.where((task) =>
//       task.dueDate != null &&
//       task.dueDate!.isBefore(DateTime.now()) &&
//       task.status != TaskStatus.done
//     ).length;

//     // Time tracking stats for dashboard
//     final timeStats = await getTimeTrackingStats(
//       startDate: DateTime.now().subtract(const Duration(days: 7)),
//       endDate: DateTime.now(),
//     );
    
//     return {
//       'taskStats': taskStats,
//       'projectStats': projectStats,
//       'overdueTasks': overdueTasks,
//       'completedThisWeek': myTasks.where((task) =>
//         task.status == TaskStatus.done &&
//         task.updatedAt.isAfter(DateTime.now().subtract(const Duration(days: 7)))
//       ).length,
//       'avgProjectProgress': userProjects.isEmpty ? 
//         0.0 : userProjects.map((p) => p.progress).reduce((a, b) => a + b) / userProjects.length,
//       'timeStats': timeStats,
//     };
//   }

// Future<Map<String, dynamic>> getProjectAnalytics(String projectId) async {
//   await Future.delayed(const Duration(milliseconds: 500));
//   _initializeData();
  
//   final project = _projects.firstWhere(
//     (p) => p.id == projectId,
//     orElse: () => throw Exception('Project not found'),
//   );
//   final projectTasks = _tasks.where((task) => task.projectId == projectId).toList();
//   final projectTimeEntries = _timeEntries.where((entry) => entry.projectId == projectId).toList();
  
//   final taskStats = {
//     'total': projectTasks.length,
//     'completed': projectTasks.where((t) => t.status == TaskStatus.completed || t.status == TaskStatus.done).length,
//     'inProgress': projectTasks.where((t) => t.status == TaskStatus.inProgress).length,
//     'todo': projectTasks.where((t) => t.status == TaskStatus.toDo).length,
//   };
  
//   final totalHours = projectTimeEntries.fold(0.0, (sum, entry) => sum + entry.durationHours);
  
//   return {
//     'project': project.toJson(),
//     'taskStats': taskStats,
//     'totalHours': totalHours,
//     'memberCount': project.memberIds.length,
//     'progress': projectTasks.isEmpty ? 0.0 : 
//       projectTasks.where((t) => t.status == TaskStatus.completed || t.status == TaskStatus.done).length / projectTasks.length,
//   };
// }

// // USER METHODS - Add to existing MockApiService class
// Future<UserModel> updateUser(String id, Map<String, dynamic> data) async {
//   await Future.delayed(const Duration(milliseconds: 500));
//   _initializeData();
  
//   final index = _users.indexWhere((user) => user.id == id);
//   if (index == -1) throw Exception('User not found');
  
//   final user = _users[index];
//   final updatedUser = user.copyWith(
//     name: data['name'],
//     email: data['email'],
//     role: data['role'] != null ? UserRole.values.firstWhere((e) => e.name == data['role']) : null,
//     updatedAt: DateTime.now(),
//   );
  
//   _users[index] = updatedUser;
//   return updatedUser;
// }


// double _calculateAvgProjectProgress(List<ProjectModel> projects) {
//   if (projects.isEmpty) return 0.0;
  
//   double totalProgress = 0.0;
//   for (final project in projects) {
//     if (project.status.name == 'completed') {
//       totalProgress += 1.0;
//     } else if (project.status.name == 'active') {
//       totalProgress += 0.5; // Assume 50% for active projects
//     } else if (project.status.name == 'planning') {
//       totalProgress += 0.1; // Assume 10% for planning
//     }
//   }
  
//   return totalProgress / projects.length;
// }

// double _calculateTotalWorkingHours(String userId) {
//   final userEntries = _timeEntries.where((entry) => entry.userId == userId);
//   return userEntries.fold(0.0, (sum, entry) => sum + entry.durationHours);
// }





// Future<TimeEntryModel> startTimer({
//   required String taskId,
//   required String projectId,
//   required String description,
// }) async {
//   await Future.delayed(const Duration(milliseconds: 400));
//   _initializeData();
  
//   final currentUser = await getCurrentUser();
  
//   // Stop any existing active timer
//   final activeIndex = _timeEntries.indexWhere((entry) => 
//     entry.userId == currentUser.id && entry.isActive);
//   if (activeIndex != -1) {
//     final activeEntry = _timeEntries[activeIndex];
//     final stoppedEntry = activeEntry.copyWith(
//       isActive: false,
//       endTime: DateTime.now(),
//       durationSeconds: DateTime.now().difference(activeEntry.startTime).inSeconds,
//     );
//     _timeEntries[activeIndex] = stoppedEntry;
//   }
  
//   final newEntry = TimeEntryModel.createTimer(
//     id: (_timeEntries.length + 1).toString(),
//     userId: currentUser.id,
//     taskId: taskId,
//     projectId: projectId,
//     description: description,
//   );
  
//   _timeEntries.add(newEntry);
//   return newEntry;
// }

// Future<TimeEntryModel> stopTimer(String timeEntryId) async {
//   await Future.delayed(const Duration(milliseconds: 300));
//   _initializeData();
  
//   final index = _timeEntries.indexWhere((entry) => entry.id == timeEntryId);
//   if (index == -1) throw Exception('Time entry not found');
  
//   final entry = _timeEntries[index];
//   if (!entry.isActive) throw Exception('Time entry is not active');
  
//   final endTime = DateTime.now();
//   final duration = endTime.difference(entry.startTime).inSeconds;
  
//   final stoppedEntry = entry.copyWith(
//     isActive: false,
//     endTime: endTime,
//     durationSeconds: duration,
//   );
  
//   _timeEntries[index] = stoppedEntry;
//   return stoppedEntry;
// }






// Future<Map<String, dynamic>> getUserAnalytics(String userId) async {
//   await Future.delayed(const Duration(milliseconds: 500));
//   _initializeData();
  
//   final userTasks = _tasks.where((task) => task.assigneeId == userId).toList();
//   final userTimeEntries = _timeEntries.where((entry) => entry.userId == userId).toList();
  
//   final taskStats = {
//     'total': userTasks.length,
//     'completed': userTasks.where((t) => t.status.name == 'completed' || t.status.name == 'done').length,
//     'inProgress': userTasks.where((t) => t.status.name == 'inProgress').length,
//     'overdue': userTasks.where((t) => t.dueDate != null && t.dueDate!.isBefore(DateTime.now()) && 
//       t.status.name != 'completed' && t.status.name != 'done').length,
//   };
  
//   final totalHours = userTimeEntries.fold(0.0, (sum, entry) => sum + entry.durationHours);
  
//   return {
//     'taskStats': taskStats,
//     'totalHours': totalHours,
//     'avgTaskCompletionTime': _calculateAvgTaskCompletionTime(userTasks),
//     'productivity': _calculateProductivityScore(userTasks, userTimeEntries),
//   };
// }

// double _calculateAvgTaskCompletionTime(List<TaskModel> tasks) {
//   final completedTasks = tasks.where((t) => t.status.name == 'completed' || t.status.name == 'done').toList();
//   if (completedTasks.isEmpty) return 0.0;
  
//   final totalDays = completedTasks.fold(0.0, (sum, task) => 
//     sum + task.updatedAt.difference(task.createdAt).inDays);
  
//   return totalDays / completedTasks.length;
// }

// double _calculateProductivityScore(List<TaskModel> tasks, List<TimeEntryModel> timeEntries) {
//   if (tasks.isEmpty || timeEntries.isEmpty) return 0.0;
  
//   final completedTasks = tasks.where((t) => t.status.name == 'completed' || t.status.name == 'done').length;
//   final totalHours = timeEntries.fold(0.0, (sum, entry) => sum + entry.durationHours);
  
//   return totalHours > 0 ? (completedTasks / totalHours) * 10 : 0.0; // Score out of 10
// }

// Future<Map<String, dynamic>> getTimeAnalytics({
//   DateTime? startDate,
//   DateTime? endDate,
//   String? projectId,
//   String? userId,
// }) async {
//   await Future.delayed(const Duration(milliseconds: 500));
//   _initializeData();
  
//   var filteredEntries = _timeEntries.toList();
  
//   if (startDate != null) {
//     filteredEntries = filteredEntries.where((entry) => entry.startTime.isAfter(startDate)).toList();
//   }
//   if (endDate != null) {
//     filteredEntries = filteredEntries.where((entry) => entry.startTime.isBefore(endDate)).toList();
//   }
//   if (projectId != null) {
//     filteredEntries = filteredEntries.where((entry) => entry.projectId == projectId).toList();
//   }
//   if (userId != null) {
//     filteredEntries = filteredEntries.where((entry) => entry.userId == userId).toList();
//   }
  
//   final totalHours = filteredEntries.fold(0.0, (sum, entry) => sum + entry.durationHours);
//   final dailyHours = <String, double>{};
  
//   for (final entry in filteredEntries) {
//     final dateKey = entry.startTime.toIso8601String().substring(0, 10);
//     dailyHours[dateKey] = (dailyHours[dateKey] ?? 0) + entry.durationHours;
//   }
  
//   return {
//     'totalHours': totalHours,
//     'entriesCount': filteredEntries.length,
//     'dailyHours': dailyHours,
//     'avgDailyHours': dailyHours.isEmpty ? 0.0 : totalHours / dailyHours.length,
//   };
// }

// // SEARCH METHODS - Add to existing MockApiService class
// Future<Map<String, List<dynamic>>> search(String query) async {
//   await Future.delayed(const Duration(milliseconds: 400));
//   _initializeData();
  
//   final projects = await searchProjects(query);
//   final tasks = await searchTasks(query);
//   final users = await searchUsers(query);
  
//   return {
//     'projects': projects,
//     'tasks': tasks,
//     'users': users,
//   };
// }

// Future<List<ProjectModel>> searchProjects(String query) async {
//   await Future.delayed(const Duration(milliseconds: 300));
//   _initializeData();
  
//   final lowerQuery = query.toLowerCase();
//   return _projects.where((project) =>
//     project.name.toLowerCase().contains(lowerQuery) ||
//     project.description.toLowerCase().contains(lowerQuery)
//   ).toList();
// }

// Future<List<TaskModel>> searchTasks(String query) async {
//   await Future.delayed(const Duration(milliseconds: 300));
//   _initializeData();
  
//   final lowerQuery = query.toLowerCase();
//   return _tasks.where((task) =>
//     task.title.toLowerCase().contains(lowerQuery) ||
//     task.description.toLowerCase().contains(lowerQuery)
//   ).toList();
// }

// Future<List<UserModel>> searchUsers(String query) async {
//   await Future.delayed(const Duration(milliseconds: 300));
//   _initializeData();
  
//   final lowerQuery = query.toLowerCase();
//   return _users.where((user) =>
//     user.name.toLowerCase().contains(lowerQuery) ||
//     user.email.toLowerCase().contains(lowerQuery)
//   ).toList();
// }

// // COMMENT METHODS - Add to existing MockApiService class
// Future<CommentModel> updateComment(String commentId, String content) async {
//   await Future.delayed(const Duration(milliseconds: 400));
//   _initializeData();
  
//   final index = _comments.indexWhere((comment) => comment.id == commentId);
//   if (index == -1) throw Exception('Comment not found');
  
//   final comment = _comments[index];
//   final updatedComment = comment.copyWith(
//     content: content,
//     updatedAt: DateTime.now(),
//   );
  
//   _comments[index] = updatedComment;
//   return updatedComment;
// }

// Future<void> deleteComment(String commentId) async {
//   await Future.delayed(const Duration(milliseconds: 300));
//   _initializeData();
  
//   final index = _comments.indexWhere((comment) => comment.id == commentId);
//   if (index == -1) throw Exception('Comment not found');
  
//   _comments.removeAt(index);
// }

// // FIX EXISTING METHODS - Update these in your existing MockApiService class

// // Fix the getTimeEntryById method signature
// Future<TimeEntryModel> getTimeEntryById(String id) async {
//   await Future.delayed(const Duration(milliseconds: 300));
//   _initializeData();
  
//   return _timeEntries.firstWhere(
//     (entry) => entry.id == id,
//     orElse: () => throw Exception('Time entry not found'),
//   );
// }

// // Fix the createTimeEntry method signature  
// Future<TimeEntryModel> createTimeEntry({
//   required String userId,
//   String? projectId,
//   String? taskId,
//   required String description,
//   required DateTime startTime,
//   DateTime? endTime,
//   bool isActive = false,
// }) async {
//   await Future.delayed(const Duration(milliseconds: 500));
//   _initializeData();
  
//   final newEntry = TimeEntryModel(
//     id: (_timeEntries.length + 1).toString(),
//     userId: userId,
//     taskId: taskId ?? '',
//     projectId: projectId ?? '',
//     description: description,
//     startTime: startTime,
//     endTime: endTime,
//     durationSeconds: endTime != null ? endTime.difference(startTime).inSeconds : 0,
//     type: TimeEntryType.manual,
//     isActive: isActive,
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//   );
  
//   _timeEntries.add(newEntry);
//   return newEntry;
// }


  
  
//   double _calculateAvgCompletionTime(List<TaskModel> tasks) {
//     final completedTasks = tasks.where((task) => task.status == TaskStatus.done).toList();
//     if (completedTasks.isEmpty) return 0.0;
    
//     final totalDays = completedTasks.map((task) => 
//       task.updatedAt.difference(task.createdAt).inDays
//     ).reduce((a, b) => a + b);
    
//     return totalDays / completedTasks.length;
//   }

//   bool _isTaskCompletedOnDay(TaskModel task, DateTime day) {
//     if (task.status != TaskStatus.done) return false;
    
//     final taskCompletionDate = DateTime(
//       task.updatedAt.year,
//       task.updatedAt.month,
//       task.updatedAt.day,
//     );
    
//     final targetDate = DateTime(day.year, day.month, day.day);
    
//     return taskCompletionDate.isAtSameMomentAs(targetDate);
//   }

//   void _createNotification(
//     String userId,
//     NotificationType type,
//     String title,
//     String message,
//     Map<String, dynamic> metadata,
//   ) {
//     final notification = NotificationModel(
//       id: (_notifications.length + 1).toString(),
//       userId: userId,
//       type: type,
//       title: title,
//       message: message,
//       metadata: metadata,
//       createdAt: DateTime.now(),
//     );
    
//     _notifications.add(notification);
//   }

//   // Reset data for testing
//   void resetData() {
//     _isDataInitialized = false;
//     _currentUserId = null;
//     _users.clear();
//     _projects.clear();
//     _tasks.clear();
//     _comments.clear();
//     _notifications.clear();
//     _timeEntries.clear();
//   }
// }


//2



// lib/data/services/mock_api_service.dart

import 'dart:math';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../models/project_model.dart';
import '../models/task_model.dart';
import '../models/comment_model.dart';
import '../models/notification_model.dart';
import '../models/time_entry_model.dart';
import '../../core/enums/user_role.dart';
import '../../core/enums/project_status.dart';
import '../../core/enums/task_status.dart';
import '../../core/enums/task_priority.dart';

class MockApiService {
  static final MockApiService _instance = MockApiService._internal();
  factory MockApiService() => _instance;
  MockApiService._internal();

  // In-memory data storage
  final List<UserModel> _users = [];
  final List<ProjectModel> _projects = [];
  final List<TaskModel> _tasks = [];
  final List<CommentModel> _comments = [];
  final List<NotificationModel> _notifications = [];
  final List<TimeEntryModel> _timeEntries = [];
  
  String? _currentUserId;
  bool _isDataInitialized = false;
  final Random _random = Random();

  // Initialize sample data - FIXED
  void _initializeData() {
    if (_isDataInitialized) return;
    
    _users.clear();
    _projects.clear();
    _tasks.clear();
    _comments.clear();
    _notifications.clear();
    _timeEntries.clear();
    
    _initializeUsers();
    _createSampleProjects();
    _createSampleTasks();
    _createSampleComments();
    _createSampleNotifications();
    _createSampleTimeEntries();
    
    _isDataInitialized = true;
  }

  // FIXED: Complete user initialization
  void _initializeUsers() {
    if (_users.isNotEmpty) return;
    
    final now = DateTime.now();
    
    _users.addAll([
      UserModel(
        id: '1',
        name: 'John Doe',
        email: 'john@flowence.com',
        role: UserRole.admin,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 1)),
        avatarUrl: null,
      ),
      UserModel(
        id: '2',
        name: 'Jane Smith',
        email: 'jane@flowence.com',
        role: UserRole.projectManager,
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(days: 2)),
        avatarUrl: null,
      ),
      UserModel(
        id: '3',
        name: 'Bob Johnson',
        email: 'bob@flowence.com',
        role: UserRole.teamMember,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 3)),
        avatarUrl: null,
      ),
      UserModel(
        id: '4',
        name: 'Alice Brown',
        email: 'alice@flowence.com',
        role: UserRole.teamMember,
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 4)),
        avatarUrl: null,
      ),
    ]);

    // Set default current user
    _currentUserId ??= '3'; // Default to Bob Johnson
  }

void _createSampleProjects() {
  final now = DateTime.now();
  _projects.addAll([
    ProjectModel(
      id: '1',
      name: 'Mobile App Development',
      description: 'Build a cross-platform mobile application using Flutter',
      status: ProjectStatus.active,
      memberIds: ['3', '4'],
      creatorId: '2',
      ownerId: '2', // FIXED: Added ownerId
      startDate: now.subtract(const Duration(days: 30)), // FIXED: Added startDate
      dueDate: now.add(const Duration(days: 30)),
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now.subtract(const Duration(days: 1)),
      progress: 0.65,
    ),
    ProjectModel(
      id: '2',
      name: 'Website Redesign',
      description: 'Complete redesign of company website with modern UI/UX',
      status: ProjectStatus.active,
      memberIds: ['4', '5'],
      creatorId: '2',
      ownerId: '2', // FIXED: Added ownerId
      startDate: now.subtract(const Duration(days: 20)), // FIXED: Added startDate
      dueDate: now.add(const Duration(days: 45)),
      createdAt: now.subtract(const Duration(days: 20)),
      updatedAt: now.subtract(const Duration(days: 3)),
      progress: 0.3,
    ),
    ProjectModel(
      id: '3',
      name: 'API Integration',
      description: 'Integrate third-party APIs for enhanced functionality',
      status: ProjectStatus.onHold,
      memberIds: ['3'],
      creatorId: '2',
      ownerId: '2', // FIXED: Added ownerId
      startDate: now.subtract(const Duration(days: 10)), // FIXED: Added startDate
      dueDate: now.add(const Duration(days: 60)),
      createdAt: now.subtract(const Duration(days: 10)),
      updatedAt: now.subtract(const Duration(days: 5)),
      progress: 0.1,
    ),
  ]);
}

 void _createSampleTasks() {
  final now = DateTime.now();
  _tasks.addAll([
    TaskModel(
      id: '1',
      title: 'Setup Flutter Project',
      description: 'Initialize Flutter project with proper structure',
      status: TaskStatus.done,
      priority: TaskPriority.high,
      projectId: '1',
      assigneeId: '3',
      creatorId: '2',
      dueDate: now.add(const Duration(days: 3)),
      createdAt: now.subtract(const Duration(days: 28)),
      updatedAt: now.subtract(const Duration(days: 25)),
      progress: 1.0,
      tags: ['flutter', 'setup', 'foundation'], // FIXED: Added tags
      estimatedTimeHours: 8.0, // FIXED: Added estimatedTimeHours
    ),
    TaskModel(
      id: '2',
      title: 'Design User Interface',
      description: 'Create mockups and wireframes for the app',
      status: TaskStatus.inProgress,
      priority: TaskPriority.medium,
      projectId: '1',
      assigneeId: '4',
      creatorId: '2',
      dueDate: now.add(const Duration(days: 7)),
      createdAt: now.subtract(const Duration(days: 20)),
      updatedAt: now.subtract(const Duration(hours: 6)),
      progress: 0.6,
      tags: ['ui', 'design', 'mockup'], // FIXED: Added tags
      estimatedTimeHours: 16.0, // FIXED: Added estimatedTimeHours
    ),
    TaskModel(
      id: '3',
      title: 'Implement Authentication',
      description: 'Add login/logout functionality with JWT',
      status: TaskStatus.inProgress,
      priority: TaskPriority.high,
      projectId: '1',
      assigneeId: '3',
      creatorId: '2',
      dueDate: now.add(const Duration(days: 5)),
      createdAt: now.subtract(const Duration(days: 15)),
      updatedAt: now.subtract(const Duration(hours: 2)),
      progress: 0.4,
      tags: ['auth', 'security', 'jwt'], // FIXED: Added tags
      estimatedTimeHours: 12.0, // FIXED: Added estimatedTimeHours
    ),
    TaskModel(
      id: '4',
      title: 'Database Integration',
      description: 'Connect app to database and create data models',
      status: TaskStatus.toDo,
      priority: TaskPriority.medium,
      projectId: '1',
      assigneeId: '3',
      creatorId: '2',
      dueDate: now.add(const Duration(days: 10)),
      createdAt: now.subtract(const Duration(days: 10)),
      updatedAt: now.subtract(const Duration(days: 10)),
      progress: 0.0,
      tags: ['database', 'models', 'integration'], // FIXED: Added tags
      estimatedTimeHours: 20.0, // FIXED: Added estimatedTimeHours
    ),
    TaskModel(
      id: '5',
      title: 'Create Homepage Design',
      description: 'Design the new homepage layout and components',
      status: TaskStatus.inProgress,
      priority: TaskPriority.high,
      projectId: '2',
      assigneeId: '4',
      creatorId: '2',
      dueDate: now.add(const Duration(days: 8)),
      createdAt: now.subtract(const Duration(days: 12)),
      updatedAt: now.subtract(const Duration(hours: 4)),
      progress: 0.7,
      tags: ['homepage', 'design', 'layout'], // FIXED: Added tags
      estimatedTimeHours: 24.0, // FIXED: Added estimatedTimeHours
    ),
    TaskModel(
      id: '6',
      title: 'Implement Responsive Design',
      description: 'Make the website responsive for all device sizes',
      status: TaskStatus.toDo,
      priority: TaskPriority.medium,
      projectId: '2',
      assigneeId: '5',
      creatorId: '2',
      dueDate: now.add(const Duration(days: 15)),
      createdAt: now.subtract(const Duration(days: 8)),
      updatedAt: now.subtract(const Duration(days: 8)),
      progress: 0.0,
      tags: ['responsive', 'css', 'mobile'], // FIXED: Added tags
      estimatedTimeHours: 18.0, // FIXED: Added estimatedTimeHours
    ),
    TaskModel(
      id: '7',
      title: 'API Documentation',
      description: 'Document all API endpoints and usage examples',
      status: TaskStatus.toDo,
      priority: TaskPriority.low,
      projectId: '3',
      assigneeId: '3',
      creatorId: '2',
      dueDate: now.add(const Duration(days: 20)),
      createdAt: now.subtract(const Duration(days: 5)),
      updatedAt: now.subtract(const Duration(days: 5)),
      progress: 0.0,
      tags: ['documentation', 'api', 'examples'], // FIXED: Added tags
      estimatedTimeHours: 10.0, // FIXED: Added estimatedTimeHours
    ),
  ]);
}



  // FIXED: Complete comments initialization
  void _createSampleComments() {
    final now = DateTime.now();
    _comments.addAll([
      CommentModel(
        id: '1',
        taskId: '1',
        authorId: '3',
        content: 'Project setup completed successfully. Will have initial setup done by tomorrow.',
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      CommentModel(
        id: '2',
        taskId: '3',
        authorId: '3',
        content: '@Jane Manager need help with JWT configuration',
        createdAt: now.subtract(const Duration(hours: 4)),
        mentions: ['2'],
      ),
      CommentModel(
        id: '3',
        taskId: '3',
        authorId: '2',
        content: 'I can help you with that. Let\'s have a call tomorrow.',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
    ]);
  }

  // FIXED: Complete notifications initialization
  void _createSampleNotifications() {
    final now = DateTime.now();
    _notifications.addAll([
      NotificationModel(
        id: '1',
        userId: '3',
        type: NotificationType.taskAssigned,
        title: 'New Task Assigned',
        message: 'You have been assigned to "Implement Authentication"',
        createdAt: now.subtract(const Duration(hours: 6)),
        metadata: {'taskId': '3'},
      ),
      NotificationModel(
        id: '2',
        userId: '2',
        type: NotificationType.mention,
        title: 'You were mentioned',
        message: 'Bob mentioned you in a comment',
        createdAt: now.subtract(const Duration(hours: 4)),
        metadata: {'taskId': '3', 'commentId': '2'},
      ),
      NotificationModel(
        id: '3',
        userId: '4',
        type: NotificationType.deadlineReminder,
        title: 'Deadline Approaching',
        message: 'Task "Design User Interface" is due in 7 days',
        createdAt: now.subtract(const Duration(hours: 1)),
        metadata: {'taskId': '2'},
      ),
    ]);
  }

  // FIXED: Complete time entries initialization
  void _createSampleTimeEntries() {
    final now = DateTime.now();
    _timeEntries.addAll([
      // Time entries for today
      TimeEntryModel(
        id: '1',
        userId: '3',
        taskId: '1',
        projectId: '1',
        description: 'Setting up initial project structure',
        startTime: now.subtract(const Duration(hours: 3, minutes: 30)),
        endTime: now.subtract(const Duration(hours: 1, minutes: 45)),
        durationSeconds: 6300, // 1h 45m
        type: TimeEntryType.tracked,
        isActive: false,
        createdAt: now.subtract(const Duration(hours: 3, minutes: 30)),
        updatedAt: now.subtract(const Duration(hours: 1, minutes: 45)),
      ),
      TimeEntryModel(
        id: '2',
        userId: '4',
        taskId: '2',
        projectId: '1',
        description: 'Working on wireframe designs',
        startTime: now.subtract(const Duration(minutes: 45)),
        endTime: null, // Active timer
        durationSeconds: 0,
        type: TimeEntryType.tracked,
        isActive: true,
        createdAt: now.subtract(const Duration(minutes: 45)),
        updatedAt: now.subtract(const Duration(minutes: 45)),
      ),
      // Yesterday's entries
      TimeEntryModel(
        id: '3',
        userId: '3',
        taskId: '3',
        projectId: '1',
        description: 'JWT authentication research',
        startTime: now.subtract(const Duration(days: 1, hours: 4)),
        endTime: now.subtract(const Duration(days: 1, hours: 2)),
        durationSeconds: 7200, // 2h
        type: TimeEntryType.manual,
        isActive: false,
        createdAt: now.subtract(const Duration(days: 1, hours: 4)),
        updatedAt: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      TimeEntryModel(
        id: '4',
        userId: '4',
        taskId: '2',
        projectId: '1',
        description: 'UI mockup creation',
        startTime: now.subtract(const Duration(days: 1, hours: 6)),
        endTime: now.subtract(const Duration(days: 1, hours: 3, minutes: 30)),
        durationSeconds: 9000, // 2h 30m
        type: TimeEntryType.tracked,
        isActive: false,
        createdAt: now.subtract(const Duration(days: 1, hours: 6)),
        updatedAt: now.subtract(const Duration(days: 1, hours: 3, minutes: 30)),
      ),
      // This week's entries
      TimeEntryModel(
        id: '5',
        userId: '3',
        taskId: '1',
        projectId: '1',
        description: 'Flutter configuration',
        startTime: now.subtract(const Duration(days: 2, hours: 3)),
        endTime: now.subtract(const Duration(days: 2, hours: 1)),
        durationSeconds: 7200, // 2h
        type: TimeEntryType.tracked,
        isActive: false,
        createdAt: now.subtract(const Duration(days: 2, hours: 3)),
        updatedAt: now.subtract(const Duration(days: 2, hours: 1)),
      ),
    ]);
  }

  // AUTH METHODS - FIXED
Future<Map<String, dynamic>> login(String email, String password) async {
  await Future.delayed(const Duration(milliseconds: 500));
  _initializeData();
  
  // Handle default demo credentials first
  if (email == 'admin@example.com' && password == 'password') {
    _currentUserId = '1'; // Set to admin user
    final user = _users.firstWhere((user) => user.id == '1');
    
    return {
      'token': 'mock_jwt_token_${user.id}',
      'user': user.toJson(),
      'expiresAt': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
    };
  }
  
  // Handle other demo credentials
  if (email == 'manager@example.com' && password == 'password') {
    _currentUserId = '2';
    final user = _users.firstWhere((user) => user.id == '2');
    return {
      'token': 'mock_jwt_token_${user.id}',
      'user': user.toJson(),
      'expiresAt': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
    };
  }
  
  if (email == 'developer@example.com' && password == 'password') {
    _currentUserId = '3';
    final user = _users.firstWhere((user) => user.id == '3');
    return {
      'token': 'mock_jwt_token_${user.id}',
      'user': user.toJson(),
      'expiresAt': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
    };
  }
  
  if (email == 'designer@example.com' && password == 'password') {
    _currentUserId = '4';
    final user = _users.firstWhere((user) => user.id == '4');
    return {
      'token': 'mock_jwt_token_${user.id}',
      'user': user.toJson(),
      'expiresAt': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
    };
  }
  
  // Try to find user by email for any other registered users
  final user = _users.firstWhere(
    (user) => user.email == email,
    orElse: () => throw Exception('Invalid credentials'),
  );
  
  // For demo purposes, accept any password for existing users
  // In a real app, you would validate the password properly
  _currentUserId = user.id;
  
  return {
    'token': 'mock_jwt_token_${user.id}',
    'user': user.toJson(),
    'expiresAt': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
  };
}

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _initializeData();
    
    if (_users.any((user) => user.email == email)) {
      throw Exception('Email already exists');
    }

    final newUser = UserModel(
      id: (_users.length + 1).toString(),
      name: name,
      email: email,
      role: UserRole.teamMember,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      avatarUrl: null,
    );
    
    _users.add(newUser);
    _currentUserId = newUser.id;

    return {
      'token': 'mock_jwt_token_${newUser.id}',
      'user': newUser.toJson(),
      'expiresAt': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
    };
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUserId = null;
  }

  Future<UserModel> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _initializeData();
    
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    return _users.firstWhere(
      (user) => user.id == _currentUserId,
      orElse: () => throw Exception('User not found'),
    );
  }

  // USER METHODS - FIXED
  Future<List<UserModel>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _initializeData();
    return List.from(_users);
  }

  Future<UserModel> getUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _initializeData();
    
    return _users.firstWhere(
      (user) => user.id == id,
      orElse: () => throw Exception('User not found'),
    );
  }

  Future<UserModel> updateUser(String id, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _initializeData();
    
    final index = _users.indexWhere((user) => user.id == id);
    if (index == -1) throw Exception('User not found');
    
    final user = _users[index];
    final updatedUser = user.copyWith(
      name: data['name'],
      email: data['email'],
      role: data['role'] != null ? 
        UserRole.values.firstWhere((e) => e.name == data['role']) : null,
      updatedAt: DateTime.now(),
    );
    
    _users[index] = updatedUser;
    return updatedUser;
  }

  // PROJECT METHODS - FIXED
  Future<List<ProjectModel>> getProjects({
    ProjectStatus? status,
    String? ownerId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _initializeData();
    
    var projects = List<ProjectModel>.from(_projects);
    
    if (status != null) {
      projects = projects.where((project) => project.status == status).toList();
    }
    
    if (ownerId != null) {
      projects = projects.where((project) => project.ownerId == ownerId).toList();
    }
    
    return projects;
  }

  Future<ProjectModel> getProjectById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _initializeData();
    
    return _projects.firstWhere(
      (project) => project.id == id,
      orElse: () => throw Exception('Project not found'),
    );
  }


Future<ProjectModel> createProject(Map<String, dynamic> data) async {
  await Future.delayed(const Duration(milliseconds: 800));
  
  // Get current user (assuming this method exists in your service)
  final currentUser = await getCurrentUser();
  final now = DateTime.now();
  final newId = DateTime.now().millisecondsSinceEpoch.toString();
  
  final newProject = ProjectModel(
    id: newId,
    name: data['name'],
    description: data['description'] ?? '',
    status: ProjectStatus.values.firstWhere(
      (e) => e.name == data['status'],
      orElse: () => ProjectStatus.active,
    ),
    memberIds: List<String>.from(data['memberIds'] ?? []),
    creatorId: currentUser.id, // FIXED: Added missing creatorId
    ownerId: currentUser.id,
    dueDate: data['dueDate'] != null ? DateTime.parse(data['dueDate']) : null,
    startDate: data['startDate'] != null ? DateTime.parse(data['startDate']) : now,
    createdAt: now,
    updatedAt: now,
    progress: 0.0,
  );
  
  _projects.add(newProject);
  return newProject;
}
  // TASK METHODS - FIXED
  
  
  Future<List<TaskModel>> getTasks({
    String? projectId,
    TaskStatus? status,
    TaskPriority? priority,
    String? assigneeId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _initializeData();
    
    var tasks = List<TaskModel>.from(_tasks);
    
    if (projectId != null) {
      tasks = tasks.where((task) => task.projectId == projectId).toList();
    }
    
    if (status != null) {
      tasks = tasks.where((task) => task.status == status).toList();
    }
    
    if (priority != null) {
      tasks = tasks.where((task) => task.priority == priority).toList();
    }
    
    if (assigneeId != null) {
      tasks = tasks.where((task) => task.assigneeId == assigneeId).toList();
    }
    
    return tasks;
  }

  Future<TaskModel> getTaskById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _initializeData();
    
    return _tasks.firstWhere(
      (task) => task.id == id,
      orElse: () => throw Exception('Task not found'),
    );
  }

  // TIME ENTRY METHODS - FIXED
  Future<List<TimeEntryModel>> getTimeEntries({
    String? projectId,
    String? taskId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _initializeData();
    
    var entries = List<TimeEntryModel>.from(_timeEntries);
    
    if (projectId != null) {
      entries = entries.where((entry) => entry.projectId == projectId).toList();
    }
    
    if (taskId != null) {
      entries = entries.where((entry) => entry.taskId == taskId).toList();
    }
    
    if (startDate != null) {
      entries = entries.where((entry) => entry.startTime.isAfter(startDate) || entry.startTime.isAtSameMomentAs(startDate)).toList();
    }
    
    if (endDate != null) {
      entries = entries.where((entry) => entry.startTime.isBefore(endDate) || entry.startTime.isAtSameMomentAs(endDate)).toList();
    }
    
    return entries;
  }

  Future<TimeEntryModel?> getActiveTimeEntry() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _initializeData();
    
    try {
      return _timeEntries.firstWhere((entry) => entry.isActive);
    } catch (e) {
      return null;
    }
  }

  Future<TimeEntryModel> getTimeEntryById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _initializeData();
    
    return _timeEntries.firstWhere(
      (entry) => entry.id == id,
      orElse: () => throw Exception('Time entry not found'),
    );
  }

  Future<TimeEntryModel> createTimeEntry({
    required String userId,
    String? projectId,
    String? taskId,
    required String description,
    required DateTime startTime,
    DateTime? endTime,
    bool isActive = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _initializeData();
    
    final newEntry = TimeEntryModel(
      id: (_timeEntries.length + 1).toString(),
      userId: userId,
      taskId: taskId ?? '',
      projectId: projectId ?? '',
      description: description,
      startTime: startTime,
      endTime: endTime,
      durationSeconds: endTime != null ? endTime.difference(startTime).inSeconds : 0,
      type: TimeEntryType.manual,
      isActive: isActive,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    _timeEntries.add(newEntry);
    return newEntry;
  }

  Future<TimeEntryModel> startTimer({
    required String taskId,
    required String projectId,
    required String description,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _initializeData();
    
    final currentUser = await getCurrentUser();
    
    // Stop any existing active timer
    final activeIndex = _timeEntries.indexWhere((entry) => entry.isActive);
    if (activeIndex >= 0) {
      final activeEntry = _timeEntries[activeIndex];
      final stoppedEntry = activeEntry.copyWith(
        endTime: DateTime.now(),
        durationSeconds: DateTime.now().difference(activeEntry.startTime).inSeconds,
        isActive: false,
        updatedAt: DateTime.now(),
      );
      _timeEntries[activeIndex] = stoppedEntry;
    }
    
    // Create new active timer
    final newEntry = TimeEntryModel(
      id: (_timeEntries.length + 1).toString(),
      userId: currentUser.id,
      taskId: taskId,
      projectId: projectId,
      description: description,
      startTime: DateTime.now(),
      endTime: null,
      durationSeconds: 0,
      type: TimeEntryType.tracked,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    _timeEntries.add(newEntry);
    return newEntry;
  }

  Future<TimeEntryModel> stopTimer(String entryId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _initializeData();
    
    final index = _timeEntries.indexWhere((entry) => entry.id == entryId);
    if (index == -1) throw Exception('Time entry not found');
    
    final entry = _timeEntries[index];
    if (!entry.isActive) throw Exception('Time entry is not active');
    
    final now = DateTime.now();
    final stoppedEntry = entry.copyWith(
      endTime: now,
      durationSeconds: now.difference(entry.startTime).inSeconds,
      isActive: false,
      updatedAt: now,
    );
    
    _timeEntries[index] = stoppedEntry;
    return stoppedEntry;
  }

  // COMMENT METHODS - FIXED
  Future<List<CommentModel>> getComments(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _initializeData();
    
    return _comments.where((comment) => comment.taskId == taskId).toList();
  }

  Future<CommentModel> createComment(Map<String, dynamic> commentData) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _initializeData();
    
    final currentUser = await getCurrentUser();
    
    final newComment = CommentModel(
      id: (_comments.length + 1).toString(),
      content: commentData['content'],
      authorId: currentUser.id,
      taskId: commentData['taskId'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      mentions: List<String>.from(commentData['mentions'] ?? []),
    );
    
    _comments.add(newComment);
    return newComment;
  }

  // NOTIFICATION METHODS - FIXED
  Future<List<NotificationModel>> getNotifications({
    String? userId,
    bool? isRead,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _initializeData();
    
    var notifications = List<NotificationModel>.from(_notifications);
    
    if (userId != null) {
      notifications = notifications.where((notification) => notification.userId == userId).toList();
    }
    
    if (isRead != null) {
      notifications = notifications.where((notification) => notification.isRead == isRead).toList();
    }
    
    return notifications;
  }

  // // DASHBOARD METHODS - FIXED
  // Future<Map<String, dynamic>> getDashboardStats() async {
  //   await Future.delayed(const Duration(milliseconds: 500));
  //   _initializeData();
    
  //   final now = DateTime.now();
  //   final currentUser = await getCurrentUser();
    
  //   // Get user's projects
  //   final userProjects = _projects.where((p) => 
  //     p.memberIds.contains(currentUser.id) || p.ownerId == currentUser.id
  //   ).toList();
    
  //   // Get user's tasks
  //   final userTasks = _tasks.where((t) => t.assigneeId == currentUser.id).toList();
    
  //   // Get time entries for current week
  //   final weekStart = now.subtract(Duration(days: now.weekday - 1));
  //   final weekEntries = _timeEntries.where((entry) =>
  //     entry.userId == currentUser.id &&
  //     entry.startTime.isAfter(weekStart)
  //   ).toList();
    
  //   final timeStats = _calculateTimeStats(weekEntries);
    
  //   return {
  //     'totalProjects': userProjects.length,
  //     'activeProjects': userProjects.where((p) => p.status == ProjectStatus.active).length,
  //     'totalTasks': userTasks.length,
  //     'completedTasks': userTasks.where((t) => t.status == TaskStatus.done).length,
  //     'inProgressTasks': userTasks.where((t) => t.status == TaskStatus.inProgress).length,
  //     'todoTasks': userTasks.where((t) => t.status == TaskStatus.toDo).length,
  //     'overdueTasks': userTasks.where((t) =>
  //       t.dueDate != null &&
  //       t.dueDate!.isBefore(now) &&
  //       t.status != TaskStatus.done
  //     ).length,
  //     'thisWeekHours': timeStats['totalHours'],
  //     'avgProjectProgress': userProjects.isEmpty ? 0.0 : 
  //       userProjects.map((p) => p.progress).reduce((a, b) => a + b) / userProjects.length,
  //     'timeStats': timeStats,
  //   };
  // }




  // HELPER METHODS - FIXED
  Map<String, dynamic> _calculateTimeStats(List<TimeEntryModel> entries) {
    final totalHours = entries.fold<double>(0.0, (sum, entry) => 
      sum + (entry.endTime != null ? entry.durationSeconds / 3600.0 : 0.0)
    );
    
    final Map<String, double> dailyHours = {};
    for (final entry in entries) {
      if (entry.endTime == null) continue;
      
      final dayKey = '${entry.startTime.year}-${entry.startTime.month.toString().padLeft(2, '0')}-${entry.startTime.day.toString().padLeft(2, '0')}';
      dailyHours[dayKey] = (dailyHours[dayKey] ?? 0.0) + (entry.durationSeconds / 3600.0);
    }
    
    return {
      'totalHours': totalHours,
      'entriesCount': entries.length,
      'dailyHours': dailyHours,
      'avgDailyHours': dailyHours.isEmpty ? 0.0 : totalHours / dailyHours.length,
    };
  }

  // ADDITIONAL METHODS - FIXED
  Future<Map<String, dynamic>> getProjectAnalytics(String projectId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _initializeData();
    
    final project = _projects.firstWhere(
      (p) => p.id == projectId,
      orElse: () => throw Exception('Project not found'),
    );
    
    final projectTasks = _tasks.where((task) => task.projectId == projectId).toList();
    final projectTimeEntries = _timeEntries.where((entry) => entry.projectId == projectId).toList();
    
    final taskStats = {
      'total': projectTasks.length,
      'completed': projectTasks.where((t) => t.status == TaskStatus.done).length,
      'inProgress': projectTasks.where((t) => t.status == TaskStatus.inProgress).length,
      'todo': projectTasks.where((t) => t.status == TaskStatus.toDo).length,
    };
    
    final totalHours = projectTimeEntries.fold<double>(0.0, (sum, entry) => 
      sum + (entry.endTime != null ? entry.durationSeconds / 3600.0 : 0.0)
    );
    
    return {
      'project': project.toJson(),
      'taskStats': taskStats,
      'totalHours': totalHours,
      'memberCount': project.memberIds.length,
      'progress': projectTasks.isEmpty ? 0.0 : 
        projectTasks.where((t) => t.status == TaskStatus.done).length / projectTasks.length,
    };
  }

  Future<Map<String, dynamic>> getTimeTrackingStats({
    DateTime? startDate,
    DateTime? endDate,
    String? projectId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _initializeData();
    
    var entries = List<TimeEntryModel>.from(_timeEntries);
    
    if (startDate != null) {
      entries = entries.where((entry) => 
        entry.startTime.isAfter(startDate) || entry.startTime.isAtSameMomentAs(startDate)
      ).toList();
    }
    
    if (endDate != null) {
      entries = entries.where((entry) => 
        entry.startTime.isBefore(endDate) || entry.startTime.isAtSameMomentAs(endDate)
      ).toList();
    }
    
    if (projectId != null) {
      entries = entries.where((entry) => entry.projectId == projectId).toList();
    }
    
    return _calculateTimeStats(entries);
  }

  Future<TimeEntryModel> updateTimeEntry(
    String entryId, {
    String? description,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _initializeData();
    
    final index = _timeEntries.indexWhere((entry) => entry.id == entryId);
    if (index == -1) throw Exception('Time entry not found');
    
    final entry = _timeEntries[index];
    final updatedEntry = entry.copyWith(
      description: description,
      startTime: startTime,
      endTime: endTime,
      durationSeconds: endTime != null && startTime != null ? 
        endTime.difference(startTime).inSeconds : entry.durationSeconds,
      updatedAt: DateTime.now(),
    );
    
    _timeEntries[index] = updatedEntry;
    return updatedEntry;
  }

  Future<void> deleteTimeEntry(String entryId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _initializeData();
    
    final index = _timeEntries.indexWhere((entry) => entry.id == entryId);
    if (index == -1) throw Exception('Time entry not found');
    
    _timeEntries.removeAt(index);
  }

  Future<TimeEntryModel> createManualTimeEntry({
    required String taskId,
    required String projectId,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _initializeData();
    
    final currentUser = await getCurrentUser();
    
    final newEntry = TimeEntryModel(
      id: (_timeEntries.length + 1).toString(),
      userId: currentUser.id,
      taskId: taskId,
      projectId: projectId,
      description: description,
      startTime: startTime,
      endTime: endTime,
      durationSeconds: endTime.difference(startTime).inSeconds,
      type: TimeEntryType.manual,
      isActive: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    _timeEntries.add(newEntry);
    return newEntry;
  }

  // Reset data for testing
  void resetData() {
    _isDataInitialized = false;
    _currentUserId = null;
    _users.clear();
    _projects.clear();
    _tasks.clear();
    _comments.clear();
    _notifications.clear();
    _timeEntries.clear();
  }

  // PROJECT METHODS
Future<ProjectModel> updateProject(String projectId, Map<String, dynamic> updateData) async {
  await Future.delayed(const Duration(milliseconds: 500));
  _initializeData();
  
  final index = _projects.indexWhere((project) => project.id == projectId);
  if (index == -1) throw Exception('Project not found');
  
  final project = _projects[index];
  final updatedProject = project.copyWith(
    name: updateData['name'],
    description: updateData['description'],
    status: updateData['status'] != null ? 
      ProjectStatus.values.firstWhere((s) => s.name == updateData['status']) : null,
    memberIds: updateData['memberIds']?.cast<String>(),
    dueDate: updateData['dueDate'] != null ? 
      DateTime.parse(updateData['dueDate']) : null,
    updatedAt: DateTime.now(),
  );
  
  _projects[index] = updatedProject;
  return updatedProject;
}

Future<void> deleteProject(String id) async {
  await Future.delayed(const Duration(milliseconds: 300));
  _initializeData();
  
  final index = _projects.indexWhere((project) => project.id == id);
  if (index == -1) throw Exception('Project not found');
  
  // Also delete all tasks related to this project
  _tasks.removeWhere((task) => task.projectId == id);
  _comments.removeWhere((comment) => 
    _tasks.any((task) => task.id == comment.taskId && task.projectId == id));
  
  _projects.removeAt(index);
}

// TASK METHODS
Future<TaskModel> createTask(Map<String, dynamic> taskData) async {
  await Future.delayed(const Duration(milliseconds: 500));
  _initializeData();
  
  final newTask = TaskModel(
    id: (_tasks.length + 1).toString(),
    title: taskData['title'] as String,
    description: taskData['description'] as String? ?? '',
    status: taskData['status'] as TaskStatus? ?? TaskStatus.toDo,
    priority: taskData['priority'] as TaskPriority? ?? TaskPriority.medium,
    projectId: taskData['projectId'] as String,
    creatorId: taskData['creatorId'] as String,
    assigneeId: taskData['assigneeId'] as String?,
    dueDate: taskData['dueDate'] as DateTime?,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  
  _tasks.add(newTask);
  return newTask;
}

Future<TaskModel> updateTask(String taskId, Map<String, dynamic> updateData) async {
  await Future.delayed(const Duration(milliseconds: 500));
  _initializeData();
  
  final index = _tasks.indexWhere((task) => task.id == taskId);
  if (index == -1) throw Exception('Task not found');
  
  final task = _tasks[index];
  final updatedTask = task.copyWith(
    title: updateData['title'],
    description: updateData['description'],
    status: updateData['status'],
    priority: updateData['priority'],
    assigneeId: updateData['assigneeId'],
    dueDate: updateData['dueDate'],
    updatedAt: DateTime.now(),
  );
  
  _tasks[index] = updatedTask;
  return updatedTask;
}

Future<void> deleteTask(String id) async {
  await Future.delayed(const Duration(milliseconds: 300));
  _initializeData();
  
  final index = _tasks.indexWhere((task) => task.id == id);
  if (index == -1) throw Exception('Task not found');
  
  // Also delete all comments related to this task
  _comments.removeWhere((comment) => comment.taskId == id);
  _timeEntries.removeWhere((entry) => entry.taskId == id);
  
  _tasks.removeAt(index);
}

// COMMENT METHODS
Future<CommentModel> updateComment(String commentId, String content) async {
  await Future.delayed(const Duration(milliseconds: 400));
  _initializeData();
  
  final index = _comments.indexWhere((comment) => comment.id == commentId);
  if (index == -1) throw Exception('Comment not found');
  
  final comment = _comments[index];
  final updatedComment = comment.copyWith(
    content: content,
    updatedAt: DateTime.now(),
  );
  
  _comments[index] = updatedComment;
  return updatedComment;
}

Future<void> deleteComment(String commentId) async {
  await Future.delayed(const Duration(milliseconds: 300));
  _initializeData();
  
  final index = _comments.indexWhere((comment) => comment.id == commentId);
  if (index == -1) throw Exception('Comment not found');
  
  _comments.removeAt(index);
}

// NOTIFICATION METHODS - CORRECTED (removed readAt parameter)
Future<NotificationModel> markNotificationAsRead(String id) async {
  await Future.delayed(const Duration(milliseconds: 300));
  _initializeData();
  
  final index = _notifications.indexWhere((notification) => notification.id == id);
  if (index == -1) throw Exception('Notification not found');
  
  final notification = _notifications[index];
  final updatedNotification = notification.copyWith(
    isRead: true,
    // Note: NotificationModel doesn't have readAt parameter, so we remove it
  );
  
  _notifications[index] = updatedNotification;
  return updatedNotification;
}

Future<void> markAllNotificationsAsRead() async {
  await Future.delayed(const Duration(milliseconds: 500));
  _initializeData();
  
  for (int i = 0; i < _notifications.length; i++) {
    if (!_notifications[i].isRead) {
      _notifications[i] = _notifications[i].copyWith(
        isRead: true,
        // Note: NotificationModel doesn't have readAt parameter, so we remove it
      );
    }
  }
}

Future<void> deleteNotification(String id) async {
  await Future.delayed(const Duration(milliseconds: 300));
  _initializeData();
  
  final index = _notifications.indexWhere((notification) => notification.id == id);
  if (index == -1) throw Exception('Notification not found');
  
  _notifications.removeAt(index);
}

// ANALYTICS METHODS
Future<Map<String, dynamic>> getUserAnalytics(String userId) async {
  await Future.delayed(const Duration(milliseconds: 500));
  _initializeData();
  
  final userTasks = _tasks.where((task) => task.assigneeId == userId).toList();
  final userProjects = _projects.where((project) => 
    project.memberIds.contains(userId) || project.ownerId == userId).toList();
  final userTimeEntries = _timeEntries.where((entry) => entry.userId == userId).toList();
  
  final taskStats = {
    'total': userTasks.length,
    'completed': userTasks.where((t) => t.status == TaskStatus.completed || t.status == TaskStatus.done).length,
    'inProgress': userTasks.where((t) => t.status == TaskStatus.inProgress).length,
    'todo': userTasks.where((t) => t.status == TaskStatus.toDo).length,
  };
  
  final timeStats = {
    'totalHours': userTimeEntries.fold(0.0, (sum, entry) => sum + entry.durationHours),
    'entriesCount': userTimeEntries.length,
    'avgDailyHours': userTimeEntries.isEmpty ? 0.0 : 
      userTimeEntries.fold(0.0, (sum, entry) => sum + entry.durationHours) / 30, // Rough estimate
  };
  
  return {
    'userId': userId,
    'taskStats': taskStats,
    'projectCount': userProjects.length,
    'avgProjectProgress': userProjects.isEmpty ? 
      0.0 : userProjects.map((p) => p.progress).reduce((a, b) => a + b) / userProjects.length,
    'timeStats': timeStats,
  };
}

// CORRECTED: Fix method signature to match AppRepository call
Future<Map<String, dynamic>> getTimeAnalytics({
  DateTime? startDate,
  DateTime? endDate,
  String? projectId,
  String? userId,
}) async {
  await Future.delayed(const Duration(milliseconds: 500));
  _initializeData();
  
  // Use current user if userId not provided
  final targetUserId = userId ?? (await getCurrentUser()).id;
  
  // Set default date range if not provided
  final defaultStartDate = startDate ?? DateTime.now().subtract(const Duration(days: 30));
  final defaultEndDate = endDate ?? DateTime.now();
  
  // Filter entries based on criteria
  var filteredEntries = _timeEntries.where((entry) => entry.userId == targetUserId).toList();
  
  // Filter by date range
  filteredEntries = filteredEntries.where((entry) => 
    entry.startTime.isAfter(defaultStartDate.subtract(const Duration(days: 1))) &&
    entry.startTime.isBefore(defaultEndDate.add(const Duration(days: 1)))
  ).toList();
  
  // Filter by project if specified
  if (projectId != null) {
    filteredEntries = filteredEntries.where((entry) => entry.projectId == projectId).toList();
  }
  
  final totalHours = filteredEntries.fold(0.0, (sum, entry) => sum + entry.durationHours);
  
  // Group by day for daily breakdown
  final Map<String, double> dailyHours = {};
  for (final entry in filteredEntries) {
    final day = '${entry.startTime.year}-${entry.startTime.month.toString().padLeft(2, '0')}-${entry.startTime.day.toString().padLeft(2, '0')}';
    dailyHours[day] = (dailyHours[day] ?? 0.0) + entry.durationHours;
  }
  
  // Group by project for project breakdown
  final Map<String, double> projectHours = {};
  for (final entry in filteredEntries) {
    final project = _projects.firstWhere(
      (p) => p.id == entry.projectId,
      orElse: () => ProjectModel(
  id: '',
  name: 'Unknown Project',
  description: '',
  status: ProjectStatus.active,
  memberIds: [],
  creatorId: targetUserId, // FIXED: Added missing creatorId
  ownerId: targetUserId,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
),
    );
    projectHours[project.name] = (projectHours[project.name] ?? 0.0) + entry.durationHours;
  }
  
  return {
    'totalHours': totalHours,
    'entriesCount': filteredEntries.length,
    'dailyHours': dailyHours,
    'projectHours': projectHours,
    'avgDailyHours': dailyHours.isEmpty ? 0.0 : totalHours / dailyHours.length,
    'dateRange': {
      'startDate': defaultStartDate.toIso8601String(),
      'endDate': defaultEndDate.toIso8601String(),
    },
  };
}
// SEARCH METHODS
Future<Map<String, List<dynamic>>> search(String query) async {
  await Future.delayed(const Duration(milliseconds: 400));
  _initializeData();
  
  final projects = await searchProjects(query);
  final tasks = await searchTasks(query);
  final users = await searchUsers(query);
  
  return {
    'projects': projects,
    'tasks': tasks,
    'users': users,
  };
}

Future<List<ProjectModel>> searchProjects(String query) async {
  await Future.delayed(const Duration(milliseconds: 300));
  _initializeData();
  
  final lowerQuery = query.toLowerCase();
  return _projects.where((project) =>
    project.name.toLowerCase().contains(lowerQuery) ||
    project.description.toLowerCase().contains(lowerQuery)
  ).toList();
}

Future<List<TaskModel>> searchTasks(String query) async {
  await Future.delayed(const Duration(milliseconds: 300));
  _initializeData();
  
  final lowerQuery = query.toLowerCase();
  return _tasks.where((task) =>
    task.title.toLowerCase().contains(lowerQuery) ||
    task.description.toLowerCase().contains(lowerQuery)
  ).toList();
}

Future<List<UserModel>> searchUsers(String query) async {
  await Future.delayed(const Duration(milliseconds: 300));
  _initializeData();
  
  final lowerQuery = query.toLowerCase();
  return _users.where((user) =>
    user.name.toLowerCase().contains(lowerQuery) ||
    user.email.toLowerCase().contains(lowerQuery)
  ).toList();
}


// NEW: Get today's tasks for dashboard
Future<List<TaskModel>> getTodaysTasks({String? userId}) async {
  await Future.delayed(const Duration(milliseconds: 500));
  
  final today = DateTime.now();
  return _tasks.where((task) {
    if (userId != null && task.assigneeId != userId) return false;
    if (task.dueDate == null) return false;
    
    final taskDate = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
    final todayDate = DateTime(today.year, today.month, today.day);
    
    return taskDate.isAtSameMomentAs(todayDate);
  }).toList();
}

// NEW: Get overdue tasks
Future<List<TaskModel>> getOverdueTasks({String? userId}) async {
  await Future.delayed(const Duration(milliseconds: 500));
  
  final now = DateTime.now();
  return _tasks.where((task) {
    if (userId != null && task.assigneeId != userId) return false;
    if (task.dueDate == null) return false;
    if (task.status == TaskStatus.done) return false;
    
    return now.isAfter(task.dueDate!);
  }).toList();
}

// NEW: Get urgent tasks (high urgency score)
Future<List<TaskModel>> getUrgentTasks({String? userId}) async {
  await Future.delayed(const Duration(milliseconds: 500));
  
  return _tasks.where((task) {
    if (userId != null && task.assigneeId != userId) return false;
    if (task.status == TaskStatus.done) return false;
    
    return task.urgencyScore >= 0.7; // Using the new urgency calculation
  }).toList();
}

// NEW: Get project statistics
Future<Map<String, dynamic>> getProjectStats(String projectId) async {
  await Future.delayed(const Duration(milliseconds: 500));
  
  final projectTasks = _tasks.where((task) => task.projectId == projectId).toList();
  final totalTasks = projectTasks.length;
  final completedTasks = projectTasks.where((task) => task.status == TaskStatus.done).length;
  final overdueTasks = projectTasks.where((task) => task.isOverdue).length;
  final urgentTasks = projectTasks.where((task) => task.urgencyScore >= 0.7).length;
  
  return {
    'totalTasks': totalTasks,
    'completedTasks': completedTasks,
    'overdueTasks': overdueTasks,
    'urgentTasks': urgentTasks,
    'progressPercentage': totalTasks > 0 ? (completedTasks / totalTasks * 100).round() : 0,
    'healthScore': totalTasks > 0 ? 1.0 - (overdueTasks / totalTasks * 0.5) : 1.0,
  };
}

// NEW: Get dashboard summary stats
Future<Map<String, dynamic>> getDashboardStats({String? userId}) async {
  await Future.delayed(const Duration(milliseconds: 500));
  
  final userTasks = userId != null 
    ? _tasks.where((task) => task.assigneeId == userId).toList()
    : _tasks;
  
  final userProjects = userId != null
    ? _projects.where((project) => project.memberIds.contains(userId)).toList()
    : _projects;
  
  final totalTasks = userTasks.length;
  final completedTasks = userTasks.where((task) => task.status == TaskStatus.done).length;
  final overdueTasks = userTasks.where((task) => task.isOverdue).length;
  final urgentTasks = userTasks.where((task) => task.urgencyScore >= 0.7).length;
  
  final activeProjects = userProjects.where((project) => project.status == ProjectStatus.active).length;
  final completedProjects = userProjects.where((project) => project.status == ProjectStatus.completed).length;
  
  return {
    'totalTasks': totalTasks,
    'completedTasks': completedTasks,
    'pendingTasks': totalTasks - completedTasks,
    'overdueTasks': overdueTasks,
    'urgentTasks': urgentTasks,
    'totalProjects': userProjects.length,
    'activeProjects': activeProjects,
    'completedProjects': completedProjects,
    'productivity': totalTasks > 0 ? (completedTasks / totalTasks * 100).round() : 0,
  };
}

// NEW: Get recent activity (simulated)
Future<List<Map<String, dynamic>>> getRecentActivity({String? userId, int limit = 10}) async {
  await Future.delayed(const Duration(milliseconds: 500));
  
  final activities = <Map<String, dynamic>>[];
  
  // Add task completions
  final recentCompletedTasks = _tasks
    .where((task) => task.status == TaskStatus.done)
    .where((task) => userId == null || task.assigneeId == userId)
    .take(3)
    .toList();
  
  for (final task in recentCompletedTasks) {
    activities.add({
      'id': 'task_${task.id}',
      'type': 'task_completed',
      'title': 'Completed task: ${task.title}',
      'subtitle': 'In project: ${_getProjectName(task.projectId)}',
      'timestamp': task.updatedAt,
      'icon': Icons.check_circle,
      'color': Colors.green,
    });
  }
  
  // Add new task assignments
  final recentTasks = _tasks
    .where((task) => task.status != TaskStatus.done)
    .where((task) => userId == null || task.assigneeId == userId)
    .take(3)
    .toList();
  
  for (final task in recentTasks) {
    activities.add({
      'id': 'assignment_${task.id}',
      'type': 'task_assigned',
      'title': 'Assigned to task: ${task.title}',
      'subtitle': 'Priority: ${task.priority.displayName}',
      'timestamp': task.createdAt,
      'icon': Icons.assignment,
      'color': task.urgencyColor,
    });
  }
  
  // Sort by timestamp and limit
  activities.sort((a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
  return activities.take(limit).toList();
}

// Helper method to get project name
String _getProjectName(String projectId) {
  try {
    return _projects.firstWhere((project) => project.id == projectId).name;
  } catch (e) {
    return 'Unknown Project';
  }
}

// NEW: Get task distribution by status
Future<Map<String, int>> getTaskDistribution({String? projectId}) async {
  await Future.delayed(const Duration(milliseconds: 500));
  
  final relevantTasks = projectId != null 
    ? _tasks.where((task) => task.projectId == projectId).toList()
    : _tasks;
  
  return {
    'toDo': relevantTasks.where((task) => task.status == TaskStatus.toDo).length,
    'inProgress': relevantTasks.where((task) => task.status == TaskStatus.inProgress).length,
    'done': relevantTasks.where((task) => task.status == TaskStatus.done).length,
  };
}

// NEW: Get priority distribution
Future<Map<String, int>> getPriorityDistribution({String? projectId}) async {
  await Future.delayed(const Duration(milliseconds: 500));
  
  final relevantTasks = projectId != null 
    ? _tasks.where((task) => task.projectId == projectId).toList()
    : _tasks;
  
  return {
    'low': relevantTasks.where((task) => task.priority == TaskPriority.low).length,
    'medium': relevantTasks.where((task) => task.priority == TaskPriority.medium).length,
    'high': relevantTasks.where((task) => task.priority == TaskPriority.high).length,
    'urgent': relevantTasks.where((task) => task.priority == TaskPriority.urgent).length,
  };
}
}