import 'package:flutter/material.dart';
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

import '../../../support/fake_settings_secure_data_source.dart';

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

  testWidgets('tapping Periodo opens date range picker dialog', (tester) async {
    await tester.pumpWidget(const ReportExpencesApp());
    await tester.pumpAndSettle();

    expect(find.text('Periodo'), findsOneWidget);

    await tester.tap(find.text('Periodo'));
    await tester.pumpAndSettle();

    final dialog = find.byType(DateRangePickerDialog);
    expect(dialog, findsOneWidget);
    expect(find.text('Rango de fechas'), findsOneWidget);
    // Actions exist (Material may use TextButton only for both actions).
    expect(
      find.descendant(of: dialog, matching: find.byType(TextButton)),
      findsWidgets,
    );
  });

  testWidgets('dismissing date range picker returns to report list', (tester) async {
    await tester.pumpWidget(const ReportExpencesApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Periodo'));
    await tester.pumpAndSettle();

    final dialog = find.byType(DateRangePickerDialog);
    final cancelButtons = find.descendant(
      of: dialog,
      matching: find.byType(TextButton),
    );
    expect(cancelButtons, findsWidgets);
    await tester.tap(cancelButtons.first);
    await tester.pumpAndSettle();

    expect(find.byType(DateRangePickerDialog), findsNothing);
    expect(find.text('Periodo'), findsOneWidget);
  });
}
