import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? avatar;
  final DateTime? createdAt;
  
  const User({
    required this.id,
    required this.email,
    this.name,
    this.avatar,
    this.createdAt,
  });
  
  @override
  List<Object?> get props => [id, email, name, avatar, createdAt];
  
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 