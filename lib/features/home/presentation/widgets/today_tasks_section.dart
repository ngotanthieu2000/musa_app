import 'package:flutter/material.dart';
import 'animated_widgets.dart';

class TodayTasksSection extends StatelessWidget {
  const TodayTasksSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInWidget(
      delay: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideInWidget(
              delay: const Duration(milliseconds: 1000),
              offset: const Offset(-0.3, 0),
              child: Text(
                "Today's Tasks",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ScaleInWidget(
              delay: const Duration(milliseconds: 1200),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildAnimatedListTile(
                        context,
                        Icons.task_alt,
                        'Complete Project Report',
                        'Due in 2 hours',
                        const Duration(milliseconds: 1400),
                      ),
                      const Divider(),
                      _buildAnimatedListTile(
                        context,
                        Icons.medical_services,
                        'Health Check-up',
                        'Scheduled for today',
                        const Duration(milliseconds: 1600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedListTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Duration delay,
  ) {
    return SlideInWidget(
      delay: delay,
      offset: const Offset(0.3, 0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            // TODO: Navigate to detail
          },
        ),
      ),
    );
  }
} 