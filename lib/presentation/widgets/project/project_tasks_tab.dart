// // lib/presentation/widgets/project/project_tasks_tab.dart

// import 'package:flutter/material.dart';
// import '../../../data/models/project_model.dart';
// import '../../../data/models/task_model.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/enums/task_status.dart';
// import '../../../core/enums/task_priority.dart';
// import '../task/task_card.dart';
// import '../task/kanban_column.dart';

// class ProjectTasksTab extends StatefulWidget {
//   final ProjectModel project;
//   final List<TaskModel> tasks;

//   const ProjectTasksTab({
//     Key? key,
//     required this.project,
//     required this.tasks,
//   }) : super(key: key);

//   @override
//   State<ProjectTasksTab> createState() => _ProjectTasksTabState();
// }

// class _ProjectTasksTabState extends State<ProjectTasksTab> {
//   String _viewMode = 'kanban';
//   TaskStatus? _statusFilter;
//   TaskPriority? _priorityFilter;
//   String? _assigneeFilter;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _buildTaskControls(),
//         Expanded(
//           child: _viewMode == 'kanban' 
//               ? _buildKanbanView()
//               : _buildListView(),
//         ),
//       ],
//     );
//   }

//   Widget _buildTaskControls() {
//     return Card(
//       margin: const EdgeInsets.all(16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: SegmentedButton<String>(
//                     segments: const [
//                       ButtonSegment(value: 'kanban', label: Text('Kanban')),
//                       ButtonSegment(value: 'list', label: Text('List')),
//                     ],
//                     selected: {_viewMode},
//                     onSelectionChanged: (Set<String> newSelection) {
//                       setState(() {
//                         _viewMode = newSelection.first;
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 IconButton(
//                   onPressed: () => _showFilterDialog(),
//                   icon: Icon(
//                     Icons.filter_list,
//                     color: _hasActiveFilters() ? AppColors.primary : null,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () => _showTaskSortDialog(),
//                   icon: const Icon(Icons.sort),
//                 ),
//               ],
//             ),
//             if (_hasActiveFilters()) ...[
//               const SizedBox(height: 12),
//               _buildActiveFilters(),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActiveFilters() {
//     return Wrap(
//       spacing: 8,
//       children: [
//         if (_statusFilter != null)
//           FilterChip(
//             label: Text(_statusFilter!.displayName),
//             onDeleted: () => setState(() => _statusFilter = null),
//             backgroundColor: AppColors.getTaskStatusColor(_statusFilter!.name).withOpacity(0.1),
//           ),
//         if (_priorityFilter != null)
//           FilterChip(
//             label: Text(_priorityFilter!.name),
//             onDeleted: () => setState(() => _priorityFilter = null),
//             backgroundColor: AppColors.getPriorityColor(_priorityFilter!.name).withOpacity(0.1),
//           ),
//         if (_assigneeFilter != null)
//           FilterChip(
//             label: Text('Assignee: $_assigneeFilter'),
//             onDeleted: () => setState(() => _assigneeFilter = null),
//           ),
//       ],
//     );
//   }

//   Widget _buildKanbanView() {
//     final tasksByStatus = _groupTasksByStatus(_getFilteredTasks());
    
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: TaskStatus.values.map((status) {
//           final tasks = tasksByStatus[status] ?? [];
//           return Container(
//             width: 300,
//             margin: const EdgeInsets.only(right: 16),
//             child: KanbanColumn(
//               title: status.displayName,
//               tasks: tasks,
//               status: status,
//               onTaskTap: (task) => _onTaskTap(task),
//               onTaskStatusChanged: (task, newStatus) => _onTaskStatusChanged(task, newStatus),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildListView() {
//     final filteredTasks = _getFilteredTasks();
    
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: filteredTasks.length,
//       itemBuilder: (context, index) {
//         final task = filteredTasks[index];
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 8),
//           child: TaskCard(
//             task: task,
//             onTap: () => _onTaskTap(task),
//             showProject: false,
//           ),
//         );
//       },
//     );
//   }

//   List<TaskModel> _getFilteredTasks() {
//     return widget.tasks.where((task) {
//       if (task.projectId != widget.project.id) return false;
//       if (_statusFilter != null && task.status != _statusFilter) return false;
//       if (_priorityFilter != null && task.priority != _priorityFilter) return false;
//       if (_assigneeFilter != null && task.assigneeId != _assigneeFilter) return false;
//       return true;
//     }).toList();
//   }

//   Map<TaskStatus, List<TaskModel>> _groupTasksByStatus(List<TaskModel> tasks) {
//     final Map<TaskStatus, List<TaskModel>> grouped = {};
    
//     for (final status in TaskStatus.values) {
//       grouped[status] = tasks.where((task) => task.status == status).toList();
//     }
    
//     return grouped;
//   }

//   bool _hasActiveFilters() {
//     return _statusFilter != null || _priorityFilter != null || _assigneeFilter != null;
//   }

//   void _showFilterDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => _FilterDialog(
//         statusFilter: _statusFilter,
//         priorityFilter: _priorityFilter,
//         assigneeFilter: _assigneeFilter,
//         availableAssignees: _getUniqueAssignees(),
//         onFiltersChanged: (status, priority, assignee) {
//           setState(() {
//             _statusFilter = status;
//             _priorityFilter = priority;
//             _assigneeFilter = assignee;
//           });
//         },
//       ),
//     );
//   }

//   void _showTaskSortDialog() {
//     // Implementation for task sorting options
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Sort Tasks'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               title: const Text('Due Date'),
//               leading: const Icon(Icons.schedule),
//               onTap: () => Navigator.pop(context),
//             ),
//             ListTile(
//               title: const Text('Priority'),
//               leading: const Icon(Icons.priority_high),
//               onTap: () => Navigator.pop(context),
//             ),
//             ListTile(
//               title: const Text('Status'),
//               leading: const Icon(Icons.flag),
//               onTap: () => Navigator.pop(context),
//             ),
//             ListTile(
//               title: const Text('Assignee'),
//               leading: const Icon(Icons.person),
//               onTap: () => Navigator.pop(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<String> _getUniqueAssignees() {
//     return widget.tasks
//         .where((task) => task.assigneeId != null)
//         .map((task) => task.assigneeId!)
//         .toSet()
//         .toList();
//   }

//   void _onTaskTap(TaskModel task) {
//     Navigator.pushNamed(
//       context,
//       '/task/detail',
//       arguments: task.id,
//     );
//   }

//   void _onTaskStatusChanged(TaskModel task, TaskStatus newStatus) {
//     // Implementation for updating task status
//     // This would typically call a method in the task view model
//   }
// }

// class _FilterDialog extends StatefulWidget {
//   final TaskStatus? statusFilter;
//   final TaskPriority? priorityFilter;
//   final String? assigneeFilter;
//   final List<String> availableAssignees;
//   final Function(TaskStatus?, TaskPriority?, String?) onFiltersChanged;

//   const _FilterDialog({
//     required this.statusFilter,
//     required this.priorityFilter,
//     required this.assigneeFilter,
//     required this.availableAssignees,
//     required this.onFiltersChanged,
//   });

//   @override
//   State<_FilterDialog> createState() => _FilterDialogState();
// }

// class _FilterDialogState extends State<_FilterDialog> {
//   TaskStatus? _statusFilter;
//   TaskPriority? _priorityFilter;
//   String? _assigneeFilter;

//   @override
//   void initState() {
//     super.initState();
//     _statusFilter = widget.statusFilter;
//     _priorityFilter = widget.priorityFilter;
//     _assigneeFilter = widget.assigneeFilter;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Filter Tasks'),
//       content: SizedBox(
//         width: double.maxFinite,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             DropdownButtonFormField<TaskStatus>(
//               value: _statusFilter,
//               decoration: const InputDecoration(
//                 hintText: 'Select status',
//                 border: OutlineInputBorder(),
//               ),
//               items: [
//                 const DropdownMenuItem<TaskStatus>(
//                   value: null,
//                   child: Text('All Statuses'),
//                 ),
//                 ...TaskStatus.values.map((status) => DropdownMenuItem<TaskStatus>(
//                   value: status,
//                   child: Text(status.displayName),
//                 )),
//               ],
//               onChanged: (value) => setState(() => _statusFilter = value),
//             ),
//             const SizedBox(height: 16),
//             const Text('Priority', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             DropdownButtonFormField<TaskPriority>(
//               value: _priorityFilter,
//               decoration: const InputDecoration(
//                 hintText: 'Select priority',
//                 border: OutlineInputBorder(),
//               ),
//               items: [
//                 const DropdownMenuItem<TaskPriority>(
//                   value: null,
//                   child: Text('All Priorities'),
//                 ),
//                 ...TaskPriority.values.map((priority) => DropdownMenuItem<TaskPriority>(
//                   value: priority,
//                   child: Text(priority.name),
//                 )),
//               ],
//               onChanged: (value) => setState(() => _priorityFilter = value),
//             ),
//             const SizedBox(height: 16),
//             const Text('Assignee', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             DropdownButtonFormField<String>(
//               value: _assigneeFilter,
//               decoration: const InputDecoration(
//                 hintText: 'Select assignee',
//                 border: OutlineInputBorder(),
//               ),
//               items: [
//                 const DropdownMenuItem<String>(
//                   value: null,
//                   child: Text('All Assignees'),
//                 ),
//                 ...widget.availableAssignees.map((assignee) => DropdownMenuItem<String>(
//                   value: assignee,
//                   child: Text('User $assignee'),
//                 )),
//               ],
//               onChanged: (value) => setState(() => _assigneeFilter = value),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             setState(() {
//               _statusFilter = null;
//               _priorityFilter = null;
//               _assigneeFilter = null;
//             });
//           },
//           child: const Text('Clear All'),
//         ),
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             widget.onFiltersChanged(_statusFilter, _priorityFilter, _assigneeFilter);
//             Navigator.pop(context);
//           },
//           child: const Text('Apply'),
//         ),
//       ],
//     );
//   }
// }


//2




// lib/presentation/widgets/project/project_tasks_tab.dart

import 'package:flutter/material.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/task_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/enums/task_status.dart';
import '../../../core/enums/task_priority.dart';
import '../task/task_card.dart';
import '../task/kanban_column.dart';

class ProjectTasksTab extends StatefulWidget {
  final ProjectModel project;
  final List<TaskModel> tasks;

  const ProjectTasksTab({
    Key? key,
    required this.project,
    required this.tasks,
  }) : super(key: key);

  @override
  State<ProjectTasksTab> createState() => _ProjectTasksTabState();
}

class _ProjectTasksTabState extends State<ProjectTasksTab> {
  String _viewMode = 'kanban';
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;
  String? _assigneeFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTaskControls(),
        Expanded(
          child: _viewMode == 'kanban' 
              ? _buildKanbanView()
              : _buildListView(),
        ),
      ],
    );
  }

  Widget _buildTaskControls() {
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
                      ButtonSegment(value: 'kanban', label: Text('Kanban')),
                      ButtonSegment(value: 'list', label: Text('List')),
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
                  onPressed: () => _showFilterDialog(),
                  icon: Icon(
                    Icons.filter_list,
                    color: _hasActiveFilters() ? AppColors.primary : null,
                  ),
                ),
                IconButton(
                  onPressed: () => _showTaskSortDialog(),
                  icon: const Icon(Icons.sort),
                ),
              ],
            ),
            if (_hasActiveFilters()) ...[
              const SizedBox(height: 12),
              _buildActiveFilters(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Wrap(
      spacing: 8,
      children: [
        if (_statusFilter != null)
          FilterChip(
            label: Text(_statusFilter!.displayName),
            onDeleted: () => setState(() => _statusFilter = null),
            backgroundColor: AppColors.getTaskStatusColor(_statusFilter!.name).withOpacity(0.1), onSelected: (bool value) {  },
          ),
        if (_priorityFilter != null)
          FilterChip(
            label: Text(_priorityFilter!.name),
            onDeleted: () => setState(() => _priorityFilter = null),
            backgroundColor: AppColors.getPriorityColor(_priorityFilter!.name).withOpacity(0.1), onSelected: (bool value) {  },
          ),
        if (_assigneeFilter != null)
          FilterChip(
            label: Text('Assignee: $_assigneeFilter'),
            onDeleted: () => setState(() => _assigneeFilter = null), onSelected: (bool value) {  },
          ),
      ],
    );
  }

  Widget _buildKanbanView() {
    final tasksByStatus = _groupTasksByStatus(_getFilteredTasks());
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: TaskStatus.values.map((status) {
          final tasks = tasksByStatus[status] ?? [];
          return Container(
            width: 300,
            margin: const EdgeInsets.only(right: 16),
            child: KanbanColumn(
              title: status.displayName,
              tasks: tasks,
              status: status,
              onTaskTap: (task) => _onTaskTap(task), onTaskMoved: (TaskModel , TaskStatus ) {  },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildListView() {
    final filteredTasks = _getFilteredTasks();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TaskCard(
            task: task,
            onTap: () => _onTaskTap(task),
            showProject: false,
          ),
        );
      },
    );
  }

  List<TaskModel> _getFilteredTasks() {
    return widget.tasks.where((task) {
      if (task.projectId != widget.project.id) return false;
      if (_statusFilter != null && task.status != _statusFilter) return false;
      if (_priorityFilter != null && task.priority != _priorityFilter) return false;
      if (_assigneeFilter != null && task.assigneeId != _assigneeFilter) return false;
      return true;
    }).toList();
  }

  Map<TaskStatus, List<TaskModel>> _groupTasksByStatus(List<TaskModel> tasks) {
    final Map<TaskStatus, List<TaskModel>> grouped = {};
    
    for (final status in TaskStatus.values) {
      grouped[status] = tasks.where((task) => task.status == status).toList();
    }
    
    return grouped;
  }

  bool _hasActiveFilters() {
    return _statusFilter != null || _priorityFilter != null || _assigneeFilter != null;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => _FilterDialog(
        statusFilter: _statusFilter,
        priorityFilter: _priorityFilter,
        assigneeFilter: _assigneeFilter,
        availableAssignees: _getUniqueAssignees(),
        onFiltersChanged: (status, priority, assignee) {
          setState(() {
            _statusFilter = status;
            _priorityFilter = priority;
            _assigneeFilter = assignee;
          });
        },
      ),
    );
  }

  void _showTaskSortDialog() {
    // Implementation for task sorting options
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Tasks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Due Date'),
              leading: const Icon(Icons.schedule),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Priority'),
              leading: const Icon(Icons.priority_high),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Status'),
              leading: const Icon(Icons.flag),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Assignee'),
              leading: const Icon(Icons.person),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getUniqueAssignees() {
    return widget.tasks
        .where((task) => task.assigneeId != null)
        .map((task) => task.assigneeId!)
        .toSet()
        .toList();
  }

  void _onTaskTap(TaskModel task) {
    Navigator.pushNamed(
      context,
      '/task/detail',
      arguments: task.id,
    );
  }

  void _onTaskStatusChanged(TaskModel task, TaskStatus newStatus) {
    // Implementation for updating task status
    // This would typically call a method in the task view model
  }
}

class _FilterDialog extends StatefulWidget {
  final TaskStatus? statusFilter;
  final TaskPriority? priorityFilter;
  final String? assigneeFilter;
  final List<String> availableAssignees;
  final Function(TaskStatus?, TaskPriority?, String?) onFiltersChanged;

  const _FilterDialog({
    required this.statusFilter,
    required this.priorityFilter,
    required this.assigneeFilter,
    required this.availableAssignees,
    required this.onFiltersChanged,
  });

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;
  String? _assigneeFilter;

  @override
  void initState() {
    super.initState();
    _statusFilter = widget.statusFilter;
    _priorityFilter = widget.priorityFilter;
    _assigneeFilter = widget.assigneeFilter;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Tasks'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<TaskStatus>(
              value: _statusFilter,
              decoration: const InputDecoration(
                hintText: 'Select status',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<TaskStatus>(
                  value: null,
                  child: Text('All Statuses'),
                ),
                ...TaskStatus.values.map((status) => DropdownMenuItem<TaskStatus>(
                  value: status,
                  child: Text(status.displayName),
                )),
              ],
              onChanged: (value) => setState(() => _statusFilter = value),
            ),
            const SizedBox(height: 16),
            const Text('Priority', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<TaskPriority>(
              value: _priorityFilter,
              decoration: const InputDecoration(
                hintText: 'Select priority',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<TaskPriority>(
                  value: null,
                  child: Text('All Priorities'),
                ),
                ...TaskPriority.values.map((priority) => DropdownMenuItem<TaskPriority>(
                  value: priority,
                  child: Text(priority.name),
                )),
              ],
              onChanged: (value) => setState(() => _priorityFilter = value),
            ),
            const SizedBox(height: 16),
            const Text('Assignee', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _assigneeFilter,
              decoration: const InputDecoration(
                hintText: 'Select assignee',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Assignees'),
                ),
                ...widget.availableAssignees.map((assignee) => DropdownMenuItem<String>(
                  value: assignee,
                  child: Text('User $assignee'),
                )),
              ],
              onChanged: (value) => setState(() => _assigneeFilter = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _statusFilter = null;
              _priorityFilter = null;
              _assigneeFilter = null;
            });
          },
          child: const Text('Clear All'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onFiltersChanged(_statusFilter, _priorityFilter, _assigneeFilter);
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}