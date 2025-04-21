import '../../domain/entities/home_data.dart';

class HomeDataModel {
  final String welcomeMessage;
  final int taskCount;
  final int completedTaskCount;
  final String userGreeting;
  final List<String> upcomingEvents;

  const HomeDataModel({
    required this.welcomeMessage,
    required this.taskCount,
    required this.completedTaskCount,
    required this.userGreeting,
    required this.upcomingEvents,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      welcomeMessage: json['welcome_message'] ?? 'Chào mừng bạn!',
      taskCount: json['task_count'] ?? 0,
      completedTaskCount: json['completed_task_count'] ?? 0,
      userGreeting: json['user_greeting'] ?? 'Xin chào!',
      upcomingEvents: json['upcoming_events'] != null
          ? List<String>.from(json['upcoming_events'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'welcome_message': welcomeMessage,
      'task_count': taskCount,
      'completed_task_count': completedTaskCount,
      'user_greeting': userGreeting,
      'upcoming_events': upcomingEvents,
    };
  }
  
  HomeData toEntity() {
    return HomeData(
      welcomeMessage: welcomeMessage,
      taskCount: taskCount,
      completedTaskCount: completedTaskCount,
      userGreeting: userGreeting,
      upcomingEvents: upcomingEvents,
    );
  }
} 