// lib/presentation/widgets/common/project_card.dart
import 'package:flutter/material.dart';
import '../../../data/models/project_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/enums/project_status.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback? onTap;
  final Map<String, dynamic>? stats; // Optional stats from API

  const ProjectCard({
    Key? key,
    required this.project,
    this.onTap,
    this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (project.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            project.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // NEW: Health indicator
                  _buildHealthIndicator(),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // NEW: Progress bar
              _buildProgressBar(),
              
              const SizedBox(height: 12),
              
              // Bottom row with status and details
              Row(
                children: [
                  _buildStatusChip(),
                  const SizedBox(width: 8),
                  
                  if (project.dueDate != null) ...[
                    _buildDueDateInfo(),
                    const SizedBox(width: 8),
                  ],
                  
                  const Spacer(),
                  
                  // NEW: Task summary
                  _buildTaskSummary(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthIndicator() {
    final totalTasks = stats?['totalTasks'] ?? 0;
    final completedTasks = stats?['completedTasks'] ?? 0;
    final overdueTasks = stats?['overdueTasks'] ?? 0;
    
    final healthStatus = project.getHealthStatus(
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      overdueTasks: overdueTasks,
    );
    
    final healthColor = project.getHealthColor(
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      overdueTasks: overdueTasks,
    );
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: healthColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: healthColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: healthColor,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            healthStatus,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: healthColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '${(project.progress * 100).round()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: project.progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            project.status == ProjectStatus.completed 
              ? Colors.green 
              : AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip() {
    Color color;
    IconData icon;
    
    switch (project.status) {
      case ProjectStatus.active:
        color = Colors.green;
        icon = Icons.play_circle_filled;
        break;
      case ProjectStatus.completed:
        color = Colors.blue;
        icon = Icons.check_circle;
        break;
      case ProjectStatus.onHold:
        color = Colors.orange;
        icon = Icons.pause_circle_filled;
        break;
      case ProjectStatus.cancelled:
        color = Colors.red;
        icon = Icons.cancel;
        break;
      case ProjectStatus.planning:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            project.status.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDueDateInfo() {
    final isOverdue = project.isOverdue;
    final color = isOverdue ? Colors.red : Colors.grey;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isOverdue ? Icons.warning : Icons.schedule,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          project.dueDateDisplay,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskSummary() {
    final totalTasks = stats?['totalTasks'] ?? 0;
    final completedTasks = stats?['completedTasks'] ?? 0;
    
    if (totalTasks == 0) {
      return Text(
        'No tasks',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[500],
        ),
      );
    }
    
    return Text(
      '$completedTasks/$totalTasks tasks',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.grey[600],
      ),
    );
  }
}