// // lib/data/models/user_model.dart

// import '../../core/enums/user_role.dart';

// class UserModel {
//   final String id;
//   final String name;
//   final String email;
//   final UserRole role;
//   final String? avatarUrl;
//   final DateTime createdAt;
//   final DateTime? lastLoginAt;

//   UserModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.role,
//     this.avatarUrl,
//     required this.createdAt,
//     this.lastLoginAt,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//       role: UserRole.values.firstWhere(
//         (e) => e.name == json['role'],
//         orElse: () => UserRole.teamMember,
//       ),
//       avatarUrl: json['avatarUrl'],
//       createdAt: DateTime.parse(json['createdAt']),
//       lastLoginAt: json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'role': role.name,
//       'avatarUrl': avatarUrl,
//       'createdAt': createdAt.toIso8601String(),
//       'lastLoginAt': lastLoginAt?.toIso8601String(),
//     };
//   }

//   UserModel copyWith({
//     String? name,
//     String? email,
//     UserRole? role,
//     String? avatarUrl,
//     DateTime? lastLoginAt,
//   }) {
//     return UserModel(
//       id: id,
//       name: name ?? this.name,
//       email: email ?? this.email,
//       role: role ?? this.role,
//       avatarUrl: avatarUrl ?? this.avatarUrl,
//       createdAt: createdAt,
//       lastLoginAt: lastLoginAt ?? this.lastLoginAt,
//     );
//   }
// }


//2



// lib/data/models/user_model.dart

import '../../core/enums/user_role.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.teamMember,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
