// features/home/presentation/widgets/home_feature_list.dart
import 'package:flutter/material.dart';
import '../../domain/entities/home_feature.dart';

class HomeFeatureList extends StatelessWidget {
  final List<HomeFeature> features;

  const HomeFeatureList({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Card(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.chat), // Thay bằng icon từ feature.icon
                const SizedBox(height: 8),
                Text(feature.title),
              ],
            ),
          ),
        );
      },
    );
  }
}
