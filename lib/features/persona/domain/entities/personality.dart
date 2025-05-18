import 'package:equatable/equatable.dart';

/// Represents the personality assessment of a user
class Personality extends Equatable {
  /// The type of personality assessment (e.g., MBTI, DISC, BIG5)
  final String type;
  
  /// The value of the personality assessment (e.g., INTJ, ENFP)
  final String value;
  
  /// The traits associated with this personality
  final List<String> traits;
  
  /// The strengths associated with this personality
  final List<String> strengths;
  
  /// The weaknesses associated with this personality
  final List<String> weaknesses;
  
  /// The timestamp when this personality was last updated
  final DateTime updatedAt;

  const Personality({
    required this.type,
    required this.value,
    required this.traits,
    required this.strengths,
    required this.weaknesses,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [type, value, traits, strengths, weaknesses, updatedAt];
}
