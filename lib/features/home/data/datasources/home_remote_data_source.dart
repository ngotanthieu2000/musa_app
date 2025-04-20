import '../models/home_feature_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeFeatureModel>> getHomeFeatures();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<List<HomeFeatureModel>> getHomeFeatures() async {
    // Giả lập API call với delay mô phỏng response
    await Future.delayed(const Duration(seconds: 1));

    // Fake data trả về, mỗi feature có: id, title, icon, route
    return [
      HomeFeatureModel(
        id: '1',
        title: 'Hỏi đáp với AI',
        icon: 'chat',
        route: '/ai-chat',
      ),
      HomeFeatureModel(
        id: '2',
        title: 'Bài học của bạn',
        icon: 'book',
        route: '/my-lessons',
      ),
      HomeFeatureModel(
        id: '3',
        title: 'Giải bài tập bằng ảnh',
        icon: 'camera',
        route: '/photo-solver',
      ),
      HomeFeatureModel(
        id: '4',
        title: 'Tiến độ của bạn',
        icon: 'chart',
        route: '/progress',
      ),
    ];
  }
}
