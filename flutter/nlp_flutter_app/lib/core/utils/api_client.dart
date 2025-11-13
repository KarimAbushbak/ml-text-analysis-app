import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../exceptions/api_exceptions.dart';
import '../constants/api_constants.dart';
import 'network_info.dart';

/// API client for making HTTP requests to backend
class ApiClient {
  // Configuration
  static const Duration _timeout = ApiConstants.requestTimeout;
  static const int _maxRetries = ApiConstants.maxRetries;
  static const Duration _initialRetryDelay = ApiConstants.initialRetryDelay;

  static final NetworkInfo _networkInfo = NetworkInfo.create();

  /// Get base URL based on platform
  /// Set USE_PRODUCTION to true to use live Hugging Face Spaces API
  static String get baseUrl {
    // Use production API if enabled
    if (ApiConstants.useProduction) {
      return ApiConstants.productionUrl;
    }
    
    // Otherwise use local backend
    if (Platform.isAndroid) {
      // Android emulator uses 10.0.2.2 to access host localhost
      return ApiConstants.localUrlAndroid;
    } else if (Platform.isIOS) {
      // iOS simulator can use localhost
      return ApiConstants.localUrlIOS;
    } else {
      // Desktop platforms
      return ApiConstants.localUrlDesktop;
    }
  }

  /// Make a POST request with retry logic
  static Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    bool enableRetry = true,
  }) async {
    return _executeWithRetry(
      () => _post(endpoint, body, headers),
      enableRetry: enableRetry,
    );
  }

  /// Make a GET request with retry logic
  static Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, String>? headers,
    bool enableRetry = true,
  }) async {
    return _executeWithRetry(
      () => _get(endpoint, headers),
      enableRetry: enableRetry,
    );
  }

  /// Internal POST method
  static Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, dynamic> body,
    Map<String, String>? headers,
  ) async {
    // Check network connectivity first
    if (!await _networkInfo.isConnected) {
      throw NetworkException();
    }

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              ApiConstants.headerContentType: ApiConstants.headerContentTypeJson,
              if (headers != null) ...headers,
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('Unable to connect to server.');
    } on TimeoutException {
      throw TimeoutException();
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      throw UnknownException('Unexpected error: $e');
    }
  }

  /// Internal GET method
  static Future<Map<String, dynamic>> _get(
    String endpoint,
    Map<String, String>? headers,
  ) async {
    // Check network connectivity first
    if (!await _networkInfo.isConnected) {
      throw NetworkException();
    }

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              ApiConstants.headerContentType: ApiConstants.headerContentTypeJson,
              if (headers != null) ...headers,
            },
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('Unable to connect to server.');
    } on TimeoutException {
      throw TimeoutException();
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      throw UnknownException('Unexpected error: $e');
    }
  }

  /// Execute request with exponential backoff retry logic
  static Future<Map<String, dynamic>> _executeWithRetry(
    Future<Map<String, dynamic>> Function() request, {
    required bool enableRetry,
  }) async {
    int attempts = 0;
    Duration delay = _initialRetryDelay;

    while (true) {
      attempts++;

      try {
        return await request();
      } on NetworkException {
        // Don't retry network exceptions - they're likely persistent
        rethrow;
      } on TimeoutException {
        // Retry timeout exceptions
        if (!enableRetry || attempts >= _maxRetries) {
          rethrow;
        }
      } on ServerException catch (e) {
        // Retry 5xx errors, but not 4xx errors
        if (!enableRetry ||
            attempts >= _maxRetries ||
            (e.statusCode != null && e.statusCode! < 500)) {
          rethrow;
        }
      } catch (e) {
        // For other errors, retry if enabled
        if (!enableRetry || attempts >= _maxRetries) {
          rethrow;
        }
      }

      // Wait before retrying with exponential backoff
      await Future.delayed(delay);
      delay *= 2; // Double the delay for next retry
    }
  }

  /// Handle HTTP response and throw appropriate exceptions
  static Map<String, dynamic> _handleResponse(http.Response response) {
    // Success responses (2xx)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        throw ServerException('Invalid JSON response from server');
      }
    }

    // Parse error message from response if available
    String errorMessage;
    try {
      final errorBody = jsonDecode(response.body);
      errorMessage = errorBody['detail'] ?? errorBody['message'] ?? 'Unknown error';
    } catch (e) {
      errorMessage = response.body.isNotEmpty 
          ? response.body 
          : 'Request failed with status ${response.statusCode}';
    }

    // Throw specific exception based on status code
    switch (response.statusCode) {
      case 400:
        throw BadRequestException(errorMessage);
      case 401:
        throw UnauthorizedException(errorMessage);
      case 403:
        throw ForbiddenException(errorMessage);
      case 404:
        throw NotFoundException(errorMessage);
      case 429:
        throw TooManyRequestsException(errorMessage);
      case 500:
        throw InternalServerException(errorMessage);
      case 503:
        throw ServiceUnavailableException(errorMessage);
      default:
        if (response.statusCode >= 500) {
          throw InternalServerException(errorMessage);
        } else {
          throw ServerException(errorMessage, response.statusCode);
        }
    }
  }

  /// Check if device has internet connection
  static Future<bool> hasConnection() async {
    return await _networkInfo.isConnected;
  }

  /// Get stream of connectivity changes
  static Stream<bool> get connectionStream {
    return _networkInfo.onConnectivityChanged;
  }
}

