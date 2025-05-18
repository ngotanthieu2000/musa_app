import 'package:flutter/material.dart';
import '../../domain/entities/goal.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const GoalCard({
    Key? key,
    required this.goal,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildCategoryChip(goal.category),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: onUpdate,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              goal.description,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  _getTimeframeText(goal.timeframe),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Text(
                  '${goal.progress}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: goal.progress / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(goal.progress)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getCategoryColor(category).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 12,
          color: _getCategoryColor(category),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'career':
        return Colors.blue;
      case 'personal':
        return Colors.purple;
      case 'health':
        return Colors.green;
      case 'finance':
        return Colors.orange;
      case 'education':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Color _getProgressColor(int progress) {
    if (progress < 30) {
      return Colors.red;
    } else if (progress < 70) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  String _getTimeframeText(String timeframe) {
    switch (timeframe.toLowerCase()) {
      case 'short-term':
        return 'Short-term';
      case 'medium-term':
        return 'Medium-term';
      case 'long-term':
        return 'Long-term';
      default:
        return timeframe;
    }
  }
}
