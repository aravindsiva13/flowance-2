
// // lib/core/utils/date_utils.dart

// import 'package:intl/intl.dart';

// class AppDateUtils {
//   static String formatDate(DateTime date, {String? pattern}) {
//     final formatter = DateFormat(pattern ?? 'MMM dd, yyyy');
//     return formatter.format(date);
//   }
  
//   static String formatDateTime(DateTime dateTime, {String? pattern}) {
//     final formatter = DateFormat(pattern ?? 'MMM dd, yyyy HH:mm');
//     return formatter.format(dateTime);
//   }
  
//   static String formatRelativeTime(DateTime dateTime) {
//     final now = DateTime.now();
//     final difference = now.difference(dateTime);
    
//     if (difference.inDays > 0) {
//       if (difference.inDays == 1) {
//         return '1 day ago';
//       } else if (difference.inDays < 30) {
//         return '${difference.inDays} days ago';
//       } else if (difference.inDays < 365) {
//         final months = (difference.inDays / 30).floor();
//         return months == 1 ? '1 month ago' : '$months months ago';
//       } else {
//         final years = (difference.inDays / 365).floor();
//         return years == 1 ? '1 year ago' : '$years years ago';
//       }
//     } else if (difference.inHours > 0) {
//       return difference.inHours == 1 ? '1 hour ago' : '${difference.inHours} hours ago';
//     } else if (difference.inMinutes > 0) {
//       return difference.inMinutes == 1 ? '1 minute ago' : '${difference.inMinutes} minutes ago';
//     } else {
//       return 'Just now';
//     }
//   }
  
//   static String formatDueDate(DateTime dueDate) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
//     final difference = due.difference(today).inDays;
    
//     if (difference < 0) {
//       return 'Overdue by ${(-difference)} day${(-difference) == 1 ? '' : 's'}';
//     } else if (difference == 0) {
//       return 'Due today';
//     } else if (difference == 1) {
//       return 'Due tomorrow';
//     } else if (difference <= 7) {
//       return 'Due in $difference days';
//     } else {
//       return 'Due on ${formatDate(dueDate)}';
//     }
//   }
  
//   static bool isOverdue(DateTime dueDate) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
//     return due.isBefore(today);
//   }
  
//   static bool isDueToday(DateTime dueDate) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
//     return due.isAtSameMomentAs(today);
//   }
  
//   static bool isDueSoon(DateTime dueDate, {int days = 3}) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
//     final difference = due.difference(today).inDays;
//     return difference >= 0 && difference <= days;
//   }
  
//   static DateTime startOfDay(DateTime date) {
//     return DateTime(date.year, date.month, date.day);
//   }
  
//   static DateTime endOfDay(DateTime date) {
//     return DateTime(date.year, date.month, date.day, 23, 59, 59);
//   }
  
//   static List<DateTime> getWeekDays(DateTime date) {
//     final weekday = date.weekday;
//     final startOfWeek = date.subtract(Duration(days: weekday - 1));
//     return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
//   }
// }


//2
// lib/core/utils/date_utils.dart

import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(DateTime date, {String? pattern}) {
    if (pattern != null) {
      return DateFormat(pattern).format(date);
    }
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime, {String? pattern}) {
    if (pattern != null) {
      return DateFormat(pattern).format(dateTime);
    }
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatMonth(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  static String formatDayMonth(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }

  static String formatWeekday(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  static String formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) {
      return 'Overdue by ${formatDuration(difference.abs())}';
    } else if (difference.inDays == 0) {
      return 'Due today';
    } else if (difference.inDays == 1) {
      return 'Due tomorrow';
    } else if (difference.inDays <= 7) {
      return 'Due in ${difference.inDays} days';
    } else {
      return 'Due ${formatDate(dueDate)}';
    }
  }

  static bool isOverdue(DateTime dueDate) {
    return DateTime.now().isAfter(dueDate);
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  static DateTime endOfWeek(DateTime date) {
    final daysUntilSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysUntilSunday)));
  }

  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  static List<DateTime> getDaysInRange(DateTime start, DateTime end) {
    final days = <DateTime>[];
    var current = startOfDay(start);
    final endDay = startOfDay(end);

    while (current.isBefore(endDay) || current.isAtSameMomentAs(endDay)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }

    return days;
  }
}