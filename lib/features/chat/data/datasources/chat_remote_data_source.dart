/// Remote API for chat / LLM-backed expense processing.
abstract class ChatRemoteDataSource {
  Future<String> postProcessExpense({
    required String baseUrl,
    required String text,
    required String provider,
    String? apiKey,
  });
}
