import 'package:flutter/material.dart';
import '../../domain/entities/feature.dart';

class FeatureCard extends StatelessWidget {
  final Feature feature;

  const FeatureCard({
    Key? key,
    required this.feature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Implement navigation
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                feature.icon,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                feature.title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 