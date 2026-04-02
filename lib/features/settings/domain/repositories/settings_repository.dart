import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/settings/domain/entities/app_settings.dart';

abstract class SettingsRepository {
  Future<Result<AppSettings>> load();

  Future<Result<AppSettings>> save(AppSettings settings);
}
