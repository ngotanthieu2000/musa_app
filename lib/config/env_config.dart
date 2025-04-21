import 'package:flutter/foundation.dart';

/// Environment configuration
class EnvConfig {
  /// API base URL
  static const String apiBaseUrl = 'http://localhost:8080';
  
  /// App name
  static const String appName = 'Musa App';
  
  /// App version
  static const String appVersion = '1.0.0';
  
  /// Is production environment
  static const bool isProduction = false;
  
  /// API timeout in seconds
  static const int apiTimeout = 30;
  
  /// Maximum retry attempts for API calls
  static const int maxRetryAttempts = 3;
  
  /// Debug mode
  static const bool debugMode = true;
  
  // Trên web có thể cần proxy, trên app native không cần
  static bool get needsCorsProxy => kIsWeb;
  
  // Headers for CORS requests
  static Map<String, String> get corsHeaders => {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, Content-Type, X-Auth-Token, Authorization',
  };
} 