

// lib/data/models/task_model.dart - FIXED VERSION
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
  final DateTime? startDate; // FIXED: Added missing startDate property
  final DateTime createdAt;
  final DateTime updatedAt;
  final double progress;
  final List<String> tags;
  final double? estimatedTimeHours;
  final int? estimatedHours;
  final int? estimatedMinutes;
  final bool isTimeTrackingEnabled;
  
  // ADDED: Missing urgency properties
  final double urgencyScore;
  final Color? urgencyColor;
  final String urgencyLevel;

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
    this.startDate, // FIXED: Added startDate parameter
    required this.createdAt,
    required this.updatedAt,
    this.progress = 0.0,
    this.tags = const [],
    this.estimatedTimeHours,
    this.estimatedHours,
    this.estimatedMinutes,
    this.isTimeTrackingEnabled = true,
    this.urgencyScore = 0.0, // ADDED: Default urgency score
    this.urgencyColor, // ADDED: Urgency color
    this.urgencyLevel = 'normal', // ADDED: Default urgency level
  });

  // Computed properties
  bool get isOverdue => dueDate != null && 
      DateTime.now().isAfter(dueDate!) && 
      status != TaskStatus.done;

  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDueDate = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return today.isAtSameMomentAs(taskDueDate);
  }

  bool get isDueTomorrow {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final taskDueDate = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return tomorrow.isAtSameMomentAs(taskDueDate);
  }

  String get dueDateDisplay {
    if (dueDate == null) return 'No due date';
    
    if (isOverdue) {
      final days = DateTime.now().difference(dueDate!).inDays;
      return 'Overdue by $days day${days > 1 ? 's' : ''}';
    }
    
    if (isDueToday) return 'Due today';
    if (isDueTomorrow) return 'Due tomorrow';
    
    final days = dueDate!.difference(DateTime.now()).inDays;
    if (days <= 7) return 'Due in $days days';
    
    return 'Due ${dueDate!.day}/${dueDate!.month}/${dueDate!.year}';
  }

  String get progressDescription {
    if (status == TaskStatus.done) return 'Completed';
    if (progress >= 0.8) return 'Nearly done';
    if (progress >= 0.5) return 'In progress';
    if (progress >= 0.2) return 'Getting started';
    return 'Not started';
  }

  Duration? get estimatedDuration {
    if (estimatedTimeHours != null) {
      return Duration(hours: estimatedTimeHours!.round());
    }
    if (estimatedHours != null || estimatedMinutes != null) {
      return Duration(
        hours: estimatedHours ?? 0,
        minutes: estimatedMinutes ?? 0,
      );
    }
    return null;
  }

  // ADDED: Formatted estimated time getter
  String get formattedEstimatedTime {
    final duration = estimatedDuration;
    if (duration == null) return 'No estimate';
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else if (minutes > 0) {
      return '${minutes}m';
    }
    return 'No estimate';
  }

  // ADDED: Calculate urgency score based on task properties
  double calculateUrgencyScore() {
    double score = 0.0;
    
    // Priority factor (0-40 points)
    switch (priority) {
      case TaskPriority.urgent:
        score += 40;
        break;
      case TaskPriority.high:
        score += 30;
        break;
      case TaskPriority.medium:
        score += 15;
        break;
      case TaskPriority.low:
        score += 5;
        break;
    }
    
    // Due date factor (0-35 points)
    if (dueDate != null) {
      final daysUntilDue = dueDate!.difference(DateTime.now()).inDays;
      if (daysUntilDue < 0) {
        score += 35; // Overdue
      } else if (daysUntilDue == 0) {
        score += 30; // Due today
      } else if (daysUntilDue == 1) {
        score += 25; // Due tomorrow
      } else if (daysUntilDue <= 3) {
        score += 20; // Due in 2-3 days
      } else if (daysUntilDue <= 7) {
        score += 10; // Due this week
      } else if (daysUntilDue <= 14) {
        score += 5; // Due in 2 weeks
      }
    }
    
    // Progress factor (0-15 points) - less progress = more urgent
    if (progress < 0.1) {
      score += 15; // Not started
    } else if (progress < 0.3) {
      score += 10; // Barely started
    } else if (progress < 0.7) {
      score += 5; // In progress
    }
    
    // Status factor (0-10 points)
    
    
    return score.clamp(0.0, 100.0);
  }

  // ADDED: Get urgency color based on score
  Color getUrgencyColor() {
    final score = urgencyScore > 0 ? urgencyScore : calculateUrgencyScore();
    
    if (score >= 80) {
      return Colors.red; // Critical
    } else if (score >= 60) {
      return Colors.orange; // High
    } else if (score >= 40) {
      return Colors.yellow; // Medium
    } else if (score >= 20) {
      return Colors.blue; // Low
    } else {
      return Colors.grey; // Minimal
    }
  }

  // ADDED: Get urgency level string
  String getUrgencyLevel() {
    final score = urgencyScore > 0 ? urgencyScore : calculateUrgencyScore();
    
    if (score >= 80) {
      return 'critical';
    } else if (score >= 60) {
      return 'high';
    } else if (score >= 40) {
      return 'medium';
    } else if (score >= 20) {
      return 'low';
    } else {
      return 'minimal';
    }
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
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null, // FIXED
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      tags: List<String>.from(json['tags'] ?? []),
      progress: (json['progress'] ?? 0.0).toDouble(),
      estimatedTimeHours: json['estimatedTimeHours']?.toDouble(),
      estimatedHours: json['estimatedHours'] as int?,
      estimatedMinutes: json['estimatedMinutes'] as int?,
      isTimeTrackingEnabled: json['isTimeTrackingEnabled'] as bool? ?? true,
      urgencyScore: (json['urgencyScore'] as num?)?.toDouble() ?? 0.0, // ADDED
      urgencyColor: json['urgencyColor'] != null 
          ? Color(json['urgencyColor'] as int) 
          : null, // ADDED
      urgencyLevel: json['urgencyLevel'] as String? ?? 'normal', // ADDED
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
      'startDate': startDate?.toIso8601String(), // FIXED
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'tags': tags,
      'progress': progress,
      'estimatedTimeHours': estimatedTimeHours,
      'estimatedHours': estimatedHours,
      'estimatedMinutes': estimatedMinutes,
      'isTimeTrackingEnabled': isTimeTrackingEnabled,
      'urgencyScore': urgencyScore, // ADDED
      'urgencyColor': urgencyColor?.value, // ADDED
      'urgencyLevel': urgencyLevel, // ADDED
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
    DateTime? startDate, // FIXED: Added startDate parameter
    DateTime? createdAt,
    DateTime? updatedAt,
    double? progress,
    List<String>? tags,
    double? estimatedTimeHours,
    int? estimatedHours,
    int? estimatedMinutes,
    bool? isTimeTrackingEnabled,
    double? urgencyScore, // ADDED
    Color? urgencyColor, // ADDED
    String? urgencyLevel, // ADDED
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
      startDate: startDate ?? this.startDate, // FIXED
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      progress: progress ?? this.progress,
      tags: tags ?? this.tags,
      estimatedTimeHours: estimatedTimeHours ?? this.estimatedTimeHours,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isTimeTrackingEnabled: isTimeTrackingEnabled ?? this.isTimeTrackingEnabled,
      urgencyScore: urgencyScore ?? this.urgencyScore, // ADDED
      urgencyColor: urgencyColor ?? this.urgencyColor, // ADDED
      urgencyLevel: urgencyLevel ?? this.urgencyLevel, // ADDED
    );
  }
}