// lib/presentation/widgets/profile/avatar_picker.dart

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AvatarPicker extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final VoidCallback onTap;
  final double size;
  final bool showEditIcon;

  const AvatarPicker({
    Key? key,
    this.imageUrl,
    required this.initials,
    required this.onTap,
    this.size = 100,
    this.showEditIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryBlue.withOpacity(0.1),
              border: Border.all(
                color: AppColors.primaryBlue,
                width: 3,
              ),
            ),
            child: imageUrl != null
                ? ClipOval(
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildInitialsAvatar(),
                    ),
                  )
                : _buildInitialsAvatar(),
          ),
          if (showEditIcon)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInitialsAvatar() {
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }
}