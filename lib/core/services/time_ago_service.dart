import 'package:intl/intl.dart';

class TimeAgoService {
  static String getTimeAgo(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();
    final now = DateTime.now();
    final difference = now.difference(localDateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${_plural(difference.inMinutes)} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${_plural(difference.inHours)} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${_plural(difference.inDays)} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${_plural(weeks)} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${_plural(months)} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${_plural(years)} ago';
    }
  }

  static String _plural(int value) => value == 1 ? '' : 's';

  static String formatTimeForDisplay(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();
    final now = DateTime.now();
    final difference = now.difference(localDateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays == 1) {
      return 'yesterday, ${DateFormat.jm().format(localDateTime)}';
    } else if (difference.inDays < 7) {
      return '${DateFormat.EEEE().format(localDateTime)}, ${DateFormat.jm().format(localDateTime)}';
    } else {
      return '${DateFormat.MMMd().format(localDateTime)}, ${DateFormat.jm().format(localDateTime)}';
    }
  }

  static String formatForStoryViewers(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();
    final now = DateTime.now();
    final difference = now.difference(localDateTime);

    if (_isSameDay(now, localDateTime)) {
      return 'today ${DateFormat.jm().format(localDateTime)}';
    } else if (_isYesterday(localDateTime)) {
      return 'yesterday ${DateFormat.jm().format(localDateTime)}';
    } else if (difference.inDays < 7) {
      return '${DateFormat.EEEE().format(localDateTime)} ${DateFormat.jm().format(localDateTime)}';
    } else {
      return '${DateFormat.MMMd().format(localDateTime)} ${DateFormat.jm().format(localDateTime)}';
    }
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool _isYesterday(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  static String getSmartChatTimestamp(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();
    final now = DateTime.now();

    if (_isSameDay(now, localDateTime)) {
      return DateFormat.jm().format(localDateTime);
    } else if (_isYesterday(localDateTime)) {
      return 'yesterday';
    } else if (now.difference(localDateTime).inDays < 7) {
      return DateFormat.EEEE().format(localDateTime);
    } else {
      return DateFormat('dd/MM/yyyy').format(localDateTime);
    }
  }

  static String formatTimeOnly(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();
    return DateFormat.jm().format(localDateTime);
  }

  static String groupTitleFromDate(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();
    final now = DateTime.now();

    if (_isSameDay(localDateTime, now)) {
      return 'Today';
    }

    if (_isYesterday(localDateTime)) {
      return 'Yesterday';
    }

    return DateFormat('dd MMM yyyy').format(localDateTime);
  }
}
