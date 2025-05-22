import 'package:flutter/material.dart';

/// Class chứa các màu sắc được sử dụng trong ứng dụng
class AppColors {
  // Primary - Sử dụng màu xanh dương hiện đại và sang trọng
  static const primary = Color(0xFF3B82F6);       // Blue-500
  static const primaryDark = Color(0xFF2563EB);   // Blue-600
  static const primaryLight = Color(0xFF60A5FA);  // Blue-400
  static const primaryLighter = Color(0xFFBFDBFE); // Blue-200
  static const primaryLightest = Color(0xFFEFF6FF); // Blue-50

  // Secondary - Sử dụng màu tím nhẹ nhàng và tinh tế
  static const secondary = Color(0xFF8B5CF6);     // Violet-500
  static const secondaryDark = Color(0xFF7C3AED);  // Violet-600
  static const secondaryLight = Color(0xFFA78BFA); // Violet-400
  static const secondaryLighter = Color(0xFFDDD6FE); // Violet-200
  static const secondaryLightest = Color(0xFFF5F3FF); // Violet-50

  // Neutral - Sử dụng màu xám tinh tế
  static const neutral900 = Color(0xFF111827);    // Gray-900
  static const neutral800 = Color(0xFF1F2937);    // Gray-800
  static const neutral700 = Color(0xFF374151);    // Gray-700
  static const neutral600 = Color(0xFF4B5563);    // Gray-600
  static const neutral500 = Color(0xFF6B7280);    // Gray-500
  static const neutral400 = Color(0xFF9CA3AF);    // Gray-400
  static const neutral300 = Color(0xFFD1D5DB);    // Gray-300
  static const neutral200 = Color(0xFFE5E7EB);    // Gray-200
  static const neutral100 = Color(0xFFF3F4F6);    // Gray-100
  static const neutral50 = Color(0xFFF9FAFB);     // Gray-50

  // Background
  static const backgroundDark = Color(0xFF0F172A);  // Slate-900
  static const backgroundLight = Color(0xFFF8FAFC); // Slate-50

  // Card
  static const cardDark = Color(0xFF1E293B);      // Slate-800
  static const cardLight = Color(0xFFFFFFFF);     // White

  // Text
  static const textPrimaryDark = Color(0xFFF8FAFC);  // Slate-50
  static const textPrimaryLight = Color(0xFF0F172A); // Slate-900
  static const textSecondaryDark = Color(0xFFCBD5E1); // Slate-300
  static const textSecondaryLight = Color(0xFF475569); // Slate-600
  static const textTertiaryDark = Color(0xFF94A3B8);  // Slate-400
  static const textTertiaryLight = Color(0xFF64748B); // Slate-500

  // Status Colors
  static const successDark = Color(0xFF10B981);   // Emerald-500
  static const successLight = Color(0xFF34D399);  // Emerald-400
  static const warningDark = Color(0xFFF59E0B);   // Amber-500
  static const warningLight = Color(0xFFFBBF24);  // Amber-400
  static const errorDark = Color(0xFFEF4444);     // Red-500
  static const errorLight = Color(0xFFF87171);    // Red-400
  static const infoDark = Color(0xFF0EA5E9);      // Sky-500
  static const infoLight = Color(0xFF38BDF8);     // Sky-400

  // Accent
  static const accentDark = Color(0xFFEC4899);    // Pink-500
  static const accentLight = Color(0xFFF472B6);   // Pink-400

  // Surface
  static const surfaceDark = Color(0xFF334155);   // Slate-700
  static const surfaceLight = Color(0xFFF1F5F9);  // Slate-100

  // Border
  static const borderDark = Color(0xFF475569);    // Slate-600
  static const borderLight = Color(0xFFE2E8F0);   // Slate-200

  // Shadow
  static const shadowDark = Color(0x80000000);
  static const shadowLight = Color(0x10000000);

  // Overlay
  static const overlayDark = Color(0x80000000);
  static const overlayLight = Color(0x10000000);

  // Divider
  static const dividerDark = Color(0xFF334155);   // Slate-700
  static const dividerLight = Color(0xFFE2E8F0);  // Slate-200

  // Icon
  static const iconDark = Color(0xFFCBD5E1);      // Slate-300
  static const iconLight = Color(0xFF64748B);     // Slate-500

  // Task Priority Colors
  static const priorityLow = Color(0xFF34D399);    // Emerald-400
  static const priorityMedium = Color(0xFF60A5FA); // Blue-400
  static const priorityHigh = Color(0xFFFBBF24);   // Amber-400
  static const priorityCritical = Color(0xFFF87171); // Red-400

  // Task Category Colors
  static const categoryGeneral = Color(0xFF60A5FA);  // Blue-400
  static const categoryWork = Color(0xFF818CF8);     // Indigo-400
  static const categoryPersonal = Color(0xFFA78BFA); // Violet-400
  static const categoryShopping = Color(0xFFF472B6); // Pink-400
  static const categoryHealth = Color(0xFF34D399);   // Emerald-400
}