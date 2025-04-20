import 'package:flutter/foundation.dart';

class EnvConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api/v1',
  );
  
  // Trên web có thể cần proxy, trên app native không cần
  static bool get needsCorsProxy => kIsWeb;
  
  // Headers for CORS requests
  static Map<String, String> get corsHeaders => {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, Content-Type, X-Auth-Token, Authorization',
  };
} 