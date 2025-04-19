import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final BorderRadius? borderRadius;
  final EdgeInsets? contentPadding;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.inputFormatters,
    this.focusNode,
    this.borderRadius,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      enabled: enabled,
      readOnly: readOnly,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: isDarkMode
            ? AppColors.textPrimaryDark
            : AppColors.textPrimaryLight,
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      cursorColor: isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingL,
              vertical: AppDimensions.spacingL,
            ),
        filled: true,
        fillColor: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefix: prefix,
        suffix: suffix,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
            width: AppDimensions.borderWidthRegular,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
            width: AppDimensions.borderWidthRegular,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
            width: AppDimensions.borderWidthThick,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.errorDark : AppColors.errorLight,
            width: AppDimensions.borderWidthRegular,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.errorDark : AppColors.errorLight,
            width: AppDimensions.borderWidthThick,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(
            color: isDarkMode 
                ? AppColors.dividerDark.withOpacity(0.5) 
                : AppColors.dividerLight.withOpacity(0.5),
            width: AppDimensions.borderWidthRegular,
          ),
        ),
      ),
    );
  }
} 