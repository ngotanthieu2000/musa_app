import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyTasks extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAddTask;
  final bool showAddButton;

  const EmptyTasks({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    this.onAddTask,
    this.showAddButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animation or Icon
              if (icon == Icons.assignment_outlined)
                SizedBox(
                  height: 200,
                  child: Lottie.network(
                    'https://assets5.lottiefiles.com/packages/lf20_ydo1amjm.json',
                    repeat: true,
                    animate: true,
                  ),
                )
              else
                Icon(
                  icon,
                  size: 100,
                  color: theme.colorScheme.primaryContainer,
                ),
              const SizedBox(height: 24),

              // Title
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Add task button
              if (showAddButton && onAddTask != null)
                FilledButton.icon(
                  onPressed: onAddTask,
                  icon: const Icon(Icons.add_task),
                  label: const Text('Tạo nhiệm vụ mới'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Tips
              _buildTipCard(
                context,
                icon: Icons.lightbulb_outline,
                title: 'Mẹo:',
                content: 'Hãy chia nhỏ công việc lớn thành các nhiệm vụ nhỏ hơn để dễ quản lý hơn.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}