import 'package:flutter/material.dart';

class AppColors {
  // Chế độ sáng
  static const Color primaryLight = Color(0xFF2563EB);
  static const Color secondaryLight = Color(0xFF10B981);
  static const Color accentLight = Color(0xFFF59E0B);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color errorLight = Color(0xFFEF4444);
  static const Color warningLight = Color(0xFFF97316);
  static const Color successLight = Color(0xFF22C55E);
  static const Color infoLight = Color(0xFF3B82F6);
  
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textSecondaryLight = Color(0xFF4B5563);
  static const Color textTertiaryLight = Color(0xFF9CA3AF);
  static const Color textInverseLight = Color(0xFFFFFFFF);
  
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color shadowLight = Color(0x1A000000);
  
  // Chế độ tối
  static const Color primaryDark = Color(0xFF3B82F6);
  static const Color secondaryDark = Color(0xFF34D399);
  static const Color accentDark = Color(0xFFFBBF24);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color surfaceDark = Color(0xFF1F2937);
  static const Color errorDark = Color(0xFFF87171);
  static const Color warningDark = Color(0xFFFB923C);
  static const Color successDark = Color(0xFF4ADE80);
  static const Color infoDark = Color(0xFF60A5FA);
  
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textTertiaryDark = Color(0xFF6B7280);
  static const Color textInverseDark = Color(0xFF111827);
  
  static const Color dividerDark = Color(0xFF374151);
  static const Color cardDark = Color(0xFF1F2937);
  static const Color shadowDark = Color(0x1AFFFFFF);
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2563EB),
      Color(0xFF3B82F6),
    ],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF10B981),
      Color(0xFF34D399),
    ],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF59E0B),
      Color(0xFFFBBF24),
    ],
  );
} 