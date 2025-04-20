// Base API exception class
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, [this.statusCode, this.data]);

  @override
  String toString() => 'ApiException: $message (${statusCode ?? 'unknown'})';
}

// Specific API exceptions
class BadRequestException extends ApiException {
  BadRequestException(String message, [dynamic data])
      : super(message, 400, data);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message, [dynamic data])
      : super(message, 401, data);
}

class ForbiddenException extends ApiException {
  ForbiddenException(String message, [dynamic data])
      : super(message, 403, data);
}

class NotFoundException extends ApiException {
  NotFoundException(String message, [dynamic data])
      : super(message, 404, data);
}

class ConflictException extends ApiException {
  ConflictException(String message, [dynamic data])
      : super(message, 409, data);
}

class ServerException extends ApiException {
  ServerException(String message, [dynamic data])
      : super(message, 500, data);
}

// Local exceptions
class CacheException implements Exception {
  final String message;
  
  CacheException([this.message = 'Cache operation failed']);
  
  @override
  String toString() => 'CacheException: $message';
} 