import 'package:flutter/material.dart';
import 'package:report_expences_app/features/expenses/domain/entities/expense.dart';

class ExpenseListTile extends StatelessWidget {
  const ExpenseListTile({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final date = MaterialLocalizations.of(context).formatMediumDate(
      expense.occurredOn,
    );
    return ListTile(
      title: Text(expense.title),
      subtitle: Text(date),
      trailing: Text(
        expense.amount.toStringAsFixed(2),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
