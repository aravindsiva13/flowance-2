

// lib/presentation/widgets/project/project_time_chart.dart - FIXED VERSION
import 'package:flowence/core/enums/task_priority.dart';
import 'package:flowence/core/enums/task_status.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/time_entry_model.dart';
import '../../../data/models/task_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_utils.dart';

class ProjectTimeChart extends StatefulWidget {
  final ProjectModel project;
  final List<TimeEntryModel> timeEntries;
  final List<TaskModel> tasks;
  final DateTimeRange? dateRange;

  const ProjectTimeChart({
    Key? key,
    required this.project,
    required this.timeEntries,
    required this.tasks,
    this.dateRange,
  }) : super(key: key);

  @override
  State<ProjectTimeChart> createState() => _ProjectTimeChartState();
}

class _ProjectTimeChartState extends State<ProjectTimeChart>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildTabBar(),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDailyTimeChart(),
                  _buildTaskTimeChart(),
                  _buildMemberTimeChart(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final totalTime = _calculateTotalTime();
    final hours = totalTime.inHours;
    final minutes = totalTime.inMinutes % 60;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Time Analytics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${hours}h ${minutes}m',
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: AppColors.primaryBlue,
      unselectedLabelColor: AppColors.textSecondary,
      indicatorColor: AppColors.primaryBlue,
      tabs: const [
        Tab(text: 'Daily'),
        Tab(text: 'By Task'),
        Tab(text: 'By Member'),
      ],
    );
  }

  Widget _buildDailyTimeChart() {
    final dailyData = _calculateDailyTime();
    
    if (dailyData.isEmpty) {
      return _buildEmptyState('No time entries found');
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.borderLight,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}h',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < dailyData.length) {
                  final date = dailyData.keys.elementAt(index);
                  return Text(
                    '${date.day}/${date.month}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: dailyData.entries.map((entry) {
              final index = dailyData.keys.toList().indexOf(entry.key);
              return FlSpot(index.toDouble(), entry.value.inHours.toDouble());
            }).toList(),
            isCurved: true,
            color: AppColors.primaryBlue,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.primaryBlue,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primaryBlue.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTimeChart() {
    final taskTime = _calculateTaskTime();
    
    if (taskTime.isEmpty) {
      return _buildEmptyState('No task time data');
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 60,
        sections: taskTime.entries.map((entry) {
          final task = widget.tasks.firstWhere(
            (t) => t.id == entry.key,
            orElse: () => TaskModel(
              id: 'unknown',
              title: 'Unknown Task',
              description: '',
              status: TaskStatus.toDo,
              priority: TaskPriority.medium,
              projectId: widget.project.id,
              creatorId: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
          
          final percentage = _calculateTotalTime().inMinutes > 0
              ? (entry.value.inMinutes / _calculateTotalTime().inMinutes) * 100
              : 0.0;

          return PieChartSectionData(
            color: _getTaskColor(entry.key),
            value: entry.value.inMinutes.toDouble(),
            title: '${percentage.toInt()}%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMemberTimeChart() {
    final memberTime = _calculateMemberTime();
    
    if (memberTime.isEmpty) {
      return _buildEmptyState('No member time data');
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: memberTime.values.isNotEmpty 
            ? memberTime.values.map((d) => d.inHours.toDouble()).reduce((a, b) => a > b ? a : b) * 1.2
            : 10,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final memberId = memberTime.keys.elementAt(groupIndex);
              final duration = memberTime[memberId]!;
              return BarTooltipItem(
                'Member: $memberId\n${duration.inHours}h ${duration.inMinutes % 60}m',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}h',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < memberTime.length) {
                  final memberId = memberTime.keys.elementAt(index);
                  return Text(
                    memberId.length > 6 ? '${memberId.substring(0, 6)}...' : memberId,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: memberTime.entries.map((entry) {
          final index = memberTime.keys.toList().indexOf(entry.key);
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: entry.value.inHours.toDouble(),
                color: AppColors.primaryBlue,
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Duration _calculateTotalTime() {
    return widget.timeEntries
        .where((entry) => entry.projectId == widget.project.id)
        .fold(Duration.zero, (total, entry) => total + _getEntryDuration(entry));
  }

  Duration _getEntryDuration(TimeEntryModel entry) {
    if (entry.endTime != null) {
      return entry.endTime!.difference(entry.startTime);
    }
    return Duration.zero; // For ongoing entries
  }

  Map<DateTime, Duration> _calculateDailyTime() {
    final dailyTime = <DateTime, Duration>{};
    
    for (final entry in widget.timeEntries) {
      if (entry.projectId == widget.project.id) {
        final date = DateTime(
          entry.startTime.year,
          entry.startTime.month,
          entry.startTime.day,
        );
        
        dailyTime[date] = (dailyTime[date] ?? Duration.zero) + _getEntryDuration(entry);
      }
    }
    
    // Sort by date
    final sortedEntries = dailyTime.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    return Map.fromEntries(sortedEntries);
  }

  Map<String, Duration> _calculateTaskTime() {
    final taskTime = <String, Duration>{};
    
    for (final entry in widget.timeEntries) {
      if (entry.projectId == widget.project.id) {
        final taskId = entry.taskId ?? 'No Task';
        taskTime[taskId] = (taskTime[taskId] ?? Duration.zero) + _getEntryDuration(entry);
      }
    }
    
    return taskTime;
  }

  Map<String, Duration> _calculateMemberTime() {
    final memberTime = <String, Duration>{};
    
    for (final entry in widget.timeEntries) {
      if (entry.projectId == widget.project.id) {
        memberTime[entry.userId] = (memberTime[entry.userId] ?? Duration.zero) + _getEntryDuration(entry);
      }
    }
    
    return memberTime;
  }

  Color _getTaskColor(String taskId) {
    final colors = [
      AppColors.primaryBlue,
      AppColors.success,
      AppColors.warning,
      AppColors.error,
      AppColors.info,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
    ];
    
    return colors[taskId.hashCode % colors.length];
  }
}