/// Class quản lý đường dẫn import cho dự án
/// Giúp dễ dàng thay đổi cấu trúc thư mục mà không cần thay đổi imports trong code
class Paths {
  /// Root path cho import tương đối 
  static const String relativeRoot = '../../../..';
  
  /// Core paths
  // Đường dẫn tuyệt đối (không hoạt động với current setup)
  static const String core = 'package:musa_app/core';
  static const String coreWidgets = '$core/widgets';
  static const String coreConstants = '$core/constants';
  static const String coreServices = '$core/services';
  static const String coreError = '$core/error';
  static const String coreStorage = '$core/storage';
  static const String coreDi = '$core/di';
  
  // Đường dẫn tương đối từ thư mục features
  static const String relativeCore = '$relativeRoot/core';
  static const String relativeCoreWidgets = '$relativeCore/widgets';
  static const String relativeCoreConstants = '$relativeCore/constants';
  static const String relativeCoreServices = '$relativeCore/services';
  static const String relativeCoreError = '$relativeCore/error';
  static const String relativeCoreStorage = '$relativeCore/storage';
  static const String relativeCoreDi = '$relativeCore/di';
  
  /// Feature paths
  // Đường dẫn tuyệt đối (không hoạt động với current setup)
  static const String features = 'package:musa_app/features';
  
  // Đường dẫn tương đối từ core
  static const String relativeFeatures = '$relativeRoot/features';
  
  /// Auth feature
  static const String auth = '$features/auth';
  static const String authDomain = '$auth/domain';
  static const String authData = '$auth/data';
  static const String authPresentation = '$auth/presentation';
  
  static const String relativeAuth = '$relativeFeatures/auth';
  static const String relativeAuthDomain = '$relativeAuth/domain';
  static const String relativeAuthData = '$relativeAuth/data';
  static const String relativeAuthPresentation = '$relativeAuth/presentation';
  
  /// Profile feature
  static const String profile = '$features/profile';
  static const String profileDomain = '$profile/domain';
  static const String profileData = '$profile/data';
  static const String profilePresentation = '$profile/presentation';
  
  static const String relativeProfile = '$relativeFeatures/profile';
  static const String relativeProfileDomain = '$relativeProfile/domain';
  static const String relativeProfileData = '$relativeProfile/data';
  static const String relativeProfilePresentation = '$relativeProfile/presentation';
  
  /// Home feature
  static const String home = '$features/home';
  static const String homeDomain = '$home/domain';
  static const String homeData = '$home/data';
  static const String homePresentation = '$home/presentation';
  
  static const String relativeHome = '$relativeFeatures/home';
  static const String relativeHomeDomain = '$relativeHome/domain';
  static const String relativeHomeData = '$relativeHome/data';
  static const String relativeHomePresentation = '$relativeHome/presentation';
  
  /// App paths
  static const String app = 'package:musa_app/app';
  static const String routes = '$app/routes';
  static const String theme = '$app/theme';
  
  static const String relativeApp = '$relativeRoot/app';
  static const String relativeRoutes = '$relativeApp/routes';
  static const String relativeTheme = '$relativeApp/theme';
} 