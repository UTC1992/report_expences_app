/// Builds absolute API URLs from a user-configured server base (from secure storage).
class ApiUriBuilder {
  ApiUriBuilder._();

  static const apiV1Prefix = '/api/v1';

  static Uri build(String serverBaseUrl, String pathWithinApiV1) {
    final base = serverBaseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    final path = pathWithinApiV1.startsWith('/')
        ? pathWithinApiV1
        : '/$pathWithinApiV1';
    return Uri.parse('$base$apiV1Prefix$path');
  }
}
