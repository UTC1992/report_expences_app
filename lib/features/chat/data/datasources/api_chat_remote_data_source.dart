import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:report_expences_app/core/network/api_exception.dart';
import 'package:report_expences_app/core/network/api_uri_builder.dart';
import 'package:report_expences_app/features/chat/data/datasources/chat_remote_data_source.dart';

class ApiChatRemoteDataSource implements ChatRemoteDataSource {
  ApiChatRemoteDataSource({required http.Client httpClient})
      : _httpClient = httpClient;

  final http.Client _httpClient;

  @override
  Future<String> postProcessExpense({
    required String baseUrl,
    required String text,
    String? apiKey,
  }) async {
    final uri = ApiUriBuilder.build(baseUrl, '/chat/process_expense');
    final payload = <String, dynamic>{
      'text': text,
      'provider': 'openai',
      if (apiKey != null && apiKey.isNotEmpty) 'apiKey': apiKey,
    };

    final response = await _httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        _readProblemDetail(response.body) ??
            'Error al procesar el mensaje (${response.statusCode}).',
        statusCode: response.statusCode,
      );
    }

    return response.body;
  }

  String? _readProblemDetail(String body) {
    try {
      final map = jsonDecode(body) as Map<String, dynamic>;
      return map['detail'] as String? ?? map['title'] as String?;
    } catch (_) {
      return null;
    }
  }
}
