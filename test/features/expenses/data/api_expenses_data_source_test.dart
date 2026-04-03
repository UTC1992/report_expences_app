import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:report_expences_app/core/network/api_exception.dart';
import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/expenses/data/datasources/api_expenses_data_source.dart';
import 'package:report_expences_app/features/settings/domain/entities/app_settings.dart';
import 'package:report_expences_app/features/settings/domain/repositories/settings_repository.dart';

class _FixedSettingsRepository implements SettingsRepository {
  _FixedSettingsRepository(this._settings);

  final AppSettings _settings;

  @override
  Future<Result<AppSettings>> load() async => Success(_settings);

  @override
  Future<Result<AppSettings>> save(AppSettings settings) async =>
      Success(settings);
}

void main() {
  test('fetchExpenses parses items from API JSON', () async {
    final client = MockClient((request) async {
      expect(request.url.toString(), 'https://api.test/api/v1/expenses');
      return http.Response(
        '''
        {
          "items": [
            {
              "id": "a1",
              "amount": 10.5,
              "category": "food",
              "description": "Lunch",
              "providerName": "Cafe",
              "expenseDate": "2026-03-31",
              "rawText": "x",
              "linkedInvoiceId": null,
              "createdAt": "2026-03-31T12:00:00Z"
            }
          ],
          "total": 1
        }
        ''',
        200,
      );
    });

    final ds = ApiExpensesDataSource(
      httpClient: client,
      settingsRepository: _FixedSettingsRepository(
        const AppSettings(
          serverBaseUrl: 'https://api.test',
          llmApiKey: '',
        ),
      ),
    );

    final list = await ds.fetchExpenses();
    expect(list, hasLength(1));
    expect(list.single.title, 'Lunch');
    expect(list.single.amount, 10.5);
    expect(list.single.id, 'a1');
  });

  test('fetchExpenses throws when server URL missing', () async {
    final client = MockClient((_) async => http.Response('', 500));
    final ds = ApiExpensesDataSource(
      httpClient: client,
      settingsRepository: _FixedSettingsRepository(AppSettings.empty),
    );

    expect(
      ds.fetchExpenses,
      throwsA(isA<ApiException>().having(
        (e) => e.message,
        'message',
        contains('Configura la URL'),
      )),
    );
  });
}
