// lib/presentation/widgets/common/task_card.dart
import 'package:flowence/core/enums/task_priority.dart';
import 'package:flutter/material.dart';
import '../../../data/models/task_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/enums/task_status.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final bool showProject;
  final VoidCallback? onStatusChanged;

  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
    this.showProject = false,
    this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
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
                  // NEW: Status checkbox
                  _buildStatusCheckbox(),
                  const SizedBox(width: 12),
                  
                  // Task title
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        decoration: task.status == TaskStatus.done 
                          ? TextDecoration.lineThrough 
                          : null,
                      ),
                    ),
                  ),
                  
                  // NEW: Urgency indicator
                  _buildUrgencyIndicator(),
                ],
              ),
              
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              const SizedBox(height: 12),
              
              // Bottom row with details
              Row(
                children: [
                  // Priority chip
                  _buildPriorityChip(),
                  const SizedBox(width: 8),
                  
                  // Due date
                  if (task.dueDate != null) ...[
                    _buildDueDateChip(),
                    const SizedBox(width: 8),
                  ],
                  
                  const Spacer(),
                  
                  // Progress indicator
                  _buildProgressIndicator(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCheckbox() {
    return GestureDetector(
      onTap: onStatusChanged,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: task.status == TaskStatus.done 
            ? Colors.green 
            : Colors.transparent,
          border: Border.all(
            color: task.status == TaskStatus.done 
              ? Colors.green 
              : Colors.grey,
            width: 2,
          ),
        ),
        child: task.status == TaskStatus.done
          ? const Icon(
              Icons.check,
              size: 16,
              color: Colors.white,
            )
          : null,
      ),
    );
  }

  Widget _buildUrgencyIndicator() {
    if (task.urgencyScore < 0.5) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: task.urgencyColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: task.urgencyColor.withOpacity(0.3)),
      ),
      child: Text(
        task.urgencyLevel,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: task.urgencyColor,
        ),
      ),
    );
  }

  Widget _buildPriorityChip() {
    Color color;
    switch (task.priority) {
      case TaskPriority.urgent:
        color = Colors.red;
        break;
      case TaskPriority.high:
        color = Colors.orange;
        break;
      case TaskPriority.medium:
        color = Colors.blue;
        break;
      case TaskPriority.low:
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        task.priority.displayName,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDueDateChip() {
    final isOverdue = task.isOverdue;
    final color = isOverdue ? Colors.red : Colors.grey;
    
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
            isOverdue ? Icons.warning : Icons.schedule,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            task.dueDateDisplay,
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

  Widget _buildProgressIndicator() {
    if (task.progress <= 0) return const SizedBox.shrink();
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 40,
          height: 6,
          child: LinearProgressIndicator(
            value: task.progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              task.status == TaskStatus.done 
                ? Colors.green 
                : AppColors.primaryBlue,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(task.progress * 100).round()}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}