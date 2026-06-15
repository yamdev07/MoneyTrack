import 'package:intl/intl.dart';

/// Date utilities for month/week scoping and display.
class DateHelpers {
  DateHelpers._();

  static final DateFormat _day = DateFormat('d MMM yyyy', 'fr_FR');
  static final DateFormat _dayShort = DateFormat('d MMM', 'fr_FR');
  static final DateFormat _weekday = DateFormat('EEEE', 'fr_FR');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy', 'fr_FR');

  static String formatDay(DateTime d) => _day.format(d);
  static String formatDayShort(DateTime d) => _dayShort.format(d);
  static String formatWeekday(DateTime d) => _weekday.format(d);
  static String formatMonth(DateTime d) => _monthYear.format(d);

  /// First instant of the month containing [ref].
  static DateTime startOfMonth(DateTime ref) => DateTime(ref.year, ref.month);

  /// First instant of the next month after [ref].
  static DateTime startOfNextMonth(DateTime ref) =>
      DateTime(ref.year, ref.month + 1);

  /// Monday 00:00 of the week containing [ref].
  static DateTime startOfWeek(DateTime ref) {
    final date = DateTime(ref.year, ref.month, ref.day);
    return date.subtract(Duration(days: date.weekday - DateTime.monday));
  }

  static bool isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Which week of the current month [ref] falls into (1-based).
  static int weekOfMonth(DateTime ref) {
    final firstDay = startOfMonth(ref);
    final offset = firstDay.weekday - DateTime.monday;
    return ((ref.day + offset - 1) ~/ 7) + 1;
  }
}
