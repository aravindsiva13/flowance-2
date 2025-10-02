
// // =================================================================

// // lib/core/enums/task_priority.dart
// enum TaskPriority {
//   low,
//   medium,
//   high,
//   urgent;

//   String get displayName {
//     switch (this) {
//       case TaskPriority.low:
//         return 'Low';
//       case TaskPriority.medium:
//         return 'Medium';
//       case TaskPriority.high:
//         return 'High';
//       case TaskPriority.urgent:
//         return 'Urgent';
//     }
//   }

//   int get value {
//     switch (this) {
//       case TaskPriority.low:
//         return 1;
//       case TaskPriority.medium:
//         return 2;
//       case TaskPriority.high:
//         return 3;
//       case TaskPriority.urgent:
//         return 4;
//     }
//   }

//   String get shortName {
//     switch (this) {
//       case TaskPriority.low:
//         return 'LOW';
//       case TaskPriority.medium:
//         return 'MED';
//       case TaskPriority.high:
//         return 'HIGH';
//       case TaskPriority.urgent:
//         return 'URG';
//     }
//   }
// }

//2

// lib/core/enums/task_priority.dart
// COPY THIS ENTIRE FILE - DELETE OLD CONTENT AND PASTE THIS

import 'package:flutter/material.dart';

enum TaskPriority {
  low,
  medium,
  high,
  urgent,
}

extension TaskPriorityExtension on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }

  // THIS IS THE MISSING METHOD - IT MUST BE HERE
  Color get color {
    switch (this) {
      case TaskPriority.low:
        return Colors.grey;
      case TaskPriority.medium:
        return Colors.blue;
      case TaskPriority.high:
        return Colors.orange;
      case TaskPriority.urgent:
        return Colors.red;
    }
  }

  // Optional: Priority value for sorting
  int get value {
    switch (this) {
      case TaskPriority.low:
        return 1;
      case TaskPriority.medium:
        return 2;
      case TaskPriority.high:
        return 3;
      case TaskPriority.urgent:
        return 4;
    }
  }

  // Optional: Add icon support
  IconData get icon {
    switch (this) {
      case TaskPriority.low:
        return Icons.arrow_downward;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.arrow_upward;
      case TaskPriority.urgent:
        return Icons.priority_high;
    }
  }
}