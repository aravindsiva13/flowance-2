
// // lib/presentation/views/projects/create_project_screen.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../viewmodels/project_viewmodel.dart';
// import '../../widgets/common/custom_button.dart';
// import '../../widgets/common/custom_text_field.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/enums/project_status.dart';
// import '../../../core/utils/validation_utils.dart';
// import '../../../core/utils/app_utils.dart';

// class CreateProjectScreen extends StatefulWidget {
//   const CreateProjectScreen({Key? key}) : super(key: key);

//   @override
//   State<CreateProjectScreen> createState() => _CreateProjectScreenState();
// }

// class _CreateProjectScreenState extends State<CreateProjectScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _dueDateController = TextEditingController();
  
//   ProjectStatus _selectedStatus = ProjectStatus.planning;
//   DateTime? _selectedDueDate;
//   List<String> _selectedMemberIds = [];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ProjectViewModel>().loadUsers();
//     });
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descriptionController.dispose();
//     _dueDateController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectDueDate() async {
//     final selectedDate = await showDatePicker(
//       context: context,
//       initialDate: _selectedDueDate ?? DateTime.now().add(const Duration(days: 30)),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );

//     if (selectedDate != null) {
//       setState(() {
//         _selectedDueDate = selectedDate;
//         _dueDateController.text = selectedDate.toString().substring(0, 10);
//       });
//     }
//   }

//   Future<void> _createProject() async {
//     if (!_formKey.currentState!.validate()) return;

//     final projectViewModel = context.read<ProjectViewModel>();
//     final success = await projectViewModel.createProject(
//       name: _nameController.text.trim(),
//       description: _descriptionController.text.trim(),
//       status: _selectedStatus,
//       memberIds: _selectedMemberIds,
//       dueDate: _selectedDueDate,
//     );

//     if (success && mounted) {
//       Navigator.pop(context);
//       AppUtils.showSuccessSnackBar(context, 'Project created successfully!');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Project'),
//       ),
//       body: Consumer<ProjectViewModel>(
//         builder: (context, projectViewModel, child) {
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Project Name
//                   CustomTextField(
//                     label: 'Project Name',
//                     controller: _nameController,
//                     validator: ValidationUtils.validateProjectName,
//                     prefixIcon: Icons.work_rounded,
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Description
//                   CustomTextField(
//                     label: 'Description',
//                     hint: 'Describe your project...',
//                     controller: _descriptionController,
//                     validator: (value) => ValidationUtils.validateDescription(value, required: true),
//                     prefixIcon: Icons.description_rounded,
//                     maxLines: 3,
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Status Dropdown
//                   const Text(
//                     'Status',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   DropdownButtonFormField<ProjectStatus>(
//                     value: _selectedStatus,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       prefixIcon: const Icon(Icons.flag_rounded),
//                     ),
//                     items: ProjectStatus.values.map((status) {
//                       return DropdownMenuItem(
//                         value: status,
//                         child: Text(status.displayName),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         setState(() {
//                           _selectedStatus = value;
//                         });
//                       }
//                     },
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Due Date
//                   CustomTextField(
//                     label: 'Due Date (Optional)',
//                     controller: _dueDateController,
//                     prefixIcon: Icons.calendar_today_rounded,
//                     readOnly: true,
//                     onTap: _selectDueDate,
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Team Members
//                   const Text(
//                     'Team Members',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
                  
//                   Container(
//                     height: 200,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: AppColors.borderLight),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: projectViewModel.users.isEmpty
//                         ? const Center(child: CircularProgressIndicator())
//                         : ListView.builder(
//                             itemCount: projectViewModel.users.length,
//                             itemBuilder: (context, index) {
//                               final user = projectViewModel.users[index];
//                               final isSelected = _selectedMemberIds.contains(user.id);
                              
//                               return CheckboxListTile(
//                                 value: isSelected,
//                                 onChanged: (selected) {
//                                   setState(() {
//                                     if (selected == true) {
//                                       _selectedMemberIds.add(user.id);
//                                     } else {
//                                       _selectedMemberIds.remove(user.id);
//                                     }
//                                   });
//                                 },
//                                 title: Text(user.name),
//                                 subtitle: Text(user.email),
//                                 secondary: CircleAvatar(
//                                   backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
//                                   child: Text(
//                                     user.name.substring(0, 1).toUpperCase(),
//                                     style: const TextStyle(
//                                       color: AppColors.primaryBlue,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                   ),
                  
//                   const SizedBox(height: 24),
                  
//                   // Error Message
//                   if (projectViewModel.errorMessage != null)
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       margin: const EdgeInsets.only(bottom: 16),
//                       decoration: BoxDecoration(
//                         color: AppColors.error.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: AppColors.error.withOpacity(0.3),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.error, color: AppColors.error),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               projectViewModel.errorMessage!,
//                               style: const TextStyle(color: AppColors.error),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
                  
//                   // Create Button
//                   CustomButton(
//                     text: 'Create Project',
//                     onPressed: _createProject,
//                     isLoading: projectViewModel.isCreating,
//                     icon: Icons.create_rounded,
//                     width: double.infinity,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


//2

// lib/presentation/views/projects/create_project_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/project_viewmodel.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/enums/project_status.dart';
import '../../../core/utils/date_utils.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({Key? key}) : super(key: key);

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  DateTime? _selectedDueDate;
  ProjectStatus _selectedStatus = ProjectStatus.planning;
  List<String> _selectedMembers = [];

  @override
  void initState() {
    super.initState();
    _selectedStartDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectViewModel>().loadUsers();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Project'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ProjectViewModel>(
        builder: (context, projectViewModel, child) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicInfoSection(),
                  const SizedBox(height: 24),
                  _buildDateSection(),
                  const SizedBox(height: 24),
                  _buildStatusSection(),
                  const SizedBox(height: 24),
                  _buildTeamSection(projectViewModel),
                  const SizedBox(height: 32),
                  _buildActionButtons(projectViewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _nameController,
              label: 'Project Name',
              hint: 'Enter project name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a project name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Enter project description',
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a project description';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Project Timeline',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    'Start Date',
                    _selectedStartDate,
                    (date) => setState(() => _selectedStartDate = date),
                    isRequired: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateField(
                    'End Date',
                    _selectedEndDate,
                    (date) => setState(() => _selectedEndDate = date),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDateField(
              'Due Date',
              _selectedDueDate,
              (date) => setState(() => _selectedDueDate = date),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(
    String label,
    DateTime? selectedDate,
    Function(DateTime?) onDateSelected, {
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (isRequired ? ' *' : ''),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context, selectedDate, onDateSelected),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  selectedDate != null
                      ? AppDateUtils.formatDate(selectedDate)
                      : 'Select date',
                  style: TextStyle(
                    fontSize: 14,
                    color: selectedDate != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Project Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ProjectStatus>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: ProjectStatus.values.map((status) {
                return DropdownMenuItem<ProjectStatus>(
                  value: status,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.getProjectStatusColor(status.name),
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
                if (value != null) {
                  setState(() => _selectedStatus = value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection(ProjectViewModel projectViewModel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Team Members',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (projectViewModel.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (projectViewModel.users.isEmpty)
              const Text('No users available')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: projectViewModel.users.length,
                itemBuilder: (context, index) {
                  final user = projectViewModel.users[index];
                  final isSelected = _selectedMembers.contains(user.id);
                  
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedMembers.add(user.id);
                        } else {
                          _selectedMembers.remove(user.id);
                        }
                      });
                    },
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    secondary: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text(
                        user.name.split(' ').map((n) => n[0]).take(2).join(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ProjectViewModel projectViewModel) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomButton(
            text: 'Create Project',
            onPressed: projectViewModel.isCreating ? null : _createProject,
            isLoading: projectViewModel.isCreating,
            backgroundColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime? currentDate,
    Function(DateTime?) onDateSelected,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      onDateSelected(date);
    }
  }

  Future<void> _createProject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedStartDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a start date')),
      );
      return;
    }

    final projectViewModel = context.read<ProjectViewModel>();

    try {
      await projectViewModel.createProject(
        name: _nameController.text,
        description: _descriptionController.text,
        startDate: _selectedStartDate!,
        endDate: _selectedEndDate,
        dueDate: _selectedDueDate,
        memberIds: _selectedMembers,
        status: _selectedStatus,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project created successfully!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create project: $e')),
        );
      }
    }
  }
}
