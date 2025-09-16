
// lib/core/enums/user_role.dart

enum UserRole {
  admin,
  manager,
  projectManager,
  teamMember,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.manager:
        return 'Manager';
      case UserRole.projectManager:
        return 'Project Manager';
      case UserRole.teamMember:
        return 'Team Member';
    }
  }

  String get name {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.manager:
        return 'manager';
      case UserRole.projectManager:
        return 'projectManager';
      case UserRole.teamMember:
        return 'teamMember';
    }
  }

  // Permission getters
  bool get canCreateProjects {
    switch (this) {
      case UserRole.admin:
      case UserRole.manager:
      case UserRole.projectManager:
        return true;
      case UserRole.teamMember:
        return false;
    }
  }

  bool get canDeleteProjects {
    switch (this) {
      case UserRole.admin:
        return true;
      case UserRole.manager:
      case UserRole.projectManager:
      case UserRole.teamMember:
        return false;
    }
  }

  bool get canManageUsers {
    switch (this) {
      case UserRole.admin:
      case UserRole.manager:
        return true;
      case UserRole.projectManager:
      case UserRole.teamMember:
        return false;
    }
  }

  bool get canAssignTasks {
    switch (this) {
      case UserRole.admin:
      case UserRole.manager:
      case UserRole.projectManager:
        return true;
      case UserRole.teamMember:
        return false;
    }
  }

  bool get canViewAllProjects {
    switch (this) {
      case UserRole.admin:
      case UserRole.manager:
        return true;
      case UserRole.projectManager:
      case UserRole.teamMember:
        return false;
    }
  }

  bool get canExportData {
    switch (this) {
      case UserRole.admin:
      case UserRole.manager:
      case UserRole.projectManager:
        return true;
      case UserRole.teamMember:
        return false;
    }
  }
}