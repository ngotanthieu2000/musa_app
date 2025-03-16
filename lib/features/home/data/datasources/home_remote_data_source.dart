// features/home/data/datasources/home_remote_data_source.dart
import '../models/home_feature_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeFeatureModel>> getHomeFeatures();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<List<HomeFeatureModel>> getHomeFeatures() async {
    // Giả lập API call
    await Future.delayed(Duration(seconds: 1));
    return [
      HomeFeatureModel(id: '1', title: 'Hỏi đáp với AI', icon: 'chat'),
      HomeFeatureModel(id: '2', title: 'Bài học của bạn', icon: 'book'),
      HomeFeatureModel(id: '3', title: 'Giải bài tập bằng ảnh', icon: 'camera'),
      HomeFeatureModel(id: '4', title: 'Tiến độ của bạn', icon: 'chart'),
    ];
  }
}