import 'package:flutter/material.dart';

class TodayTasks extends StatelessWidget {
  const TodayTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        taskCard('Today\'s Tasks', '9 Actions', Icons.check_circle_outline),
        const SizedBox(height: 12),
        taskCard('Assistant Tasks', '5 New', Icons.favorite_border,
            color: Colors.redAccent),
      ],
    );
  }

  Widget taskCard(String title, String subtitle, IconData icon,
      {Color color = Colors.blueAccent}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 8)
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.more_horiz),
        ],
      ),
    );
  }
}
