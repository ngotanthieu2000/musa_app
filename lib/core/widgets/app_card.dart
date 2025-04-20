import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final bool isClickable;
  final EdgeInsetsGeometry? margin;
  
  const AppCard({
    Key? key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
    this.gradient,
    this.onTap,
    this.isClickable = false,
    this.margin,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    
    final effectivePadding = padding ?? const EdgeInsets.all(AppDimensions.spacingM);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(AppDimensions.radiusL);
    final effectiveElevation = elevation ?? AppDimensions.cardElevation;
    final effectiveMargin = margin ?? EdgeInsets.zero;
    
    // Determine the shadow color based on the theme mode
    final shadowColor = isDarkMode 
        ? AppColors.shadowDark
        : AppColors.shadowLight;
    
    Widget cardContent = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? (isDarkMode ? AppColors.cardDark : AppColors.cardLight),
        borderRadius: effectiveBorderRadius,
        border: border,
        gradient: gradient,
        boxShadow: effectiveElevation > 0 
            ? [
                BoxShadow(
                  color: shadowColor.withOpacity(0.2),
                  blurRadius: effectiveElevation * 2,
                  offset: Offset(0, effectiveElevation),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: effectivePadding,
        child: child,
      ),
    );
    
    if (onTap != null || isClickable) {
      return Padding(
        padding: effectiveMargin,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: cardContent,
        ),
      );
    }
    
    return Padding(
      padding: effectiveMargin,
      child: cardContent,
    );
  }
} 