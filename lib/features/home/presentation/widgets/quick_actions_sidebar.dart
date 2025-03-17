import 'package:flutter/material.dart';

class QuickActionsSidebar extends StatelessWidget {
  const QuickActionsSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickActionButton(
            context,
            Icons.calendar_today,
            'Calendar',
            () {
              // TODO: Navigate to Calendar
            },
          ),
          _buildQuickActionButton(
            context,
            Icons.health_and_safety,
            'Health',
            () {
              // TODO: Navigate to Health
            },
          ),
          _buildQuickActionButton(
            context,
            Icons.account_balance_wallet,
            'Finance',
            () {
              // TODO: Navigate to Finance
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
} 