// lib/data/models/user_model.dart - COMPLETE FIXED VERSION

import '../../core/enums/user_role.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;        // ADDED
  final String? avatarUrl;    // ADDED
  final UserRole role;
  final DateTime createdAt;
  final DateTime? updatedAt;  // ADDED (if not present)

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,              // ADDED
    this.avatarUrl,          // ADDED
    required this.role,
    required this.createdAt,
    this.updatedAt,          // ADDED
  });

  // From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,              // ADDED
      avatarUrl: json['avatarUrl'] as String?,      // ADDED
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.teamMember,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null           // ADDED
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,                                 // ADDED
      'avatarUrl': avatarUrl,                         // ADDED
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),      // ADDED
    };
  }

  // Copy with method (useful for updates)
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,                     // ADDED
      avatarUrl: avatarUrl ?? this.avatarUrl,         // ADDED
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,         // ADDED
    );
  }
}