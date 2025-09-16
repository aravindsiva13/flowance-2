// // lib/presentation/widgets/project/project_members_tab.dart

// import 'package:flutter/material.dart';
// import '../../../data/models/project_model.dart';
// import '../../../data/models/user_model.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/enums/user_role.dart';

// class ProjectMembersTab extends StatefulWidget {
//   final ProjectModel project;

//   const ProjectMembersTab({
//     Key? key,
//     required this.project,
//   }) : super(key: key);

//   @override
//   State<ProjectMembersTab> createState() => _ProjectMembersTabState();
// }

// class _ProjectMembersTabState extends State<ProjectMembersTab> {
//   final List<UserModel> _members = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadMembers();
//   }

//   void _loadMembers() async {
//     // Simulate loading members
//     await Future.delayed(const Duration(milliseconds: 500));
    
//     // Mock member data based on project member IDs
//     final mockMembers = widget.project.memberIds.map((id) => UserModel(
//       id: id,
//       name: 'Member $id',
//       email: 'member$id@company.com',
//       role: id == widget.project.ownerId ? UserRole.admin : UserRole.teamMember,
//       createdAt: DateTime.now().subtract(Duration(days: int.parse(id) * 10)),
//       updatedAt: DateTime.now(),
//     )).toList();

//     setState(() {
//       _members.clear();
//       _members.addAll(mockMembers);
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildMembersOverview(),
//           const SizedBox(height: 16),
//           _buildMembersList(),
//           const SizedBox(height: 16),
//           _buildMemberRoles(),
//           const SizedBox(height: 16),
//           _buildMemberActivity(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMembersOverview() {
//     final totalMembers = _members.length;
//     final admins = _members.where((m) => m.role == UserRole.admin).length;
//     final managers = _members.where((m) => m.role == UserRole.manager).length;
//     final teamMembers = _members.where((m) => m.role == UserRole.teamMember).length;

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Team Overview',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildOverviewCard(
//                     'Total Members',
//                     totalMembers.toString(),
//                     Icons.group,
//                     AppColors.primary,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _buildOverviewCard(
//                     'Admins',
//                     admins.toString(),
//                     Icons.admin_panel_settings,
//                     AppColors.error,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _buildOverviewCard(
//                     'Managers',
//                     managers.toString(),
//                     Icons.supervisor_account,
//                     AppColors.warning,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _buildOverviewCard(
//                     'Team Members',
//                     teamMembers.toString(),
//                     Icons.person,
//                     AppColors.success,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 24),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 10,
//               color: AppColors.textSecondary,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMembersList() {
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
//                   'Team Members',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 TextButton.icon(
//                   onPressed: () => _addMember(),
//                   icon: const Icon(Icons.person_add),
//                   label: const Text('Add Member'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             ..._members.map((member) => _buildMemberTile(member)).toList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMemberTile(UserModel member) {
//     final isOwner = member.id == widget.project.ownerId;
    
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 20,
//             backgroundColor: AppColors.primary.withOpacity(0.1),
//             child: Text(
//               member.name.split(' ').map((n) => n[0]).take(2).join(),
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.primary,
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       member.name,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     if (isOwner) ...[
//                       const SizedBox(width: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: AppColors.primary.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Text(
//                           'Owner',
//                           style: TextStyle(
//                             fontSize: 10,
//                             color: AppColors.primary,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   member.email,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: _getRoleColor(member.role).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: _getRoleColor(member.role).withOpacity(0.3),
//                         ),
//                       ),
//                       child: Text(
//                         member.role.displayName,
//                         style: TextStyle(
//                           fontSize: 11,
//                           color: _getRoleColor(member.role),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Joined ${_formatJoinDate(member.createdAt)}',
//                       style: const TextStyle(
//                         fontSize: 11,
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           PopupMenuButton<String>(
//             itemBuilder: (context) => [
//               const PopupMenuItem(
//                 value: 'view',
//                 child: Row(
//                   children: [
//                     Icon(Icons.visibility),
//                     SizedBox(width: 8),
//                     Text('View Profile'),
//                   ],
//                 ),
//               ),
//               const PopupMenuItem(
//                 value: 'tasks',
//                 child: Row(
//                   children: [
//                     Icon(Icons.assignment),
//                     SizedBox(width: 8),
//                     Text('View Tasks'),
//                   ],
//                 ),
//               ),
//               const PopupMenuItem(
//                 value: 'time',
//                 child: Row(
//                   children: [
//                     Icon(Icons.access_time),
//                     SizedBox(width: 8),
//                     Text('Time Logs'),
//                   ],
//                 ),
//               ),
//               if (!isOwner)
//                 const PopupMenuItem(
//                   value: 'remove',
//                   child: Row(
//                     children: [
//                       Icon(Icons.remove_circle, color: AppColors.error),
//                       SizedBox(width: 8),
//                       Text('Remove Member'),
//                     ],
//                   ),
//                 ),
//             ],
//             onSelected: (value) => _handleMemberAction(value, member),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMemberRoles() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Role Distribution',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             ...UserRole.values.map((role) {
//               final count = _members.where((m) => m.role == role).length;
//               final percentage = _members.isNotEmpty ? count / _members.length : 0.0;
              
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 12,
//                       height: 12,
//                       decoration: BoxDecoration(
//                         color: _getRoleColor(role),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         role.displayName,
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     ),
//                     Text(
//                       count.toString(),
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     SizedBox(
//                       width: 60,
//                       child: LinearProgressIndicator(
//                         value: percentage,
//                         backgroundColor: AppColors.surface,
//                         valueColor: AlwaysStoppedAnimation<Color>(_getRoleColor(role)),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMemberActivity() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Recent Activity',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             ..._generateMockActivity().map((activity) => 
//               _buildActivityItem(activity)
//             ).toList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActivityItem(Map<String, dynamic> activity) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 12,
//             backgroundColor: AppColors.primary.withOpacity(0.1),
//             child: Icon(
//               activity['icon'] as IconData,
//               size: 12,
//               color: AppColors.primary,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               activity['description'] as String,
//               style: const TextStyle(fontSize: 13),
//             ),
//           ),
//           Text(
//             activity['time'] as String,
//             style: const TextStyle(
//               fontSize: 11,
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getRoleColor(UserRole role) {
//     switch (role) {
//       case UserRole.admin:
//         return AppColors.error;
//       case UserRole.manager:
//         return AppColors.warning;
//       case UserRole.teamMember:
//         return AppColors.success;
//     }
//   }

//   String _formatJoinDate(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date).inDays;
    
//     if (difference < 1) return 'today';
//     if (difference < 7) return '${difference}d ago';
//     if (difference < 30) return '${(difference / 7).round()}w ago';
//     return '${(difference / 30).round()}m ago';
//   }

//   List<Map<String, dynamic>> _generateMockActivity() {
//     return [
//       {
//         'description': 'Member 1 completed task "Design Homepage"',
//         'time': '2h ago',
//         'icon': Icons.check_circle,
//       },
//       {
//         'description': 'Member 2 added comment to "User Authentication"',
//         'time': '4h ago',
//         'icon': Icons.comment,
//       },
//       {
//         'description': 'Member 3 logged 3 hours of work',
//         'time': '6h ago',
//         'icon': Icons.access_time,
//       },
//       {
//         'description': 'Member 1 was assigned to "Database Migration"',
//         'time': '1d ago',
//         'icon': Icons.assignment,
//       },
//     ];
//   }

//   void _handleMemberAction(String action, UserModel member) {
//     switch (action) {
//       case 'view':
//         Navigator.pushNamed(
//           context,
//           '/user/profile',
//           arguments: member.id,
//         );
//         break;
//       case 'tasks':
//         Navigator.pushNamed(
//           context,
//           '/tasks',
//           arguments: {'assigneeId': member.id, 'projectId': widget.project.id},
//         );
//         break;
//       case 'time':
//         Navigator.pushNamed(
//           context,
//           '/time/user',
//           arguments: {'userId': member.id, 'projectId': widget.project.id},
//         );
//         break;
//       case 'remove':
//         _showRemoveMemberDialog(member);
//         break;
//     }
//   }

//   void _showRemoveMemberDialog(UserModel member) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Remove Team Member'),
//         content: Text('Are you sure you want to remove ${member.name} from this project?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _removeMember(member);
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
//             child: const Text('Remove'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _removeMember(UserModel member) {
//     setState(() {
//       _members.removeWhere((m) => m.id == member.id);
//     });
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('${member.name} removed from project')),
//     );
//   }

//   void _addMember() {
//     Navigator.pushNamed(
//       context,
//       '/project/add-member',
//       arguments: widget.project.id,
//     );
//   }
// }

//2

// lib/presentation/widgets/project/project_members_tab.dart

import 'package:flutter/material.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/user_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/enums/user_role.dart';

class ProjectMembersTab extends StatefulWidget {
  final ProjectModel project;

  const ProjectMembersTab({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  State<ProjectMembersTab> createState() => _ProjectMembersTabState();
}

class _ProjectMembersTabState extends State<ProjectMembersTab> {
  final List<UserModel> _members = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  void _loadMembers() async {
    // Simulate loading members
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock member data based on project member IDs
    final mockMembers = widget.project.memberIds.map((id) => UserModel(
      id: id,
      name: 'Member $id',
      email: 'member$id@company.com',
      role: id == widget.project.ownerId ? UserRole.admin : UserRole.teamMember,
      createdAt: DateTime.now().subtract(Duration(days: int.parse(id) * 10)),
      updatedAt: DateTime.now(),
    )).toList();

    setState(() {
      _members.clear();
      _members.addAll(mockMembers);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMembersOverview(),
          const SizedBox(height: 16),
          _buildMembersList(),
          const SizedBox(height: 16),
          _buildMemberRoles(),
          const SizedBox(height: 16),
          _buildMemberActivity(),
        ],
      ),
    );
  }

  Widget _buildMembersOverview() {
    final totalMembers = _members.length;
    final admins = _members.where((m) => m.role == UserRole.admin).length;
    final managers = _members.where((m) => m.role == UserRole.manager).length;
    final teamMembers = _members.where((m) => m.role == UserRole.teamMember).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Team Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewCard(
                    'Total Members',
                    totalMembers.toString(),
                    Icons.group,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildOverviewCard(
                    'Admins',
                    admins.toString(),
                    Icons.admin_panel_settings,
                    AppColors.error,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildOverviewCard(
                    'Managers',
                    managers.toString(),
                    Icons.supervisor_account,
                    AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildOverviewCard(
                    'Team Members',
                    teamMembers.toString(),
                    Icons.person,
                    AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
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
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMembersList() {
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
                  'Team Members',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => _addMember(),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Member'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._members.map((member) => _buildMemberTile(member)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(UserModel member) {
    final isOwner = member.id == widget.project.ownerId;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              member.name.split(' ').map((n) => n[0]).take(2).join(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isOwner) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Owner',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  member.email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getRoleColor(member.role).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getRoleColor(member.role).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        member.role.displayName,
                        style: TextStyle(
                          fontSize: 11,
                          color: _getRoleColor(member.role),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Joined ${_formatJoinDate(member.createdAt)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(Icons.visibility),
                    SizedBox(width: 8),
                    Text('View Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'tasks',
                child: Row(
                  children: [
                    Icon(Icons.assignment),
                    SizedBox(width: 8),
                    Text('View Tasks'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'time',
                child: Row(
                  children: [
                    Icon(Icons.access_time),
                    SizedBox(width: 8),
                    Text('Time Logs'),
                  ],
                ),
              ),
              if (!isOwner)
                const PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.remove_circle, color: AppColors.error),
                      SizedBox(width: 8),
                      Text('Remove Member'),
                    ],
                  ),
                ),
            ],
            onSelected: (value) => _handleMemberAction(value, member),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberRoles() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Role Distribution',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...UserRole.values.map((role) {
              final count = _members.where((m) => m.role == role).length;
              final percentage = _members.isNotEmpty ? count / _members.length : 0.0;
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getRoleColor(role),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        role.displayName,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Text(
                      count.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 60,
                      child: LinearProgressIndicator(
                        value: percentage,
                        backgroundColor: AppColors.surface,
                        valueColor: AlwaysStoppedAnimation<Color>(_getRoleColor(role)),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberActivity() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._generateMockActivity().map((activity) => 
              _buildActivityItem(activity)
            ).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Icon(
              activity['icon'] as IconData,
              size: 12,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              activity['description'] as String,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Text(
            activity['time'] as String,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AppColors.error;
      case UserRole.manager:
      case UserRole.projectManager:
        return AppColors.warning;
      case UserRole.teamMember:
        return AppColors.success;
    }
  }

  String _formatJoinDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference < 1) return 'today';
    if (difference < 7) return '${difference}d ago';
    if (difference < 30) return '${(difference / 7).round()}w ago';
    return '${(difference / 30).round()}m ago';
  }

  List<Map<String, dynamic>> _generateMockActivity() {
    return [
      {
        'description': 'Member 1 completed task "Design Homepage"',
        'time': '2h ago',
        'icon': Icons.check_circle,
      },
      {
        'description': 'Member 2 added comment to "User Authentication"',
        'time': '4h ago',
        'icon': Icons.comment,
      },
      {
        'description': 'Member 3 logged 3 hours of work',
        'time': '6h ago',
        'icon': Icons.access_time,
      },
      {
        'description': 'Member 1 was assigned to "Database Migration"',
        'time': '1d ago',
        'icon': Icons.assignment,
      },
    ];
  }

  void _handleMemberAction(String action, UserModel member) {
    switch (action) {
      case 'view':
        Navigator.pushNamed(
          context,
          '/user/profile',
          arguments: member.id,
        );
        break;
      case 'tasks':
        Navigator.pushNamed(
          context,
          '/tasks',
          arguments: {'assigneeId': member.id, 'projectId': widget.project.id},
        );
        break;
      case 'time':
        Navigator.pushNamed(
          context,
          '/time/user',
          arguments: {'userId': member.id, 'projectId': widget.project.id},
        );
        break;
      case 'remove':
        _showRemoveMemberDialog(member);
        break;
    }
  }

  void _showRemoveMemberDialog(UserModel member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Team Member'),
        content: Text('Are you sure you want to remove ${member.name} from this project?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _removeMember(member);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _removeMember(UserModel member) {
    setState(() {
      _members.removeWhere((m) => m.id == member.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${member.name} removed from project')),
    );
  }

  void _addMember() {
    Navigator.pushNamed(
      context,
      '/project/add-member',
      arguments: widget.project.id,
    );
  }
}