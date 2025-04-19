import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import 'app_button.dart';

class AppErrorDisplay extends StatelessWidget {
  final String message;
  final String? details;
  final VoidCallback? onRetry;
  final String retryText;
  final bool showIcon;
  final TextAlign textAlign;
  
  const AppErrorDisplay({
    super.key,
    required this.message,
    this.details,
    this.onRetry,
    this.retryText = 'Thử lại',
    this.showIcon = true,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final errorColor = isDarkMode ? AppColors.errorDark : AppColors.errorLight;
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: errorColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              Icons.error_outline,
              color: errorColor,
              size: AppDimensions.iconSizeL,
            ),
            const SizedBox(height: AppDimensions.spacingM),
          ],
          
          SelectableText.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: message,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: errorColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (details != null) ...[
                  const TextSpan(text: '\n\n'),
                  TextSpan(
                    text: details,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDarkMode 
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ],
            ),
            textAlign: textAlign,
          ),
          
          if (onRetry != null) ...[
            const SizedBox(height: AppDimensions.spacingL),
            AppButton(
              text: retryText,
              onPressed: onRetry,
              type: AppButtonType.outlined,
              size: AppButtonSize.medium,
              icon: Icons.refresh,
            ),
          ],
        ],
      ),
    );
  }
} 