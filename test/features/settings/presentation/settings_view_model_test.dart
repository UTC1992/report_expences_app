import 'package:flutter_test/flutter_test.dart';
import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/settings/domain/entities/app_settings.dart';
import 'package:report_expences_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:report_expences_app/features/settings/domain/use_cases/get_app_settings_use_case.dart';
import 'package:report_expences_app/features/settings/domain/use_cases/save_app_settings_use_case.dart';
import 'package:report_expences_app/features/settings/presentation/view_models/settings_view_model.dart';

class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository({required this.loadValue});

  AppSettings loadValue;
  AppSettings? lastSaved;

  @override
  Future<Result<AppSettings>> load() async => Success(loadValue);

  @override
  Future<Result<AppSettings>> save(AppSettings settings) async {
    lastSaved = settings;
    loadValue = settings;
    return Success(settings);
  }
}

void main() {
  test('load copies repository values into view state', () async {
    final repo = _FakeSettingsRepository(
      loadValue: const AppSettings(
        serverBaseUrl: 'https://api.test',
        llmApiKey: 'secret',
      ),
    );
    final vm = SettingsViewModel(
      getSettings: GetAppSettingsUseCase(repo),
      saveSettings: SaveAppSettingsUseCase(repo),
    );

    await vm.load();

    expect(vm.isLoading, isFalse);
    expect(vm.serverBaseUrl, 'https://api.test');
    expect(vm.llmApiKey, 'secret');
    expect(vm.errorMessage, isNull);
  });

  test('save updates state on success', () async {
    final repo = _FakeSettingsRepository(loadValue: AppSettings.empty);
    final vm = SettingsViewModel(
      getSettings: GetAppSettingsUseCase(repo),
      saveSettings: SaveAppSettingsUseCase(repo),
    );

    await vm.save(
      serverBaseUrl: 'https://ok.example',
      llmApiKey: 't1',
    );

    expect(vm.isSaving, isFalse);
    expect(vm.serverBaseUrl, 'https://ok.example');
    expect(vm.llmApiKey, 't1');
    expect(vm.errorMessage, isNull);
    expect(repo.lastSaved?.serverBaseUrl, 'https://ok.example');
  });

  test('save exposes validation message when URL invalid', () async {
    final repo = _FakeSettingsRepository(loadValue: AppSettings.empty);
    final vm = SettingsViewModel(
      getSettings: GetAppSettingsUseCase(repo),
      saveSettings: SaveAppSettingsUseCase(repo),
    );

    await vm.save(
      serverBaseUrl: 'bad',
      llmApiKey: '',
    );

    expect(vm.errorMessage, isNotNull);
    expect(repo.lastSaved, isNull);
  });
}
