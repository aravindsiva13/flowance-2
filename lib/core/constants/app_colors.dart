

// lib/core/constants/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryBlue = Color(0xFF2196F3); // Added for backward compatibility
  
  // Secondary colors
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryLight = Color(0xFF66FFF9);
  static const Color secondaryDark = Color(0xFF00A896);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);
  
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);
  
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorDark = Color(0xFFD32F2F);
  
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);
  
  // Neutral colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  // Border colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFEEEEEE);
  static const Color borderDark = Color(0xFFBDBDBD);
  
  // Shadow colors
  static const Color shadow = Color(0x1F000000);
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowDark = Color(0x3D000000);
  
  // Priority colors for tasks
  static const Color priorityLow = Color(0xFF4CAF50);
  static const Color priorityMedium = Color(0xFFFF9800);
  static const Color priorityHigh = Color(0xFFF44336);
  static const Color priorityUrgent = Color(0xFF9C27B0);
  
  // Project status colors
  static const Color statusPlanning = Color(0xFF2196F3);
  static const Color statusActive = Color(0xFF4CAF50);
  static const Color statusOnHold = Color(0xFFFF9800);
  static const Color statusCompleted = Color(0xFF9C27B0);
  static const Color statusCancelled = Color(0xFF757575);
  
  // Task status colors (for backward compatibility)
  static const Color statusToDo = Color(0xFF757575);
  static const Color statusInProgress = Color(0xFF2196F3);
  static const Color statusInReview = Color(0xFFFF9800);
  static const Color statusDone = Color(0xFF4CAF50);
  
  // Chart colors
  static const List<Color> chartColors = [
    Color(0xFF2196F3), // Blue
    Color(0xFF4CAF50), // Green
    Color(0xFFFF9800), // Orange
    Color(0xFFF44336), // Red
    Color(0xFF9C27B0), // Purple
    Color(0xFF00BCD4), // Cyan
    Color(0xFFFFEB3B), // Yellow
    Color(0xFF795548), // Brown
    Color(0xFF607D8B), // Blue Grey
    Color(0xFFE91E63), // Pink
  ];
  
  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );
  
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [successLight, success],
  );
  
  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warningLight, warning],
  );
  
  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [errorLight, error],
  );
  
  // Dark theme colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2D2D2D);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFBDBDBD);
  static const Color darkBorder = Color(0xFF424242);
  
  // Time tracking colors
  static const Color timeActive = Color(0xFF4CAF50);
  static const Color timePaused = Color(0xFFFF9800);
  static const Color timeStopped = Color(0xFF757575);
  static const Color timeOvertime = Color(0xFFF44336);
  
  // Health score colors
  static Color getHealthScoreColor(double score) {
    if (score >= 80) return success;
    if (score >= 60) return warning;
    if (score >= 40) return const Color(0xFFFF5722); // Deep orange
    return error;
  }
  
  // Risk level colors
  static Color getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return success;
      case 'medium':
        return warning;
      case 'high':
        return error;
      case 'critical':
        return const Color(0xFF880E4F); // Dark red
      default:
        return textSecondary;
    }
  }
  
  // Task status colors
  static Color getTaskStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'todo':
      case 'toDo':
        return statusToDo;
      case 'inprogress':
      case 'in_progress':
        return statusInProgress;
      case 'inreview':
      case 'in_review':
        return statusInReview;
      case 'completed':
        return statusDone;
      case 'cancelled':
        return error;
      default:
        return textSecondary;
    }
  }
  
  // Project status colors
  static Color getProjectStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'planning':
        return statusPlanning;
      case 'active':
        return statusActive;
      case 'onhold':
      case 'on_hold':
        return statusOnHold;
      case 'completed':
        return statusCompleted;
      case 'cancelled':
        return statusCancelled;
      default:
        return textSecondary;
    }
  }
  
  // Priority colors
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return priorityLow;
      case 'medium':
        return priorityMedium;
      case 'high':
        return priorityHigh;
      case 'urgent':
        return priorityUrgent;
      default:
        return textSecondary;
    }
  }
  
  // Budget usage colors
  static Color getBudgetUsageColor(double usage) {
    if (usage <= 0.7) return success;
    if (usage <= 0.9) return warning;
    return error;
  }
  
  // Progress colors
  static Color getProgressColor(double progress) {
    if (progress >= 0.8) return success;
    if (progress >= 0.5) return warning;
    if (progress >= 0.2) return info;
    return textSecondary;
  }
  
  // Velocity colors
  static Color getVelocityColor(double velocity, double target) {
    if (velocity >= target) return success;
    if (velocity >= target * 0.8) return warning;
    return error;
  }
  
  // Accessibility helpers
  static Color getContrastColor(Color backgroundColor) {
    // Calculate luminance and return appropriate contrast color
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? textPrimary : textOnPrimary;
  }
  
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity.clamp(0.0, 1.0));
  }
  
  // Material 3 color scheme helper
  static ColorScheme get lightColorScheme => ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
  );
  
  static ColorScheme get darkColorScheme => ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.dark,
  );
}