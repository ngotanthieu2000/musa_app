import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../profile/domain/entities/goal.dart';

part 'home_data.freezed.dart';

@freezed
class HomeData with _$HomeData {
  const factory HomeData({
    required String welcomeMessage,
    required int taskCount,
    required int completedTaskCount,
    required String userGreeting,
    required List<String> upcomingEvents,
  }) = _HomeData;
} 