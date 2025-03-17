import 'package:flutter/material.dart';
import 'animated_widgets.dart';

class FeatureCardsSection extends StatelessWidget {
  const FeatureCardsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInWidget(
      delay: const Duration(milliseconds: 1000),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideInWidget(
              delay: const Duration(milliseconds: 1200),
              offset: const Offset(-0.3, 0),
              child: Text(
                'Features',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildAnimatedFeatureCard(
                  context,
                  'AI Assistant Help',
                  Icons.assistant,
                  Colors.blue,
                  const Duration(milliseconds: 1400),
                  () {
                    // TODO: Navigate to AI Assistant
                  },
                ),
                _buildAnimatedFeatureCard(
                  context,
                  'Health Summary',
                  Icons.health_and_safety,
                  Colors.green,
                  const Duration(milliseconds: 1600),
                  () {
                    // TODO: Navigate to Health
                  },
                ),
                _buildAnimatedFeatureCard(
                  context,
                  'Finance Summary',
                  Icons.account_balance_wallet,
                  Colors.orange,
                  const Duration(milliseconds: 1800),
                  () {
                    // TODO: Navigate to Finance
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Duration delay,
    VoidCallback onTap,
  ) {
    return ScaleInWidget(
      delay: delay,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: color,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 