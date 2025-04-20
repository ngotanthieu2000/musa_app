import 'package:flutter/material.dart';

class AppErrorDisplay extends StatelessWidget {
  final String message;
  final String? details;
  final IconData? icon;
  final bool showIcon;
  final VoidCallback? onRetry;
  final String? retryText;
  
  const AppErrorDisplay({
    Key? key,
    required this.message,
    this.details,
    this.icon = Icons.error_outline,
    this.showIcon = true,
    this.onRetry,
    this.retryText = 'Thử lại',
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              icon,
              color: colorScheme.error,
              size: 32,
            ),
            const SizedBox(height: 12),
          ],
          Text(
            message,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (details != null) ...[
            const SizedBox(height: 8),
            Text(
              details!,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryText!),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }
} 