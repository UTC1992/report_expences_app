import 'package:report_expences_app/features/settings/data/datasources/settings_secure_data_source.dart';

class FakeSettingsSecureDataSource implements SettingsSecureDataSource {
  final Map<String, String> _values = {};

  @override
  Future<Map<String, String>> readAll() async {
    return {
      'serverBaseUrl': _values['serverBaseUrl'] ?? '',
      'llmApiKey': _values['llmApiKey'] ?? '',
    };
  }

  @override
  Future<void> writeAll({
    required String serverBaseUrl,
    required String llmApiKey,
  }) async {
    _values['serverBaseUrl'] = serverBaseUrl;
    _values['llmApiKey'] = llmApiKey;
  }
}
