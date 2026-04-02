class AppSettings {
  const AppSettings({
    required this.serverBaseUrl,
    required this.llmApiKey,
  });

  final String serverBaseUrl;
  final String llmApiKey;

  static const empty = AppSettings(serverBaseUrl: '', llmApiKey: '');
}
