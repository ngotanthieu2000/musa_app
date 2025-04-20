// Utilities for web platform
import 'dart:js_util' as js_util;
import 'package:flutter/foundation.dart';

// Safe method to access JavaScript globals
dynamic getJsGlobal(String name) {
  if (!kIsWeb) return null;
  
  try {
    final window = js_util.getProperty(js_util.globalThis, 'window');
    if (js_util.hasProperty(window, name)) {
      return js_util.getProperty(window, name);
    }
  } catch (e) {
    print('Error accessing JS global $name: $e');
  }
  return null;
}

// Get CORS proxy URL from JavaScript
String getCorsProxyUrl() {
  final proxy = getJsGlobal('corsProxyUrl');
  return proxy != null ? proxy.toString() : '';
}

// Check if we should use the proxy
bool shouldUseProxy() {
  final useProxy = getJsGlobal('useProxy');
  return useProxy != null && useProxy.toString() == 'true';
}

// Add CORS headers to request
void addCorsHeaders(Map<String, dynamic> headers) {
  headers['Access-Control-Allow-Origin'] = '*';
  headers['Access-Control-Allow-Headers'] = '*';
  headers['Access-Control-Allow-Methods'] = '*';
}

// Apply CORS proxy to a URL if needed
String applyProxyToUrl(String originalUrl) {
  if (!kIsWeb || !shouldUseProxy()) return originalUrl;
  
  final corsProxyUrl = getCorsProxyUrl();
  if (corsProxyUrl.isEmpty) return originalUrl;
  
  // For APIs using query parameters with allOrigins, we need special handling
  if (corsProxyUrl.contains('allorigins.win')) {
    return '$corsProxyUrl${Uri.encodeComponent(originalUrl)}';
  }
  
  // For other proxies like cors-anywhere
  return '$corsProxyUrl$originalUrl';
} 