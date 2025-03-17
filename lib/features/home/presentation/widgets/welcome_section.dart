import 'package:flutter/material.dart';
import 'animated_widgets.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideInWidget(
      delay: const Duration(milliseconds: 600),
      offset: const Offset(0, 0.3),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInWidget(
              delay: const Duration(milliseconds: 800),
              child: Text(
                'Welcome You',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ScaleInWidget(
              delay: const Duration(milliseconds: 1000),
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to services
                },
                icon: const Icon(Icons.home_repair_service),
                label: const Text('Service'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 