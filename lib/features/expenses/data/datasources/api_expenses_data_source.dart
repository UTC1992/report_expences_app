import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:report_expences_app/core/network/api_exception.dart';
import 'package:report_expences_app/core/network/api_uri_builder.dart';
import 'package:report_expences_app/core/result/result.dart';
import 'package:report_expences_app/features/expenses/data/datasources/expenses_data_source.dart';
import 'package:report_expences_app/features/expenses/data/models/expense_model.dart';
import 'package:report_expences_app/features/settings/domain/repositories/settings_repository.dart';

class ApiExpensesDataSource implements ExpensesDataSource {
  ApiExpensesDataSource({
    required http.Client httpClient,
    required SettingsRepository settingsRepository,
  })  : _httpClient = httpClient,
        _settingsRepository = settingsRepository;

  final http.Client _httpClient;
  final SettingsRepository _settingsRepository;

  @override
  Future<List<ExpenseModel>> fetchExpenses() async {
    final settingsResult = await _settingsRepository.load();
    final settings = switch (settingsResult) {
      Success(:final data) => data,
      FailureResult() => throw ApiException(
          'No se pudieron leer los ajustes del servidor.',
        ),
    };

    final base = settings.serverBaseUrl.trim();
    if (base.isEmpty) {
      throw ApiException(
        'Configura la URL del servidor en Configuración.',
      );
    }

    final uri = ApiUriBuilder.build(base, '/expenses');
    final response = await _httpClient.get(uri, headers: _jsonHeaders);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        _extractErrorDetail(response.body) ??
            'Error al cargar gastos (${response.statusCode}).',
        statusCode: response.statusCode,
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final items = decoded['items'] as List<dynamic>? ?? [];
    return items
        .map((e) => ExpenseModel.fromExpenseListItemJson(
              Map<String, dynamic>.from(e as Map),
            ))
        .toList();
  }

  Map<String, String> get _jsonHeaders => {
        'Accept': 'application/json',
      };

  String? _extractErrorDetail(String body) {
    try {
      final map = jsonDecode(body) as Map<String, dynamic>;
      return map['detail'] as String? ?? map['title'] as String?;
    } catch (_) {
      return null;
    }
  }
}
