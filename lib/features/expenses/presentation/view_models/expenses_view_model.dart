import 'package:flutter/foundation.dart';
import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/expenses/domain/entities/expense.dart';
import 'package:report_expences_app/features/expenses/domain/entities/expense_date_range_filter.dart';
import 'package:report_expences_app/features/expenses/domain/use_cases/get_expenses_use_case.dart';

class ExpensesViewModel extends ChangeNotifier {
  ExpensesViewModel({required GetExpensesUseCase getExpenses})
      : _getExpenses = getExpenses,
        _dateRange = ExpenseDateRangeFilter.currentMonth();

  final GetExpensesUseCase _getExpenses;

  ExpenseDateRangeFilter _dateRange;

  bool _loading = false;
  List<Expense> _expenses = const [];
  String? _errorMessage;

  bool get isLoading => _loading;
  List<Expense> get expenses => _expenses;
  String? get errorMessage => _errorMessage;
  ExpenseDateRangeFilter get dateRange => _dateRange;

  void setDateRange(DateTime start, DateTime end) {
    _dateRange = ExpenseDateRangeFilter(start: start, end: end);
    notifyListeners();
    load();
  }

  Future<void> load() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getExpenses(_dateRange);
    switch (result) {
      case Success(:final data):
        _expenses = data;
      case FailureResult(:final failure):
        _errorMessage = failure.message;
    }

    _loading = false;
    notifyListeners();
  }
}
