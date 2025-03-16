// features/home/data/models/home_feature_model.dart
import '../../domain/entities/home_feature.dart'; // Import lớp HomeFeature

class HomeFeatureModel {
  final String id;
  final String title;
  final String icon;

  HomeFeatureModel({required this.id, required this.title, required this.icon});

  factory HomeFeatureModel.fromJson(Map<String, dynamic> json) {
    return HomeFeatureModel(
      id: json['id'],
      title: json['title'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'icon': icon};
  }

  // Phương thức chuyển đổi sang HomeFeature
  HomeFeature toEntity() {
    return HomeFeature(id: id, title: title, icon: icon);
  }
}
