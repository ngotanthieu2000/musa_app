import 'package:flutter/material.dart';
import '../../domain/entities/emotional_state.dart';

class EmotionalStateCard extends StatelessWidget {
  final EmotionalState emotionalState;
  final VoidCallback onUpdate;

  const EmotionalStateCard({
    Key? key,
    required this.emotionalState,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Emotional State',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onUpdate,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildEmotionIcon(emotionalState.mood),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getMoodTitle(emotionalState.mood),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Updated ${_getTimeAgo(emotionalState.timestamp)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricColumn('Stress', emotionalState.stressLevel, 10),
                _buildMetricColumn('Energy', emotionalState.energy, 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionIcon(String mood) {
    IconData iconData;
    Color color;

    switch (mood.toLowerCase()) {
      case 'happy':
        iconData = Icons.sentiment_very_satisfied;
        color = Colors.amber;
        break;
      case 'calm':
        iconData = Icons.sentiment_satisfied;
        color = Colors.blue;
        break;
      case 'sad':
        iconData = Icons.sentiment_dissatisfied;
        color = Colors.indigo;
        break;
      case 'anxious':
        iconData = Icons.sentiment_very_dissatisfied;
        color = Colors.purple;
        break;
      case 'angry':
        iconData = Icons.mood_bad;
        color = Colors.red;
        break;
      case 'motivated':
        iconData = Icons.emoji_events;
        color = Colors.orange;
        break;
      default:
        iconData = Icons.sentiment_neutral;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: color,
        size: 32,
      ),
    );
  }

  Widget _buildMetricColumn(String label, int value, int max) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' / $max',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getMoodTitle(String mood) {
    // Capitalize first letter
    return '${mood[0].toUpperCase()}${mood.substring(1)}';
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }
}
