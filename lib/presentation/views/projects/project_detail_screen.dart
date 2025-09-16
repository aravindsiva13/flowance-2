
// // lib/presentation/views/projects/project_detail_screen.dart - ENHANCED WITH TIME TRACKING

// import 'package:flowence/core/enums/project_status.dart';
// import 'package:flowence/core/enums/task_status.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../../viewmodels/project_viewmodel.dart';
// import '../../viewmodels/task_viewmodel.dart';
// import '../../viewmodels/time_tracking_viewmodel.dart';
// import '../../widgets/common/custom_app_bar.dart';
// import '../../widgets/common/loading_widget.dart';
// import '../../widgets/task/task_card.dart';
// import '../../widgets/time/time_entry_card.dart';
// import '../../widgets/project/project_time_summary_card.dart';
// import '../../../data/models/project_model.dart';
// import '../../../data/models/task_model.dart';
// import '../../../data/models/time_entry_model.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/utils/date_utils.dart';
// import '../../../routes/app_routes.dart';

// class ProjectDetailScreen extends StatefulWidget {
//   final String projectId;

//   const ProjectDetailScreen({Key? key, required this.projectId}) : super(key: key);

//   @override
//   State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
// }

// class _ProjectDetailScreenState extends State<ProjectDetailScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   ProjectModel? _project;
//   DateTime _selectedTimeRange = DateTime.now().subtract(const Duration(days: 30));

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this); // Added Time tab
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadData();
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadData() async {
//     final projectVM = context.read<ProjectViewModel>();
//     final taskVM = context.read<TaskViewModel>();
//     final timeVM = context.read<TimeTrackingViewModel>();

//     // Load project data
//     _project = await projectVM.getProject(widget.projectId);
//     if (_project != null) {
//       setState(() {});
//     }

//     // Load associated data
//     await Future.wait([
//       taskVM.loadTasks(projectId: widget.projectId),
//       timeVM.loadTimeEntries(
//         projectId: widget.projectId,
//         startDate: _selectedTimeRange,
//       ),
//     ]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: _project?.name ?? 'Project Details',
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: _handleMenuAction,
//             itemBuilder: (context) => [
//               const PopupMenuItem(
//                 value: 'edit',
//                 child: Row(
//                   children: [
//                     Icon(Icons.edit_rounded),
//                     SizedBox(width: 8),
//                     Text('Edit Project'),
//                   ],
//                 ),
//               ),
//               const PopupMenuItem(
//                 value: 'archive',
//                 child: Row(
//                   children: [
//                     Icon(Icons.archive_rounded),
//                     SizedBox(width: 8),
//                     Text('Archive'),
//                   ],
//                 ),
//               ),
//               const PopupMenuItem(
//                 value: 'export',
//                 child: Row(
//                   children: [
//                     Icon(Icons.download_rounded),
//                     SizedBox(width: 8),
//                     Text('Export Report'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: _project == null
//           ? const LoadingWidget(message: 'Loading project details...')
//           : Column(
//               children: [
//                 _buildProjectHeader(),
//                 _buildTabBar(),
//                 Expanded(
//                   child: TabBarView(
//                     controller: _tabController,
//                     children: [
//                       _buildOverviewTab(),
//                       _buildTasksTab(),
//                       _buildTimeTrackingTab(), // NEW: Time tracking tab
//                       _buildTeamTab(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//       floatingActionButton: _buildFloatingActionButton(),
//     );
//   }

//   Widget _buildProjectHeader() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: const BoxDecoration(
//         color: AppColors.surface,
//         border: Border(bottom: BorderSide(color: AppColors.borderLight)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _project!.name,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       _project!.description,
//                       style: const TextStyle(
//                         color: AppColors.textSecondary,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               _buildStatusChip(_project!.status),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(child: _buildProgressCard()),
//               const SizedBox(width: 16),
//               Expanded(child: _buildDateCard()),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusChip(ProjectStatus status) {
//     Color color;
//     switch (status) {
//       case ProjectStatus.active:
//         color = AppColors.success;
//         break;
//       case ProjectStatus.planning:
//         color = AppColors.warning;
//         break;
//       case ProjectStatus.completed:
//         color = AppColors.info;
//         break;
//       case ProjectStatus.onHold:
//       color = AppColors.error;
//       break;
//     case ProjectStatus.cancelled:  // ADD THIS CASE
//       color = AppColors.error;
//       break;
//     }

//     return Chip(
//       label: Text(
//         status.displayName,
//         style: TextStyle(color: color, fontWeight: FontWeight.w600),
//       ),
//       backgroundColor: color.withOpacity(0.1),
//       side: BorderSide(color: color.withOpacity(0.3)),
//     );
//   }

//   Widget _buildProgressCard() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Progress', style: TextStyle(fontWeight: FontWeight.w600)),
//             const SizedBox(height: 8),
//             LinearProgressIndicator(
//               value: _project!.progress,
//               backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
//               valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
//             ),
//             const SizedBox(height: 4),
//             Text('${(_project!.progress * 100).toInt()}% complete'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDateCard() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Timeline', style: TextStyle(fontWeight: FontWeight.w600)),
//             const SizedBox(height: 8),
//             if (_project!.dueDate != null) ...[
//               Text(
//                 'Due: ${AppDateUtils.formatDate(_project!.dueDate!)}',
//                 style: const TextStyle(fontSize: 14),
//               ),
//               Text(
//                 _getDaysRemaining(),
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: _getDaysRemainingColor(),
//                 ),
//               ),
//             ] else ...[
//               const Text('No due date set', style: TextStyle(fontSize: 14)),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   String _getDaysRemaining() {
//     if (_project!.dueDate == null) return '';
//     final remaining = _project!.dueDate!.difference(DateTime.now()).inDays;
//     if (remaining < 0) return '${-remaining} days overdue';
//     if (remaining == 0) return 'Due today';
//     return '$remaining days remaining';
//   }

//   Color _getDaysRemainingColor() {
//     if (_project!.dueDate == null) return AppColors.textSecondary;
//     final remaining = _project!.dueDate!.difference(DateTime.now()).inDays;
//     if (remaining < 0) return AppColors.error;
//     if (remaining <= 7) return AppColors.warning;
//     return AppColors.success;
//   }

//   Widget _buildTabBar() {
//     return Container(
//       decoration: const BoxDecoration(
//         border: Border(bottom: BorderSide(color: AppColors.borderLight)),
//       ),
//       child: TabBar(
//         controller: _tabController,
//         labelColor: AppColors.primaryBlue,
//         unselectedLabelColor: AppColors.textSecondary,
//         indicatorColor: AppColors.primaryBlue,
//         tabs: const [
//           Tab(text: 'Overview'),
//           Tab(text: 'Tasks'),
//           Tab(text: 'Time Tracking'), // NEW TAB
//           Tab(text: 'Team'),
//         ],
//       ),
//     );
//   }

//   Widget _buildOverviewTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildQuickStats(),
//           const SizedBox(height: 24),
//           _buildRecentActivity(),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickStats() {
//     return Consumer2<TaskViewModel, TimeTrackingViewModel>(
//       builder: (context, taskVM, timeVM, child) {
//         final projectTasks = taskVM.tasks.where((t) => t.projectId == widget.projectId).toList();
//         final completedTasks = projectTasks.where((t) => t.status == TaskStatus.done).length;
//        final totalHours = timeVM.timeEntries
//     .where((entry) => entry.projectId == widget.projectId)
//     .fold(0.0, (sum, entry) => sum + entry.durationHours);

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Quick Stats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           const Icon(Icons.task_alt, size: 32, color: AppColors.primaryBlue),
//                           const SizedBox(height: 8),
//                           Text('$completedTasks/${projectTasks.length}', 
//                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                           const Text('Tasks Done'),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           const Icon(Icons.access_time, size: 32, color: AppColors.success),
//                           const SizedBox(height: 8),
//                           Text('${totalHours.toStringAsFixed(1)}h', 
//                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                           const Text('Time Logged'),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           const Icon(Icons.group, size: 32, color: AppColors.secondary),
//                           const SizedBox(height: 8),
//                           Text('${_project!.memberIds.length}', 
//                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                           const Text('Team Members'),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildTasksTab() {
//     return Consumer<TaskViewModel>(
//       builder: (context, taskVM, child) {
//         final projectTasks = taskVM.tasks.where((t) => t.projectId == widget.projectId).toList();
        
//         if (taskVM.isLoading) {
//           return const LoadingWidget(message: 'Loading tasks...');
//         }

//         if (projectTasks.isEmpty) {
//           return _buildEmptyState('No tasks yet', 'Create your first task to get started');
//         }

//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: projectTasks.length,
//           itemBuilder: (context, index) {
//             final task = projectTasks[index];
//             return TaskCard(
//               task: task,
//               showProject: false, // Don't show project name since we're in project view
//               onTap: () {
//                 Navigator.pushNamed(
//                   context,
//                   AppRoutes.taskDetail,
//                   arguments: task.id,
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   // NEW: Time Tracking Tab Implementation
//   Widget _buildTimeTrackingTab() {
//     return Consumer<TimeTrackingViewModel>(
//       builder: (context, timeVM, child) {
//         return Column(
//           children: [
//             _buildTimeTrackingHeader(timeVM),
//             Expanded(
//               child: DefaultTabController(
//                 length: 3,
//                 child: Column(
//                   children: [
//                     const TabBar(
//                       labelColor: AppColors.primaryBlue,
//                       unselectedLabelColor: AppColors.textSecondary,
//                       indicatorColor: AppColors.primaryBlue,
//                       tabs: [
//                         Tab(text: 'Summary'),
//                         Tab(text: 'Entries'),
//                         Tab(text: 'Analytics'),
//                       ],
//                     ),
//                     Expanded(
//                       child: TabBarView(
//                         children: [
//                           _buildTimeSummaryView(timeVM),
//                           _buildTimeEntriesView(timeVM),
//                           _buildTimeAnalyticsView(timeVM),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildTimeTrackingHeader(TimeTrackingViewModel timeVM) {
//     final projectEntries = timeVM.filteredTimeEntries
//         .where((entry) => entry.projectId == widget.projectId)
//         .toList();
    
//     final totalHours = projectEntries.fold<double>(
//       0.0, (sum, entry) => sum + entry.durationHours);
    
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: const BoxDecoration(
//         color: AppColors.surface,
//         border: Border(bottom: BorderSide(color: AppColors.borderLight)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: ProjectTimeSummaryCard(
//               projectId: widget.projectId,
//               totalHours: totalHours,
//               entriesCount: projectEntries.length,
//               dateRange: '${AppDateUtils.formatDate(_selectedTimeRange)} - ${AppDateUtils.formatDate(DateTime.now())}',
//             ),
//           ),
//           IconButton(
//             onPressed: () => _showDateRangePicker(timeVM),
//             icon: const Icon(Icons.date_range),
//             tooltip: 'Change date range',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTimeSummaryView(TimeTrackingViewModel timeVM) {
//     // Implementation for time summary with charts and breakdowns
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildTimeByMemberCard(timeVM),
//           const SizedBox(height: 16),
//           _buildTimeByTaskCard(timeVM),
//           const SizedBox(height: 16),
//           _buildTimeTrendsCard(timeVM),
//         ],
//       ),
//     );
//   }

//   Widget _buildTimeEntriesView(TimeTrackingViewModel timeVM) {
//     final projectEntries = timeVM.filteredTimeEntries
//         .where((entry) => entry.projectId == widget.projectId)
//         .toList()
//       ..sort((a, b) => b.startTime.compareTo(a.startTime));

//     if (projectEntries.isEmpty) {
//       return _buildEmptyState('No time entries', 'Start tracking time for this project');
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: projectEntries.length,
//       itemBuilder: (context, index) {
//         final entry = projectEntries[index];
//         return TimeEntryCard(
//           entry: entry,
//           showTaskName: true,
//           showProjectName: false, // We're already in project context
//           onEdit: () => _editTimeEntry(entry),
//           onDelete: () => _deleteTimeEntry(entry.id),
//         );
//       },
//     );
//   }

//   Widget _buildTimeAnalyticsView(TimeTrackingViewModel timeVM) {
//     // Implementation for detailed analytics with charts
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           _buildTimeDistributionChart(timeVM),
//           const SizedBox(height: 16),
//           _buildProductivityChart(timeVM),
//         ],
//       ),
//     );
//   }

//   // Helper methods for time tracking widgets
//   Widget _buildTimeByMemberCard(TimeTrackingViewModel timeVM) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Time by Team Member', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             // Implementation for member time breakdown
//             const Text('Team member time breakdown coming soon...'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeByTaskCard(TimeTrackingViewModel timeVM) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Time by Task', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             // Implementation for task time breakdown
//             const Text('Task time breakdown coming soon...'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeTrendsCard(TimeTrackingViewModel timeVM) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Time Trends', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             // Implementation for time trends
//             const Text('Time trends coming soon...'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeDistributionChart(TimeTrackingViewModel timeVM) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Time Distribution', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             // Pie chart implementation
//             const Text('Time distribution chart coming soon...'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProductivityChart(TimeTrackingViewModel timeVM) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Productivity Trends', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             // Line chart implementation
//             const Text('Productivity trends chart coming soon...'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTeamTab() {
//     return Consumer<ProjectViewModel>(
//       builder: (context, projectVM, child) {
//         if (_project!.memberIds.isEmpty) {
//           return _buildEmptyState('No team members', 'Add team members to this project');
//         }

//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: _project!.memberIds.length,
//           itemBuilder: (context, index) {
//             final memberId = _project!.memberIds[index];
//             return Card(
//               child: ListTile(
//                 leading: CircleAvatar(
//                   child: Text(memberId[0].toUpperCase()),
//                 ),
//                 title: Text('Team Member $memberId'),
//                 subtitle: const Text('Role information'),
//                 trailing: PopupMenuButton<String>(
//                   onSelected: (value) => _handleTeamMemberAction(value, memberId),
//                   itemBuilder: (context) => [
//                     const PopupMenuItem(
//                       value: 'view_time',
//                       child: Text('View Time Logs'),
//                     ),
//                     const PopupMenuItem(
//                       value: 'view_tasks',
//                       child: Text('View Tasks'),
//                     ),
//                     if (_project!.ownerId != memberId)
//                       const PopupMenuItem(
//                         value: 'remove',
//                         child: Text('Remove from Project'),
//                       ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildRecentActivity() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 16),
//         Card(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 _buildActivityItem(
//                   icon: Icons.task_alt,
//                   title: 'Task "Setup Database" completed',
//                   subtitle: '2 hours ago by Bob Developer',
//                   color: AppColors.success,
//                 ),
//                 const Divider(),
//                 _buildActivityItem(
//                   icon: Icons.access_time,
//                   title: '3.5 hours logged on "UI Design"',
//                   subtitle: '4 hours ago by Alice Designer',
//                   color: AppColors.primaryBlue,
//                 ),
//                 const Divider(),
//                 _buildActivityItem(
//                   icon: Icons.comment,
//                   title: 'New comment on "API Integration"',
//                   subtitle: '1 day ago by Jane Manager',
//                   color: AppColors.secondary,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildActivityItem({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color,
//   }) {
//     return Row(
//       children: [
//         CircleAvatar(
//           radius: 16,
//           backgroundColor: color.withOpacity(0.1),
//           child: Icon(icon, size: 16, color: color),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
//               Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmptyState(String title, String subtitle) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.inbox_rounded, size: 80, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(title, style: TextStyle(fontSize: 18, color: Colors.grey[600])),
//           const SizedBox(height: 8),
//           Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[500])),
//         ],
//       ),
//     );
//   }

//   // Widget? _buildFloatingActionButton() {
//   //   switch (_tabController.index) {
//   //     case 1: // Tasks tab
//   //       return FloatingActionButton(
//   //         heroTag: "project_detail_add_task",
//   //         onPressed: () {
//   //           Navigator.pushNamed(
//   //             context,
//   //             AppRoutes.createTask,
//   //             arguments: widget.projectId,
//   //           );
//   //         },
//   //         child: const Icon(Icons.add_task),
//   //       );
//   //     case 2: // Time tracking tab
//   //       return FloatingActionButton(
//   //         heroTag: "project_detail_start_timer",
//   //         onPressed: () => _showStartTimerDialog(),
//   //         child: const Icon(Icons.play_arrow),
//   //       );
//   //     default:
//   //       return null;
//   //   }
//   // }


// Widget? _buildFloatingActionButton() {
//   switch (_tabController.index) {
//     case 1: // Tasks tab
//       return FloatingActionButton(
//         heroTag: "project_detail_add_task_fab", // ADD THIS LINE
//         onPressed: () {
//           Navigator.pushNamed(
//             context,
//             AppRoutes.createTask,
//             arguments: widget.projectId,
//           );
//         },
//         child: const Icon(Icons.add_task),
//       );
//     case 2: // Time tracking tab
//       return FloatingActionButton(
//         heroTag: "project_detail_start_timer_fab", // ADD THIS LINE
//         onPressed: () => _showStartTimerDialog(),
//         child: const Icon(Icons.play_arrow),
//       );
//     default:
//       return null;
//   }
// }


//   void _handleMenuAction(String action) {
//     switch (action) {
//       case 'edit':
//         Navigator.pushNamed(context, AppRoutes.editProject, arguments: widget.projectId);
//         break;
//       case 'archive':
//         _showArchiveDialog();
//         break;
//       case 'export':
//         _exportProjectReport();
//         break;
//     }
//   }

//   void _handleTeamMemberAction(String action, String memberId) {
//     switch (action) {
//       case 'view_time':
//         _showMemberTimeDialog(memberId);
//         break;
//       case 'view_tasks':
//         _showMemberTasksDialog(memberId);
//         break;
//       case 'remove':
//         _removeMemberFromProject(memberId);
//         break;
//     }
//   }

//   void _showDateRangePicker(TimeTrackingViewModel timeVM) async {
//     final picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime.now().subtract(const Duration(days: 365)),
//       lastDate: DateTime.now(),
//       initialDateRange: DateTimeRange(
//         start: _selectedTimeRange,
//         end: DateTime.now(),
//       ),
//     );
    
//     if (picked != null) {
//       setState(() {
//         _selectedTimeRange = picked.start;
//       });
//       await timeVM.loadTimeEntries(
//         projectId: widget.projectId,
//         startDate: picked.start,
//         endDate: picked.end,
//       );
//     }
//   }

//   void _showStartTimerDialog() {
//     // Implementation for starting timer dialog
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Start Timer'),
//         content: const Text('Select a task to start tracking time'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // Start timer logic
//             },
//             child: const Text('Start'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _editTimeEntry(TimeEntryModel entry) {
//     // Implementation for editing time entry
//     showAddTimeEntryDialog(context, entryToEdit: entry);
//   }

//   Future<void> _deleteTimeEntry(String entryId) async {
//     final timeVM = context.read<TimeTrackingViewModel>();
//     final success = await timeVM.deleteTimeEntry(entryId);
    
//     if (success && mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Time entry deleted')),
//       );
//     }
//   }

//   void _showArchiveDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Archive Project'),
//         content: const Text('Are you sure you want to archive this project? This action can be undone later.'),
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
//             style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
//             child: const Text('Archive'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _exportProjectReport() {
//     // Implementation for exporting project report
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Export feature coming soon!')),
//     );
//   }

//   void _showMemberTimeDialog(String memberId) {
//     // Implementation for showing member time details
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Time Logs for Member $memberId'),
//         content: const Text('Member time details coming soon'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showMemberTasksDialog(String memberId) {
//     // Implementation for showing member tasks
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Tasks for Member $memberId'),
//         content: const Text('Member tasks coming soon'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _removeMemberFromProject(String memberId) {
//     // Implementation for removing member
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Remove Team Member'),
//         content: Text('Remove member $memberId from this project?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // Remove member logic
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
//             child: const Text('Remove'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _archiveProject() {
//     // Implementation for archiving project
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Project archived successfully')),
//     );
//   }
// }

// // Additional helper function for the dialog
// Future<void> showAddTimeEntryDialog(BuildContext context, {TimeEntryModel? entryToEdit}) {
//   // This would be the same dialog implementation from before
//   return showDialog<void>(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return Dialog(
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(entryToEdit != null ? 'Edit Time Entry' : 'Add Time Entry'),
//               const SizedBox(height: 16),
//               const Text('Time entry dialog implementation'),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Cancel'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Save'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }


//2



// lib/presentation/views/projects/project_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/time_entry_model.dart';
import '../../../data/models/user_model.dart';
import '../../viewmodels/project_viewmodel.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../../viewmodels/time_tracking_viewmodel.dart';
import '../../widgets/project/project_info_tab.dart';
import '../../widgets/project/project_tasks_tab.dart';
import '../../widgets/project/project_members_tab.dart';
import '../../widgets/project/project_time_tracking_tab.dart';
import '../../widgets/project/project_analytics_tab.dart';
import '../../widgets/project/project_timeline_tab.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/enums/project_status.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _loadProjectData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadProjectData() async {
    final projectVM = Provider.of<ProjectViewModel>(context, listen: false);
    final taskVM = Provider.of<TaskViewModel>(context, listen: false);
    final timeVM = Provider.of<TimeTrackingViewModel>(context, listen: false);

    await projectVM.loadProjectById(widget.projectId);
    await taskVM.loadTasks(projectId: widget.projectId);
    await timeVM.loadTimeEntries(projectId: widget.projectId);

    setState(() {
      _project = projectVM.projects.firstWhere(
        (p) => p.id == widget.projectId,
        orElse: () => throw Exception('Project not found'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer3<ProjectViewModel, TaskViewModel, TimeTrackingViewModel>(
        builder: (context, projectVM, taskVM, timeVM, child) {
          if (_project == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(_project!.name),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getStatusColor(_project!.status),
                            _getStatusColor(_project!.status).withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: _buildProjectHeader(),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editProject(),
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'archive',
                          child: Row(
                            children: [
                              Icon(Icons.archive),
                              SizedBox(width: 8),
                              Text('Archive Project'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'export',
                          child: Row(
                            children: [
                              Icon(Icons.download),
                              SizedBox(width: 8),
                              Text('Export Report'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'duplicate',
                          child: Row(
                            children: [
                              Icon(Icons.copy),
                              SizedBox(width: 8),
                              Text('Duplicate Project'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) => _handleMenuAction(value),
                    ),
                  ],
                ),
                SliverPersistentHeader(
                  delegate: _SliverTabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: AppColors.textSecondary,
                      indicatorColor: AppColors.primary,
                      tabs: const [
                        Tab(icon: Icon(Icons.info), text: 'Overview'),
                        Tab(icon: Icon(Icons.task), text: 'Tasks'),
                        Tab(icon: Icon(Icons.people), text: 'Team'),
                        Tab(icon: Icon(Icons.access_time), text: 'Time'),
                        Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
                        Tab(icon: Icon(Icons.timeline), text: 'Timeline'),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                ProjectInfoTab(project: _project!),
                ProjectTasksTab(
                  project: _project!,
                  tasks: taskVM.tasks,
                ),
                ProjectMembersTab(project: _project!),
                ProjectTimeTrackingTab(
                  project: _project!,
                  timeEntries: timeVM.timeEntries,
                ),
                ProjectAnalyticsTab(
                  project: _project!,
                  tasks: taskVM.tasks,
                  timeEntries: timeVM.timeEntries,
                ),
                ProjectTimelineTab(
                  project: _project!,
                  
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildProjectHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _project!.status.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(_project!.progress * 100).toInt()}% Complete',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _project!.description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Consumer<TabController>(
      builder: (context, _, __) {
        switch (_tabController.index) {
          case 1: // Tasks tab
            return FloatingActionButton(
              onPressed: () => _addTask(),
              child: const Icon(Icons.add_task),
            );
          case 2: // Team tab
            return FloatingActionButton(
              onPressed: () => _addMember(),
              child: const Icon(Icons.person_add),
            );
          case 3: // Time tab
            return FloatingActionButton(
              onPressed: () => _addTimeEntry(),
              child: const Icon(Icons.add_alarm),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Color _getStatusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.planning:
        return AppColors.info;
      case ProjectStatus.active:
        return AppColors.success;
      case ProjectStatus.onHold:
        return AppColors.warning;
      case ProjectStatus.completed:
        return AppColors.primary;
      case ProjectStatus.cancelled:
        return AppColors.error;
    }
  }

  void _editProject() {
    Navigator.pushNamed(
      context,
      '/project/edit',
      arguments: _project!.id,
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'archive':
        _showArchiveDialog();
        break;
      case 'export':
        _exportProjectReport();
        break;
      case 'duplicate':
        _duplicateProject();
        break;
    }
  }

  void _showArchiveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive Project'),
        content: const Text(
          'Are you sure you want to archive this project? '
          'This action can be undone later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _archiveProject();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
            ),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
  }

  void _exportProjectReport() {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export feature coming soon!')),
    );
  }

  void _duplicateProject() {
    // TODO: Implement duplicate functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Duplicate feature coming soon!')),
    );
  }

  void _archiveProject() {
    // TODO: Implement archive functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project archived successfully')),
    );
  }

  void _addTask() {
    Navigator.pushNamed(
      context,
      '/task/create',
      arguments: {'projectId': _project!.id},
    );
  }

  void _addMember() {
    Navigator.pushNamed(
      context,
      '/project/add-member',
      arguments: _project!.id,
    );
  }

  void _addTimeEntry() {
    Navigator.pushNamed(
      context,
      '/time/create',
      arguments: {'projectId': _project!.id},
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}