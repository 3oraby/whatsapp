class TimeAgoService {
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

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
}
