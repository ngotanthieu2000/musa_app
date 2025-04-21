/// Enum for categorizing API errors
enum ApiErrorType {
  /// Server error (5xx status codes)
  server,
  
  /// Client error (4xx status codes)
  client,
  
  /// Authentication error (401, 403 status codes)
  auth,
  
  /// Validation error (422 status code)
  validation,
  
  /// Resource not found (404 status code)
  notFound,
  
  /// Network connection error
  network,
  
  /// Timeout error
  timeout,
  
  /// Cache error
  cache,
  
  /// CORS error
  cors,
  
  /// Unknown error
  unknown,
} 