import 'package:flowence/core/enums/task_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/project_model.dart';
import '../../viewmodels/project_viewmodel.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../../viewmodels/time_tracking_viewmodel.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProjectData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadProjectData() {
    final projectVM = context.read<ProjectViewModel>();
    final taskVM = context.read<TaskViewModel>();
    final timeVM = context.read<TimeTrackingViewModel>();

    // Fire-and-forget the loading calls. The UI will react via the Consumer.
    projectVM.loadProjectById(widget.projectId);
    taskVM.loadTasks(projectId: widget.projectId);
    timeVM.loadTimeEntries(projectId: widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProjectViewModel, TaskViewModel>(
      builder: (context, projectVM, taskVM, child) {
        // Handle Loading State
        if (projectVM.isLoading) {
          return Scaffold(
            appBar: AppBar(title: const Text('Loading Project...')),
            body: const LoadingWidget(message: 'Loading project details...'),
          );
        }

        // Handle Error State
        if (projectVM.errorMessage != null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: CustomErrorWidget(
              message: projectVM.errorMessage!,
              onRetry: _loadProjectData,
            ),
          );
        }

        // Handle Data Not Found State
        final project = projectVM.getProjectById(widget.projectId);
        if (project == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Not Found')),
            body: const Center(child: Text('Project not found.')),
          );
        }

        // Handle Success State
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                _buildSliverAppBar(project),
                _buildSliverTabBar(),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(project),
                _buildTasksTab(taskVM),
                _buildMembersTab(),
                _buildAnalyticsTab(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(ProjectModel project) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(project.name, style: const TextStyle(color: Colors.white)),
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
                  project.description,
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
    );
  }

  Widget _buildSliverTabBar() {
    return SliverPersistentHeader(
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
    );
  }

  Widget _buildOverviewTab(ProjectModel project) {
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
                  _buildInfoRow('Status', project.status.displayName),
                  if (project.startDate != null)
                    _buildInfoRow('Start Date', _formatDate(project.startDate!)),
                  if (project.dueDate != null)
                    _buildInfoRow('Due Date', _formatDate(project.dueDate!)),
                  _buildInfoRow('Progress', '${(project.progress * 100).toInt()}%'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTab(TaskViewModel taskVM) {
    final projectTasks = taskVM.tasks.where((task) => task.projectId == widget.projectId).toList();

    if (projectTasks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No tasks found for this project'),
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
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}