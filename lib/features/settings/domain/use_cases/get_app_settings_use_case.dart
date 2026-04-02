import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/settings/domain/entities/app_settings.dart';
import 'package:report_expences_app/features/settings/domain/repositories/settings_repository.dart';

class GetAppSettingsUseCase {
  GetAppSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Result<AppSettings>> call() => _repository.load();
}
