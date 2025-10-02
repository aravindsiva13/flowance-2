
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
  final DateTime? endDate; // FIXED: Added missing endDate getter
  final DateTime? startDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double progress;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.memberIds,
    String? creatorId,
    required this.ownerId,
    this.dueDate,
    this.endDate, // FIXED: Added endDate parameter
    this.startDate,
    required this.createdAt,
    required this.updatedAt,
    this.progress = 0.0,
  }) : creatorId = creatorId ?? ownerId;

  // Computed properties
  bool get isActive => status == ProjectStatus.active;
  bool get isCompleted => status == ProjectStatus.completed;
  bool get isOverdue => dueDate != null && 
      DateTime.now().isAfter(dueDate!) && 
      status != ProjectStatus.completed;

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

  double calculateHealthScore({
    int totalTasks = 0,
    int completedTasks = 0,
    int overdueTasks = 0,
    double budgetUsed = 0.0,
  }) {
    double healthScore = 1.0;
    
    // Progress vs time factor - FIXED: Check for null startDate and dueDate
    if (dueDate != null && startDate != null) {
      final totalDuration = dueDate!.difference(startDate!).inDays;
      final elapsedDuration = DateTime.now().difference(startDate!).inDays;
      final timeProgress = totalDuration > 0 ? 
          (elapsedDuration / totalDuration).clamp(0.0, 1.0) : 0.0;
      
      if (timeProgress > progress) {
        healthScore -= (timeProgress - progress) * 0.3;
      }
    }
    
    // Task completion factor
    if (totalTasks > 0) {
      final completionRate = completedTasks / totalTasks;
      if (completionRate < progress) {
        healthScore -= (progress - completionRate) * 0.2;
      }
      
      // Overdue task penalty
      final overdueRate = overdueTasks / totalTasks;
      healthScore -= overdueRate * 0.4;
    }
    
    // Budget factor
    if (budgetUsed > 1.0) {
      healthScore -= (budgetUsed - 1.0) * 0.3;
    }
    
    return (healthScore * 100).clamp(0.0, 100.0);
  }

  // ADDED: Get health status string
  String getHealthStatus() {
    final score = calculateHealthScore();
    
    if (score >= 80) {
      return 'excellent';
    } else if (score >= 65) {
      return 'good';
    } else if (score >= 50) {
      return 'fair';
    } else if (score >= 35) {
      return 'poor';
    } else {
      return 'critical';
    }
  }

  // ADDED: Get health color based on score
  Color getHealthColor() {
    final score = calculateHealthScore();
    
    if (score >= 80) {
      return Colors.green; // Excellent
    } else if (score >= 65) {
      return Colors.lightGreen; // Good
    } else if (score >= 50) {
      return Colors.orange; // Fair
    } else if (score >= 35) {
      return Colors.deepOrange; // Poor
    } else {
      return Colors.red; // Critical
    }
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
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null, // FIXED
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
      'endDate': endDate?.toIso8601String(), // FIXED
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
    DateTime? endDate, // FIXED: Added endDate parameter
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
      endDate: endDate ?? this.endDate, // FIXED
      startDate: startDate ?? this.startDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      progress: progress ?? this.progress,
    );
  }
}