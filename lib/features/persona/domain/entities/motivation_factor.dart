import 'package:equatable/equatable.dart';

/// Represents a factor that motivates the user
class MotivationFactor extends Equatable {
  /// The factor that motivates the user (e.g., growth, achievement, recognition)
  final String factor;
  
  /// The importance of this factor to the user (1-10)
  final int importance;
  
  /// Additional notes about this motivation factor
  final String notes;
  
  /// The timestamp when this motivation factor was last updated
  final DateTime updatedAt;

  const MotivationFactor({
    required this.factor,
    required this.importance,
    required this.notes,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [factor, importance, notes, updatedAt];
}
