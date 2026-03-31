import 'package:flutter/foundation.dart';
import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/expenses/domain/entities/expense.dart';
import 'package:report_expences_app/features/expenses/domain/use_cases/get_expenses_use_case.dart';

class ExpensesViewModel extends ChangeNotifier {
  ExpensesViewModel({required GetExpensesUseCase getExpenses})
      : _getExpenses = getExpenses;

  final GetExpensesUseCase _getExpenses;

  bool _loading = false;
  List<Expense> _expenses = const [];
  String? _errorMessage;

  bool get isLoading => _loading;
  List<Expense> get expenses => _expenses;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getExpenses();
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
