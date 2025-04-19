import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../profile/domain/entities/goal.dart';

part 'home_data.freezed.dart';
part 'home_data.g.dart';

@freezed
class HomeData with _$HomeData {
  const factory HomeData({
    required String userName,
    required List<Task> todayTasks,
    required List<Goal> goals,
    required int overallProgress,
    required int tasksCompleted,
    required int totalTasks,
    String? reminder,
    Map<String, dynamic>? healthData,
    Map<String, dynamic>? financeData,
  }) = _HomeData;

  factory HomeData.fromJson(Map<String, dynamic> json) => _$HomeDataFromJson(json);
} 