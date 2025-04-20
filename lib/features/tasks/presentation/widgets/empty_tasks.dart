import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyTasksWidget extends StatelessWidget {
  final VoidCallback onAddTask;

  const EmptyTasksWidget({
    super.key,
    required this.onAddTask,
  });

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
              // Animation
              SizedBox(
                height: 200,
                child: Lottie.network(
                  'https://assets5.lottiefiles.com/packages/lf20_ydo1amjm.json',
                  repeat: true,
                  animate: true,
                ),
              ),
              const SizedBox(height: 24),
              
              // Title
              Text(
                'Chưa có nhiệm vụ nào',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Description
              Text(
                'Bạn chưa có nhiệm vụ nào. Tạo nhiệm vụ đầu tiên để bắt đầu quản lý công việc của mình.',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Add task button
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