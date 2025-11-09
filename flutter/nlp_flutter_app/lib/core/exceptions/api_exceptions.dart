
/// Base class for all API exceptions
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

/// Thrown when there's no internet connection
class NetworkException extends ApiException {
  NetworkException([String? message])
      : super(message ?? 'No internet connection. Please check your network settings.');
}

/// Thrown when the request times out
class TimeoutException extends ApiException {
  TimeoutException([String? message])
      : super(message ?? 'Request timed out. Please try again.');
}

/// Thrown when the server returns an error (4xx or 5xx)
class ServerException extends ApiException {
  ServerException(super.message, [super.statusCode]);
}

/// Thrown when the request is invalid (400 Bad Request)
class BadRequestException extends ApiException {
  BadRequestException([String? message])
      : super(message ?? 'Invalid request. Please check your input.', 400);
}

/// Thrown when authentication fails (401 Unauthorized)
class UnauthorizedException extends ApiException {
  UnauthorizedException([String? message])
      : super(message ?? 'Authentication failed. Please login again.', 401);
}

/// Thrown when access is forbidden (403 Forbidden)
class ForbiddenException extends ApiException {
  ForbiddenException([String? message])
      : super(message ?? 'Access forbidden.', 403);
}

/// Thrown when resource is not found (404 Not Found)
class NotFoundException extends ApiException {
  NotFoundException([String? message])
      : super(message ?? 'Resource not found.', 404);
}

/// Thrown when too many requests are made (429 Too Many Requests)
class TooManyRequestsException extends ApiException {
  TooManyRequestsException([String? message])
      : super(message ?? 'Too many requests. Please try again later.', 429);
}

/// Thrown when server has an internal error (500 Internal Server Error)
class InternalServerException extends ApiException {
  InternalServerException([String? message])
      : super(message ?? 'Server error. Please try again later.', 500);
}

/// Thrown when server is unavailable (503 Service Unavailable)
class ServiceUnavailableException extends ApiException {
  ServiceUnavailableException([String? message])
      : super(message ?? 'Service temporarily unavailable. Please try again later.', 503);
}

/// Thrown when an unknown error occurs
class UnknownException extends ApiException {
  UnknownException([String? message])
      : super(message ?? 'An unexpected error occurred. Please try again.');
}

