import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/expenses/domain/entities/expense.dart';

/// Contract for expense data. Implementations live in the data layer.
abstract class ExpensesRepository {
  Future<Result<List<Expense>>> getExpenses();
}
