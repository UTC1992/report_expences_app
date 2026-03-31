import 'package:report_expences_app/features/expenses/data/datasources/expenses_data_source.dart';
import 'package:report_expences_app/features/expenses/data/models/expense_model.dart';

class MockExpensesDataSource implements ExpensesDataSource {
  @override
  Future<List<ExpenseModel>> fetchExpenses() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return [
      ExpenseModel(
        id: '1',
        title: 'Coffee',
        amount: 4.5,
        occurredOn: DateTime(2025, 3, 1),
      ),
      ExpenseModel(
        id: '2',
        title: 'Train ticket',
        amount: 12.0,
        occurredOn: DateTime(2025, 3, 3),
      ),
      ExpenseModel(
        id: '3',
        title: 'Team lunch',
        amount: 28.75,
        occurredOn: DateTime(2025, 3, 5),
      ),
    ];
  }
}
