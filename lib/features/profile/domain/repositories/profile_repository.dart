import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getBasicProfile();
  Future<Either<Failure, Profile>> getFullProfile();
  Future<Either<Failure, Profile>> updateProfile(Map<String, dynamic> profileData);
  Future<Either<Failure, Profile>> updatePreferences(Map<String, dynamic> preferencesData);
  Future<Either<Failure, Profile>> updateNotificationSettings(Map<String, dynamic> notificationData);
  Future<Either<Failure, Profile>> updateHealthData(Map<String, dynamic> healthData);
  Future<Either<Failure, bool>> changePassword(String currentPassword, String newPassword);
  Future<Either<Failure, String>> uploadProfileImage(File imageFile);
} 