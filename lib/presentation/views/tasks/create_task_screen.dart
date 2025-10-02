// lib/presentation/views/tasks/create_task_screen.dart - REFACTORED VERSION

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/task/task_form_widget.dart';
import '../../../core/enums/task_status.dart';
import '../../../core/enums/task_priority.dart';
import '../../../core/constants/app_colors.dart';

class CreateTaskScreen extends StatefulWidget {
  final String? projectId;

  const CreateTaskScreen({
    Key? key,
    this.projectId,
  }) : super(key: key);

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedProjectId;
  String? _selectedAssigneeId;
  TaskStatus _selectedStatus = TaskStatus.toDo;
  TaskPriority _selectedPriority = TaskPriority.medium;
  DateTime? _selectedDueDate;
  DateTime? _selectedStartDate;
  List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _selectedProjectId = widget.projectId;
    _loadData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final taskViewModel = context.read<TaskViewModel>();
    await taskViewModel.loadProjects();
    await taskViewModel.loadUsers();
  }

  Future<void> _createTask() async {
    if (!_formKey.currentState!.validate()) return;

    final taskViewModel = context.read<TaskViewModel>();

    final success = await taskViewModel.createTask(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      projectId: _selectedProjectId!,
      assigneeId: _selectedAssigneeId,
      priority: _selectedPriority,
      dueDate: _selectedDueDate,
      tags: _selectedTags,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task created successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              taskViewModel.errorMessage ?? 'Failed to create task',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Create Task'),
      body: Consumer<TaskViewModel>(
        builder: (context, taskVM, child) {
          return Column(
            children: [
              Expanded(
                child: TaskFormWidget(
                  formKey: _formKey,
                  projects: taskVM.projects,
                  users: taskVM.users,
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  selectedProjectId: _selectedProjectId,
                  selectedAssigneeId: _selectedAssigneeId,
                  selectedStatus: _selectedStatus,
                  selectedPriority: _selectedPriority,
                  selectedDueDate: _selectedDueDate,
                  selectedStartDate: _selectedStartDate,
                  selectedTags: _selectedTags,
                  onProjectChanged: (value) {
                    setState(() {
                      _selectedProjectId = value;
                    });
                  },
                  onAssigneeChanged: (value) {
                    setState(() {
                      _selectedAssigneeId = value;
                    });
                  },
                  onStatusChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                  onPriorityChanged: (value) {
                    setState(() {
                      _selectedPriority = value;
                    });
                  },
                  onDueDateChanged: (value) {
                    setState(() {
                      _selectedDueDate = value;
                    });
                  },
                  onStartDateChanged: (value) {
                    setState(() {
                      _selectedStartDate = value;
                    });
                  },
                  onTagsChanged: (value) {
                    setState(() {
                      _selectedTags = value;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: taskVM.isCreating ? null : _createTask,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: taskVM.isCreating
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Create Task',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}