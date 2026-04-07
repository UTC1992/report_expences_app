import 'package:flutter/foundation.dart';
import 'package:report_expences_app/core/error/failures.dart';
import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/settings/domain/entities/llm_provider.dart';
import 'package:report_expences_app/features/settings/domain/use_cases/get_app_settings_use_case.dart';
import 'package:report_expences_app/features/settings/domain/use_cases/save_app_settings_use_case.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({
    required GetAppSettingsUseCase getSettings,
    required SaveAppSettingsUseCase saveSettings,
  })  : _getSettings = getSettings,
        _saveSettings = saveSettings;

  final GetAppSettingsUseCase _getSettings;
  final SaveAppSettingsUseCase _saveSettings;

  bool _loading = false;
  bool _saving = false;
  String _serverBaseUrl = '';
  String _llmApiKey = '';
  LlmProvider _llmProvider = LlmProvider.openai;
  String? _errorMessage;

  bool get isLoading => _loading;

  bool get isSaving => _saving;

  String get serverBaseUrl => _serverBaseUrl;

  String get llmApiKey => _llmApiKey;

  LlmProvider get llmProvider => _llmProvider;

  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getSettings();
    switch (result) {
      case Success(:final data):
        _serverBaseUrl = data.serverBaseUrl;
        _llmApiKey = data.llmApiKey;
        _llmProvider = data.llmProvider;
      case FailureResult():
        _errorMessage = 'No se pudieron cargar los ajustes.';
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> save({
    required String serverBaseUrl,
    required String llmApiKey,
    LlmProvider llmProvider = LlmProvider.openai,
  }) async {
    _saving = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _saveSettings(
      serverBaseUrl: serverBaseUrl,
      llmApiKey: llmApiKey,
      llmProvider: llmProvider,
    );

    switch (result) {
      case Success(:final data):
        _serverBaseUrl = data.serverBaseUrl;
        _llmApiKey = data.llmApiKey;
        _llmProvider = data.llmProvider;
      case FailureResult(:final failure):
        _errorMessage = switch (failure) {
          ValidationFailure(:final message) => message,
          _ => 'No se pudieron guardar los ajustes.',
        };
    }

    _saving = false;
    notifyListeners();
  }
}
