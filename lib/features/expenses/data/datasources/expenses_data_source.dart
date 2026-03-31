import 'package:report_expences_app/features/expenses/data/models/expense_model.dart';

/// Abstraction over any backend: REST, GraphQL, local DB, etc.
/// The domain layer never depends on this type.
abstract class ExpensesDataSource {
  Future<List<ExpenseModel>> fetchExpenses();
}
