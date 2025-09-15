// lib/presentation/widgets/project/project_timeline_tab.dart

import 'package:flutter/material.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/task_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/enums/task_status.dart';
import '../../../core/enums/task_priority.dart';
import '../../../core/utils/date_utils.dart';

class ProjectTimelineTab extends StatefulWidget {
  final ProjectModel project;
  final List<TaskModel> tasks;

  const ProjectTimelineTab({
    Key? key,
    required this.project,
    required this.tasks,
  }) : super(key: key);

  @override
  State<ProjectTimelineTab> createState() => _ProjectTimelineTabState();
}

class _ProjectTimelineTabState extends State<ProjectTimelineTab> {
  String _viewMode = 'gantt';
  DateTime _currentDate = DateTime.now();
  double _zoomLevel = 1.0;
  bool _showCriticalPath = false;
  bool _showMilestones = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTimelineControls(),
        Expanded(
          child: _viewMode == 'gantt' 
              ? _buildGanttChart()
              : _buildMilestoneView(),
        ),
      ],
    );
  }

  Widget _buildTimelineControls() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'gantt', label: Text('Gantt Chart')),
                      ButtonSegment(value: 'milestone', label: Text('Milestones')),
                    ],
                    selected: {_viewMode},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _viewMode = newSelection.first;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => _zoomOut(),
                  icon: const Icon(Icons.zoom_out),
                  tooltip: 'Zoom Out',
                ),
                Text('${(_zoomLevel * 100).toInt()}%'),
                IconButton(
                  onPressed: () => _zoomIn(),
                  icon: const Icon(Icons.zoom_in),
                  tooltip: 'Zoom In',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Checkbox(
                        value: _showCriticalPath,
                        onChanged: (value) {
                          setState(() {
                            _showCriticalPath = value ?? false;
                          });
                        },
                      ),
                      const Text('Show Critical Path'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Checkbox(
                        value: _showMilestones,
                        onChanged: (value) {
                          setState(() {
                            _showMilestones = value ?? true;
                          });
                        },
                      ),
                      const Text('Show Milestones'),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _goToToday(),
                  icon: const Icon(Icons.today),
                  label: const Text('Today'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGanttChart() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildGanttHeader(),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: _calculateChartWidth(),
                child: Column(
                  children: [
                    _buildTimelineHeader(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.tasks.length,
                        itemBuilder: (context, index) {
                          return _buildTaskRow(widget.tasks[index], index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGanttHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 200,
            child: Text(
              'Tasks',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Timeline (${AppDateUtils.formatMonth(widget.project.startDate)} - ${widget.project.endDate != null ? AppDateUtils.formatMonth(widget.project.endDate!) : "Ongoing"})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineHeader() {
    final startDate = widget.project.startDate;
    final endDate = widget.project.endDate ?? DateTime.now().add(const Duration(days: 90));
    final totalDays = endDate.difference(startDate).inDays;
    final daysToShow = (totalDays * _zoomLevel).round();

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 200), // Task name column width
          Expanded(
            child: Row(
              children: List.generate(daysToShow ~/ 7, (weekIndex) {
                final weekStart = startDate.add(Duration(days: weekIndex * 7));
                return Container(
                  width: 100 * _zoomLevel,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(right: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppDateUtils.formatDate(weekStart),
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(7, (dayIndex) {
                          final day = weekStart.add(Duration(days: dayIndex));
                          final isToday = AppDateUtils.isSameDay(day, DateTime.now());
                          return Container(
                            width: 12,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isToday ? AppColors.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: isToday ? Colors.white : AppColors.textSecondary,
                                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskRow(TaskModel task, int index) {
    final isEvenRow = index % 2 == 0;
    final backgroundColor = isEvenRow ? Colors.white : AppColors.surface;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          _buildTaskInfo(task),
          Expanded(child: _buildTaskTimeline(task)),
        ],
      ),
    );
  }

  Widget _buildTaskInfo(TaskModel task) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getTaskColor(task),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(
                _getPriorityIcon(task.priority),
                size: 12,
                color: _getPriorityColor(task.priority),
              ),
              const SizedBox(width: 4),
              Text(
                task.status.displayName,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTimeline(TaskModel task) {
    final projectStart = widget.project.startDate;
    final projectEnd = widget.project.endDate ?? DateTime.now().add(const Duration(days: 90));
    final totalDays = projectEnd.difference(projectStart).inDays;

    final taskStart = task.startDate ?? task.createdAt;
    final taskEnd = task.dueDate ?? taskStart.add(const Duration(days: 7));

    final startOffset = taskStart.difference(projectStart).inDays;
    final taskDuration = taskEnd.difference(taskStart).inDays;

    final chartWidth = _calculateChartWidth() - 200; // Subtract task info width
    final pixelsPerDay = chartWidth / totalDays;

    final barLeft = startOffset * pixelsPerDay;
    final barWidth = taskDuration * pixelsPerDay;

    return Stack(
      children: [
        // Grid lines
        ...List.generate((totalDays / 7).ceil(), (index) {
          final x = index * 7 * pixelsPerDay;
          return Positioned(
            left: x,
            top: 0,
            bottom: 0,
            child: Container(
              width: 1,
              color: Colors.grey.shade300,
            ),
          );
        }),
        // Today line
        if (_shouldShowTodayLine()) _buildTodayLine(projectStart, pixelsPerDay),
        // Task bar
        Positioned(
          left: barLeft.clamp(0, chartWidth),
          top: 12,
          child: Container(
            width: barWidth.clamp(10, chartWidth - barLeft.clamp(0, chartWidth)),
            height: 26,
            decoration: BoxDecoration(
              color: _getTaskColor(task),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Progress indicator
                Container(
                  width: (barWidth * task.progress).clamp(0, barWidth),
                  height: 26,
                  decoration: BoxDecoration(
                    color: _getTaskColor(task).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Task progress text
                if (barWidth > 50)
                  Center(
                    child: Text(
                      '${(task.progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Dependencies (if any)
        if (_showCriticalPath) _buildDependencyLines(task, projectStart, pixelsPerDay),
        // Milestones
        if (_showMilestones && task.dueDate != null)
          _buildMilestone(task, projectStart, pixelsPerDay),
      ],
    );
  }

  Widget _buildTodayLine(DateTime projectStart, double pixelsPerDay) {
    final todayOffset = DateTime.now().difference(projectStart).inDays;
    final x = todayOffset * pixelsPerDay;

    return Positioned(
      left: x,
      top: 0,
      bottom: 0,
      child: Container(
        width: 2,
        color: AppColors.error,
        child: const Positioned(
          top: 0,
          child: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.error,
            size: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDependencyLines(TaskModel task, DateTime projectStart, double pixelsPerDay) {
    // This would show dependency connections between tasks
    return const SizedBox.shrink();
  }

  Widget _buildMilestone(TaskModel task, DateTime projectStart, double pixelsPerDay) {
    final milestoneOffset = task.dueDate!.difference(projectStart).inDays;
    final x = milestoneOffset * pixelsPerDay;

    return Positioned(
      left: x - 6,
      top: 18,
      child: Container(
        width: 12,
        height: 12,
        decoration: const BoxDecoration(
          color: AppColors.warning,
          shape: BoxShape.diamond,
        ),
        child: const Icon(
          Icons.flag,
          size: 8,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMilestoneView() {
    final milestones = _generateMilestones();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Project Milestones',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...milestones.map((milestone) => _buildMilestoneCard(milestone)).toList(),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(Map<String, dynamic> milestone) {
    final isCompleted = milestone['completed'] as bool;
    final date = milestone['date'] as DateTime;
    final title = milestone['title'] as String;
    final description = milestone['description'] as String;
    final tasks = milestone['tasks'] as List<TaskModel>;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isCompleted ? AppColors.success : AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getMilestoneStatusColor(date, isCompleted).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getMilestoneStatusColor(date, isCompleted).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    AppDateUtils.formatDate(date),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getMilestoneStatusColor(date, isCompleted),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Related Tasks:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: tasks.map((task) => Chip(
                label: Text(
                  task.title,
                  style: const TextStyle(fontSize: 10),
                ),
                backgroundColor: _getTaskColor(task).withOpacity(0.1),
                side: BorderSide(color: _getTaskColor(task).withOpacity(0.3)),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateChartWidth() {
    final projectStart = widget.project.startDate;
    final projectEnd = widget.project.endDate ?? DateTime.now().add(const Duration(days: 90));
    final totalDays = projectEnd.difference(projectStart).inDays;
    return (totalDays / 7 * 100 * _zoomLevel) + 200; // 100px per week + task info width
  }

  bool _shouldShowTodayLine() {
    final today = DateTime.now();
    final projectStart = widget.project.startDate;
    final projectEnd = widget.project.endDate ?? DateTime.now().add(const Duration(days: 90));
    
    return today.isAfter(projectStart) && today.isBefore(projectEnd);
  }

  List<Map<String, dynamic>> _generateMilestones() {
    // Generate sample milestones based on project timeline
    final projectDuration = (widget.project.endDate ?? DateTime.now().add(const Duration(days: 90)))
        .difference(widget.project.startDate).inDays;
    
    return [
      {
        'title': 'Project Kickoff',
        'description': 'Initial project setup and team onboarding',
        'date': widget.project.startDate,
        'completed': true,
        'tasks': widget.tasks.take(2).toList(),
      },
      {
        'title': 'Phase 1 Complete',
        'description': 'Core features developed and tested',
        'date': widget.project.startDate.add(Duration(days: (projectDuration * 0.3).round())),
        'completed': true,
        'tasks': widget.tasks.skip(2).take(3).toList(),
      },
      {
        'title': 'Beta Release',
        'description': 'Beta version released for testing',
        'date': widget.project.startDate.add(Duration(days: (projectDuration * 0.7).round())),
        'completed': false,
        'tasks': widget.tasks.skip(5).take(2).toList(),
      },
      {
        'title': 'Project Completion',
        'description': 'Final delivery and project closure',
        'date': widget.project.endDate ?? DateTime.now().add(const Duration(days: 90)),
        'completed': false,
        'tasks': widget.tasks.skip(7).toList(),
      },
    ];
  }

  Color _getTaskColor(TaskModel task) {
    switch (task.status) {
      case TaskStatus.todo:
        return AppColors.textSecondary;
      case TaskStatus.inProgress:
        return AppColors.info;
      case TaskStatus.inReview:
        return AppColors.warning;
      case TaskStatus.completed:
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

  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Icons.keyboard_arrow_down;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.keyboard_arrow_up;
      case TaskPriority.urgent:
        return Icons.priority_high;
    }
  }

  Color _getMilestoneStatusColor(DateTime date, bool isCompleted) {
    if (isCompleted) return AppColors.success;
    if (date.isBefore(DateTime.now())) return AppColors.error;
    if (date.difference(DateTime.now()).inDays <= 7) return AppColors.warning;
    return AppColors.info;
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel * 1.2).clamp(0.5, 3.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel / 1.2).clamp(0.5, 3.0);
    });
  }

  void _goToToday() {
    setState(() {
      _currentDate = DateTime.now();
    });
  }
}