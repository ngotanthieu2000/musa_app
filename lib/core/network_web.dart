import 'dart:html' as html;
import 'dart:js' as js;

// JavaScript interop functions for web
String getCorsProxyUrl() {
  try {
    if (js.context.hasProperty('corsProxyUrl')) {
      return js.context['corsProxyUrl'] as String;
    }
  } catch (e) {
    print('Error accessing JS context: $e');
  }
  return '';
}

// Add cors headers to request
void addCorsHeaders(Map<String, String> headers) {
  headers['Access-Control-Allow-Origin'] = '*';
  headers['Access-Control-Allow-Headers'] = '*';
  headers['Access-Control-Allow-Methods'] = '*';
} 