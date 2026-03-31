import 'package:get_it/get_it.dart';
import 'package:report_expences_app/features/expenses/data/datasources/expenses_data_source.dart';
import 'package:report_expences_app/features/expenses/data/datasources/mock_expenses_data_source.dart';
import 'package:report_expences_app/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:report_expences_app/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:report_expences_app/features/expenses/domain/use_cases/get_expenses_use_case.dart';
import 'package:report_expences_app/features/expenses/presentation/view_models/expenses_view_model.dart';

final GetIt sl = GetIt.instance;

/// Registers dependencies. Swap [MockExpensesDataSource] for an API-backed
/// implementation without changing domain or presentation.
Future<void> initDependencies() async {
  sl
    ..registerLazySingleton<ExpensesDataSource>(MockExpensesDataSource.new)
    ..registerLazySingleton<ExpensesRepository>(
      () => ExpensesRepositoryImpl(dataSource: sl()),
    )
    ..registerFactory(() => GetExpensesUseCase(sl()))
    ..registerFactory(
      () => ExpensesViewModel(getExpenses: sl()),
    );
}
