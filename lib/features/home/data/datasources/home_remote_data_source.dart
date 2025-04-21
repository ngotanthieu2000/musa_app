import 'package:injectable/injectable.dart';
import '../../../../core/network_helper.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/home_data_model.dart';
import '../models/home_feature_model.dart';

abstract class HomeRemoteDataSource {
  /// Gets home data from API.
  Future<HomeDataModel> getHomeData();

  /// Gets home features from API.
  Future<List<HomeFeatureModel>> getHomeFeatures();
}

@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<HomeDataModel> getHomeData() async {
    try {
      final response = await apiClient.get('/api/v1/home');
      return HomeDataModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HomeFeatureModel>> getHomeFeatures() async {
    try {
      final response = await apiClient.get('/api/v1/home/features');
      final List<dynamic> featuresJson = response['features'];
      return featuresJson
          .map((featureJson) => HomeFeatureModel.fromJson(featureJson))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
