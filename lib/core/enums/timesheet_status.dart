// lib/core/enums/timesheet_status.dart

import 'package:flutter/material.dart';

enum TimesheetStatus {
  draft,        // Being filled by team member
  submitted,    // Awaiting manager approval
  approved,     // Approved, ready for payroll
  rejected,     // Needs corrections
  paid,         // Processed in payroll
}

extension TimesheetStatusExtension on TimesheetStatus {
  String get displayName {
    switch (this) {
      case TimesheetStatus.draft:
        return 'Draft';
      case TimesheetStatus.submitted:
        return 'Submitted';
      case TimesheetStatus.approved:
        return 'Approved';
      case TimesheetStatus.rejected:
        return 'Rejected';
      case TimesheetStatus.paid:
        return 'Paid';
    }
  }

  Color get color {
    switch (this) {
      case TimesheetStatus.draft:
        return Colors.grey;
      case TimesheetStatus.submitted:
        return Colors.orange;
      case TimesheetStatus.approved:
        return Colors.green;
      case TimesheetStatus.rejected:
        return Colors.red;
      case TimesheetStatus.paid:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case TimesheetStatus.draft:
        return Icons.edit_outlined;
      case TimesheetStatus.submitted:
        return Icons.upload_outlined;
      case TimesheetStatus.approved:
        return Icons.check_circle_outline;
      case TimesheetStatus.rejected:
        return Icons.cancel_outlined;
      case TimesheetStatus.paid:
        return Icons.payment_outlined;
    }
  }

  bool get canEdit {
    return this == TimesheetStatus.draft || this == TimesheetStatus.rejected;
  }

  bool get isLocked {
    return this == TimesheetStatus.approved || this == TimesheetStatus.paid;
  }
}