// lib/presentation/widgets/project/project_timeline_tab.dart

import 'package:flowence/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/task_model.dart';

import '../../../core/utils/date_utils.dart';
import '../../viewmodels/task_viewmodel.dart';

class ProjectTimelineTab extends StatefulWidget {
  final ProjectModel project;

  const ProjectTimelineTab({
    super.key,
    required this.project,
  });

  @override
  State<ProjectTimelineTab> createState() => _ProjectTimelineTabState();
}

class _ProjectTimelineTabState extends State<ProjectTimelineTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskViewModel>().loadTasks(projectId: widget.project.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, taskViewModel, child) {
        if (taskViewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final tasks = taskViewModel.tasks
            .where((task) => task.projectId == widget.project.id)
            .toList();

        if (tasks.isEmpty) {
          return _buildEmptyState();
        }

        // Sort tasks by creation date
        tasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProjectTimeline(tasks),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timeline_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No timeline data available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tasks will appear here as they are created',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectTimeline(List<TaskModel> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Timeline',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Project start
        _buildTimelineItem(
          title: 'Project Started',
          subtitle: 'Project "${widget.project.name}" was created',
          date: widget.project.createdAt,
          icon: Icons.flag,
          color: AppColors.primary,
          isFirst: true,
        ),
        
        // Task events
        ...tasks.map((task) => _buildTimelineItem(
          title: 'Task Created',
          subtitle: task.title,
          date: task.createdAt,
          icon: Icons.task_alt,
          color: _getTaskStatusColor(task),
        )),
        
        // Project end (if completed)
        if (widget.project.status.name == 'completed')
          _buildTimelineItem(
            title: 'Project Completed',
            subtitle: 'All tasks completed successfully',
            date: widget.project.updatedAt,
            icon: Icons.check_circle,
            color: AppColors.success,
            isLast: true,
          ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required DateTime date,
    required IconData icon,
    required Color color,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line and dot
          Column(
            children: [
              if (!isFirst)
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.grey[300],
                ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey[300],
                  ),
                ),
            ],
          ),
          
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppDateUtils.formatDateTime(date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTaskStatusColor(TaskModel task) {
    switch (task.status.name) {
      case 'completed':
      case 'done':
        return AppColors.success;
      case 'inProgress':
        return AppColors.warning;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }
}