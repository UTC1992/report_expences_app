import 'package:flutter_test/flutter_test.dart';
import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:report_expences_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:report_expences_app/features/settings/domain/entities/app_settings.dart';
import 'package:report_expences_app/features/settings/domain/repositories/settings_repository.dart';

class _FakeRemote implements ChatRemoteDataSource {
  @override
  Future<String> postProcessExpense({
    required String baseUrl,
    required String text,
    required String provider,
    String? apiKey,
  }) async {
    return '''
{"saved":true,"duplicate":false,"expenseId":"e1","expense":{"description":"Coffee","amount":3.5,"providerName":"Shop"}}
''';
  }
}

class _SettingsRepo implements SettingsRepository {
  _SettingsRepo(this.value);

  AppSettings value;

  @override
  Future<Result<AppSettings>> load() async => Success(value);

  @override
  Future<Result<AppSettings>> save(AppSettings settings) async {
    value = settings;
    return Success(settings);
  }
}

void main() {
  test('processExpenseText maps saved response to assistant reply', () async {
    final repo = ChatRepositoryImpl(
      remoteDataSource: _FakeRemote(),
      settingsRepository: _SettingsRepo(
        const AppSettings(
          serverBaseUrl: 'https://host',
          llmApiKey: 'k',
        ),
      ),
    );

    final result = await repo.processExpenseText('buy coffee');
    expect(result, isA<Success>());
    final data = (result as Success).data;
    expect(data.saved, isTrue);
    expect(data.assistantReply, contains('Coffee'));
    expect(data.assistantReply, contains('3.5'));
    expect(data.assistantReply, contains('Shop'));
  });

  test('processExpenseText returns validation failure when base URL empty',
      () async {
    final repo = ChatRepositoryImpl(
      remoteDataSource: _FakeRemote(),
      settingsRepository: _SettingsRepo(AppSettings.empty),
    );

    final result = await repo.processExpenseText('x');
    expect(result, isA<FailureResult>());
  });
}
