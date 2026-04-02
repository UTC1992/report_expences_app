import 'package:flutter_test/flutter_test.dart';
import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/settings/domain/entities/app_settings.dart';
import 'package:report_expences_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:report_expences_app/features/settings/domain/use_cases/save_app_settings_use_case.dart';

class _SpySettingsRepository implements SettingsRepository {
  AppSettings? lastSaved;

  @override
  Future<Result<AppSettings>> load() async => const Success(AppSettings.empty);

  @override
  Future<Result<AppSettings>> save(AppSettings settings) async {
    lastSaved = settings;
    return Success(settings);
  }
}

void main() {
  test('trims fields and allows empty server URL', () async {
    final repo = _SpySettingsRepository();
    final useCase = SaveAppSettingsUseCase(repo);

    final result = await useCase(
      serverBaseUrl: '   ',
      llmApiKey: '  sk-test  ',
    );

    expect(result, isA<Success<AppSettings>>());
    final data = (result as Success<AppSettings>).data;
    expect(data.serverBaseUrl, '');
    expect(data.llmApiKey, 'sk-test');
    expect(repo.lastSaved?.llmApiKey, 'sk-test');
  });

  test('rejects invalid server URL', () async {
    final repo = _SpySettingsRepository();
    final useCase = SaveAppSettingsUseCase(repo);

    final result = await useCase(
      serverBaseUrl: 'not-a-valid-url',
      llmApiKey: '',
    );

    expect(result, isA<FailureResult<AppSettings>>());
    expect(repo.lastSaved, isNull);
  });

  test('accepts valid https URL and persists', () async {
    final repo = _SpySettingsRepository();
    final useCase = SaveAppSettingsUseCase(repo);

    final result = await useCase(
      serverBaseUrl: 'https://api.example.com',
      llmApiKey: 'k',
    );

    expect(result, isA<Success<AppSettings>>());
    expect(repo.lastSaved?.serverBaseUrl, 'https://api.example.com');
  });

  test('accepts http URL with host', () async {
    final repo = _SpySettingsRepository();
    final useCase = SaveAppSettingsUseCase(repo);

    final result = await useCase(
      serverBaseUrl: 'http://localhost:8080',
      llmApiKey: '',
    );

    expect(result, isA<Success<AppSettings>>());
    expect(repo.lastSaved?.serverBaseUrl, 'http://localhost:8080');
  });
}
