import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final Gradient? gradient;
  final BoxBorder? border;
  final VoidCallback? onTap;
  final bool hasShadow;
  
  const AppCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.gradient,
    this.border,
    this.onTap,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final cardBorderRadius = borderRadius ?? 
        BorderRadius.circular(AppDimensions.cardBorderRadius);
        
    final cardShadow = hasShadow ? [
      BoxShadow(
        color: isDarkMode 
            ? AppColors.shadowDark
            : AppColors.shadowLight,
        blurRadius: elevation ?? AppDimensions.cardElevation,
        offset: const Offset(0, 2),
        spreadRadius: 0,
      ),
    ] : null;
    
    final Widget cardContent = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: backgroundColor ?? (isDarkMode ? AppColors.cardDark : AppColors.cardLight),
        borderRadius: cardBorderRadius,
        boxShadow: cardShadow,
        gradient: gradient,
        border: border,
      ),
      child: child,
    );
    
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: cardBorderRadius,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: cardBorderRadius,
          ),
          child: Padding(
            padding: margin ?? const EdgeInsets.all(AppDimensions.spacingS),
            child: cardContent,
          ),
        ),
      );
    }
    
    return Padding(
      padding: margin ?? const EdgeInsets.all(AppDimensions.spacingS),
      child: cardContent,
    );
  }
} 