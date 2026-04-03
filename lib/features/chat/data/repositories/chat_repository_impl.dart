import 'dart:convert';

import 'package:report_expences_app/core/error/failures.dart';
import 'package:report_expences_app/core/network/api_exception.dart';
import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:report_expences_app/features/chat/domain/entities/process_expense_result.dart';
import 'package:report_expences_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:report_expences_app/features/settings/domain/repositories/settings_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required ChatRemoteDataSource remoteDataSource,
    required SettingsRepository settingsRepository,
  })  : _remoteDataSource = remoteDataSource,
        _settingsRepository = settingsRepository;

  final ChatRemoteDataSource _remoteDataSource;
  final SettingsRepository _settingsRepository;

  @override
  Future<Result<ProcessExpenseResult>> processExpenseText(String text) async {
    final settingsResult = await _settingsRepository.load();
    switch (settingsResult) {
      case FailureResult(:final failure):
        return FailureResult(failure);
      case Success(:final data):
        final base = data.serverBaseUrl.trim();
        if (base.isEmpty) {
          return const FailureResult(
            ValidationFailure(
              'Configura la URL del servidor en Configuración.',
            ),
          );
        }

        final apiKey = data.llmApiKey.trim();
        try {
          final body = await _remoteDataSource.postProcessExpense(
            baseUrl: base,
            text: text,
            apiKey: apiKey.isEmpty ? null : apiKey,
          );
          final map = jsonDecode(body) as Map<String, dynamic>;
          return Success(_mapResponse(map));
        } on ApiException catch (e) {
          return FailureResult(UnknownFailure(e.message));
        } catch (e) {
          return FailureResult(UnknownFailure(e.toString()));
        }
    }
  }

  ProcessExpenseResult _mapResponse(Map<String, dynamic> json) {
    final duplicate = json['duplicate'] as bool? ?? false;
    if (duplicate) {
      return const ProcessExpenseResult(
        saved: false,
        duplicate: true,
        assistantReply:
            'Este gasto ya estaba registrado; no se guardó de nuevo.',
      );
    }

    final saved = json['saved'] as bool? ?? false;
    if (saved) {
      final exp = json['expense'] as Map<String, dynamic>?;
      final desc = exp?['description'] as String? ?? 'Gasto';
      final amt = exp?['amount'];
      final provider = exp?['providerName'] as String?;
      final buf = StringBuffer('Gasto guardado: $desc');
      if (amt != null) {
        buf.write(' ($amt)');
      }
      if (provider != null && provider.isNotEmpty) {
        buf.write(' · $provider');
      }
      buf.write('.');
      return ProcessExpenseResult(
        saved: true,
        duplicate: false,
        expenseId: json['expenseId'] as String?,
        assistantReply: buf.toString(),
      );
    }

    return const ProcessExpenseResult(
      saved: false,
      duplicate: false,
      assistantReply: 'No se pudo guardar el gasto.',
    );
  }
}
