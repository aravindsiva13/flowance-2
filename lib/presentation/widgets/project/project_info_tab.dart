// lib/presentation/widgets/project/project_info_tab.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/project_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/enums/project_status.dart';
import '../../../core/utils/date_utils.dart';
import '../../viewmodels/project_viewmodel.dart';
import '../common/progress_ring.dart';

class ProjectInfoTab extends StatelessWidget {
  final ProjectModel project;

  const ProjectInfoTab({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Consumer<ProjectViewModel>(
        builder: (context, projectVM, child) {
          final insights = projectVM.getProjectInsights(project.id);
          final healthScore = projectVM.calculateProjectHealthScore(project.id);
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProjectOverview(insights, healthScore),
              const SizedBox(height: 16),
              _buildProjectDetails(),
              const SizedBox(height: 16),
              _buildProjectMetrics(insights),
              const SizedBox(height: 16),
              _buildRiskAssessment(insights),
              const SizedBox(height: 16),
              _buildRecommendations(insights),
              const SizedBox(height: 16),
              _buildProjectTimeline(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProjectOverview(Map<String, dynamic> insights, double healthScore) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Project Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewMetric(
                    'Health Score',
                    '${healthScore.toInt()}/100',
                    _getHealthColor(healthScore),
                    Icons.health_and_safety,
                  ),
                ),
                Expanded(
                  child: _buildOverviewMetric(
                    'Progress',
                    '${(project.progress * 100).toInt()}%',
                    AppColors.primary,
                    Icons.trending_up,
                  ),
                ),
                Expanded(
                  child: _buildProgressRing(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewMetric(
                    'Status',
                    project.status.displayName,
                    _getStatusColor(project.status),
                    Icons.flag,
                  ),
                ),
                Expanded(
                  child: _buildOverviewMetric(
                    'Team Size',
                    '${project.memberIds.length}',
                    AppColors.info,
                    Icons.group,
                  ),
                ),
                Expanded(
                  child: _buildOverviewMetric(
                    'Duration',
                    _calculateDuration(),
                    AppColors.textSecondary,
                    Icons.schedule,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewMetric(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressRing() {
    return Column(
      children: [
        ProgressRing(
          progress: project.progress,
          size: 60,
          strokeWidth: 6,
          color: AppColors.primary,
        ),
        const SizedBox(height: 8),
        const Text(
          'Completion',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Project Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Description', project.description),
            const SizedBox(height: 12),
            _buildDetailRow('Start Date', AppDateUtils.formatDate(project.startDate)),
            const SizedBox(height: 12),
            _buildDetailRow(
              'End Date',
              project.endDate != null 
                  ? AppDateUtils.formatDate(project.endDate!)
                  : 'Not set',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              'Due Date',
              project.dueDate != null 
                  ? AppDateUtils.formatDate(project.dueDate!)
                  : 'Not set',
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Created', AppDateUtils.formatDateTime(project.createdAt)),
            const SizedBox(height: 12),
            _buildDetailRow('Last Updated', AppDateUtils.formatDateTime(project.updatedAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectMetrics(Map<String, dynamic> insights) {
    final totalTasks = insights['totalTasks'] ?? 0;
    final completedTasks = insights['completedTasks'] ?? 0;
    final inProgressTasks = insights['inProgressTasks'] ?? 0;
    final velocity = insights['velocity'] ?? 0.0;
    final budgetUsed = insights['budgetUsed'] ?? 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Key Metrics',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Total Tasks',
                    totalTasks.toString(),
                    Icons.task_alt,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard(
                    'Completed',
                    completedTasks.toString(),
                    Icons.check_circle,
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard(
                    'In Progress',
                    inProgressTasks.toString(),
                    Icons.work,
                    AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Velocity',
                    '${velocity.toStringAsFixed(1)}/week',
                    Icons.speed,
                    AppColors.info,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard(
                    'Budget Used',
                    '${(budgetUsed * 100).toInt()}%',
                    Icons.account_balance_wallet,
                    budgetUsed > 0.8 ? AppColors.error : AppColors.success,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard(
                    'Time Logged',
                    '${insights['totalTimeHours'] ?? 0}h',
                    Icons.access_time,
                    AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRiskAssessment(Map<String, dynamic> insights) {
    final riskLevel = insights['riskLevel'] ?? 'Low';
    final riskColor = _getRiskColor(riskLevel);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Risk Assessment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: riskColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: riskColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_getRiskIcon(riskLevel), color: riskColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$riskLevel Risk',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: riskColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _showRiskDetails(),
                  child: const Text('View Details'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _getRiskDescription(riskLevel),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations(Map<String, dynamic> insights) {
    final recommendations = insights['recommendedActions'] as List<String>? ?? [];

    if (recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recommended Actions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...recommendations.map((recommendation) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.warning,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recommendation,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectTimeline() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Project Timeline',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTimelineItem(
              'Project Started',
              AppDateUtils.formatDate(project.startDate),
              true,
              AppColors.success,
            ),
            _buildTimelineItem(
              'Current Progress',
              '${(project.progress * 100).toInt()}% Complete',
              true,
              AppColors.primary,
            ),
            if (project.dueDate != null)
              _buildTimelineItem(
                'Due Date',
                AppDateUtils.formatDate(project.dueDate!),
                false,
                _getDueDateColor(),
              ),
            if (project.endDate != null)
              _buildTimelineItem(
                'End Date',
                AppDateUtils.formatDate(project.endDate!),
                false,
                AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, String date, bool completed, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                decoration: completed ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
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

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      case 'low':
      default:
        return AppColors.success;
    }
  }

  IconData _getRiskIcon(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return Icons.warning;
      case 'medium':
        return Icons.info;
      case 'low':
      default:
        return Icons.check_circle;
    }
  }

  String _getRiskDescription(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return 'This project has significant risks that require immediate attention.';
      case 'medium':
        return 'This project has some risks that should be monitored closely.';
      case 'low':
      default:
        return 'This project is on track with minimal risks identified.';
    }
  }

  Color _getDueDateColor() {
    if (project.dueDate == null) return AppColors.textSecondary;
    
    final now = DateTime.now();
    final daysUntilDue = project.dueDate!.difference(now).inDays;
    
    if (daysUntilDue < 0) return AppColors.error; // Overdue
    if (daysUntilDue <= 7) return AppColors.warning; // Due soon
    return AppColors.success; // On track
  }

  String _calculateDuration() {
    final endDate = project.endDate ?? DateTime.now();
    final duration = endDate.difference(project.startDate).inDays;
    
    if (duration < 30) {
      return '$duration days';
    } else if (duration < 365) {
      final weeks = (duration / 7).round();
      return '$weeks weeks';
    } else {
      final years = (duration / 365).toStringAsFixed(1);
      return '$years years';
    }
  }

  void _showRiskDetails() {
    // This would show a detailed risk analysis dialog
    // For now, it's a placeholder
  }
}