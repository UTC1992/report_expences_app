import 'package:flutter_test/flutter_test.dart';
import 'package:report_expences_app/features/expenses/domain/entities/expense_date_range_filter.dart';

void main() {
  test('normalizes start and end to date-only', () {
    final f = ExpenseDateRangeFilter(
      start: DateTime(2026, 3, 10, 15, 30),
      end: DateTime(2026, 3, 31, 8, 0),
    );
    expect(f.startInclusive, DateTime(2026, 3, 10));
    expect(f.endInclusive, DateTime(2026, 3, 31));
  });

  test('swaps when start is after end', () {
    final f = ExpenseDateRangeFilter(
      start: DateTime(2026, 3, 20),
      end: DateTime(2026, 3, 1),
    );
    expect(f.startInclusive, DateTime(2026, 3, 1));
    expect(f.endInclusive, DateTime(2026, 3, 20));
  });

  test('currentMonth spans full calendar month', () {
    final f = ExpenseDateRangeFilter.currentMonth();
    expect(f.startInclusive.day, 1);
    final last = DateTime(f.startInclusive.year, f.startInclusive.month + 1, 0);
    expect(f.endInclusive, last);
  });
}
