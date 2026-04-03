import 'package:flutter_test/flutter_test.dart';
import 'package:report_expences_app/features/expenses/data/models/expense_model.dart';

void main() {
  test('fromExpenseListItemJson maps API list item', () {
    final m = ExpenseModel.fromExpenseListItemJson({
      'id': '1',
      'amount': 12.5,
      'description': 'Lunch',
      'expenseDate': '2026-03-31',
    });
    expect(m.id, '1');
    expect(m.title, 'Lunch');
    expect(m.amount, 12.5);
    expect(m.occurredOn, DateTime.parse('2026-03-31'));
  });
}
