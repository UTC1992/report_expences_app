import 'package:report_expences_app/features/settings/domain/entities/llm_provider.dart';

class AppSettings {
  const AppSettings({
    required this.serverBaseUrl,
    required this.llmApiKey,
    this.llmProvider = LlmProvider.openai,
  });

  final String serverBaseUrl;
  final String llmApiKey;
  final LlmProvider llmProvider;

  static const empty = AppSettings(
    serverBaseUrl: '',
    llmApiKey: '',
    llmProvider: LlmProvider.openai,
  );
}
