/// Constants for API endpoints
class ApiConstants {
  // Base URL and path segments
  static const String baseUrl = '/api/v1';
  
  // Auth endpoints
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String refreshToken = '$baseUrl/auth/refresh';
  static const String logout = '$baseUrl/auth/logout';
  static const String currentUser = '$baseUrl/auth/me';
  
  // Profile endpoints
  static const String profile = '$baseUrl/profile';
  static const String preferences = '$baseUrl/profile/preferences';
  static const String notificationSettings = '$baseUrl/profile/notifications';
  static const String healthData = '$baseUrl/profile/health';
  static const String changePassword = '$baseUrl/profile/password';
  
  // Task endpoints
  static const String tasks = '$baseUrl/tasks';
  
  // Home endpoints
  static const String homeData = '$baseUrl/home';
  static const String homeFeatures = '$baseUrl/home/features';
  
  // Goals endpoints
  static const String goals = '$baseUrl/goals';
  
  // Finance endpoints
  static const String finance = '$baseUrl/finance';
  static const String financeIncome = '$baseUrl/finance/income';
  
  // Learning endpoints
  static const String learning = '$baseUrl/learning';
  static const String learningSkills = '$baseUrl/learning/skills';
  
  // Energy endpoints
  static const String energy = '$baseUrl/energy';
  static const String energyLevels = '$baseUrl/energy/levels';
  
  // Wellbeing endpoints
  static const String wellbeing = '$baseUrl/wellbeing';
  static const String wellbeingMood = '$baseUrl/wellbeing/mood';
  static const String wellbeingJournal = '$baseUrl/wellbeing/journal';
  
  // Social endpoints
  static const String social = '$baseUrl/social';
  static const String socialRelationships = '$baseUrl/social/relationships';
  
  // AI Personalization
  static const String aiPersonalization = '$baseUrl/ai/personalization';
  static const String aiPersonalizationInteraction = '$baseUrl/ai/personalization/interaction';
  static const String aiPersonalizationPermissions = '$baseUrl/ai/personalization/permissions';
} 