// // lib/presentation/widgets/common/task_card.dart
// import 'package:flowence/core/enums/task_priority.dart';
// import 'package:flutter/material.dart';
// import '../../../data/models/task_model.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/enums/task_status.dart';

// class TaskCard extends StatelessWidget {
//   final TaskModel task;
//   final VoidCallback? onTap;
//   final bool showProject;
//   final VoidCallback? onStatusChanged;

//   const TaskCard({
//     Key? key,
//     required this.task,
//     this.onTap,
//     this.showProject = false,
//     this.onStatusChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 8),
//       elevation: 2,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(8),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   // NEW: Status checkbox
//                   _buildStatusCheckbox(),
//                   const SizedBox(width: 12),
                  
//                   // Task title
//                   Expanded(
//                     child: Text(
//                       task.title,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textPrimary,
//                         decoration: task.status == TaskStatus.done 
//                           ? TextDecoration.lineThrough 
//                           : null,
//                       ),
//                     ),
//                   ),
                  
//                   // NEW: Urgency indicator
//                   _buildUrgencyIndicator(),
//                 ],
//               ),
              
//               if (task.description.isNotEmpty) ...[
//                 const SizedBox(height: 8),
//                 Text(
//                   task.description,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
              
//               const SizedBox(height: 12),
              
//               // Bottom row with details
//               Row(
//                 children: [
//                   // Priority chip
//                   _buildPriorityChip(),
//                   const SizedBox(width: 8),
                  
//                   // Due date
//                   if (task.dueDate != null) ...[
//                     _buildDueDateChip(),
//                     const SizedBox(width: 8),
//                   ],
                  
//                   const Spacer(),
                  
//                   // Progress indicator
//                   _buildProgressIndicator(),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusCheckbox() {
//     return GestureDetector(
//       onTap: onStatusChanged,
//       child: Container(
//         width: 24,
//         height: 24,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: task.status == TaskStatus.done 
//             ? Colors.green 
//             : Colors.transparent,
//           border: Border.all(
//             color: task.status == TaskStatus.done 
//               ? Colors.green 
//               : Colors.grey,
//             width: 2,
//           ),
//         ),
//         child: task.status == TaskStatus.done
//           ? const Icon(
//               Icons.check,
//               size: 16,
//               color: Colors.white,
//             )
//           : null,
//       ),
//     );
//   }

//   Widget _buildUrgencyIndicator() {
//     if (task.urgencyScore < 0.5) return const SizedBox.shrink();
    
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration: BoxDecoration(
//         color: task.urgencyColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(4),
//         border: Border.all(color: task.urgencyColor.withOpacity(0.3)),
//       ),
//       child: Text(
//         task.urgencyLevel,
//         style: TextStyle(
//           fontSize: 10,
//           fontWeight: FontWeight.bold,
//           color: task.urgencyColor,
//         ),
//       ),
//     );
//   }

//   Widget _buildPriorityChip() {
//     Color color;
//     switch (task.priority) {
//       case TaskPriority.urgent:
//         color = Colors.red;
//         break;
//       case TaskPriority.high:
//         color = Colors.orange;
//         break;
//       case TaskPriority.medium:
//         color = Colors.blue;
//         break;
//       case TaskPriority.low:
//         color = Colors.green;
//         break;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Text(
//         task.priority.displayName,
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//           color: color,
//         ),
//       ),
//     );
//   }

//   Widget _buildDueDateChip() {
//     final isOverdue = task.isOverdue;
//     final color = isOverdue ? Colors.red : Colors.grey;
    
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             isOverdue ? Icons.warning : Icons.schedule,
//             size: 12,
//             color: color,
//           ),
//           const SizedBox(width: 4),
//           Text(
//             task.dueDateDisplay,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProgressIndicator() {
//     if (task.progress <= 0) return const SizedBox.shrink();
    
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         SizedBox(
//           width: 40,
//           height: 6,
//           child: LinearProgressIndicator(
//             value: task.progress,
//             backgroundColor: Colors.grey[300],
//             valueColor: AlwaysStoppedAnimation<Color>(
//               task.status == TaskStatus.done 
//                 ? Colors.green 
//                 : AppColors.primaryBlue,
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           '${(task.progress * 100).round()}%',
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey[600],
//           ),
//         ),
//       ],
//     );
//   }
// }


//2


// lib/presentation/widgets/common/task_card.dart - FIXED VERSION

import 'package:flowence/core/enums/task_priority.dart';
import 'package:flowence/core/enums/task_status.dart';
import 'package:flutter/material.dart';
import '../../../data/models/task_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_utils.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onStatusChanged;
  final bool showProject;
  final bool showActions;
  final String? projectName;

  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onStatusChanged,
    this.showProject = false,
    this.showActions = false,
    this.projectName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 8),
              _buildDescription(),
              const SizedBox(height: 12),
              _buildProgress(),
              const SizedBox(height: 12),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildStatusChip(),
                  const SizedBox(width: 8),
                  _buildPriorityChip(),
                  const Spacer(),
                  _buildUrgencyIndicator(),
                ],
              ),
            ],
          ),
        ),
        if (showActions) _buildActionButtons(),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      task.description.isNotEmpty 
          ? task.description 
          : 'No description provided',
      style: TextStyle(
        color: task.description.isNotEmpty 
            ? AppColors.textPrimary 
            : AppColors.textSecondary,
        fontSize: 14,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Progress',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(task.progress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: task.progress,
          backgroundColor: AppColors.borderLight,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        if (showProject && projectName != null) ...[
          Icon(
            Icons.folder_outlined,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            projectName!,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 16),
        ],
        if (task.estimatedTimeHours != null) ...[
          Icon(
            Icons.schedule_rounded,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            task.formattedEstimatedTime,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const Spacer(),
        ],
        if (task.dueDate != null) ...[
          Icon(
            task.isOverdue ? Icons.warning_rounded : Icons.schedule_rounded,
            size: 16,
            color: task.isOverdue ? Colors.red : AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            task.dueDateDisplay,
            style: TextStyle(
              color: task.isOverdue ? Colors.red : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: task.isOverdue ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor()),
      ),
      child: Text(
        task.status.displayName,
        style: TextStyle(
          color: _getStatusColor(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPriorityChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getPriorityColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getPriorityColor()),
      ),
      child: Text(
        task.priority.displayName,
        style: TextStyle(
          color: _getPriorityColor(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildUrgencyIndicator() {
    // FIXED: Handle nullable urgencyColor properly
    final urgencyColor = task.urgencyColor ?? task.getUrgencyColor();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        // FIXED: Safe null handling for urgencyColor
        color: urgencyColor.withOpacity(0.1), // Remove null assertion
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          // FIXED: Safe null handling for urgencyColor
          color: urgencyColor, // Remove null assertion
          width: 1,
        ),
      ),
      child: Text(
        task.urgencyLevel.toUpperCase(),
        style: TextStyle(
          // FIXED: Safe null handling for urgencyColor
          color: urgencyColor, // Remove null assertion
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_rounded),
            iconSize: 20,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        if (onStatusChanged != null)
          IconButton(
            onPressed: onStatusChanged,
            icon: const Icon(Icons.check_circle_outline_rounded),
            iconSize: 20,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
            color: Colors.green,
          ),
        if (onDelete != null)
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
            iconSize: 20,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
            color: Colors.red,
          ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (task.status) {
      case TaskStatus.toDo:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.inReview:
        return Colors.orange;
      case TaskStatus.done:
        return Colors.green;
      case TaskStatus.completed:
        // TODO: Handle this case.
        throw UnimplementedError();
      case TaskStatus.cancelled:
        // TODO: Handle this case.
        throw UnimplementedError();
      case TaskStatus.blocked:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Color _getPriorityColor() {
    switch (task.priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.urgent:
        return Colors.deepOrange;
    }
  }
}