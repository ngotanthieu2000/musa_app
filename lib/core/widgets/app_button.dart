import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

enum AppButtonType { primary, secondary, outlined, text }
enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final bool iconOnly;
  final double? iconSize;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconOnly = false,
    this.iconSize,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Get size based on AppButtonSize
    double buttonHeight;
    double fontSize;
    double defaultIconSize;
    
    switch (size) {
      case AppButtonSize.small:
        buttonHeight = AppDimensions.buttonHeightS;
        fontSize = 14;
        defaultIconSize = AppDimensions.iconSizeS;
        break;
      case AppButtonSize.medium:
        buttonHeight = AppDimensions.buttonHeightM;
        fontSize = 16;
        defaultIconSize = AppDimensions.iconSizeM;
        break;
      case AppButtonSize.large:
        buttonHeight = AppDimensions.buttonHeightL;
        fontSize = 18;
        defaultIconSize = AppDimensions.iconSizeM;
        break;
    }
    
    // Define style based on button type
    ButtonStyle buttonStyle;
    
    switch (type) {
      case AppButtonType.primary:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
          foregroundColor: Colors.white,
          disabledBackgroundColor: isDarkMode 
              ? AppColors.primaryDark.withOpacity(0.5) 
              : AppColors.primaryLight.withOpacity(0.5),
          disabledForegroundColor: Colors.white.withOpacity(0.5),
          textStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          padding: padding ?? _getPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusM),
          ),
          elevation: 0,
          minimumSize: Size(0, buttonHeight),
        );
        break;
      case AppButtonType.secondary:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: isDarkMode ? AppColors.secondaryDark : AppColors.secondaryLight,
          foregroundColor: Colors.white,
          disabledBackgroundColor: isDarkMode 
              ? AppColors.secondaryDark.withOpacity(0.5) 
              : AppColors.secondaryLight.withOpacity(0.5),
          disabledForegroundColor: Colors.white.withOpacity(0.5),
          textStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          padding: padding ?? _getPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusM),
          ),
          elevation: 0,
          minimumSize: Size(0, buttonHeight),
        );
        break;
      case AppButtonType.outlined:
        buttonStyle = OutlinedButton.styleFrom(
          foregroundColor: isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
          disabledForegroundColor: isDarkMode 
              ? AppColors.primaryDark.withOpacity(0.5) 
              : AppColors.primaryLight.withOpacity(0.5),
          textStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          padding: padding ?? _getPadding(),
          side: BorderSide(
            color: isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusM),
          ),
          minimumSize: Size(0, buttonHeight),
        );
        break;
      case AppButtonType.text:
        buttonStyle = TextButton.styleFrom(
          foregroundColor: isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
          disabledForegroundColor: isDarkMode 
              ? AppColors.primaryDark.withOpacity(0.5) 
              : AppColors.primaryLight.withOpacity(0.5),
          textStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          padding: padding ?? _getPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusM),
          ),
          minimumSize: Size(0, buttonHeight),
        );
        break;
    }
    
    // Widget for the button content - text, icon, or loading indicator
    Widget buttonContent;
    
    if (isLoading) {
      buttonContent = SizedBox(
        height: defaultIconSize,
        width: defaultIconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == AppButtonType.outlined || type == AppButtonType.text
                ? (isDarkMode ? AppColors.primaryDark : AppColors.primaryLight)
                : Colors.white,
          ),
        ),
      );
    } else if (iconOnly && icon != null) {
      buttonContent = Icon(
        icon,
        size: iconSize ?? defaultIconSize,
      );
    } else if (icon != null) {
      buttonContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize ?? defaultIconSize,
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Text(text),
        ],
      );
    } else {
      buttonContent = Text(text);
    }
    
    // Render the button based on type
    Widget button;
    
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonContent,
        );
        break;
      case AppButtonType.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonContent,
        );
        break;
      case AppButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonContent,
        );
        break;
    }
    
    // If full width, wrap in SizedBox.expand
    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }
    
    return button;
  }
  
  EdgeInsets _getPadding() {
    if (iconOnly) {
      // For icon-only buttons, use square padding
      return const EdgeInsets.all(AppDimensions.spacingM);
    }
    
    // For text or text+icon buttons, use horizontal padding
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingXS,
        );
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingL,
          vertical: AppDimensions.spacingS,
        );
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingXL,
          vertical: AppDimensions.spacingM,
        );
    }
  }
} 