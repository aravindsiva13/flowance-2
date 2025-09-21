// lib/presentation/widgets/project/project_analytics_tab.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/time_entry_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/enums/task_status.dart';
import '../../../core/enums/task_priority.dart';
import '../../../core/utils/date_utils.dart';

class ProjectAnalyticsTab extends StatefulWidget {
  final ProjectModel project;
  final List<TaskModel> tasks;
  final List<TimeEntryModel> timeEntries;

  const ProjectAnalyticsTab({
    Key? key,
    required this.project,
    required this.tasks,
    required this.timeEntries,
  }) : super(key: key);

  @override
  State<ProjectAnalyticsTab> createState() => _ProjectAnalyticsTabState();
}

class _ProjectAnalyticsTabState extends State<ProjectAnalyticsTab> {
  String _selectedMetric = 'velocity';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetricSelector(),
          const SizedBox(height: 16),
          _buildKPICards(),
          const SizedBox(height: 16),
          _buildSelectedChart(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTaskStatusChart()),
              const SizedBox(width: 16),
              Expanded(child: _buildPriorityDistribution()),
            ],
          ),
          const SizedBox(height: 16),
          _buildProductivityMetrics(),
          const SizedBox(height: 16),
          _buildBurndownChart(),
          const SizedBox(height: 16),
          _buildTeamPerformance(),
        ],
      ),
    );
  }

  Widget _buildMetricSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analytics View',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'velocity', label: Text('Velocity')),
                ButtonSegment(value: 'burndown', label: Text('Burndown')),
                ButtonSegment(value: 'productivity', label: Text('Productivity')),
                ButtonSegment(value: 'timeline', label: Text('Timeline')),
              ],
              selected: {_selectedMetric},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedMetric = newSelection.first;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPICards() {
    final completedTasks = widget.tasks.where((t) => t.status == TaskStatus.completed).length;
    final totalTasks = widget.tasks.length;
    final completionRate = totalTasks > 0 ? (completedTasks / totalTasks) : 0.0;
    
    final totalTime = widget.timeEntries
        .where((e) => e.projectId == widget.project.id)
        .fold(Duration.zero, (sum, e) => sum + e.duration);
    
    final averageTaskTime = completedTasks > 0 
        ? Duration(minutes: totalTime.inMinutes ~/ completedTasks)
        : Duration.zero;

    final velocity = _calculateVelocity();
    final efficiency = _calculateEfficiency();

    return Row(
      children: [
        Expanded(
          child: _buildKPICard(
            'Completion Rate',
            '${(completionRate * 100).toInt()}%',
            Icons.check_circle,
            AppColors.success,
            subtitle: '$completedTasks of $totalTasks tasks',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildKPICard(
            'Velocity',
            '$velocity',
            Icons.speed,
            AppColors.primary,
            subtitle: 'tasks/week',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildKPICard(
            'Avg Task Time',
            _formatDuration(averageTaskTime),
            Icons.access_time,
            AppColors.info,
            subtitle: 'per task',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildKPICard(
            'Efficiency',
            '${(efficiency * 100).toInt()}%',
            Icons.trending_up,
            AppColors.warning,
            subtitle: 'estimated vs actual',
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color, {String? subtitle}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedChart() {
    switch (_selectedMetric) {
      case 'velocity':
        return _buildVelocityChart();
      case 'burndown':
        return _buildBurndownChart();
      case 'productivity':
        return _buildProductivityChart();
      case 'timeline':
        return _buildTimelineChart();
      default:
        return _buildVelocityChart();
    }
  }

  Widget _buildVelocityChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Velocity Trend',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'W${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _buildVelocitySpots(),
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                    LineChartBarData(
                      spots: _buildAverageVelocityLine(),
                      isCurved: false,
                      color: AppColors.warning,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      dashArray: [5, 5],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildChartLegendItem('Actual Velocity', AppColors.primary),
                _buildChartLegendItem('Average', AppColors.warning),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskStatusChart() {
    final statusCounts = <TaskStatus, int>{};
    for (final task in widget.tasks) {
      statusCounts[task.status] = (statusCounts[task.status] ?? 0) + 1;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: PieChart(
                PieChartData(
                  sections: statusCounts.entries.map((entry) {
                    final percentage = widget.tasks.isNotEmpty
                        ? (entry.value / widget.tasks.length) * 100
                        : 0.0;
                    return PieChartSectionData(
                      color: _getStatusColor(entry.key),
                      value: entry.value.toDouble(),
                      title: '${percentage.toInt()}%',
                      radius: 40,
                      titleStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  centerSpaceRadius: 30,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...statusCounts.entries.map((entry) => 
              _buildStatusLegendItem(entry.key, entry.value),
            ).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityDistribution() {
    final priorityCounts = <TaskPriority, int>{};
    for (final task in widget.tasks) {
      priorityCounts[task.priority] = (priorityCounts[task.priority] ?? 0) + 1;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Priority Distribution',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (priorityCounts.values.isEmpty ? 1 : priorityCounts.values.reduce((a, b) => a > b ? a : b)).toDouble(),
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final priorities = TaskPriority.values;
                          if (value.toInt() < priorities.length) {
                            return Text(
                              priorities[value.toInt()].name.substring(0, 3).toUpperCase(),
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: TaskPriority.values.asMap().entries.map((entry) {
                    final count = priorityCounts[entry.value] ?? 0;
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: count.toDouble(),
                          color: _getPriorityColor(entry.value),
                          width: 20,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductivityMetrics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Productivity Metrics',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildProductivityMetric(
                    'Focus Time',
                    '85%',
                    'Time spent on active work',
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProductivityMetric(
                    'Task Switching',
                    '12',
                    'Context switches per day',
                    AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildProductivityMetric(
                    'Estimation Accuracy',
                    '78%',
                    'Actual vs estimated time',
                    AppColors.info,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProductivityMetric(
                    'On-time Delivery',
                    '92%',
                    'Tasks completed by due date',
                    AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductivityMetric(String title, String value, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBurndownChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Burndown Chart',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'D${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _buildIdealBurndownSpots(),
                      isCurved: false,
                      color: AppColors.textSecondary,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      dashArray: [5, 5],
                    ),
                    LineChartBarData(
                      spots: _buildActualBurndownSpots(),
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildChartLegendItem('Ideal Burndown', AppColors.textSecondary),
                _buildChartLegendItem('Actual Progress', AppColors.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamPerformance() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Team Performance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...widget.project.memberIds.take(5).map((memberId) => 
              _buildTeamMemberPerformance(memberId),
            ).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMemberPerformance(String memberId) {
    final memberTasks = widget.tasks.where((t) => t.assigneeId == memberId).length;
    final completedTasks = widget.tasks
        .where((t) => t.assigneeId == memberId && t.status == TaskStatus.completed)
        .length;
    final completionRate = memberTasks > 0 ? (completedTasks / memberTasks) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            child: Text('M${memberId.substring(0, 1)}'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Member $memberId',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: completionRate,
                  backgroundColor: AppColors.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    completionRate > 0.8 ? AppColors.success : 
                    completionRate > 0.5 ? AppColors.warning : AppColors.error,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$completedTasks/$memberTasks',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${(completionRate * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductivityChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Productivity Trends',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'W${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _buildProductivitySpots(),
                      isCurved: true,
                      color: AppColors.success,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineChart() {
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
            Container(
              height: 250,
              child: const Center(
                child: Text('Timeline view coming soon...'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildStatusLegendItem(TaskStatus status, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _getStatusColor(status),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              status.displayName,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for chart data
  List<FlSpot> _buildVelocitySpots() {
    return List.generate(8, (index) => 
      FlSpot(index.toDouble(), (index * 2 + 5 + (index % 3)).toDouble()));
  }

  List<FlSpot> _buildAverageVelocityLine() {
    return List.generate(8, (index) => FlSpot(index.toDouble(), 8.0));
  }

  List<FlSpot> _buildIdealBurndownSpots() {
    final totalTasks = widget.tasks.length.toDouble();
    return List.generate(15, (index) => 
      FlSpot(index.toDouble(), totalTasks - (totalTasks / 14 * index)));
  }

  List<FlSpot> _buildActualBurndownSpots() {
    final totalTasks = widget.tasks.length.toDouble();
    return List.generate(10, (index) => 
      FlSpot(index.toDouble(), totalTasks - (totalTasks / 12 * index) + (index % 3)));
  }

  List<FlSpot> _buildProductivitySpots() {
    return List.generate(8, (index) => 
      FlSpot(index.toDouble(), (75 + index * 3 + (index % 2 * 5)).toDouble()));
  }

 double _calculateVelocity() {
  // Handle null startDate safely
  final startDate = widget.project.startDate;
  if (startDate == null) {
    // If no start date, use creation date as fallback
    final weeks = DateTime.now().difference(widget.project.createdAt).inDays / 7;
    final completedTasks = widget.tasks.where((t) => t.status == TaskStatus.done).length;
    return weeks > 0 ? completedTasks / weeks : 0.0;
  }
  
  // Calculate weeks since project start
  final daysSinceStart = DateTime.now().difference(startDate).inDays;
  final weeks = daysSinceStart / 7.0;
  
  // Count completed tasks (using correct enum value)
  final completedTasks = widget.tasks.where((t) => t.status == TaskStatus.done).length;
  
  // Avoid division by zero and handle edge cases
  if (weeks <= 0) {
    return 0.0; // Project just started or invalid date
  }
  
  if (completedTasks == 0) {
    return 0.0; // No tasks completed yet
  }
  
  // Calculate velocity (tasks per week)
  return completedTasks / weeks;
}

  double _calculateEfficiency() {
    // This would calculate estimated vs actual time
    return 0.78; // Placeholder
  }

  // Helper method to get duration from time entry
  Duration _getEntryDuration(TimeEntryModel entry) {
    if (entry.endTime != null) {
      return entry.endTime!.difference(entry.startTime);
    }
    return Duration.zero;
  }

  Color _getStatusColor(TaskStatus status) {
  switch (status) {
    case TaskStatus.toDo:
      return AppColors.info;
    case TaskStatus.inProgress:
      return AppColors.warning;
    case TaskStatus.inReview:
      return AppColors.secondary;
    case TaskStatus.completed:
    case TaskStatus.done:
      return AppColors.success;
    case TaskStatus.cancelled:
      return AppColors.error;
  }
}
  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppColors.success;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.high:
        return AppColors.error;
      case TaskPriority.urgent:
        return Colors.purple;
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }
}