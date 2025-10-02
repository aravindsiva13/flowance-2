// lib/presentation/views/time/team_timesheet_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/team_time_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/loading_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/enums/timesheet_status.dart';

class TeamTimesheetScreen extends StatefulWidget {
  const TeamTimesheetScreen({Key? key}) : super(key: key);

  @override
  State<TeamTimesheetScreen> createState() => _TeamTimesheetScreenState();
}

class _TeamTimesheetScreenState extends State<TeamTimesheetScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamTimeViewModel>().loadTeamTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Team Timesheet',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => _showFilterDialog(),
            tooltip: 'Filters',
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () => _exportTimesheet(),
            tooltip: 'Export',
          ),
        ],
      ),
      body: Consumer<TeamTimeViewModel>(
        builder: (context, teamTimeVM, child) {
          if (teamTimeVM.isLoading) {
            return const LoadingWidget(message: 'Loading timesheet...');
          }

          final entries = teamTimeVM.filteredEntries;

          return Column(
            children: [
              // Filter chips
              _buildFilterChips(teamTimeVM),

              // Time entries list
              Expanded(
                child: entries.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          return _buildTimeEntryCard(context, entry, teamTimeVM);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(TeamTimeViewModel teamTimeVM) {
    final hasFilters = teamTimeVM.selectedMemberId != null ||
        teamTimeVM.selectedProjectId != null ||
        teamTimeVM.selectedStatus != null ||
        teamTimeVM.startDate != null;

    if (!hasFilters) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (teamTimeVM.selectedMemberId != null)
              _buildFilterChip(
                'Member: ${_getMemberName(teamTimeVM, teamTimeVM.selectedMemberId!)}',
                () => teamTimeVM.setMemberFilter(null),
              ),
            if (teamTimeVM.selectedProjectId != null)
              _buildFilterChip(
                'Project: ${_getProjectName(teamTimeVM, teamTimeVM.selectedProjectId!)}',
                () => teamTimeVM.setProjectFilter(null),
              ),
            if (teamTimeVM.selectedStatus != null)
              _buildFilterChip(
                'Status: ${teamTimeVM.selectedStatus!.displayName}',
                () => teamTimeVM.setStatusFilter(null),
              ),
            if (teamTimeVM.startDate != null || teamTimeVM.endDate != null)
              _buildFilterChip(
                'Date Range',
                () => teamTimeVM.setDateRange(null, null),
              ),
            TextButton.icon(
              onPressed: () => teamTimeVM.clearFilters(),
              icon: const Icon(Icons.clear_all, size: 18),
              label: const Text('Clear All'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onDelete) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: onDelete,
        backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
        labelStyle: const TextStyle(
          color: AppColors.primaryBlue,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildTimeEntryCard(
    BuildContext context,
    entry,
    TeamTimeViewModel teamTimeVM,
  ) {
    final memberName = _getMemberName(teamTimeVM, entry.userId);
    final projectName = _getProjectName(teamTimeVM, entry.projectId);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                  child: Text(
                    memberName[0].toUpperCase(),
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
                        memberName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        projectName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: entry.status.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    entry.status.displayName,
                    style: TextStyle(
                      color: entry.status.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Task description
            Text(
              entry.description.isNotEmpty 
                  ? entry.description 
                  : 'Task ${entry.taskId}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // Time info
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDateTime(entry.startTime),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${entry.durationHours.toStringAsFixed(2)}h',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (entry.isBillable) ...[
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Billable',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            // Action buttons for pending entries
            if (entry.status == TimesheetStatus.submitted) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _rejectEntry(context, entry, teamTimeVM),
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _approveEntry(context, entry, teamTimeVM),
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Approve'),
                    ),
                  ),
                ],
              ),
            ],

            // Rejection reason
            if (entry.status == TimesheetStatus.rejected &&
                entry.rejectionReason != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Rejection reason: ${entry.rejectionReason}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No time entries found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => Consumer<TeamTimeViewModel>(
        builder: (context, teamTimeVM, child) {
          return AlertDialog(
            title: const Text('Filter Timesheet'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Member filter
                  DropdownButtonFormField<String>(
                    value: teamTimeVM.selectedMemberId,
                    decoration: const InputDecoration(
                      labelText: 'Team Member',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Members'),
                      ),
                      ...teamTimeVM.teamMembers.map((member) {
                        return DropdownMenuItem(
                          value: member.id,
                          child: Text(member.name),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      teamTimeVM.setMemberFilter(value);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Project filter
                  DropdownButtonFormField<String>(
                    value: teamTimeVM.selectedProjectId,
                    decoration: const InputDecoration(
                      labelText: 'Project',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Projects'),
                      ),
                      ...teamTimeVM.projects.map((project) {
                        return DropdownMenuItem(
                          value: project.id,
                          child: Text(project.name),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      teamTimeVM.setProjectFilter(value);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Status filter
                  DropdownButtonFormField<TimesheetStatus>(
                    value: teamTimeVM.selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Statuses'),
                      ),
                      ...TimesheetStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.displayName),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      teamTimeVM.setStatusFilter(value);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  teamTimeVM.clearFilters();
                  Navigator.pop(context);
                },
                child: const Text('Clear'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _approveEntry(
    BuildContext context,
    entry,
    TeamTimeViewModel teamTimeVM,
  ) async {
    final authVM = context.read<AuthViewModel>();
    final currentUserId = authVM.currentUser?.id;

    if (currentUserId == null) return;

    final success = await teamTimeVM.approveTimeEntry(entry.id, currentUserId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Time entry approved'
                : teamTimeVM.errorMessage ?? 'Failed to approve',
          ),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
    }
  }

  Future<void> _rejectEntry(
    BuildContext context,
    entry,
    TeamTimeViewModel teamTimeVM,
  ) async {
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Time Entry'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Reason for rejection',
            border: OutlineInputBorder(),
            hintText: 'Enter reason...',
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final authVM = context.read<AuthViewModel>();
    final currentUserId = authVM.currentUser?.id;

    if (currentUserId == null) return;

    final success = await teamTimeVM.rejectTimeEntry(
      entry.id,
      currentUserId,
      reasonController.text.trim(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Time entry rejected'
                : teamTimeVM.errorMessage ?? 'Failed to reject',
          ),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
    }
  }

  Future<void> _exportTimesheet() async {
    final teamTimeVM = context.read<TeamTimeViewModel>();

    try {
      final csv = await teamTimeVM.exportToCSV();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Timesheet exported successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _getMemberName(TeamTimeViewModel teamTimeVM, String userId) {
    final member = teamTimeVM.teamMembers.firstWhere(
      (m) => m.id == userId,
      orElse: () => null,
    );
    return member?.name ?? 'Unknown';
  }

  String _getProjectName(TeamTimeViewModel teamTimeVM, String projectId) {
    final project = teamTimeVM.projects.firstWhere(
      (p) => p.id == projectId,
      orElse: () => null,
    );
    return project?.name ?? 'Unknown';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}