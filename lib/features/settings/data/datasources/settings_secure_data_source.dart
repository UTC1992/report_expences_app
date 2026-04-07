/// Persists sensitive settings using platform secure storage (encrypted at rest).
abstract class SettingsSecureDataSource {
  Future<Map<String, String>> readAll();

  Future<void> writeAll({
    required String serverBaseUrl,
    required String llmApiKey,
    required String llmProvider,
  });
}
