import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  /// Gets the cached [ProfileModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<ProfileModel> getLastProfile();
  
  /// Caches the [ProfileModel] to local storage.
  Future<void> cacheProfile(ProfileModel profileToCache);
}

const CACHED_PROFILE = 'CACHED_PROFILE';

@LazySingleton(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProfileLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ProfileModel> getLastProfile() {
    final jsonString = sharedPreferences.getString(CACHED_PROFILE);
    if (jsonString != null) {
      return Future.value(ProfileModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
  
  @override
  Future<void> cacheProfile(ProfileModel profileToCache) {
    return sharedPreferences.setString(
      CACHED_PROFILE,
      json.encode(profileToCache.toJson()),
    );
  }
} 