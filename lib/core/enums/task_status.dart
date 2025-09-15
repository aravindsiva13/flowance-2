// lib/core/enums/task_status.dart

enum TaskStatus {
  toDo,
  inProgress,
  inReview,
  completed,
  cancelled,
  done, // For backward compatibility
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
      case TaskStatus.completed:
      case TaskStatus.done:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get name {
    switch (this) {
      case TaskStatus.toDo:
        return 'toDo';
      case TaskStatus.inProgress:
        return 'inProgress';
      case TaskStatus.inReview:
        return 'inReview';
      case TaskStatus.completed:
        return 'completed';
      case TaskStatus.cancelled:
        return 'cancelled';
      case TaskStatus.done:
        return 'done';
    }
  }
}