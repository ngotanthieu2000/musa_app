import 'package:flutter/material.dart';

/// Extension to provide responsive size utilities for BuildContext
extension ResponsiveSize on BuildContext {
  /// Returns the screen size
  Size get screenSize => MediaQuery.of(this).size;
  
  /// Returns screen width
  double get width => screenSize.width;
  
  /// Returns screen height
  double get height => screenSize.height;
  
  /// Returns true if screen width is less than 600px (considered mobile)
  bool get isMobile => width < 600;
  
  /// Returns true if screen width is between 600px and 900px (considered tablet)
  bool get isTablet => width >= 600 && width < 900;
  
  /// Returns true if screen width is greater than 900px (considered desktop)
  bool get isDesktop => width >= 900;
  
  /// Returns a percentage of screen width
  double widthPercent(double percent) => width * percent;
  
  /// Returns a percentage of screen height
  double heightPercent(double percent) => height * percent;
  
  /// Returns a value based on screen size category
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
} 