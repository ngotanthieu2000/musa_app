import 'package:equatable/equatable.dart';

/// Represents the emotional state of a user at a specific point in time
class EmotionalState extends Equatable {
  /// The mood of the user (e.g., happy, sad, anxious, etc.)
  final String mood;
  
  /// The stress level of the user (1-10)
  final int stressLevel;
  
  /// The energy level of the user (1-10)
  final int energy;
  
  /// The timestamp when this emotional state was recorded
  final DateTime timestamp;

  const EmotionalState({
    required this.mood,
    required this.stressLevel,
    required this.energy,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [mood, stressLevel, energy, timestamp];
}
