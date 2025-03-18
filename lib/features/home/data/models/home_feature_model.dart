import '../../domain/entities/home_feature.dart';
import 'package:flutter/material.dart';

class HomeFeatureModel {
  final String id;
  final String title;
  final String icon; // String tên hoặc mã icon
  final String route; // cần thêm route vì HomeFeature cần route

  HomeFeatureModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
  });

  factory HomeFeatureModel.fromJson(Map<String, dynamic> json) {
    return HomeFeatureModel(
      id: json['id'],
      title: json['title'],
      icon: json['icon'],
      route: json['route'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'route': route,
    };
  }

  // Chuyển đổi sang entity
  HomeFeature toEntity() {
    return HomeFeature(
      title: title,
      icon: _mapIconStringToIconData(icon), // convert String to IconData
      route: route,
    );
  }

  // Hàm map icon từ string -> IconData
  static IconData _mapIconStringToIconData(String iconName) {
    switch (iconName) {
      case 'calendar':
        return Icons.calendar_today;
      case 'health':
        return Icons.favorite;
      case 'finance':
        return Icons.account_balance_wallet;
      case 'more':
        return Icons.more_horiz;
      default:
        return Icons.help_outline; // fallback icon
    }
  }
}
