

// // lib/presentation/views/projects/project_detail_screen.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../data/models/project_model.dart';
// import '../../../data/models/task_model.dart';
// import '../../../data/models/time_entry_model.dart';
// import '../../../data/models/user_model.dart';
// import '../../viewmodels/project_viewmodel.dart';
// import '../../viewmodels/task_viewmodel.dart';
// import '../../viewmodels/time_tracking_viewmodel.dart';
// import '../../widgets/project/project_info_tab.dart';
// import '../../widgets/project/project_tasks_tab.dart';
// import '../../widgets/project/project_members_tab.dart';
// import '../../widgets/project/project_time_tracking_tab.dart';
// import '../../widgets/project/project_analytics_tab.dart';
// import '../../widgets/project/project_timeline_tab.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/enums/project_status.dart';

// class ProjectDetailScreen extends StatefulWidget {
//   final String projectId;

//   const ProjectDetailScreen({
//     Key? key,
//     required this.projectId,
//   }) : super(key: key);

//   @override
//   State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
// }

// class _ProjectDetailScreenState extends State<ProjectDetailScreen>
//     with TickerProviderStateMixin {
//   late TabController _tabController;
//   ProjectModel? _project;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 6, vsync: this);
//     _loadProjectData();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _loadProjectData() async {
//     final projectVM = Provider.of<ProjectViewModel>(context, listen: false);
//     final taskVM = Provider.of<TaskViewModel>(context, listen: false);
//     final timeVM = Provider.of<TimeTrackingViewModel>(context, listen: false);

//     await projectVM.loadProjectById(widget.projectId);
//     await taskVM.loadTasks(projectId: widget.projectId);
//     await timeVM.loadTimeEntries(projectId: widget.projectId);

//     setState(() {
//       _project = projectVM.projects.firstWhere(
//         (p) => p.id == widget.projectId,
//         orElse: () => throw Exception('Project not found'),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer3<ProjectViewModel, TaskViewModel, TimeTrackingViewModel>(
//         builder: (context, projectVM, taskVM, timeVM, child) {
//           if (_project == null) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           return NestedScrollView(
//             headerSliverBuilder: (context, innerBoxIsScrolled) {
//               return [
//                 SliverAppBar(
//                   expandedHeight: 200,
//                   pinned: true,
//                   flexibleSpace: FlexibleSpaceBar(
//                     title: Text(_project!.name),
//                     background: Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             _getStatusColor(_project!.status),
//                             _getStatusColor(_project!.status).withOpacity(0.7),
//                           ],
//                         ),
//                       ),
//                       child: _buildProjectHeader(),
//                     ),
//                   ),
//                   actions: [
//                     IconButton(
//                       icon: const Icon(Icons.edit),
//                       onPressed: () => _editProject(),
//                     ),
//                     PopupMenuButton(
//                       itemBuilder: (context) => [
//                         const PopupMenuItem(
//                           value: 'archive',
//                           child: Row(
//                             children: [
//                               Icon(Icons.archive),
//                               SizedBox(width: 8),
//                               Text('Archive Project'),
//                             ],
//                           ),
//                         ),
//                         const PopupMenuItem(
//                           value: 'export',
//                           child: Row(
//                             children: [
//                               Icon(Icons.download),
//                               SizedBox(width: 8),
//                               Text('Export Report'),
//                             ],
//                           ),
//                         ),
//                         const PopupMenuItem(
//                           value: 'duplicate',
//                           child: Row(
//                             children: [
//                               Icon(Icons.copy),
//                               SizedBox(width: 8),
//                               Text('Duplicate Project'),
//                             ],
//                           ),
//                         ),
//                       ],
//                       onSelected: (value) => _handleMenuAction(value),
//                     ),
//                   ],
//                 ),
//                 SliverPersistentHeader(
//                   delegate: _SliverTabBarDelegate(
//                     TabBar(
//                       controller: _tabController,
//                       isScrollable: true,
//                       labelColor: AppColors.primary,
//                       unselectedLabelColor: AppColors.textSecondary,
//                       indicatorColor: AppColors.primary,
//                       tabs: const [
//                         Tab(icon: Icon(Icons.info), text: 'Overview'),
//                         Tab(icon: Icon(Icons.task), text: 'Tasks'),
//                         Tab(icon: Icon(Icons.people), text: 'Team'),
//                         Tab(icon: Icon(Icons.access_time), text: 'Time'),
//                         Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
//                         Tab(icon: Icon(Icons.timeline), text: 'Timeline'),
//                       ],
//                     ),
//                   ),
//                   pinned: true,
//                 ),
//               ];
//             },
//             body: TabBarView(
//               controller: _tabController,
//               children: [
//                 ProjectInfoTab(project: _project!),
//                 ProjectTasksTab(
//                   project: _project!,
//                   tasks: taskVM.tasks,
//                 ),
//                 ProjectMembersTab(project: _project!),
//                 ProjectTimeTrackingTab(
//                   project: _project!,
//                   timeEntries: timeVM.timeEntries,
//                 ),
//                 ProjectAnalyticsTab(
//                   project: _project!,
//                   tasks: taskVM.tasks,
//                   timeEntries: timeVM.timeEntries,
//                 ),
//                 ProjectTimelineTab(
//                   project: _project!,
                  
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//       floatingActionButton: _buildFloatingActionButton(),
//     );
//   }

//   Widget _buildProjectHeader() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   _project!.status.displayName,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//               const Spacer(),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   '${(_project!.progress * 100).toInt()}% Complete',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             _project!.description,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFloatingActionButton() {
//     return Consumer<TabController>(
//       builder: (context, _, __) {
//         switch (_tabController.index) {
//           case 1: // Tasks tab
//             return FloatingActionButton(
//               onPressed: () => _addTask(),
//               child: const Icon(Icons.add_task),
//             );
//           case 2: // Team tab
//             return FloatingActionButton(
//               onPressed: () => _addMember(),
//               child: const Icon(Icons.person_add),
//             );
//           case 3: // Time tab
//             return FloatingActionButton(
//               onPressed: () => _addTimeEntry(),
//               child: const Icon(Icons.add_alarm),
//             );
//           default:
//             return const SizedBox.shrink();
//         }
//       },
//     );
//   }

//   Color _getStatusColor(ProjectStatus status) {
//     switch (status) {
//       case ProjectStatus.planning:
//         return AppColors.info;
//       case ProjectStatus.active:
//         return AppColors.success;
//       case ProjectStatus.onHold:
//         return AppColors.warning;
//       case ProjectStatus.completed:
//         return AppColors.primary;
//       case ProjectStatus.cancelled:
//         return AppColors.error;
//     }
//   }

//   void _editProject() {
//     Navigator.pushNamed(
//       context,
//       '/project/edit',
//       arguments: _project!.id,
//     );
//   }

//   void _handleMenuAction(String action) {
//     switch (action) {
//       case 'archive':
//         _showArchiveDialog();
//         break;
//       case 'export':
//         _exportProjectReport();
//         break;
//       case 'duplicate':
//         _duplicateProject();
//         break;
//     }
//   }

//   void _showArchiveDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Archive Project'),
//         content: const Text(
//           'Are you sure you want to archive this project? '
//           'This action can be undone later.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _archiveProject();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.warning,
//             ),
//             child: const Text('Archive'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _exportProjectReport() {
//     // TODO: Implement export functionality
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Export feature coming soon!')),
//     );
//   }

//   void _duplicateProject() {
//     // TODO: Implement duplicate functionality
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Duplicate feature coming soon!')),
//     );
//   }

//   void _archiveProject() {
//     // TODO: Implement archive functionality
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Project archived successfully')),
//     );
//   }

//   void _addTask() {
//     Navigator.pushNamed(
//       context,
//       '/task/create',
//       arguments: {'projectId': _project!.id},
//     );
//   }

//   void _addMember() {
//     Navigator.pushNamed(
//       context,
//       '/project/add-member',
//       arguments: _project!.id,
//     );
//   }

//   void _addTimeEntry() {
//     Navigator.pushNamed(
//       context,
//       '/time/create',
//       arguments: {'projectId': _project!.id},
//     );
//   }
// }

// class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
//   final TabBar _tabBar;

//   _SliverTabBarDelegate(this._tabBar);

//   @override
//   double get minExtent => _tabBar.preferredSize.height;

//   @override
//   double get maxExtent => _tabBar.preferredSize.height;

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return Container(
//       color: Theme.of(context).scaffoldBackgroundColor,
//       child: _tabBar,
//     );
//   }

//   @override
//   bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
//     return false;
//   }
// }


//2



import 'package:flowence/core/enums/task_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/project_model.dart';
import '../../viewmodels/project_viewmodel.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../../viewmodels/time_tracking_viewmodel.dart';
import '../../../core/constants/app_colors.dart';

class ProjectDetailScreen extends StatefulWidget {
  final String projectId;

  const ProjectDetailScreen({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  ProjectModel? _project;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Reduced tabs for now
    _loadProjectData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadProjectData() async {
    try {
      // Get providers safely with error handling
      final projectVM = Provider.of<ProjectViewModel>(context, listen: false);
      final taskVM = Provider.of<TaskViewModel>(context, listen: false);
      
      // Load project data
      await projectVM.loadProjectById(widget.projectId);
      await taskVM.loadTasks(projectId: widget.projectId);
      
      // Try to load time tracking if available
      try {
        final timeVM = Provider.of<TimeTrackingViewModel>(context, listen: false);
        await timeVM.loadTimeEntries(projectId: widget.projectId);
      } catch (e) {
        // TimeTrackingViewModel might not be available, continue without it
        debugPrint('TimeTracking not available: $e');
      }

      // Get the project
      final project = projectVM.projects.firstWhere(
        (p) => p.id == widget.projectId,
        orElse: () => throw Exception('Project not found'),
      );

      if (mounted) {
        setState(() {
          _project = project;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error: $_error',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadProjectData();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_project == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Project Not Found'),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Project not found'),
        ),
      );
    }

    return Scaffold(
      body: Consumer2<ProjectViewModel, TaskViewModel>(
        builder: (context, projectVM, taskVM, child) {
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(_project!.name),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primaryBlue,
                            AppColors.primaryBlue.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(height: 40), // Account for title space
                            Text(
                              _project!.description,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverTabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.primaryBlue,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColors.primaryBlue,
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Tasks'),
                        Tab(text: 'Members'),
                        Tab(text: 'Analytics'),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildTasksTab(taskVM),
                _buildMembersTab(),
                _buildAnalyticsTab(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Project Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Status', _project!.status.displayName),
                  if (_project!.startDate != null)
  _buildInfoRow('Start Date', _formatDate(_project!.startDate!)),
                  if (_project!.dueDate != null)
                    _buildInfoRow('Due Date', _formatDate(_project!.dueDate!)),
                  _buildInfoRow('Progress', '${(_project!.progress * 100).toInt()}%'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildTasksTab(TaskViewModel taskVM) {
  //   final projectTasks = taskVM.tasks.where((task) => task.projectId == widget.projectId).toList();
    
  //   if (projectTasks.isEmpty) {
  //     return const Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(Icons.task_alt, size: 64, color: Colors.grey),
  //           SizedBox(height: 16),
  //           Text('No tasks found'),
  //         ],
  //       ),
  //     );
  //   }

  //   return ListView.builder(
  //     padding: const EdgeInsets.all(16),
  //     itemCount: projectTasks.length,
  //     itemBuilder: (context, index) {
  //       final task = projectTasks[index];
  //       return Card(
  //         child: ListTile(
  //           title: Text(task.title),
  //           subtitle: Text(task.description),
  //           trailing: Chip(
  //             label: Text(task.status.displayName),
  //             backgroundColor: _getStatusColor(task.status.toString()),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }



Widget _buildTasksTab(TaskViewModel taskVM) {
  final projectTasks = taskVM.tasks.where((task) => task.projectId == widget.projectId).toList();
  
  if (projectTasks.isEmpty) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No tasks found'),
        ],
      ),
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: projectTasks.length,
    itemBuilder: (context, index) {
      final task = projectTasks[index];
      return Card(
        child: ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: Chip(
            // FIXED: Use a helper function instead of .displayName
            label: Text(_getTaskStatusText(task.status)),
            backgroundColor: _getStatusColor(task.status),
          ),
        ),
      );
    },
  );
}


String _getTaskStatusText(TaskStatus status) {
  switch (status) {
    case TaskStatus.toDo:
      return 'To Do';
    case TaskStatus.inProgress:
      return 'In Progress';
    case TaskStatus.inReview:
      return 'In Review';
    case TaskStatus.completed:
    case TaskStatus.done:
      return 'Completed';
    case TaskStatus.cancelled:
      return 'Cancelled';
    default:
      return 'Unknown';
  }
}

Color _getStatusColor(TaskStatus status) {
  switch (status) {
    case TaskStatus.completed:
    case TaskStatus.done:
      return Colors.green.withOpacity(0.2);
    case TaskStatus.inProgress:
      return Colors.blue.withOpacity(0.2);
    case TaskStatus.inReview:
      return Colors.orange.withOpacity(0.2);
    case TaskStatus.cancelled:
      return Colors.red.withOpacity(0.2);
    case TaskStatus.toDo:
    default:
      return Colors.grey.withOpacity(0.2);
  }
}

  Widget _buildMembersTab() {
    return const Center(
      child: Text('Members tab - Coming soon'),
    );
  }

  Widget _buildAnalyticsTab() {
    return const Center(
      child: Text('Analytics tab - Coming soon'),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Color _getStatusColor(String status) {
  //   switch (status.toLowerCase()) {
  //     case 'completed':
  //       return Colors.green.withOpacity(0.2);
  //     case 'inprogress':
  //       return Colors.blue.withOpacity(0.2);
  //     default:
  //       return Colors.orange.withOpacity(0.2);
  //   }
  // }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}  

