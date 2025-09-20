
// // lib/data/models/project_model.dart

// import 'package:flowence/core/enums/task_status.dart';

// import '../../core/enums/project_status.dart';

// class ProjectModel {
//   final String id;
//   final String name;
//   final String description;
//   final ProjectStatus status;
//   final String ownerId;
//   final List<String> memberIds;
//   final DateTime startDate;
//   final DateTime? endDate;
//   final DateTime? dueDate;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final double progress;

//   ProjectModel({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.status,
//     required this.ownerId,
//     required this.memberIds,
//     required this.startDate,
//     this.endDate,
//     this.dueDate,
//     required this.createdAt,
//     required this.updatedAt,
//     this.progress = 0.0, String? color,
//   });

//   factory ProjectModel.fromJson(Map<String, dynamic> json) {
//     return ProjectModel(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'],
//       status: ProjectStatus.values.firstWhere(
//         (e) => e.name == json['status'],
//         orElse: () => ProjectStatus.planning,
//       ),
//       ownerId: json['ownerId'],
//       memberIds: List<String>.from(json['memberIds']),
//       startDate: DateTime.parse(json['startDate']),
//       endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
//       dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       progress: (json['progress'] ?? 0.0).toDouble(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'description': description,
//       'status': status.name,
//       'ownerId': ownerId,
//       'memberIds': memberIds,
//       'startDate': startDate.toIso8601String(),
//       'endDate': endDate?.toIso8601String(),
//       'dueDate': dueDate?.toIso8601String(),
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       'progress': progress,
//     };
//   }

//   ProjectModel copyWith({
//     String? name,
//     String? description,
//     ProjectStatus? status,
//     List<String>? memberIds,
//     DateTime? endDate,
//     DateTime? dueDate,
//     double? progress, required DateTime updatedAt,
//   }) {
//     return ProjectModel(
//       id: id,
//       name: name ?? this.name,
//       description: description ?? this.description,
//       status: status ?? this.status,
//       ownerId: ownerId,
//       memberIds: memberIds ?? this.memberIds,
//       startDate: startDate,
//       endDate: endDate ?? this.endDate,
//       dueDate: dueDate ?? this.dueDate,
//       createdAt: createdAt,
//       updatedAt: DateTime.now(),
//       progress: progress ?? this.progress,
//     );
//   }
// }



//2


// lib/data/models/project_model.dart - FIXED VERSION
import 'package:flutter/material.dart';
import '../../core/enums/project_status.dart';

class ProjectModel {
  final String id;
  final String name;
  final String description;
  final ProjectStatus status;
  final List<String> memberIds;
  final String creatorId;
  final String ownerId;
  final DateTime? dueDate;
  final DateTime? startDate; // Nullable - this is correct
  final DateTime createdAt;
  final DateTime updatedAt;
  final double progress;

  ProjectModel({
  required this.id,
  required this.name,
  required this.description,
  required this.status,
  required this.memberIds,
  String? creatorId, // CHANGED: Made optional
  required this.ownerId,
  this.dueDate,
  this.startDate,
  required this.createdAt,
  required this.updatedAt,
  this.progress = 0.0,
}) : creatorId = creatorId ?? ownerId; 

  // FIXED: Handle nullable startDate properly
  double calculateHealthScore({
    int totalTasks = 0,
    int completedTasks = 0,
    int overdueTasks = 0,
    double budgetUsed = 0.0,
  }) {
    double healthScore = 1.0;
    
    // Progress vs time factor - FIXED: Check for null startDate
    if (dueDate != null && startDate != null) {
      final totalDuration = dueDate!.difference(startDate!).inDays;
      final elapsedDuration = DateTime.now().difference(startDate!).inDays;
      final timeProgress = totalDuration > 0 ? elapsedDuration / totalDuration : 0.0;
      
      if (timeProgress > progress) {
        healthScore -= (timeProgress - progress) * 0.3;
      }
    }
    
    // Overdue tasks factor
    if (totalTasks > 0) {
      final overdueRatio = overdueTasks / totalTasks;
      healthScore -= overdueRatio * 0.4;
    }
    
    // Budget factor
    if (budgetUsed > 1.0) {
      healthScore -= (budgetUsed - 1.0) * 0.3;
    }
    
    return healthScore.clamp(0.0, 1.0);
  }

  String getHealthStatus({
    int totalTasks = 0,
    int completedTasks = 0,
    int overdueTasks = 0,
    double budgetUsed = 0.0,
  }) {
    final health = calculateHealthScore(
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      overdueTasks: overdueTasks,
      budgetUsed: budgetUsed,
    );
    
    if (health >= 0.8) return 'HEALTHY';
    if (health >= 0.6) return 'GOOD';
    if (health >= 0.4) return 'AT RISK';
    return 'CRITICAL';
  }

  Color getHealthColor({
    int totalTasks = 0,
    int completedTasks = 0,
    int overdueTasks = 0,
    double budgetUsed = 0.0,
  }) {
    final health = calculateHealthScore(
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      overdueTasks: overdueTasks,
      budgetUsed: budgetUsed,
    );
    
    if (health >= 0.8) return Colors.green;
    if (health >= 0.6) return Colors.lightGreen;
    if (health >= 0.4) return Colors.orange;
    return Colors.red;
  }

  bool get isOverdue {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!) && status != ProjectStatus.completed;
  }

  String get dueDateDisplay {
    if (dueDate == null) return 'No due date';
    
    final now = DateTime.now();
    final difference = dueDate!.difference(now);
    
    if (isOverdue) {
      final days = difference.inDays.abs();
      return 'Overdue by $days day${days > 1 ? 's' : ''}';
    }
    
    final days = difference.inDays;
    if (days == 0) return 'Due today';
    if (days == 1) return 'Due tomorrow';
    if (days <= 30) return 'Due in $days days';
    
    return 'Due ${dueDate!.day}/${dueDate!.month}/${dueDate!.year}';
  }

  String get progressDescription {
    if (progress >= 1.0) return 'Complete';
    if (progress >= 0.8) return 'Nearly done';
    if (progress >= 0.5) return 'In progress';
    if (progress >= 0.2) return 'Getting started';
    return 'Not started';
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: ProjectStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProjectStatus.active,
      ),
      memberIds: List<String>.from(json['memberIds'] ?? []),
      creatorId: json['creatorId'],
      ownerId: json['ownerId'] ?? json['creatorId'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status.name,
      'memberIds': memberIds,
      'creatorId': creatorId,
      'ownerId': ownerId,
      'dueDate': dueDate?.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'progress': progress,
    };
  }

  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    ProjectStatus? status,
    List<String>? memberIds,
    String? creatorId,
    String? ownerId,
    DateTime? dueDate,
    DateTime? startDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? progress,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      memberIds: memberIds ?? this.memberIds,
      creatorId: creatorId ?? this.creatorId,
      ownerId: ownerId ?? this.ownerId,
      dueDate: dueDate ?? this.dueDate,
      startDate: startDate ?? this.startDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      progress: progress ?? this.progress,
    );
  }
}