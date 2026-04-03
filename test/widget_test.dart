import 'package:flutter_test/flutter_test.dart';
import 'package:report_expences_app/app.dart';
import 'package:report_expences_app/core/di/injection_container.dart';
import 'package:report_expences_app/features/expenses/data/datasources/expenses_data_source.dart';
import 'package:report_expences_app/features/expenses/data/datasources/mock_expenses_data_source.dart';
import 'package:report_expences_app/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:report_expences_app/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:report_expences_app/features/settings/data/datasources/settings_secure_data_source.dart';
import 'package:report_expences_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:report_expences_app/features/settings/domain/repositories/settings_repository.dart';

import 'support/fake_settings_secure_data_source.dart';

void main() {
  setUp(() async {
    await sl.reset();
    await initDependencies();
    sl.unregister<SettingsSecureDataSource>();
    sl.registerLazySingleton<SettingsSecureDataSource>(
      FakeSettingsSecureDataSource.new,
    );
    sl.unregister<SettingsRepository>();
    sl.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(sl()),
    );
    sl.unregister<ExpensesDataSource>();
    sl.registerLazySingleton<ExpensesDataSource>(MockExpensesDataSource.new);
    sl.unregister<ExpensesRepository>();
    sl.registerLazySingleton<ExpensesRepository>(
      () => ExpensesRepositoryImpl(dataSource: sl()),
    );
  });

  testWidgets('Home shows reports tab by default', (WidgetTester tester) async {
    await tester.pumpWidget(const ReportExpencesApp());
    await tester.pumpAndSettle();
    expect(find.text('Reportes'), findsWidgets);
  });
}
