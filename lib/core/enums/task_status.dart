// // lib/core/enums/task_status.dart

// enum TaskStatus {
//   toDo,
//   inProgress,
//   inReview,
//   completed,
//   cancelled,
//   done, blocked, // For backward compatibility
// }

// extension TaskStatusExtension on TaskStatus {
//   String get displayName {
//     switch (this) {
//       case TaskStatus.toDo:
//         return 'To Do';
//       case TaskStatus.inProgress:
//         return 'In Progress';
//       case TaskStatus.inReview:
//         return 'In Review';
//       case TaskStatus.completed:
//       case TaskStatus.done:
//         return 'Completed';
//       case TaskStatus.cancelled:
//         return 'Cancelled';
//       case TaskStatus.blocked:
//         // TODO: Handle this case.
//         throw UnimplementedError();
//     }
//   }

//   String get name {
//     switch (this) {
//       case TaskStatus.toDo:
//         return 'toDo';
//       case TaskStatus.inProgress:
//         return 'inProgress';
//       case TaskStatus.inReview:
//         return 'inReview';
//       case TaskStatus.completed:
//         return 'completed';
//       case TaskStatus.cancelled:
//         return 'cancelled';
//       case TaskStatus.done:
//         return 'done';
//       case TaskStatus.blocked:
//         // TODO: Handle this case.
//         throw UnimplementedError();
//     }
//   }
// }

//2

// lib/core/enums/task_status.dart
// REPLACE ENTIRE FILE WITH THIS CODE

import 'package:flutter/material.dart';

enum TaskStatus {
  toDo,
  inProgress,
  inReview,
  done,
  completed,
  cancelled,
  blocked,
}

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.toDo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.inReview:
        return 'In Review';
      case TaskStatus.done:
        return 'Done';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
      case TaskStatus.blocked:
        return 'Blocked';
    }
  }

  // THIS IS THE REQUIRED COLOR GETTER
  Color get color {
    switch (this) {
      case TaskStatus.toDo:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.inReview:
        return Colors.orange;
      case TaskStatus.done:
        return Colors.green;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.cancelled:
        return Colors.red;
      case TaskStatus.blocked:
        return Colors.deepOrange;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskStatus.toDo:
        return Icons.radio_button_unchecked;
      case TaskStatus.inProgress:
        return Icons.pending_outlined;
      case TaskStatus.inReview:
        return Icons.rate_review_outlined;
      case TaskStatus.done:
        return Icons.check_circle_outline;
      case TaskStatus.completed:
        return Icons.check_circle;
      case TaskStatus.cancelled:
        return Icons.cancel_outlined;
      case TaskStatus.blocked:
        return Icons.block_outlined;
    }
  }
}