import 'package:equatable/equatable.dart';

/// Represents metrics about the user's behavior
class BehaviorMetrics extends Equatable {
  /// The rate at which the user completes todos (0.0-1.0)
  final double todoCompletionRate;
  
  /// The average time (in hours) it takes the user to complete a todo
  final double avgTodoCompletionTime;
  
  /// The average time (in hours) the user spends learning per week
  final double learningTimePerWeek;
  
  /// The frequency (times per week) the user reflects on their goals
  final double reflectionFrequency;
  
  /// The frequency (times per day) the user uses the app
  final double appUsageFrequency;
  
  /// The timestamp when these metrics were last updated
  final DateTime lastUpdated;

  const BehaviorMetrics({
    required this.todoCompletionRate,
    required this.avgTodoCompletionTime,
    required this.learningTimePerWeek,
    required this.reflectionFrequency,
    required this.appUsageFrequency,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    todoCompletionRate,
    avgTodoCompletionTime,
    learningTimePerWeek,
    reflectionFrequency,
    appUsageFrequency,
    lastUpdated,
  ];
}
