// features/home/presentation/widgets/home_feature_list.dart
import 'package:flutter/material.dart';
import '../../domain/entities/home_feature.dart';

class HomeFeatureList extends StatelessWidget {
  final List<HomeFeature> features;

  const HomeFeatureList({required this.features});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                Icon(Icons.chat), // Thay bằng icon từ feature.icon
                SizedBox(height: 8),
                Text(feature.title),
              ],
            ),
          ),
        );
      },
    );
  }
}
