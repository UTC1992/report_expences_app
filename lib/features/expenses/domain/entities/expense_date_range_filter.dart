/// Inclusive calendar date range for listing expenses (`startDate` / `endDate` in the API).
class ExpenseDateRangeFilter {
  const ExpenseDateRangeFilter._(this.startInclusive, this.endInclusive);

  /// Normalizes to date-only; if [start] is after [end], dates are swapped.
  factory ExpenseDateRangeFilter({
    required DateTime start,
    required DateTime end,
  }) {
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    if (s.isAfter(e)) {
      return ExpenseDateRangeFilter._(e, s);
    }
    return ExpenseDateRangeFilter._(s, e);
  }

  /// First through last day of the current calendar month.
  factory ExpenseDateRangeFilter.currentMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    return ExpenseDateRangeFilter._(start, end);
  }

  final DateTime startInclusive;
  final DateTime endInclusive;
}
