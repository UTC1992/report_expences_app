import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:report_expences_app/features/settings/data/datasources/settings_secure_data_source.dart';

class SettingsSecureDataSourceImpl implements SettingsSecureDataSource {
  SettingsSecureDataSourceImpl(this._storage);

  final FlutterSecureStorage _storage;

  static const _serverKey = 'settings_server_base_url';
  static const _llmKey = 'settings_llm_api_key';
  static const _llmProviderKey = 'settings_llm_provider';

  @override
  Future<Map<String, String>> readAll() async {
    final server = await _storage.read(key: _serverKey) ?? '';
    final llm = await _storage.read(key: _llmKey) ?? '';
    final provider = await _storage.read(key: _llmProviderKey) ?? '';
    return {
      'serverBaseUrl': server,
      'llmApiKey': llm,
      'llmProvider': provider,
    };
  }

  @override
  Future<void> writeAll({
    required String serverBaseUrl,
    required String llmApiKey,
    required String llmProvider,
  }) async {
    await _storage.write(key: _serverKey, value: serverBaseUrl);
    await _storage.write(key: _llmKey, value: llmApiKey);
    await _storage.write(key: _llmProviderKey, value: llmProvider);
  }
}
