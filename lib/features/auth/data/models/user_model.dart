import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required String id,
    required String email,
    String? name,
    String? avatar,
    DateTime? createdAt,
  }) : super(
    id: id,
    email: email,
    name: name,
    avatar: avatar,
    createdAt: createdAt,
  );
  
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      avatar: user.avatar,
      createdAt: user.createdAt,
    );
  }
  
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      avatar: avatar,
      createdAt: createdAt,
    );
  }
} 