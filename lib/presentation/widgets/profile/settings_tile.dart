// lib/presentation/widgets/profile/settings_tile.dart

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

enum SettingsTileType {
  navigation,
  switchToggle,
  selection,
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final SettingsTileType type;
  final VoidCallback? onTap;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final Widget? trailing;
  final Color? iconColor;

  const SettingsTile({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.type = SettingsTileType.navigation,
    this.onTap,
    this.switchValue,
    this.onSwitchChanged,
    this.trailing,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primaryBlue).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.primaryBlue,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing: _buildTrailing(),
      onTap: type == SettingsTileType.switchToggle ? null : onTap,
    );
  }

  Widget _buildTrailing() {
    switch (type) {
      case SettingsTileType.navigation:
        return trailing ??
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            );
      case SettingsTileType.switchToggle:
        return Switch(
          value: switchValue ?? false,
          onChanged: onSwitchChanged,
          activeColor: AppColors.primaryBlue,
        );
      case SettingsTileType.selection:
        return trailing ??
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            );
    }
  }
}