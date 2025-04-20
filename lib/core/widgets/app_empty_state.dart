import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import 'app_button.dart';

class AppEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  
  const AppEmptyState({
    Key? key,
    required this.title,
    required this.message,
    this.icon = Icons.sentiment_dissatisfied,
    this.actionLabel,
    this.onAction,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              child: Icon(
                icon,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.spacingXL),
              AppButton(
                text: actionLabel!,
                onPressed: onAction,
                type: AppButtonType.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingXL,
                  vertical: AppDimensions.spacingM,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 