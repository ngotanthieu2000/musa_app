import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';

class AssistantCard extends StatelessWidget {
  final VoidCallback onAskQuestion;
  
  const AssistantCard({
    Key? key,
    required this.onAskQuestion,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    
    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primary.withOpacity(0.2),
                child: Icon(
                  Icons.assistant,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Assistant',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'How can I help you today?',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingL),
          _buildSuggestions(context),
          const SizedBox(height: AppDimensions.spacingL),
          _buildAskButton(context),
        ],
      ),
    );
  }
  
  Widget _buildSuggestions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    List<String> suggestions = [
      'What tasks do I have today?',
      'Create a new reminder',
      'Summarize my health data',
      'Show my spending this month',
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Suggestions',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Wrap(
          spacing: AppDimensions.spacingS,
          runSpacing: AppDimensions.spacingS,
          children: suggestions.map((suggestion) {
            return Chip(
              label: Text(
                suggestion,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              backgroundColor: colorScheme.primary.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingXS,
                vertical: AppDimensions.spacingXXS,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildAskButton(BuildContext context) {
    return AppButton(
      text: 'Ask a Question',
      icon: const Icon(Icons.chat),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingM,
        vertical: AppDimensions.spacingS,
      ),
      onPressed: onAskQuestion,
      isFullWidth: true,
    );
  }
} 