

// lib/presentation/widgets/project/project_info_tab.dart - FIXED VERSION
import 'package:flowence/core/enums/project_status.dart';
import 'package:flowence/core/enums/user_role.dart';
import 'package:flutter/material.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/user_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_utils.dart';

class ProjectInfoTab extends StatelessWidget {
  final ProjectModel project;
  final List<UserModel> members;
  final VoidCallback? onEdit;

  const ProjectInfoTab({
    Key? key,
    required this.project,
    required this.members,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildProjectInfo(),
          const SizedBox(height: 24),
          _buildDatesInfo(),
          const SizedBox(height: 24),
          _buildProgressInfo(),
          const SizedBox(height: 24),
          _buildMembersInfo(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getStatusColor()),
                ),
                child: Text(
                  project.status.displayName,
                  style: TextStyle(
                    color: _getStatusColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (onEdit != null)
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_rounded),
            tooltip: 'Edit Project',
          ),
      ],
    );
  }

  Widget _buildProjectInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              project.description.isNotEmpty 
                  ? project.description 
                  : 'No description provided',
              style: TextStyle(
                color: project.description.isNotEmpty 
                    ? AppColors.textPrimary 
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatesInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Timeline',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDateRow(
              'Start Date',
              project.startDate, // FIXED: Using nullable startDate
              Icons.play_arrow_rounded,
            ),
            const SizedBox(height: 12),
            _buildDateRow(
              'Due Date',
              project.dueDate, // FIXED: Using nullable dueDate
              Icons.flag_rounded,
            ),
            if (project.endDate != null) ...[
              const SizedBox(height: 12),
              _buildDateRow(
                'End Date',
                project.endDate!, // FIXED: Using endDate getter
                Icons.stop_rounded,
              ),
            ],
            const SizedBox(height: 12),
            _buildDateRow(
              'Created',
              project.createdAt,
              Icons.add_circle_outline_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRow(String label, DateTime? date, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),
        Text(
          date != null 
              ? AppDateUtils.formatDate(date) // FIXED: Proper null handling
              : 'Not set',
          style: TextStyle(
            color: date != null 
                ? AppColors.textPrimary 
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progress',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(project.progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: project.progress,
              backgroundColor: AppColors.borderLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            ),
            const SizedBox(height: 8),
            Text(
              project.progressDescription,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Team Members (${members.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (members.isEmpty)
              Text(
                'No team members assigned',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              )
            else
              Column(
                children: members.map((member) => _buildMemberRow(member)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberRow(UserModel member) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
            child: Text(
              member.name.isNotEmpty ? member.name[0].toUpperCase() : 'U',
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  member.email,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              member.role.displayName,
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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

// Helper extension for ProjectStatus
extension ProjectStatusExtension on ProjectStatus {
  String get displayName {
    switch (this) {
      case ProjectStatus.planning:
        return 'Planning';
      case ProjectStatus.active:
        return 'Active';
      case ProjectStatus.completed:
        return 'Completed';
      case ProjectStatus.onHold:
        return 'On Hold';
      case ProjectStatus.cancelled:
        return 'Cancelled';
    }
  }
}