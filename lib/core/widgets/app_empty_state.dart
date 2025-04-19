import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import 'app_button.dart';

class AppEmptyState extends StatelessWidget {
  final String title;
  final String? message;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionText;
  final AppButtonType actionButtonType;
  
  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.info_outline,
    this.onAction,
    this.actionText,
    this.actionButtonType = AppButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: AppDimensions.iconSizeXL,
                color: isDarkMode
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiaryLight,
              ),
              const SizedBox(height: AppDimensions.spacingL),
            ],
            
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (message != null) ...[
              const SizedBox(height: AppDimensions.spacingM),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: AppDimensions.spacingXL),
              AppButton(
                text: actionText!,
                onPressed: onAction,
                type: actionButtonType,
                size: AppButtonSize.medium,
              ),
            ],
          ],
        ),
      ),
    );
  }
} 