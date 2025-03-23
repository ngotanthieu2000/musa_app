// finance_summary_card.dart
import 'package:flutter/material.dart';

class FinanceSummaryCard extends StatelessWidget {
  const FinanceSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.account_balance_wallet,
            color: Colors.green, size: 40),
        title: const Text('Finance Summary'),
        subtitle: const Text('\$5,200'),
        trailing: const Icon(Icons.more_vert),
      ),
    );
  }
}
