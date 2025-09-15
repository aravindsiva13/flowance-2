// // lib/presentation/widgets/project/project_time_tracking_tab.dart

// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../../../data/models/project_model.dart';
// import '../../../data/models/time_entry_model.dart';
// import '../../../data/models/user_model.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/utils/date_utils.dart';

// class ProjectTimeTrackingTab extends StatefulWidget {
//   final ProjectModel project;
//   final List<TimeEntryModel> timeEntries;

//   const ProjectTimeTrackingTab({
//     Key? key,
//     required this.project,
//     required this.timeEntries,
//   }) : super(key: key);

//   @override
//   State<ProjectTimeTrackingTab> createState() => _ProjectTimeTrackingTabState();
// }

// class _ProjectTimeTrackingTabState extends State<ProjectTimeTrackingTab> {
//   String _selectedTimeframe = 'week';
//   DateTime _selectedDate = DateTime.now();

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildTimeframeSelector(),
//           const SizedBox(height: 16),
//           _buildTimeOverview(),
//           const SizedBox(height: 16),
//           _buildTimeDistributionChart(),
//           const SizedBox(height: 16),
//           _buildTeamTimeBreakdown(),
//           const SizedBox(height: 16),
//           _buildDailyTimeChart(),
//           const SizedBox(height: 16),
//           _buildRecentTimeEntries(),
//         ],
//       ),
//     );
//   }

//   Widget _buildTimeframeSelector() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Time Period',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: SegmentedButton<String>(
//                     segments: const [
//                       ButtonSegment(value: 'day', label: Text('Day')),
//                       ButtonSegment(value: 'week', label: Text('Week')),
//                       ButtonSegment(value: 'month', label: Text('Month')),
//                     ],
//                     selected: {_selectedTimeframe},
//                     onSelectionChanged: (Set<String> newSelection) {
//                       setState(() {
//                         _selectedTimeframe = newSelection.first;
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 OutlinedButton.icon(
//                   onPressed: () => _selectDate(),
//                   icon: const Icon(Icons.calendar_today),
//                   label: Text(_formatSelectedDate()),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeOverview() {
//     final totalTime = _calculateTotalTime();
//     final budgetTime = Duration(hours: 160); // Example budget
//     final budgetProgress = totalTime.inMinutes / budgetTime.inMinutes;

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Time Overview',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildTimeMetric(
//                     'Total Time',
//                     _formatDuration(totalTime),
//                     Icons.access_time,
//                     AppColors.primary,
//                   ),
//                 ),
//                 Expanded(
//                   child: _buildTimeMetric(
//                     'Budget',
//                     _formatDuration(budgetTime),
//                     Icons.account_balance_wallet,
//                     AppColors.info,
//                   ),
//                 ),
//                 Expanded(
//                   child: _buildTimeMetric(
//                     'Remaining',
//                     _formatDuration(budgetTime - totalTime),
//                     Icons.timelapse,
//                     AppColors.warning,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Budget Progress',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//             const SizedBox(height: 8),
//             LinearProgressIndicator(
//               value: budgetProgress.clamp(0.0, 1.0),
//               backgroundColor: AppColors.surface,
//               valueColor: AlwaysStoppedAnimation<Color>(
//                 budgetProgress > 1.0 ? AppColors.error : AppColors.success,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               '${(budgetProgress * 100).toInt()}% of budget used',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeMetric(String label, String value, IconData icon, Color color) {
//     return Column(
//       children: [
//         Icon(icon, color: color, size: 24),
//         const SizedBox(height: 8),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: AppColors.textSecondary,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   Widget _buildTimeDistributionChart() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Time Distribution by Task',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 200,
//               child: PieChart(
//                 PieChartData(
//                   sections: _buildPieChartSections(),
//                   centerSpaceRadius: 40,
//                   sectionsSpace: 2,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildChartLegend(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTeamTimeBreakdown() {
//     final memberTime = _calculateMemberTime();

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Team Time Breakdown',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 TextButton(
//                   onPressed: () => _showDetailedMemberTime(),
//                   child: const Text('View Details'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             ...memberTime.entries.map((entry) => _buildMemberTimeRow(
//               entry.key,
//               entry.value,
//             )).toList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMemberTimeRow(String memberId, Duration time) {
//     // This would typically fetch user data from repository
//     final memberName = 'Member $memberId'; // Placeholder
//     final totalProjectTime = _calculateTotalTime();
//     final percentage = totalProjectTime.inMinutes > 0 
//         ? (time.inMinutes / totalProjectTime.inMinutes) 
//         : 0.0;

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 16,
//             child: Text(memberName[0]),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   memberName,
//                   style: const TextStyle(fontWeight: FontWeight.w500),
//                 ),
//                 LinearProgressIndicator(
//                   value: percentage,
//                   backgroundColor: AppColors.surface,
//                   valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 12),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 _formatDuration(time),
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 '${(percentage * 100).toInt()}%',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: AppColors.textSecondary,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDailyTimeChart() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Daily Time Trend',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 200,
//               child: LineChart(
//                 LineChartData(
//                   gridData: const FlGridData(show: true),
//                   titlesData: FlTitlesData(
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           return Text(
//                             '${value.toInt()}',
//                             style: const TextStyle(fontSize: 10),
//                           );
//                         },
//                       ),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           return Text(
//                             '${value.toInt()}h',
//                             style: const TextStyle(fontSize: 10),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   borderData: FlBorderData(show: false),
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: _buildDailyTimeSpots(),
//                       isCurved: true,
//                       color: AppColors.primary,
//                       barWidth: 3,
//                       dotData: const FlDotData(show: true),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRecentTimeEntries() {
//     final recentEntries = widget.timeEntries
//         .where((entry) => entry.projectId == widget.project.id)
//         .take(10)
//         .toList();

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Recent Time Entries',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 TextButton(
//                   onPressed: () => _viewAllTimeEntries(),
//                   child: const Text('View All'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             ...recentEntries.map((entry) => _buildTimeEntryTile(entry)).toList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeEntryTile(TimeEntryModel entry) {
//     return ListTile(
//       leading: Icon(
//         entry.isActive ? Icons.play_circle : Icons.stop_circle,
//         color: entry.isActive ? AppColors.success : AppColors.textSecondary,
//       ),
//       title: Text(entry.description),
//       subtitle: Text(
//         '${AppDateUtils.formatDate(entry.startTime)} • ${_formatDuration(entry.duration)}',
//       ),
//       trailing: IconButton(
//         icon: const Icon(Icons.edit),
//         onPressed: () => _editTimeEntry(entry),
//       ),
//     );
//   }

//   Widget _buildChartLegend() {
//     final taskColors = [
//       AppColors.primary,
//       AppColors.success,
//       AppColors.warning,
//       AppColors.error,
//       AppColors.info,
//     ];

//     return Wrap(
//       spacing: 16,
//       runSpacing: 8,
//       children: List.generate(5, (index) {
//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 12,
//               height: 12,
//               decoration: BoxDecoration(
//                 color: taskColors[index],
//                 shape: BoxShape.circle,
//               ),
//             ),
//             const SizedBox(width: 4),
//             Text(
//               'Task ${index + 1}',
//               style: const TextStyle(fontSize: 12),
//             ),
//           ],
//         );
//       }),
//     );
//   }

//   List<PieChartSectionData> _buildPieChartSections() {
//     final taskTime = <String, Duration>{};
    
//     // Group time entries by task
//     for (final entry in widget.timeEntries) {
//       if (entry.projectId == widget.project.id) {
//         taskTime[entry.taskId ?? 'No Task'] = 
//             (taskTime[entry.taskId ?? 'No Task'] ?? Duration.zero) + entry.duration;
//       }
//     }

//     final colors = [
//       AppColors.primary,
//       AppColors.success,
//       AppColors.warning,
//       AppColors.error,
//       AppColors.info,
//     ];

//     return taskTime.entries.toList().asMap().entries.map((entry) {
//       final index = entry.key;
//       final taskEntry = entry.value;
//       final percentage = _calculateTotalTime().inMinutes > 0
//           ? (taskEntry.value.inMinutes / _calculateTotalTime().inMinutes) * 100
//           : 0.0;

//       return PieChartSectionData(
//         color: colors[index % colors.length],
//         value: taskEntry.value.inMinutes.toDouble(),
//         title: '${percentage.toInt()}%',
//         radius: 50,
//         titleStyle: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       );
//     }).toList();
//   }

//   List<FlSpot> _buildDailyTimeSpots() {
//     // This would calculate daily time for the selected period
//     final spots = <FlSpot>[];
//     for (int i = 0; i < 7; i++) {
//       spots.add(FlSpot(i.toDouble(), (i * 2 + 3).toDouble()));
//     }
//     return spots;
//   }

//   Duration _calculateTotalTime() {
//     return widget.timeEntries
//         .where((entry) => entry.projectId == widget.project.id)
//         .fold(Duration.zero, (total, entry) => total + _getEntryDuration(entry));
//   }

//   // Helper method to get duration from time entry
//   Duration _getEntryDuration(TimeEntryModel entry) {
//     if (entry.endTime != null) {
//       return entry.endTime!.difference(entry.startTime);
//     }
//     return Duration.zero;
//   }

//   Map<String, Duration> _calculateMemberTime() {
//     final memberTime = <String, Duration>{};
    
//     for (final entry in widget.timeEntries) {
//       if (entry.projectId == widget.project.id) {
//         memberTime[entry.userId] = 
//             (memberTime[entry.userId] ?? Duration.zero) + _getEntryDuration(entry);
//       }
//     }
    
//     return memberTime;
//   }

//   String _formatDuration(Duration duration) {
//     final hours = duration.inHours;
//     final minutes = duration.inMinutes % 60;
//     return '${hours}h ${minutes}m';
//   }

//   String _formatSelectedDate() {
//     switch (_selectedTimeframe) {
//       case 'day':
//         return AppDateUtils.formatDate(_selectedDate);
//       case 'week':
//         return 'Week of ${AppDateUtils.formatDate(_selectedDate)}';
//       case 'month':
//         return AppDateUtils.formatMonth(_selectedDate);
//       default:
//         return AppDateUtils.formatDate(_selectedDate);
//     }
//   }

//   void _selectDate() async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//     );
//     if (date != null) {
//       setState(() {
//         _selectedDate = date;
//       });
//     }
//   }

//   void _showDetailedMemberTime() {
//     Navigator.pushNamed(
//       context,
//       '/project/team-time',
//       arguments: widget.project.id,
//     );
//   }

//   void _viewAllTimeEntries() {
//     Navigator.pushNamed(
//       context,
//       '/project/time-entries',
//       arguments: widget.project.id,
//     );
//   }

//   void _editTimeEntry(TimeEntryModel entry) {
//     Navigator.pushNamed(
//       context,
//       '/time/edit',
//       arguments: entry.id,
//     );
//   }
// }


//2



// lib/presentation/widgets/project/project_time_tracking_tab.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/time_entry_model.dart';
import '../../../data/models/user_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_utils.dart';

class ProjectTimeTrackingTab extends StatefulWidget {
  final ProjectModel project;
  final List<TimeEntryModel> timeEntries;

  const ProjectTimeTrackingTab({
    Key? key,
    required this.project,
    required this.timeEntries,
  }) : super(key: key);

  @override
  State<ProjectTimeTrackingTab> createState() => _ProjectTimeTrackingTabState();
}

class _ProjectTimeTrackingTabState extends State<ProjectTimeTrackingTab> {
  String _selectedTimeframe = 'week';
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimeframeSelector(),
          const SizedBox(height: 16),
          _buildTimeOverview(),
          const SizedBox(height: 16),
          _buildTimeDistributionChart(),
          const SizedBox(height: 16),
          _buildTeamTimeBreakdown(),
          const SizedBox(height: 16),
          _buildDailyTimeChart(),
          const SizedBox(height: 16),
          _buildRecentTimeEntries(),
        ],
      ),
    );
  }

  Widget _buildTimeframeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Time Period',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'day', label: Text('Day')),
                      ButtonSegment(value: 'week', label: Text('Week')),
                      ButtonSegment(value: 'month', label: Text('Month')),
                    ],
                    selected: {_selectedTimeframe},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _selectedTimeframe = newSelection.first;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () => _selectDate(),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_formatSelectedDate()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeOverview() {
    final totalTime = _calculateTotalTime();
    final budgetTime = Duration(hours: 160); // Example budget
    final budgetProgress = totalTime.inMinutes / budgetTime.inMinutes;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Time Overview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTimeMetric(
                    'Total Time',
                    _formatDuration(totalTime),
                    Icons.access_time,
                    AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _buildTimeMetric(
                    'Budget',
                    _formatDuration(budgetTime),
                    Icons.account_balance_wallet,
                    AppColors.info,
                  ),
                ),
                Expanded(
                  child: _buildTimeMetric(
                    'Remaining',
                    _formatDuration(budgetTime - totalTime),
                    Icons.timelapse,
                    AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Budget Progress',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: budgetProgress.clamp(0.0, 1.0),
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation<Color>(
                budgetProgress > 1.0 ? AppColors.error : AppColors.success,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(budgetProgress * 100).toInt()}% of budget used',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeMetric(String label, String value, IconData icon, Color color) {
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
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTimeDistributionChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Time Distribution by Task',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _buildPieChartSections(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildChartLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamTimeBreakdown() {
    final memberTime = _calculateMemberTime();

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
                  'Team Time Breakdown',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => _showDetailedMemberTime(),
                  child: const Text('View Details'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...memberTime.entries.map((entry) => _buildMemberTimeRow(
              entry.key,
              entry.value,
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTimeRow(String memberId, Duration time) {
    // This would typically fetch user data from repository
    final memberName = 'Member $memberId'; // Placeholder
    final totalProjectTime = _calculateTotalTime();
    final percentage = totalProjectTime.inMinutes > 0 
        ? (time.inMinutes / totalProjectTime.inMinutes) 
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            child: Text(memberName[0]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  memberName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                LinearProgressIndicator(
                  value: percentage,
                  backgroundColor: AppColors.surface,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatDuration(time),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${(percentage * 100).toInt()}%',
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

  Widget _buildDailyTimeChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Time Trend',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
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
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}h',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _buildDailyTimeSpots(),
                      isCurved: true,
                      color: AppColors.primary,
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

  Widget _buildRecentTimeEntries() {
    final recentEntries = widget.timeEntries
        .where((entry) => entry.projectId == widget.project.id)
        .take(10)
        .toList();

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
                  'Recent Time Entries',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => _viewAllTimeEntries(),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...recentEntries.map((entry) => _buildTimeEntryTile(entry)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeEntryTile(TimeEntryModel entry) {
    return ListTile(
      leading: Icon(
        entry.isActive ? Icons.play_circle : Icons.stop_circle,
        color: entry.isActive ? AppColors.success : AppColors.textSecondary,
      ),
      title: Text(entry.description),
      subtitle: Text(
        '${AppDateUtils.formatDate(entry.startTime)} • ${_formatDuration(entry.duration)}',
      ),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => _editTimeEntry(entry),
      ),
    );
  }

  Widget _buildChartLegend() {
    final taskColors = [
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
      AppColors.error,
      AppColors.info,
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: List.generate(5, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: taskColors[index],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Task ${index + 1}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final taskTime = <String, Duration>{};
    
    // Group time entries by task
    for (final entry in widget.timeEntries) {
      if (entry.projectId == widget.project.id) {
        taskTime[entry.taskId ?? 'No Task'] = 
            (taskTime[entry.taskId ?? 'No Task'] ?? Duration.zero) + entry.duration;
      }
    }

    final colors = [
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
      AppColors.error,
      AppColors.info,
    ];

    return taskTime.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final taskEntry = entry.value;
      final percentage = _calculateTotalTime().inMinutes > 0
          ? (taskEntry.value.inMinutes / _calculateTotalTime().inMinutes) * 100
          : 0.0;

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: taskEntry.value.inMinutes.toDouble(),
        title: '${percentage.toInt()}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<FlSpot> _buildDailyTimeSpots() {
    // This would calculate daily time for the selected period
    final spots = <FlSpot>[];
    for (int i = 0; i < 7; i++) {
      spots.add(FlSpot(i.toDouble(), (i * 2 + 3).toDouble()));
    }
    return spots;
  }

  Duration _calculateTotalTime() {
    return widget.timeEntries
        .where((entry) => entry.projectId == widget.project.id)
        .fold(Duration.zero, (total, entry) => total + _getEntryDuration(entry));
  }

  // Helper method to get duration from time entry
  Duration _getEntryDuration(TimeEntryModel entry) {
    if (entry.endTime != null) {
      return entry.endTime!.difference(entry.startTime);
    }
    return Duration.zero;
  }

  Map<String, Duration> _calculateMemberTime() {
    final memberTime = <String, Duration>{};
    
    for (final entry in widget.timeEntries) {
      if (entry.projectId == widget.project.id) {
        memberTime[entry.userId] = 
            (memberTime[entry.userId] ?? Duration.zero) + _getEntryDuration(entry);
      }
    }
    
    return memberTime;
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String _formatSelectedDate() {
    switch (_selectedTimeframe) {
      case 'day':
        return AppDateUtils.formatDate(_selectedDate);
      case 'week':
        return 'Week of ${AppDateUtils.formatDate(_selectedDate)}';
      case 'month':
        return AppDateUtils.formatMonth(_selectedDate);
      default:
        return AppDateUtils.formatDate(_selectedDate);
    }
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _showDetailedMemberTime() {
    Navigator.pushNamed(
      context,
      '/project/team-time',
      arguments: widget.project.id,
    );
  }

  void _viewAllTimeEntries() {
    Navigator.pushNamed(
      context,
      '/project/time-entries',
      arguments: widget.project.id,
    );
  }

  void _editTimeEntry(TimeEntryModel entry) {
    Navigator.pushNamed(
      context,
      '/time/edit',
      arguments: entry.id,
    );
  }
}