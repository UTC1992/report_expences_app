import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/expenses/domain/entities/expense.dart';
import 'package:report_expences_app/features/expenses/domain/entities/expense_date_range_filter.dart';
import 'package:report_expences_app/features/expenses/domain/repositories/expenses_repository.dart';

class GetExpensesUseCase {
  GetExpensesUseCase(this._repository);

  final ExpensesRepository _repository;

  Future<Result<List<Expense>>> call(ExpenseDateRangeFilter range) =>
      _repository.getExpenses(range);
}
