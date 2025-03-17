import 'package:flutter/material.dart';
import 'animated_widgets.dart';

class QuickActionsSidebar extends StatelessWidget {
  const QuickActionsSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInWidget(
      delay: const Duration(milliseconds: 1200),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAnimatedQuickActionButton(
              context,
              Icons.calendar_today,
              'Calendar',
              const Duration(milliseconds: 1400),
              () {
                // TODO: Navigate to Calendar
              },
            ),
            _buildAnimatedQuickActionButton(
              context,
              Icons.health_and_safety,
              'Health',
              const Duration(milliseconds: 1600),
              () {
                // TODO: Navigate to Health
              },
            ),
            _buildAnimatedQuickActionButton(
              context,
              Icons.account_balance_wallet,
              'Finance',
              const Duration(milliseconds: 1800),
              () {
                // TODO: Navigate to Finance
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedQuickActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Duration delay,
    VoidCallback onTap,
  ) {
    return ScaleInWidget(
      delay: delay,
      child: Column(
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
      ),
    );
  }
} 