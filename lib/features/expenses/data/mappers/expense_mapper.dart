import 'package:report_expences_app/features/expenses/data/models/expense_model.dart';
import 'package:report_expences_app/features/expenses/domain/entities/expense.dart';

extension ExpenseModelMapper on ExpenseModel {
  Expense toEntity() {
    return Expense(
      id: id,
      title: title,
      amount: amount,
      occurredOn: occurredOn,
    );
  }
}
