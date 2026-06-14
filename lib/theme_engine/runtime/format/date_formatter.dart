class DateFormatter {
  String format(DateTime date, {String locale = 'en', String pattern = 'MM/dd/yyyy'}) {
    final map = <String, String>{
      'yyyy': _padZero(date.year, 4),
      'yy': _padZero(date.year % 100, 2),
      'MM': _padZero(date.month, 2),
      'dd': _padZero(date.day, 2),
      'HH': _padZero(date.hour, 2),
      'mm': _padZero(date.minute, 2),
      'ss': _padZero(date.second, 2),
    };
    var result = pattern;
    for (final entry in map.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result;
  }

  String relative(DateTime date, {String locale = 'en'}) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 365) {
      final years = (diff.inDays / 365).floor();
      return _relativeString('year', years, locale);
    }
    if (diff.inDays > 30) {
      final months = (diff.inDays / 30).floor();
      return _relativeString('month', months, locale);
    }
    if (diff.inDays > 0) {
      return _relativeString('day', diff.inDays, locale);
    }
    if (diff.inHours > 0) {
      return _relativeString('hour', diff.inHours, locale);
    }
    if (diff.inMinutes > 0) {
      return _relativeString('minute', diff.inMinutes, locale);
    }
    return _relativeString('just_now', 0, locale);
  }

  String _relativeString(String unit, int count, String locale) {
    if (unit == 'just_now') return 'just now';
    final plural = count == 1 ? '' : 's';
    return '$count $unit$plural ago';
  }

  String _padZero(int value, int length) {
    return value.toString().padLeft(length, '0');
  }
}
