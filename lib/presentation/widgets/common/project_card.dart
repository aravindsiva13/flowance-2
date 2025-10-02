// // lib/presentation/widgets/common/project_card.dart
// import 'package:flutter/material.dart';
// import '../../../data/models/project_model.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/enums/project_status.dart';

// class ProjectCard extends StatelessWidget {
//   final ProjectModel project;
//   final VoidCallback? onTap;
//   final Map<String, dynamic>? stats; // Optional stats from API

//   const ProjectCard({
//     Key? key,
//     required this.project,
//     this.onTap,
//     this.stats,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
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
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           project.name,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.textPrimary,
//                           ),
//                         ),
//                         if (project.description.isNotEmpty) ...[
//                           const SizedBox(height: 4),
//                           Text(
//                             project.description,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
                  
//                   // NEW: Health indicator
//                   _buildHealthIndicator(),
//                 ],
//               ),
              
//               const SizedBox(height: 16),
              
//               // NEW: Progress bar
//               _buildProgressBar(),
              
//               const SizedBox(height: 12),
              
//               // Bottom row with status and details
//               Row(
//                 children: [
//                   _buildStatusChip(),
//                   const SizedBox(width: 8),
                  
//                   if (project.dueDate != null) ...[
//                     _buildDueDateInfo(),
//                     const SizedBox(width: 8),
//                   ],
                  
//                   const Spacer(),
                  
//                   // NEW: Task summary
//                   _buildTaskSummary(),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHealthIndicator() {
//     final totalTasks = stats?['totalTasks'] ?? 0;
//     final completedTasks = stats?['completedTasks'] ?? 0;
//     final overdueTasks = stats?['overdueTasks'] ?? 0;
    
//     final healthStatus = project.getHealthStatus(
//       totalTasks: totalTasks,
//       completedTasks: completedTasks,
//       overdueTasks: overdueTasks,
//     );
    
//     final healthColor = project.getHealthColor(
//       totalTasks: totalTasks,
//       completedTasks: completedTasks,
//       overdueTasks: overdueTasks,
//     );
    
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: healthColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: healthColor.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: healthColor,
//             ),
//           ),
//           const SizedBox(width: 6),
//           Text(
//             healthStatus,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.bold,
//               color: healthColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProgressBar() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Progress',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey[600],
//               ),
//             ),
//             Text(
//               '${(project.progress * 100).round()}%',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.primaryBlue,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 4),
//         LinearProgressIndicator(
//           value: project.progress,
//           backgroundColor: Colors.grey[300],
//           valueColor: AlwaysStoppedAnimation<Color>(
//             project.status == ProjectStatus.completed 
//               ? Colors.green 
//               : AppColors.primaryBlue,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatusChip() {
//     Color color;
//     IconData icon;
    
//     switch (project.status) {
//       case ProjectStatus.active:
//         color = Colors.green;
//         icon = Icons.play_circle_filled;
//         break;
//       case ProjectStatus.completed:
//         color = Colors.blue;
//         icon = Icons.check_circle;
//         break;
//       case ProjectStatus.onHold:
//         color = Colors.orange;
//         icon = Icons.pause_circle_filled;
//         break;
//       case ProjectStatus.cancelled:
//         color = Colors.red;
//         icon = Icons.cancel;
//         break;
//       case ProjectStatus.planning:
//         // TODO: Handle this case.
//         throw UnimplementedError();
//     }

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
//             icon,
//             size: 12,
//             color: color,
//           ),
//           const SizedBox(width: 4),
//           Text(
//             project.status.displayName,
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

//   Widget _buildDueDateInfo() {
//     final isOverdue = project.isOverdue;
//     final color = isOverdue ? Colors.red : Colors.grey;
    
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           isOverdue ? Icons.warning : Icons.schedule,
//           size: 14,
//           color: color,
//         ),
//         const SizedBox(width: 4),
//         Text(
//           project.dueDateDisplay,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: color,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTaskSummary() {
//     final totalTasks = stats?['totalTasks'] ?? 0;
//     final completedTasks = stats?['completedTasks'] ?? 0;
    
//     if (totalTasks == 0) {
//       return Text(
//         'No tasks',
//         style: TextStyle(
//           fontSize: 12,
//           color: Colors.grey[500],
//         ),
//       );
//     }
    
//     return Text(
//       '$completedTasks/$totalTasks tasks',
//       style: TextStyle(
//         fontSize: 12,
//         fontWeight: FontWeight.w500,
//         color: Colors.grey[600],
//       ),
//     );
//   }
// }

//2

// lib/presentation/widgets/common/project_card.dart - FIXED VERSION

import 'package:flowence/core/enums/project_status.dart';
import 'package:flutter/material.dart';
import '../../../data/models/project_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_utils.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;
  final int? totalTasks; // ADDED: Optional task stats
  final int? completedTasks; // ADDED: Optional task stats
  final int? overdueTasks; // ADDED: Optional task stats

  const ProjectCard({
    Key? key,
    required this.project,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
    this.totalTasks, // ADDED: Accept task stats as parameters
    this.completedTasks, // ADDED: Accept task stats as parameters  
    this.overdueTasks, // ADDED: Accept task stats as parameters
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
              const SizedBox(height: 12),
              _buildDescription(),
              const SizedBox(height: 12),
              _buildProgress(),
              const SizedBox(height: 12),
              _buildFooter(),
              if (totalTasks != null || completedTasks != null || overdueTasks != null) ...[
                const SizedBox(height: 12),
                _buildTaskStats(),
              ],
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
                project.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getStatusColor()),
                ),
                child: Text(
                  project.status.displayName,
                  style: TextStyle(
                    color: _getStatusColor(),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showActions) _buildActionButtons(),
        if (!showActions) _buildHealthIndicator(),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      project.description.isNotEmpty 
          ? project.description 
          : 'No description provided',
      style: TextStyle(
        color: project.description.isNotEmpty 
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
              '${(project.progress * 100).toInt()}%',
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
          value: project.progress,
          backgroundColor: AppColors.borderLight,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Icon(
          Icons.people_outline_rounded,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          '${project.memberIds.length} members',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const Spacer(),
        if (project.dueDate != null) ...[
          Icon(
            project.isOverdue ? Icons.warning_rounded : Icons.schedule_rounded,
            size: 16,
            color: project.isOverdue ? Colors.red : AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            project.dueDateDisplay,
            style: TextStyle(
              color: project.isOverdue ? Colors.red : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: project.isOverdue ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTaskStats() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (totalTasks != null)
            _buildStatItem('Total', totalTasks.toString(), Colors.blue),
          if (completedTasks != null)
            _buildStatItem('Done', completedTasks.toString(), Colors.green),
          if (overdueTasks != null && overdueTasks! > 0)
            _buildStatItem('Overdue', overdueTasks.toString(), Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
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

  Widget _buildHealthIndicator() {
    // FIXED: Use method calls with optional parameters instead of undefined named parameters
    final healthScore = project.calculateHealthScore(
      totalTasks: totalTasks ?? 0, // Use provided value or default
      completedTasks: completedTasks ?? 0, // Use provided value or default
      overdueTasks: overdueTasks ?? 0, // Use provided value or default
    );
    
    final healthColor = project.getHealthColor();
    
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: healthColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Color _getStatusColor() {
    switch (project.status) {
      case ProjectStatus.planning:
        return Colors.orange;
      case ProjectStatus.active:
        return Colors.blue;
      case ProjectStatus.completed:
        return Colors.green;
      case ProjectStatus.onHold:
        return Colors.grey;
      case ProjectStatus.cancelled:
        return Colors.red;
    }
  }
}