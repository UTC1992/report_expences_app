import 'package:report_expences_app/features/settings/data/datasources/settings_secure_data_source.dart';

class FakeSettingsSecureDataSource implements SettingsSecureDataSource {
  final Map<String, String> _values = {};

  @override
  Future<Map<String, String>> readAll() async {
    return {
      'serverBaseUrl': _values['serverBaseUrl'] ?? '',
      'llmApiKey': _values['llmApiKey'] ?? '',
      'llmProvider': _values['llmProvider'] ?? '',
    };
  }

  @override
  Future<void> writeAll({
    required String serverBaseUrl,
    required String llmApiKey,
    required String llmProvider,
  }) async {
    _values['serverBaseUrl'] = serverBaseUrl;
    _values['llmApiKey'] = llmApiKey;
    _values['llmProvider'] = llmProvider;
  }
}
