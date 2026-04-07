import 'package:report_expences_app/core/error/failures.dart';
import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/settings/domain/entities/app_settings.dart';
import 'package:report_expences_app/features/settings/domain/entities/llm_provider.dart';
import 'package:report_expences_app/features/settings/domain/repositories/settings_repository.dart';

class SaveAppSettingsUseCase {
  SaveAppSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Result<AppSettings>> call({
    required String serverBaseUrl,
    required String llmApiKey,
    LlmProvider llmProvider = LlmProvider.openai,
  }) async {
    final url = serverBaseUrl.trim();
    final key = llmApiKey.trim();

    if (url.isNotEmpty && !_isValidServerBaseUrl(url)) {
      return const FailureResult(
        ValidationFailure('La URL del servidor no es válida.'),
      );
    }

    final settings = AppSettings(
      serverBaseUrl: url,
      llmApiKey: key,
      llmProvider: llmProvider,
    );
    return _repository.save(settings);
  }

  bool _isValidServerBaseUrl(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null) return false;
    if (uri.scheme != 'http' && uri.scheme != 'https') return false;
    if (uri.host.isEmpty) return false;
    return true;
  }
}
