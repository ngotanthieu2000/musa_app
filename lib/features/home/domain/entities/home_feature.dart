// features/home/domain/entities/home_feature.dart
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class HomeFeature extends Equatable {
  final String id;
  final String title;
  final String icon;
  final String route;

  const HomeFeature({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
  });

  @override
  List<Object> get props => [id, title, icon, route];
}
