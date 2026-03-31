import 'package:report_expences_app/core/error/failures.dart';
import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/expenses/data/datasources/expenses_data_source.dart';
import 'package:report_expences_app/features/expenses/data/mappers/expense_mapper.dart';
import 'package:report_expences_app/features/expenses/domain/entities/expense.dart';
import 'package:report_expences_app/features/expenses/domain/repositories/expenses_repository.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  ExpensesRepositoryImpl({required ExpensesDataSource dataSource})
      : _dataSource = dataSource;

  final ExpensesDataSource _dataSource;

  @override
  Future<Result<List<Expense>>> getExpenses() async {
    try {
      final models = await _dataSource.fetchExpenses();
      return Success(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }
}
