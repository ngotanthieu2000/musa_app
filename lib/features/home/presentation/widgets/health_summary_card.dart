// health_summary_card.dart
import 'package:flutter/material.dart';

class HealthSummaryCard extends StatelessWidget {
  const HealthSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.favorite, color: Colors.redAccent, size: 40),
        title: const Text('Heart Rate'),
        subtitle: const Text('76 bpm'),
        trailing: const Icon(Icons.more_vert),
      ),
    );
  }
}
