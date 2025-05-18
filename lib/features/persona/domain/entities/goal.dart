import 'package:equatable/equatable.dart';

/// Represents a goal set by the user
class Goal extends Equatable {
  /// The unique identifier of the goal
  final String id;
  
  /// The category of the goal (e.g., career, personal, health)
  final String category;
  
  /// The description of the goal
  final String description;
  
  /// The timeframe of the goal (e.g., short-term, medium-term, long-term)
  final String timeframe;
  
  /// The progress of the goal (0-100)
  final int progress;
  
  /// The timestamp when this goal was created
  final DateTime createdAt;
  
  /// The timestamp when this goal was last updated
  final DateTime updatedAt;

  const Goal({
    required this.id,
    required this.category,
    required this.description,
    required this.timeframe,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, category, description, timeframe, progress, createdAt, updatedAt];
}
