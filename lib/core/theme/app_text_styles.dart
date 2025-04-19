import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryLight,
    height: 1.2,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryLight,
    height: 1.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
    height: 1.4,
  );
  
  static const TextStyle subtitle1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
    letterSpacing: 0.15,
    height: 1.4,
  );
  
  static const TextStyle subtitle2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryLight,
    letterSpacing: 0.1,
    height: 1.5,
  );
  
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryLight,
    letterSpacing: 0.5,
    height: 1.5,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryLight,
    letterSpacing: 0.25,
    height: 1.5,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryLight,
    letterSpacing: 0.4,
    height: 1.5,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
    height: 1.5,
  );
  
  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiaryLight,
    letterSpacing: 1.5,
    height: 1.5,
  );
  
  // Text styles with primary color
  static const TextStyle subtitle1Primary = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryLight,
    letterSpacing: 0.15,
    height: 1.4,
  );
  
  static const TextStyle subtitle2Primary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryLight,
    letterSpacing: 0.1,
    height: 1.5,
  );
  
  static const TextStyle body1Primary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryLight,
    letterSpacing: 0.5,
    height: 1.5,
  );
  
  static const TextStyle body2Primary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryLight,
    letterSpacing: 0.25,
    height: 1.5,
  );
  
  // Text styles with secondary color
  static const TextStyle body1Secondary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryLight,
    letterSpacing: 0.5,
    height: 1.5,
  );
  
  static const TextStyle body2Secondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryLight,
    letterSpacing: 0.25,
    height: 1.5,
  );
  
  // Text styles for dark theme
  static TextStyle heading1Dark = heading1.copyWith(
    color: AppColors.textPrimaryDark,
  );
  
  static TextStyle heading2Dark = heading2.copyWith(
    color: AppColors.textPrimaryDark,
  );
  
  static TextStyle heading3Dark = heading3.copyWith(
    color: AppColors.textPrimaryDark,
  );
  
  static TextStyle subtitle1Dark = subtitle1.copyWith(
    color: AppColors.textPrimaryDark,
  );
  
  static TextStyle subtitle2Dark = subtitle2.copyWith(
    color: AppColors.textPrimaryDark,
  );
  
  static TextStyle body1Dark = body1.copyWith(
    color: AppColors.textPrimaryDark,
  );
  
  static TextStyle body2Dark = body2.copyWith(
    color: AppColors.textPrimaryDark,
  );
  
  static TextStyle captionDark = caption.copyWith(
    color: AppColors.textSecondaryDark,
  );
  
  static TextStyle buttonDark = button.copyWith(
    color: Colors.white,
  );
  
  static TextStyle overlineDark = overline.copyWith(
    color: AppColors.textTertiaryDark,
  );
} 