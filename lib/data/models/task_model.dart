// // lib/data/models/task_model.dart - Updated with time estimates

// import '../../core/enums/task_status.dart';
// import '../../core/enums/task_priority.dart';

// class TaskModel {
//   final String id;
//   final String title;
//   final String description;
//   final TaskStatus status;
//   final TaskPriority priority;
//   final String projectId;
//   final String? assigneeId;
//   final String creatorId;
//   final DateTime? dueDate;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final List<String> tags;
//   final double progress;
  
//   // Time tracking fields
//   final int? estimatedHours; // Estimated time in hours
//   final int? estimatedMinutes; // Additional minutes for estimates
//   final bool isTimeTrackingEnabled; // Whether time tracking is enabled for this task

//   TaskModel({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.status,
//     required this.priority,
//     required this.projectId,
//     this.assigneeId,
//     required this.creatorId,
//     this.dueDate,
//     required this.createdAt,
//     required this.updatedAt,
//     this.tags = const [],
//     this.progress = 0.0,
//     this.estimatedHours,
//     this.estimatedMinutes,
//     this.isTimeTrackingEnabled = true,
//   });

//   // Get total estimated time in seconds
//   int? get totalEstimatedSeconds {
//     if (estimatedHours == null && estimatedMinutes == null) return null;
//     final hours = estimatedHours ?? 0;
//     final minutes = estimatedMinutes ?? 0;
//     return (hours * 3600) + (minutes * 60);
//   }

//   // Get formatted estimated time
//   String get formattedEstimatedTime {
//     if (totalEstimatedSeconds == null) return 'No estimate';
//     final duration = Duration(seconds: totalEstimatedSeconds!);
//     final hours = duration.inHours;
//     final minutes = duration.inMinutes % 60;
    
//     if (hours > 0) {
//       return '${hours}h ${minutes}m';
//     } else {
//       return '${minutes}m';
//     }
//   }

//   // Get estimated time in decimal hours
//   double? get estimatedTimeHours {
//     if (totalEstimatedSeconds == null) return null;
//     return totalEstimatedSeconds! / 3600.0;
//   }

//   factory TaskModel.fromJson(Map<String, dynamic> json) {
//     return TaskModel(
//       id: json['id'],
//       title: json['title'],
//       description: json['description'],
//       status: TaskStatus.values.firstWhere(
//         (e) => e.name == json['status'],
//         orElse: () => TaskStatus.toDo,
//       ),
//       priority: TaskPriority.values.firstWhere(
//         (e) => e.name == json['priority'],
//         orElse: () => TaskPriority.medium,
//       ),
//       projectId: json['projectId'],
//       assigneeId: json['assigneeId'],
//       creatorId: json['creatorId'],
//       dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       tags: List<String>.from(json['tags'] ?? []),
//       progress: (json['progress'] ?? 0.0).toDouble(),
//       estimatedHours: json['estimatedHours'] as int?,
//       estimatedMinutes: json['estimatedMinutes'] as int?,
//       isTimeTrackingEnabled: json['isTimeTrackingEnabled'] as bool? ?? true,
//     );
//   }

//   get startDate => null;

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'description': description,
//       'status': status.name,
//       'priority': priority.name,
//       'projectId': projectId,
//       'assigneeId': assigneeId,
//       'creatorId': creatorId,
//       'dueDate': dueDate?.toIso8601String(),
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       'tags': tags,
//       'progress': progress,
//       'estimatedHours': estimatedHours,
//       'estimatedMinutes': estimatedMinutes,
//       'isTimeTrackingEnabled': isTimeTrackingEnabled,
//     };
//   }

// TaskModel copyWith({
//   String? id,
//   String? title,
//   String? description,
//   TaskStatus? status,
//   TaskPriority? priority,
//   String? projectId,
//   String? creatorId,
//   String? assigneeId,
//   DateTime? dueDate,
//   DateTime? createdAt,
//   DateTime? updatedAt,
//   List<String>? tags,
//   double? progress,
// }) {
//   return TaskModel(
//     id: id ?? this.id,
//     title: title ?? this.title,
//     description: description ?? this.description,
//     status: status ?? this.status,
//     priority: priority ?? this.priority,
//     projectId: projectId ?? this.projectId,
//     creatorId: creatorId ?? this.creatorId,
//     assigneeId: assigneeId ?? this.assigneeId,
//     dueDate: dueDate ?? this.dueDate,
//     createdAt: createdAt ?? this.createdAt,
//     updatedAt: updatedAt ?? DateTime.now(),
//     tags: tags ?? this.tags,
//     progress: progress ?? this.progress,
//   );
// }
// }


//2
// lib/data/models/task_model.dart
import 'package:flutter/material.dart';
import '../../core/enums/task_status.dart';
import '../../core/enums/task_priority.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final String projectId;
  final String? assigneeId;
  final String creatorId;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double progress;
  final List<String> tags; // FIXED: Added missing tags
  final double? estimatedTimeHours; // FIXED: Added missing estimatedTimeHours

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.projectId,
    this.assigneeId,
    required this.creatorId,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    this.progress = 0.0,
    this.tags = const [], // FIXED: Added to constructor
    this.estimatedTimeHours, // FIXED: Added to constructor
  });

  // FIXED: Added missing formattedEstimatedTime getter
  String get formattedEstimatedTime {
    if (estimatedTimeHours == null) return 'No estimate';
    
    final hours = estimatedTimeHours!;
    if (hours < 1) {
      final minutes = (hours * 60).round();
      return '${minutes}m';
    } else if (hours == hours.round()) {
      return '${hours.round()}h';
    } else {
      final wholeHours = hours.floor();
      final minutes = ((hours - wholeHours) * 60).round();
      return '${wholeHours}h ${minutes}m';
    }
  }

  // NEW: Simple urgency calculation
  double get urgencyScore {
    double score = 0.0;
    
    // Due date factor (40% weight)
    if (dueDate != null) {
      final daysUntilDue = dueDate!.difference(DateTime.now()).inDays;
      if (daysUntilDue < 0) score += 0.4; // Overdue
      else if (daysUntilDue <= 1) score += 0.35; // Due today/tomorrow
      else if (daysUntilDue <= 3) score += 0.25; // Due this week
      else if (daysUntilDue <= 7) score += 0.15; // Due this week
    }
    
    // Priority factor (40% weight)
    switch (priority) {
      case TaskPriority.urgent:
        score += 0.4;
        break;
      case TaskPriority.high:
        score += 0.3;
        break;
      case TaskPriority.medium:
        score += 0.2;
        break;
      case TaskPriority.low:
        score += 0.1;
        break;
    }
    
    // Status factor (20% weight)
    if (status == TaskStatus.toDo && progress == 0.0) {
      score += 0.2; // Not started tasks get higher urgency
    }
    
    return score.clamp(0.0, 1.0);
  }

  // NEW: Simple urgency level
  String get urgencyLevel {
    final score = urgencyScore;
    if (score >= 0.7) return 'URGENT';
    if (score >= 0.5) return 'HIGH';
    if (score >= 0.3) return 'MEDIUM';
    return 'LOW';
  }

  // NEW: Simple urgency color
  Color get urgencyColor {
    final score = urgencyScore;
    if (score >= 0.7) return Colors.red;
    if (score >= 0.5) return Colors.orange;
    if (score >= 0.3) return Colors.blue;
    return Colors.green;
  }

  // NEW: Is task overdue
  bool get isOverdue {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!) && status != TaskStatus.done;
  }

  // NEW: Days until due (for display)
  String get dueDateDisplay {
    if (dueDate == null) return 'No due date';
    
    final now = DateTime.now();
    final difference = dueDate!.difference(now);
    
    if (isOverdue) {
      final days = difference.inDays.abs();
      return days == 0 ? 'Overdue today' : 'Overdue by $days day${days > 1 ? 's' : ''}';
    }
    
    final days = difference.inDays;
    if (days == 0) return 'Due today';
    if (days == 1) return 'Due tomorrow';
    if (days <= 7) return 'Due in $days days';
    
    return 'Due ${dueDate!.day}/${dueDate!.month}/${dueDate!.year}';
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: TaskStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TaskStatus.toDo,
      ),
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => TaskPriority.medium,
      ),
      projectId: json['projectId'],
      assigneeId: json['assigneeId'],
      creatorId: json['creatorId'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      tags: List<String>.from(json['tags'] ?? []), // FIXED: Added
      estimatedTimeHours: (json['estimatedTimeHours'] as num?)?.toDouble(), // FIXED: Added
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'priority': priority.name,
      'projectId': projectId,
      'assigneeId': assigneeId,
      'creatorId': creatorId,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'progress': progress,
      'tags': tags, // FIXED: Added
      'estimatedTimeHours': estimatedTimeHours, // FIXED: Added
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    String? projectId,
    String? assigneeId,
    String? creatorId,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? progress,
    List<String>? tags, // FIXED: Added
    double? estimatedTimeHours, // FIXED: Added
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      projectId: projectId ?? this.projectId,
      assigneeId: assigneeId ?? this.assigneeId,
      creatorId: creatorId ?? this.creatorId,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      progress: progress ?? this.progress,
      tags: tags ?? this.tags, // FIXED: Added
      estimatedTimeHours: estimatedTimeHours ?? this.estimatedTimeHours, // FIXED: Added
    );
  }
}