import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:report_expences_app/features/chat/presentation/view_models/chat_view_model.dart';
import 'package:report_expences_app/features/expenses/data/datasources/expenses_data_source.dart';
import 'package:report_expences_app/features/expenses/data/datasources/mock_expenses_data_source.dart';
import 'package:report_expences_app/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:report_expences_app/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:report_expences_app/features/expenses/domain/use_cases/get_expenses_use_case.dart';
import 'package:report_expences_app/features/expenses/presentation/view_models/expenses_view_model.dart';
import 'package:report_expences_app/features/settings/data/datasources/settings_secure_data_source.dart';
import 'package:report_expences_app/features/settings/data/datasources/settings_secure_data_source_impl.dart';
import 'package:report_expences_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:report_expences_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:report_expences_app/features/settings/domain/use_cases/get_app_settings_use_case.dart';
import 'package:report_expences_app/features/settings/domain/use_cases/save_app_settings_use_case.dart';
import 'package:report_expences_app/features/settings/presentation/view_models/settings_view_model.dart';

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
    )
    ..registerFactory<ChatViewModel>(() => ChatViewModel())
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    )
    ..registerLazySingleton<SettingsSecureDataSource>(
      () => SettingsSecureDataSourceImpl(sl()),
    )
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(sl()),
    )
    ..registerFactory<GetAppSettingsUseCase>(
      () => GetAppSettingsUseCase(sl()),
    )
    ..registerFactory<SaveAppSettingsUseCase>(
      () => SaveAppSettingsUseCase(sl()),
    )
    ..registerFactory(
      () => SettingsViewModel(
        getSettings: sl(),
        saveSettings: sl(),
      ),
    );
}
