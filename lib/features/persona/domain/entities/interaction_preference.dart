import 'package:equatable/equatable.dart';

/// Represents the user's preferences for interaction with the AI
class InteractionPreference extends Equatable {
  /// The preferred communication style (e.g., direct, supportive, analytical)
  final String communicationStyle;
  
  /// The preferred response length (e.g., concise, balanced, detailed)
  final String responseLength;
  
  /// The topics the user prefers to discuss
  final List<String> topicPreferences;
  
  /// The topics the user prefers to avoid
  final List<String> avoidTopics;
  
  /// The timestamp when these preferences were last updated
  final DateTime updatedAt;

  const InteractionPreference({
    required this.communicationStyle,
    required this.responseLength,
    required this.topicPreferences,
    required this.avoidTopics,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    communicationStyle,
    responseLength,
    topicPreferences,
    avoidTopics,
    updatedAt,
  ];
}
