import 'dart:js_util' as js_util;

// Enable CORS proxy in browser environment
void enableCorsProxy() {
  try {
    final window = js_util.getProperty(js_util.globalThis, 'window');
    js_util.setProperty(window, 'useProxy', true);
    
    // Also log to console
    final console = js_util.getProperty(js_util.globalThis, 'console');
    js_util.callMethod(console, 'log', ['CORS proxy enabled via Flutter app']);
    
  } catch (e) {
    print('Error enabling CORS proxy: $e');
  }
} 