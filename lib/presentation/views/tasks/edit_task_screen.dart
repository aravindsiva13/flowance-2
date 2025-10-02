// lib/presentation/views/tasks/edit_task_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/task/task_form_widget.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/user_model.dart';
import '../../../core/enums/task_status.dart';
import '../../../core/enums/task_priority.dart';
import '../../../core/constants/app_colors.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;

  const EditTaskScreen({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
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

  List<ProjectModel> _projects = [];
  List<UserModel> _users = [];
  TaskModel? _task;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
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

    // Load task data
    final task = await taskViewModel.getTask(widget.taskId);
    if (task == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task not found')),
        );
        Navigator.pop(context);
      }
      return;
    }

    // Load projects and users
    await taskViewModel.loadProjects();
    await taskViewModel.loadUsers();

    setState(() {
      _task = task;
      _projects = taskViewModel.projects;
      _users = taskViewModel.users;
      
      // Pre-fill form with task data
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _selectedProjectId = task.projectId;
      _selectedAssigneeId = task.assigneeId;
      _selectedStatus = task.status;
      _selectedPriority = task.priority;
      _selectedDueDate = task.dueDate;
      _selectedStartDate = task.startDate;
      _selectedTags = List.from(task.tags);
      
      _isLoading = false;
    });
  }

  Future<void> _updateTask() async {
    if (!_formKey.currentState!.validate()) return;

    final taskViewModel = context.read<TaskViewModel>();

    final success = await taskViewModel.updateTask(
      widget.taskId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      projectId: _selectedProjectId!,
      assigneeId: _selectedAssigneeId,
      status: _selectedStatus,
      priority: _selectedPriority,
      dueDate: _selectedDueDate,
      startDate: _selectedStartDate,
      tags: _selectedTags,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              taskViewModel.errorMessage ?? 'Failed to update task',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteTask() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text(
          'Are you sure you want to delete this task? This action cannot be undone.',
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
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final taskViewModel = context.read<TaskViewModel>();
    final success = await taskViewModel.deleteTask(widget.taskId);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task deleted successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              taskViewModel.errorMessage ?? 'Failed to delete task',
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
      appBar: CustomAppBar(
        title: 'Edit Task',
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: _deleteTask,
            tooltip: 'Delete Task',
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Loading task...')
          : Consumer<TaskViewModel>(
              builder: (context, taskVM, child) {
                return Column(
                  children: [
                    Expanded(
                      child: TaskFormWidget(
                        task: _task,
                        formKey: _formKey,
                        projects: _projects,
                        users: _users,
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
                            onPressed: taskVM.isCreating ? null : _updateTask,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: taskVM.isCreating
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Update Task',
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