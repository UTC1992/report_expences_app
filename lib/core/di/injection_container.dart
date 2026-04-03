import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:report_expences_app/features/chat/data/datasources/api_chat_remote_data_source.dart';
import 'package:report_expences_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:report_expences_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:report_expences_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:report_expences_app/features/chat/domain/use_cases/process_expense_from_chat_use_case.dart';
import 'package:report_expences_app/features/chat/presentation/view_models/chat_view_model.dart';
import 'package:report_expences_app/features/expenses/data/datasources/api_expenses_data_source.dart';
import 'package:report_expences_app/features/expenses/data/datasources/expenses_data_source.dart';
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

/// Registers dependencies. Remote data sources read [SettingsRepository] for base URL.
Future<void> initDependencies() async {
  sl
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    )
    ..registerLazySingleton<SettingsSecureDataSource>(
      () => SettingsSecureDataSourceImpl(sl()),
    )
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(sl()),
    )
    ..registerLazySingleton<http.Client>(() => http.Client())
    ..registerLazySingleton<ExpensesDataSource>(
      () => ApiExpensesDataSource(
        httpClient: sl(),
        settingsRepository: sl(),
      ),
    )
    ..registerLazySingleton<ExpensesRepository>(
      () => ExpensesRepositoryImpl(dataSource: sl()),
    )
    ..registerFactory(() => GetExpensesUseCase(sl()))
    ..registerFactory(
      () => ExpensesViewModel(getExpenses: sl()),
    )
    ..registerLazySingleton<ChatRemoteDataSource>(
      () => ApiChatRemoteDataSource(httpClient: sl()),
    )
    ..registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(
        remoteDataSource: sl(),
        settingsRepository: sl(),
      ),
    )
    ..registerFactory(() => ProcessExpenseFromChatUseCase(sl()))
    ..registerFactory<ChatViewModel>(
      () => ChatViewModel(processExpense: sl()),
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
