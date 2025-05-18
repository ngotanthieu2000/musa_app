import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/api_error_type.dart';
import '../../../../core/network_info.dart';
import '../../../../core/services/image_upload_service.dart';
import '../../../../core/mock/mock_api.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_model.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final ImageUploadService imageUploadService;
  final MockApi _mockApi = MockApi();
  
  // Đánh dấu có sử dụng mock API hay không
  final bool useMockApi = false; // Set false khi có API thực

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.imageUploadService,
  });

  @override
  Future<Either<Failure, Profile>> getBasicProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProfile = await remoteDataSource.getBasicProfile();
        localDataSource.cacheProfile(remoteProfile);
        return Right(remoteProfile);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          errorType: e.errorType,
        ));
      }
    } else {
      try {
        final localProfile = await localDataSource.getLastProfile();
        return Right(localProfile);
      } on CacheException catch (e) {
        return Left(NetworkFailure(
          message: e.message,
          errorType: ApiErrorType.network,
        ));
      }
    }
  }

  @override
  Future<Either<Failure, Profile>> getFullProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProfile = await remoteDataSource.getFullProfile();
        localDataSource.cacheProfile(remoteProfile);
        return Right(remoteProfile);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          errorType: e.errorType,
          data: e.data,
        ));
      } catch (e) {
        return Left(ServerFailure(
          message: e.toString(),
          errorType: ApiErrorType.unknown,
        ));
      }
    } else {
      try {
        final localProfile = await localDataSource.getLastProfile();
        return Right(localProfile);
      } on CacheException catch (e) {
        return Left(CacheFailure(
          message: e.message,
        ));
      }
    }
  }

  @override
  Future<Either<Failure, Profile>> updateProfile(Map<String, dynamic> profileData) async {
    print('DEBUG REPO: Starting updateProfile with data: $profileData');
    if (await networkInfo.isConnected) {
      try {
        // Kiểm tra xem có ảnh đại diện mới không
        if (profileData.containsKey('avatar_file')) {
          final avatarFilePath = profileData['avatar_file'] as String;
          print('DEBUG REPO: Uploading avatar from path: $avatarFilePath');
          
          try {
            // Tải ảnh lên server
            final String imageUrl;
            if (useMockApi) {
              print('DEBUG REPO: Using mock to upload image');
              imageUrl = await _mockApi.uploadImage(File(avatarFilePath));
            } else {
              print('DEBUG REPO: Using image upload service');
              imageUrl = await imageUploadService.uploadImage(
                File(avatarFilePath),
                folder: 'avatars',
              );
            }
            
            print('DEBUG REPO: Image uploaded, got URL: $imageUrl');
            // Cập nhật URL ảnh trong dữ liệu profile
            profileData.remove('avatar_file');
            profileData['avatar'] = imageUrl;
          } catch (e) {
            print('DEBUG REPO: Image upload failed: $e');
            return Left(ServerFailure(
              message: 'Không thể tải ảnh đại diện: ${e.toString()}',
              errorType: ApiErrorType.server,
            ));
          }
        }
        
        print('DEBUG REPO: Calling remote data source updateProfile');
        final updatedProfile = await remoteDataSource.updateProfile(profileData);
        print('DEBUG REPO: Profile updated successfully, caching to local');
        localDataSource.cacheProfile(updatedProfile);
        return Right(updatedProfile);
      } on ServerException catch (e) {
        print('DEBUG REPO: ServerException in updateProfile: ${e.message}');
        return Left(ServerFailure(
          message: e.message,
          errorType: e.errorType,
        ));
      } catch (e) {
        print('DEBUG REPO: Unexpected error in updateProfile: $e');
        return Left(ServerFailure(
          message: e.toString(),
          errorType: ApiErrorType.unknown,
        ));
      }
    } else {
      print('DEBUG REPO: No internet connection');
      return Left(NetworkFailure(
        message: 'Không có kết nối internet',
        errorType: ApiErrorType.network,
      ));
    }
  }

  @override
  Future<Either<Failure, Profile>> updatePreferences(Map<String, dynamic> preferencesData) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedProfile = await remoteDataSource.updatePreferences(preferencesData);
        localDataSource.cacheProfile(updatedProfile);
        return Right(updatedProfile);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          errorType: e.errorType,
        ));
      }
    } else {
      return Left(NetworkFailure(
        message: 'Không có kết nối internet',
        errorType: ApiErrorType.network,
      ));
    }
  }

  @override
  Future<Either<Failure, Profile>> updateNotificationSettings(
      Map<String, dynamic> notificationData) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedProfile = await remoteDataSource.updateNotificationSettings(notificationData);
        localDataSource.cacheProfile(updatedProfile);
        return Right(updatedProfile);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          errorType: e.errorType,
        ));
      }
    } else {
      return Left(NetworkFailure(
        message: 'Không có kết nối internet',
        errorType: ApiErrorType.network,
      ));
    }
  }

  @override
  Future<Either<Failure, Profile>> updateHealthData(Map<String, dynamic> healthData) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedProfile = await remoteDataSource.updateHealthData(healthData);
        localDataSource.cacheProfile(updatedProfile);
        return Right(updatedProfile);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          errorType: e.errorType,
        ));
      }
    } else {
      return Left(NetworkFailure(
        message: 'Không có kết nối internet',
        errorType: ApiErrorType.network,
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> changePassword(String currentPassword, String newPassword) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.changePassword(currentPassword, newPassword);
        return const Right(true);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          errorType: e.errorType,
        ));
      }
    } else {
      return Left(NetworkFailure(
        message: 'Không có kết nối internet',
        errorType: ApiErrorType.network,
      ));
    }
  }
  
  @override
  Future<Either<Failure, String>> uploadProfileImage(File imageFile) async {
    if (await networkInfo.isConnected) {
      try {
        final String imageUrl;
        if (useMockApi) {
          imageUrl = await _mockApi.uploadImage(imageFile);
        } else {
          imageUrl = await imageUploadService.uploadImage(imageFile, folder: 'avatars');
        }
        return Right(imageUrl);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          errorType: e.errorType,
        ));
      }
    } else {
      return Left(NetworkFailure(
        message: 'Không có kết nối internet',
        errorType: ApiErrorType.network,
      ));
    }
  }
} 