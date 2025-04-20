import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum AppButtonType {
  primary,
  secondary,
  tertiary,
  text,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isFullWidth;
  final bool isLoading;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;
  
  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isFullWidth = false,
    this.isLoading = false,
    this.icon,
    this.padding,
    this.iconSize,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Choose button style based on type
    ButtonStyle buttonStyle;
    switch (type) {
      case AppButtonType.primary:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        );
        break;
      case AppButtonType.secondary:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        );
        break;
      case AppButtonType.tertiary:
        buttonStyle = OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        );
        break;
      case AppButtonType.text:
        buttonStyle = TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        );
        break;
    }
    
    final buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  type == AppButtonType.tertiary || type == AppButtonType.text
                      ? colorScheme.primary
                      : Colors.white,
                ),
              ),
            ),
          )
        else if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconTheme(
              data: IconThemeData(
                size: iconSize ?? 20,
                color: type == AppButtonType.tertiary || type == AppButtonType.text
                    ? colorScheme.primary
                    : Colors.white,
              ),
              child: icon!,
            ),
          ),
        Text(text),
      ],
    );
    
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.secondary:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonContent,
          ),
        );
      case AppButtonType.tertiary:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonContent,
          ),
        );
      case AppButtonType.text:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonContent,
          ),
        );
    }
  }
} 