import 'package:report_expences_app/features/expenses/data/datasources/expenses_data_source.dart';
import 'package:report_expences_app/features/expenses/data/models/expense_model.dart';
import 'package:report_expences_app/features/expenses/domain/entities/expense_date_range_filter.dart';

class MockExpensesDataSource implements ExpensesDataSource {
  @override
  Future<List<ExpenseModel>> fetchExpenses(ExpenseDateRangeFilter range) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    const titles = ['Coffee', 'Train ticket', 'Team lunch'];
    const amounts = [4.5, 12.0, 28.75];
    final out = <ExpenseModel>[];
    var d = range.startInclusive;
    for (var i = 0; i < 3 && !d.isAfter(range.endInclusive); i++) {
      out.add(
        ExpenseModel(
          id: '${i + 1}',
          title: titles[i],
          amount: amounts[i],
          occurredOn: d,
        ),
      );
      d = d.add(const Duration(days: 3));
    }
    return out;
  }
}
