// lib/presentation/viewmodels/team_time_viewmodel.dart

import 'package:flutter/foundation.dart';
import '../../data/models/time_entry_model.dart';
import '../../data/models/user_model.dart';
import '../../data/models/project_model.dart';
import '../../data/repositories/app_repository.dart';
import '../../core/enums/timesheet_status.dart';

class TeamTimeViewModel extends ChangeNotifier {
  final AppRepository _repository = AppRepository();

  List<TimeEntryModel> _teamTimeEntries = [];
  List<UserModel> _teamMembers = [];
  List<ProjectModel> _projects = [];
  
  bool _isLoading = false;
  String? _errorMessage;

  // Filters
  String? _selectedMemberId;
  String? _selectedProjectId;
  DateTime? _startDate;
  DateTime? _endDate;
  TimesheetStatus? _selectedStatus;

  // Getters
  List<TimeEntryModel> get teamTimeEntries => _teamTimeEntries;
  List<UserModel> get teamMembers => _teamMembers;
  List<ProjectModel> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  String? get selectedMemberId => _selectedMemberId;
  String? get selectedProjectId => _selectedProjectId;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  TimesheetStatus? get selectedStatus => _selectedStatus;

  // Filtered entries based on current filters
  List<TimeEntryModel> get filteredEntries {
    var entries = List<TimeEntryModel>.from(_teamTimeEntries);

    if (_selectedMemberId != null) {
      entries = entries.where((e) => e.userId == _selectedMemberId).toList();
    }

    if (_selectedProjectId != null) {
      entries = entries.where((e) => e.projectId == _selectedProjectId).toList();
    }

    if (_startDate != null) {
      entries = entries.where((e) => 
        e.startTime.isAfter(_startDate!) || 
        e.startTime.isAtSameMomentAs(_startDate!)
      ).toList();
    }

    if (_endDate != null) {
      entries = entries.where((e) => 
        e.startTime.isBefore(_endDate!) || 
        e.startTime.isAtSameMomentAs(_endDate!)
      ).toList();
    }

    if (_selectedStatus != null) {
      entries = entries.where((e) => e.status == _selectedStatus).toList();
    }

    // Sort by date descending
    entries.sort((a, b) => b.startTime.compareTo(a.startTime));

    return entries;
  }

  // Get pending approvals count
  int get pendingApprovalsCount {
    return _teamTimeEntries
        .where((e) => e.status == TimesheetStatus.submitted)
        .length;
  }

  // Get currently working members
  List<Map<String, dynamic>> get currentlyWorkingMembers {
    final activeEntries = _teamTimeEntries.where((e) => e.isActive).toList();
    
    return activeEntries.map((entry) {
      final member = _teamMembers.firstWhere(
        (m) => m.id == entry.userId,
        orElse: () => UserModel(
          id: entry.userId,
          name: 'Unknown',
          email: '',
          role: UserRole.teamMember,
          createdAt: DateTime.now(),
        ),
      );

      return {
        'member': member,
        'entry': entry,
        'duration': _calculateDuration(entry),
      };
    }).toList();
  }

  // Statistics
  Map<String, dynamic> get weeklyStats {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    final weekEntries = _teamTimeEntries.where((e) =>
      e.startTime.isAfter(weekStart) && e.startTime.isBefore(weekEnd)
    ).toList();

    final totalHours = weekEntries.fold<double>(
      0.0,
      (sum, entry) => sum + entry.durationHours,
    );

    final billableHours = weekEntries
        .where((e) => e.isBillable)
        .fold<double>(0.0, (sum, entry) => sum + entry.durationHours);

    return {
      'totalHours': totalHours,
      'billableHours': billableHours,
      'nonBillableHours': totalHours - billableHours,
      'avgPerMember': _teamMembers.isNotEmpty 
          ? totalHours / _teamMembers.length 
          : 0.0,
      'entriesCount': weekEntries.length,
    };
  }

  // Load all team time data
  Future<void> loadTeamTime() async {
    _setLoading(true);
    _clearError();

    try {
      // Load team members
      _teamMembers = await _repository.getUsers();
      
      // Load projects
      _projects = await _repository.getProjects();

      // Load all time entries (not filtered by current user)
      _teamTimeEntries = await _repository.getTimeEntries(
        startDate: _startDate,
        endDate: _endDate,
      );

      _setLoading(false);
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
    }
  }

  // Set filters
  void setMemberFilter(String? memberId) {
    _selectedMemberId = memberId;
    notifyListeners();
  }

  void setProjectFilter(String? projectId) {
    _selectedProjectId = projectId;
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
    loadTeamTime(); // Reload with new date range
  }

  void setStatusFilter(TimesheetStatus? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void clearFilters() {
    _selectedMemberId = null;
    _selectedProjectId = null;
    _startDate = null;
    _endDate = null;
    _selectedStatus = null;
    notifyListeners();
  }

  // Approve time entry
  Future<bool> approveTimeEntry(String entryId, String reviewerId) async {
    _clearError();

    try {
      final index = _teamTimeEntries.indexWhere((e) => e.id == entryId);
      if (index == -1) throw Exception('Time entry not found');

      final updatedEntry = _teamTimeEntries[index].copyWith(
        status: TimesheetStatus.approved,
        reviewerId: reviewerId,
        reviewedAt: DateTime.now(),
        rejectionReason: null,
      );

      // Update in repository (mock API for now)
      await _repository.updateTimeEntry(entryId, updatedEntry.toJson());
      
      _teamTimeEntries[index] = updatedEntry;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    }
  }

  // Reject time entry
  Future<bool> rejectTimeEntry(
    String entryId,
    String reviewerId,
    String reason,
  ) async {
    _clearError();

    try {
      final index = _teamTimeEntries.indexWhere((e) => e.id == entryId);
      if (index == -1) throw Exception('Time entry not found');

      final updatedEntry = _teamTimeEntries[index].copyWith(
        status: TimesheetStatus.rejected,
        reviewerId: reviewerId,
        reviewedAt: DateTime.now(),
        rejectionReason: reason,
      );

      await _repository.updateTimeEntry(entryId, updatedEntry.toJson());
      
      _teamTimeEntries[index] = updatedEntry;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    }
  }

  // Bulk approve entries
  Future<bool> bulkApproveEntries(
    List<String> entryIds,
    String reviewerId,
  ) async {
    _clearError();

    try {
      for (final entryId in entryIds) {
        await approveTimeEntry(entryId, reviewerId);
      }
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    }
  }

  // Submit timesheet (for team member)
  Future<bool> submitTimesheet(List<String> entryIds) async {
    _clearError();

    try {
      for (final entryId in entryIds) {
        final index = _teamTimeEntries.indexWhere((e) => e.id == entryId);
        if (index != -1) {
          final updatedEntry = _teamTimeEntries[index].copyWith(
            status: TimesheetStatus.submitted,
          );
          
          await _repository.updateTimeEntry(entryId, updatedEntry.toJson());
          _teamTimeEntries[index] = updatedEntry;
        }
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    }
  }

  // Get member's time entries for a period
  List<TimeEntryModel> getMemberTimeEntries(
    String memberId, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    var entries = _teamTimeEntries.where((e) => e.userId == memberId).toList();

    if (startDate != null) {
      entries = entries.where((e) => 
        e.startTime.isAfter(startDate) || 
        e.startTime.isAtSameMomentAs(startDate)
      ).toList();
    }

    if (endDate != null) {
      entries = entries.where((e) => 
        e.startTime.isBefore(endDate) || 
        e.startTime.isAtSameMomentAs(endDate)
      ).toList();
    }

    entries.sort((a, b) => b.startTime.compareTo(a.startTime));
    return entries;
  }

  // Get member stats
  Map<String, dynamic> getMemberStats(String memberId) {
    final memberEntries = _teamTimeEntries
        .where((e) => e.userId == memberId)
        .toList();

    final totalHours = memberEntries.fold<double>(
      0.0,
      (sum, entry) => sum + entry.durationHours,
    );

    final billableHours = memberEntries
        .where((e) => e.isBillable)
        .fold<double>(0.0, (sum, entry) => sum + entry.durationHours);

    final pendingCount = memberEntries
        .where((e) => e.status == TimesheetStatus.submitted)
        .length;

    return {
      'totalHours': totalHours,
      'billableHours': billableHours,
      'entriesCount': memberEntries.length,
      'pendingCount': pendingCount,
    };
  }

  // Export to CSV
  Future<String> exportToCSV() async {
    final entries = filteredEntries;
    
    final csvLines = <String>[];
    
    // Header
    csvLines.add('Date,Member,Project,Task,Hours,Status,Billable,Notes');
    
    // Data rows
    for (final entry in entries) {
      final member = _getMemberName(entry.userId);
      final project = _getProjectName(entry.projectId);
      final task = 'Task ${entry.taskId}'; // Get actual task name if needed
      
      csvLines.add(
        '${_formatDate(entry.startTime)},'
        '"$member",'
        '"$project",'
        '"$task",'
        '${entry.durationHours.toStringAsFixed(2)},'
        '${entry.status.displayName},'
        '${entry.isBillable ? "Yes" : "No"},'
        '"${entry.notes ?? ""}"'
      );
    }
    
    return csvLines.join('\n');
  }

  // Helper methods
  String _getMemberName(String userId) {
    final member = _teamMembers.firstWhere(
      (m) => m.id == userId,
      orElse: () => UserModel(
        id: userId,
        name: 'Unknown',
        email: '',
        role: UserRole.teamMember,
        createdAt: DateTime.now(),
      ),
    );
    return member.name;
  }

  String _getProjectName(String projectId) {
    final project = _projects.firstWhere(
      (p) => p.id == projectId,
      orElse: () => ProjectModel(
        id: projectId,
        name: 'Unknown',
        description: '',
        status: ProjectStatus.active,
        memberIds: [],
        creatorId: '',
        ownerId: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    return project.name;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Duration _calculateDuration(TimeEntryModel entry) {
    if (entry.isActive) {
      return DateTime.now().difference(entry.startTime);
    }
    return Duration(seconds: entry.durationSeconds);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return error.toString();
  }
}