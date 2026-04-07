import 'package:report_expences_app/core/error/failures.dart';
import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/settings/data/datasources/settings_secure_data_source.dart';
import 'package:report_expences_app/features/settings/domain/entities/app_settings.dart';
import 'package:report_expences_app/features/settings/domain/entities/llm_provider.dart';
import 'package:report_expences_app/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._dataSource);

  final SettingsSecureDataSource _dataSource;

  @override
  Future<Result<AppSettings>> load() async {
    try {
      final map = await _dataSource.readAll();
      return Success(
        AppSettings(
          serverBaseUrl: map['serverBaseUrl'] ?? '',
          llmApiKey: map['llmApiKey'] ?? '',
          llmProvider: LlmProvider.fromStored(map['llmProvider']),
        ),
      );
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<AppSettings>> save(AppSettings settings) async {
    try {
      await _dataSource.writeAll(
        serverBaseUrl: settings.serverBaseUrl,
        llmApiKey: settings.llmApiKey,
        llmProvider: settings.llmProvider.name,
      );
      return Success(settings);
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }
}
