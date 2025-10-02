// lib/presentation/widgets/task/task_form_widget.dart

import 'package:flutter/material.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/user_model.dart';
import '../../../core/enums/task_status.dart';
import '../../../core/enums/task_priority.dart';
import '../../../core/constants/app_colors.dart';
import '../common/custom_text_field.dart';

class TaskFormWidget extends StatefulWidget {
  final TaskModel? task; // null for create, non-null for edit
  final List<ProjectModel> projects;
  final List<UserModel> users;
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final Function(String?) onProjectChanged;
  final Function(String?) onAssigneeChanged;
  final Function(TaskStatus) onStatusChanged;
  final Function(TaskPriority) onPriorityChanged;
  final Function(DateTime?) onDueDateChanged;
  final Function(DateTime?) onStartDateChanged;
  final Function(List<String>) onTagsChanged;
  
  final String? selectedProjectId;
  final String? selectedAssigneeId;
  final TaskStatus selectedStatus;
  final TaskPriority selectedPriority;
  final DateTime? selectedDueDate;
  final DateTime? selectedStartDate;
  final List<String> selectedTags;

  const TaskFormWidget({
    Key? key,
    this.task,
    required this.projects,
    required this.users,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.onProjectChanged,
    required this.onAssigneeChanged,
    required this.onStatusChanged,
    required this.onPriorityChanged,
    required this.onDueDateChanged,
    required this.onStartDateChanged,
    required this.onTagsChanged,
    required this.selectedProjectId,
    required this.selectedAssigneeId,
    required this.selectedStatus,
    required this.selectedPriority,
    required this.selectedDueDate,
    required this.selectedStartDate,
    required this.selectedTags,
  }) : super(key: key);

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  final TextEditingController _tagController = TextEditingController();

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Title
          CustomTextField(
            controller: widget.titleController,
            label: 'Task Title',
            hint: 'Enter task title',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a task title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Description
          CustomTextField(
            controller: widget.descriptionController,
            label: 'Description',
            hint: 'Enter task description',
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a task description';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Project Dropdown
          DropdownButtonFormField<String>(
            value: widget.selectedProjectId,
            decoration: const InputDecoration(
              labelText: 'Project',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.folder_outlined),
            ),
            items: widget.projects.map((project) {
              return DropdownMenuItem(
                value: project.id,
                child: Text(project.name),
              );
            }).toList(),
            onChanged: widget.onProjectChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a project';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Status Dropdown (only show in edit mode)
          if (widget.task != null)
            DropdownButtonFormField<TaskStatus>(
              value: widget.selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag_outlined),
              ),
              items: TaskStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: status.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(status.displayName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) widget.onStatusChanged(value);
              },
            ),
          if (widget.task != null) const SizedBox(height: 16),

          // Priority Dropdown
          DropdownButtonFormField<TaskPriority>(
            value: widget.selectedPriority,
            decoration: const InputDecoration(
              labelText: 'Priority',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.priority_high_rounded),
            ),
            items: TaskPriority.values.map((priority) {
              return DropdownMenuItem(
                value: priority,
                child: Row(
                  children: [
                    Icon(
                      Icons.flag_rounded,
                      color: priority.color,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(priority.displayName),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) widget.onPriorityChanged(value);
            },
          ),
          const SizedBox(height: 16),

          // Assignee Dropdown
          DropdownButtonFormField<String>(
            value: widget.selectedAssigneeId,
            decoration: const InputDecoration(
              labelText: 'Assign To',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('Unassigned'),
              ),
              ...widget.users.map((user) {
                return DropdownMenuItem(
                  value: user.id,
                  child: Text(user.name),
                );
              }).toList(),
            ],
            onChanged: widget.onAssigneeChanged,
          ),
          const SizedBox(height: 16),

          // Start Date
          InkWell(
            onTap: () => _selectStartDate(context),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Start Date (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today_rounded),
              ),
              child: Text(
                widget.selectedStartDate != null
                    ? _formatDate(widget.selectedStartDate!)
                    : 'Select start date',
                style: TextStyle(
                  color: widget.selectedStartDate != null
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Due Date
          InkWell(
            onTap: () => _selectDueDate(context),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Due Date',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.event_rounded),
              ),
              child: Text(
                widget.selectedDueDate != null
                    ? _formatDate(widget.selectedDueDate!)
                    : 'Select due date',
                style: TextStyle(
                  color: widget.selectedDueDate != null
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tags
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tags',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...widget.selectedTags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        final newTags = List<String>.from(widget.selectedTags);
                        newTags.remove(tag);
                        widget.onTagsChanged(newTags);
                      },
                    );
                  }).toList(),
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 18),
                    label: const Text('Add Tag'),
                    onPressed: () => _showAddTagDialog(context),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      widget.onStartDateChanged(picked);
    }
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      widget.onDueDateChanged(picked);
    }
  }

  void _showAddTagDialog(BuildContext context) {
    _tagController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tag'),
        content: TextField(
          controller: _tagController,
          decoration: const InputDecoration(
            hintText: 'Enter tag name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              final newTags = List<String>.from(widget.selectedTags);
              if (!newTags.contains(value.trim())) {
                newTags.add(value.trim());
                widget.onTagsChanged(newTags);
              }
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_tagController.text.trim().isNotEmpty) {
                final newTags = List<String>.from(widget.selectedTags);
                if (!newTags.contains(_tagController.text.trim())) {
                  newTags.add(_tagController.text.trim());
                  widget.onTagsChanged(newTags);
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}