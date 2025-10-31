import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// API client for making HTTP requests to backend
class ApiClient {
  /// Get base URL based on platform
  static String get baseUrl {
    if (Platform.isAndroid) {
      // Android emulator uses 10.0.2.2 to access host localhost
      return 'http://10.0.2.2:8000';
    } else if (Platform.isIOS) {
      // iOS simulator can use localhost
      return 'http://localhost:8000';
    } else {
      // Desktop platforms
      return 'http://localhost:8000';
    }
  }

  /// Make a POST request
  static Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (headers != null) ...headers,
        },
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Make a GET request
  static Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (headers != null) ...headers,
        },
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Handle HTTP response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return <String, dynamic>{};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        'Request failed with status: ${response.statusCode}\n'
        'Response: ${response.body}',
      );
    }
  }
}

