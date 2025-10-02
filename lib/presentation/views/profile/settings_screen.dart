// lib/presentation/views/profile/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/profile/settings_tile.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../../routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _taskReminders = true;
  bool _projectUpdates = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: ListView(
        children: [
          // Account Section
          _buildSectionHeader('Account'),
          SettingsTile(
            icon: Icons.person_outline_rounded,
            title: 'Edit Profile',
            subtitle: 'Update your personal information',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.editProfile);
            },
          ),
          SettingsTile(
            icon: Icons.lock_outline_rounded,
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.changePassword);
            },
          ),
          const Divider(height: 32),

          // Notifications Section
          _buildSectionHeader('Notifications'),
          SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: _notificationsEnabled ? 'Enabled' : 'Disabled',
            type: SettingsTileType.switchToggle,
            switchValue: _notificationsEnabled,
            onSwitchChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SettingsTile(
            icon: Icons.email_outlined,
            title: 'Email Notifications',
            subtitle: _emailNotifications ? 'Enabled' : 'Disabled',
            type: SettingsTileType.switchToggle,
            switchValue: _emailNotifications,
            onSwitchChanged: (value) {
              setState(() {
                _emailNotifications = value;
              });
            },
          ),
          SettingsTile(
            icon: Icons.alarm_rounded,
            title: 'Task Reminders',
            subtitle: _taskReminders ? 'Enabled' : 'Disabled',
            type: SettingsTileType.switchToggle,
            switchValue: _taskReminders,
            onSwitchChanged: (value) {
              setState(() {
                _taskReminders = value;
              });
            },
          ),
          SettingsTile(
            icon: Icons.update_rounded,
            title: 'Project Updates',
            subtitle: _projectUpdates ? 'Enabled' : 'Disabled',
            type: SettingsTileType.switchToggle,
            switchValue: _projectUpdates,
            onSwitchChanged: (value) {
              setState(() {
                _projectUpdates = value;
              });
            },
          ),
          const Divider(height: 32),

          // Appearance Section
          _buildSectionHeader('Appearance'),
          SettingsTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Switch to dark theme',
            type: SettingsTileType.switchToggle,
            switchValue: _darkMode,
            onSwitchChanged: (value) {
              setState(() {
                _darkMode = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dark mode will be available in next update'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          SettingsTile(
            icon: Icons.language_rounded,
            title: 'Language',
            subtitle: 'English',
            onTap: () {
              _showLanguageDialog();
            },
          ),
          const Divider(height: 32),

          // Privacy Section
          _buildSectionHeader('Privacy & Security'),
          SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening Privacy Policy...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          SettingsTile(
            icon: Icons.shield_outlined,
            title: 'Terms of Service',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening Terms of Service...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(height: 32),

          // About Section
          _buildSectionHeader('About'),
          SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'App Version',
            subtitle: '1.0.0',
            trailing: const SizedBox.shrink(),
            onTap: null,
          ),
          SettingsTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.help);
            },
          ),
          SettingsTile(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.feedback);
            },
          ),
          const Divider(height: 32),

          // Logout Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<AuthViewModel>(
              builder: (context, authVM, child) {
                return ElevatedButton(
                  onPressed: () => _handleLogout(authVM),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('English'),
              value: 'en',
              groupValue: 'en',
              onChanged: (value) {
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Spanish'),
              value: 'es',
              groupValue: 'en',
              onChanged: (value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Language support coming soon'),
                  ),
                );
              },
            ),
            RadioListTile(
              title: const Text('French'),
              value: 'fr',
              groupValue: 'en',
              onChanged: (value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Language support coming soon'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout(AuthViewModel authVM) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await authVM.logout();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}