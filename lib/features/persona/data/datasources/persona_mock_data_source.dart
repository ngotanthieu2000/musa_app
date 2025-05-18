import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/persona_model.dart';
import '../models/emotional_state_model.dart';
import '../models/goal_model.dart';
import '../models/personality_model.dart';
import '../models/interaction_preference_model.dart';
import '../models/motivation_factor_model.dart';
import '../models/behavior_metrics_model.dart';
import '../models/ai_advisor_analysis_model.dart';
import '../../../../core/error/exceptions.dart';

class PersonaMockDataSource {
  PersonaModel? _persona;
  final Random _random = Random();
  final Uuid _uuid = const Uuid();

  Future<PersonaModel> getPersona() async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (_persona != null) {
      return _persona!;
    }
    
    // Create a mock persona
    _persona = PersonaModel(
      id: _uuid.v4(),
      userId: 'user123',
      basicInfo: {
        'name': 'Alex Johnson',
        'age': 32,
        'occupation': 'Software Developer',
        'location': 'San Francisco, CA',
      },
      personality: PersonalityModel(
        type: 'MBTI',
        value: 'INTJ',
        traits: [
          'Analytical',
          'Strategic',
          'Independent',
          'Determined',
          'Curious',
        ],
        strengths: [
          'Problem-solving',
          'Strategic planning',
          'Critical thinking',
          'Independent work',
        ],
        weaknesses: [
          'Perfectionism',
          'Overthinking',
          'Difficulty expressing emotions',
          'Impatience with others',
        ],
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      emotionalStates: [
        EmotionalStateModel(
          mood: 'happy',
          stressLevel: 3,
          energy: 8,
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
        ),
        EmotionalStateModel(
          mood: 'anxious',
          stressLevel: 7,
          energy: 5,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
        EmotionalStateModel(
          mood: 'calm',
          stressLevel: 4,
          energy: 6,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      currentEmotionalState: EmotionalStateModel(
        mood: 'motivated',
        stressLevel: 5,
        energy: 7,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      goals: [
        GoalModel(
          id: _uuid.v4(),
          category: 'career',
          description: 'Learn a new programming language',
          timeframe: 'medium-term',
          progress: 65,
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
          updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        GoalModel(
          id: _uuid.v4(),
          category: 'health',
          description: 'Exercise 3 times per week',
          timeframe: 'short-term',
          progress: 40,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        GoalModel(
          id: _uuid.v4(),
          category: 'personal',
          description: 'Read 20 books this year',
          timeframe: 'long-term',
          progress: 25,
          createdAt: DateTime.now().subtract(const Duration(days: 90)),
          updatedAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ],
      behaviorMetrics: BehaviorMetricsModel(
        todoCompletionRate: 0.75,
        avgTodoCompletionTime: 2.5,
        learningTimePerWeek: 8.0,
        reflectionFrequency: 3.0,
        appUsageFrequency: 2.5,
        lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
      ),
      motivationFactors: [
        MotivationFactorModel(
          factor: 'Growth',
          importance: 9,
          notes: 'Learning new skills and expanding knowledge',
          updatedAt: DateTime.now().subtract(const Duration(days: 45)),
        ),
        MotivationFactorModel(
          factor: 'Achievement',
          importance: 8,
          notes: 'Completing challenging tasks and goals',
          updatedAt: DateTime.now().subtract(const Duration(days: 45)),
        ),
        MotivationFactorModel(
          factor: 'Recognition',
          importance: 6,
          notes: 'Being acknowledged for contributions and expertise',
          updatedAt: DateTime.now().subtract(const Duration(days: 45)),
        ),
      ],
      interactionPreference: InteractionPreferenceModel(
        communicationStyle: 'direct',
        responseLength: 'balanced',
        topicPreferences: [
          'technology',
          'productivity',
          'science',
          'psychology',
        ],
        avoidTopics: [
          'politics',
          'celebrity gossip',
        ],
        updatedAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      insights: [
        'You tend to be more productive in the morning hours.',
        'Your stress levels decrease after physical activity.',
        'You complete tasks more efficiently when they align with your personal goals.',
        'You learn best through practical application rather than theory.',
        'Your motivation increases when you track your progress visually.',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      version: 1,
    );
    
    return _persona!;
  }

  Future<PersonaModel> updatePersona(PersonaModel persona) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    _persona = persona.copyWith(
      updatedAt: DateTime.now(),
      version: (_persona?.version ?? 0) + 1,
    );
    
    return _persona!;
  }

  Future<EmotionalStateModel> recordEmotionalState(EmotionalStateModel state) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (_persona == null) {
      await getPersona();
    }
    
    final emotionalStates = List<EmotionalStateModel>.from(_persona!.emotionalStates);
    emotionalStates.add(state);
    
    _persona = _persona!.copyWith(
      emotionalStates: emotionalStates,
      currentEmotionalState: state,
      updatedAt: DateTime.now(),
    );
    
    return state;
  }

  Future<GoalModel> addGoal(GoalModel goal) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (_persona == null) {
      await getPersona();
    }
    
    final goals = List<GoalModel>.from(_persona!.goals);
    goals.add(goal);
    
    _persona = _persona!.copyWith(
      goals: goals,
      updatedAt: DateTime.now(),
    );
    
    return goal;
  }

  Future<GoalModel> updateGoal(GoalModel goal) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (_persona == null) {
      await getPersona();
    }
    
    final goals = List<GoalModel>.from(_persona!.goals);
    final index = goals.indexWhere((g) => g.id == goal.id);
    
    if (index == -1) {
      throw ServerException(
        message: 'Goal not found',
        statusCode: 404,
      );
    }
    
    goals[index] = goal;
    
    _persona = _persona!.copyWith(
      goals: goals,
      updatedAt: DateTime.now(),
    );
    
    return goal;
  }

  Future<bool> deleteGoal(String goalId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (_persona == null) {
      await getPersona();
    }
    
    final goals = List<GoalModel>.from(_persona!.goals);
    final index = goals.indexWhere((g) => g.id == goalId);
    
    if (index == -1) {
      throw ServerException(
        message: 'Goal not found',
        statusCode: 404,
      );
    }
    
    goals.removeAt(index);
    
    _persona = _persona!.copyWith(
      goals: goals,
      updatedAt: DateTime.now(),
    );
    
    return true;
  }

  Future<PersonalityModel> updatePersonality(PersonalityModel personality) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (_persona == null) {
      await getPersona();
    }
    
    _persona = _persona!.copyWith(
      personality: personality,
      updatedAt: DateTime.now(),
    );
    
    return personality;
  }

  Future<InteractionPreferenceModel> updateInteractionPreference(InteractionPreferenceModel preference) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (_persona == null) {
      await getPersona();
    }
    
    _persona = _persona!.copyWith(
      interactionPreference: preference,
      updatedAt: DateTime.now(),
    );
    
    return preference;
  }

  Future<List<MotivationFactorModel>> updateMotivationFactors(List<MotivationFactorModel> factors) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (_persona == null) {
      await getPersona();
    }
    
    _persona = _persona!.copyWith(
      motivationFactors: factors,
      updatedAt: DateTime.now(),
    );
    
    return factors;
  }

  Future<List<String>> generateInsights() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (_persona == null) {
      await getPersona();
    }
    
    final insights = [
      'You tend to be more productive in the morning hours.',
      'Your stress levels decrease after physical activity.',
      'You complete tasks more efficiently when they align with your personal goals.',
      'You learn best through practical application rather than theory.',
      'Your motivation increases when you track your progress visually.',
      'You focus better in quiet environments with minimal distractions.',
      'You retain information better when you teach it to others.',
      'Your creativity peaks when you take regular breaks during work sessions.',
      'You make better decisions after a good night\'s sleep.',
      'Your problem-solving abilities improve when you collaborate with others.',
    ];
    
    // Randomly select 5-7 insights
    final count = _random.nextInt(3) + 5;
    insights.shuffle();
    final selectedInsights = insights.take(count).toList();
    
    _persona = _persona!.copyWith(
      insights: selectedInsights,
      updatedAt: DateTime.now(),
    );
    
    return selectedInsights;
  }

  Future<AIAdvisorAnalysisModel> analyzeWithAIAdvisor(String input) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    
    // Generate a mock analysis based on the input
    final advisors = [
      AdvisorOpinionModel(
        role: 'Psychology',
        opinion: _generatePsychologyOpinion(input),
      ),
      AdvisorOpinionModel(
        role: 'Career',
        opinion: _generateCareerOpinion(input),
      ),
      AdvisorOpinionModel(
        role: 'Finance',
        opinion: _generateFinanceOpinion(input),
      ),
    ];
    
    return AIAdvisorAnalysisModel(
      summary: 'Analysis of your question: "$input"',
      advisors: advisors,
      conclusion: _generateConclusion(input, advisors),
      provider: 'Gemini',
      language: 'en',
    );
  }

  String _generatePsychologyOpinion(String input) {
    final lowercaseInput = input.toLowerCase();
    
    if (lowercaseInput.contains('stress') || lowercaseInput.contains('anxious') || lowercaseInput.contains('anxiety')) {
      return 'I notice you\'re discussing stress or anxiety. This is a common experience, especially for analytical personalities like yours. Consider implementing mindfulness practices or structured breaks to manage stress levels.';
    } else if (lowercaseInput.contains('motivation') || lowercaseInput.contains('procrastination')) {
      return 'Motivation challenges are common for your personality type. Try breaking tasks into smaller components and connecting them to your core values of growth and achievement.';
    } else if (lowercaseInput.contains('relationship') || lowercaseInput.contains('people') || lowercaseInput.contains('social')) {
      return 'As an INTJ, you may find social interactions draining at times. Consider scheduling dedicated recovery time after social events and being explicit about your communication preferences.';
    } else {
      return 'From a psychological perspective, your question relates to cognitive patterns typical of analytical personalities. Consider how your thinking style influences your approach to this situation.';
    }
  }

  String _generateCareerOpinion(String input) {
    final lowercaseInput = input.toLowerCase();
    
    if (lowercaseInput.contains('job') || lowercaseInput.contains('career') || lowercaseInput.contains('work')) {
      return 'Your career question aligns with your goal of professional growth. As a software developer, consider how this relates to your medium-term goal of learning a new programming language.';
    } else if (lowercaseInput.contains('learn') || lowercaseInput.contains('skill') || lowercaseInput.contains('education')) {
      return 'Your interest in learning aligns with your high motivation for growth. Consider creating a structured learning plan with measurable milestones to satisfy your need for achievement.';
    } else if (lowercaseInput.contains('project') || lowercaseInput.contains('team') || lowercaseInput.contains('collaborate')) {
      return 'For project work, leverage your analytical strengths while being mindful of your preference for independent work. Clear communication about expectations can help prevent friction.';
    } else {
      return 'From a career perspective, consider how this question relates to your professional development goals and your strengths in strategic planning and problem-solving.';
    }
  }

  String _generateFinanceOpinion(String input) {
    final lowercaseInput = input.toLowerCase();
    
    if (lowercaseInput.contains('money') || lowercaseInput.contains('finance') || lowercaseInput.contains('budget')) {
      return 'Your financial question should be approached with the same analytical rigor you apply to technical problems. Consider creating a structured plan with clear metrics for success.';
    } else if (lowercaseInput.contains('invest') || lowercaseInput.contains('saving')) {
      return 'For investment decisions, your analytical nature is an asset. Research thoroughly and consider how these financial choices align with your long-term goals.';
    } else if (lowercaseInput.contains('purchase') || lowercaseInput.contains('buy') || lowercaseInput.contains('spend')) {
      return 'When making purchasing decisions, evaluate not just the immediate benefit but also the long-term value and alignment with your goals and priorities.';
    } else {
      return 'While this may not directly relate to finances, consider the resource implications (time, energy, money) of any decision you make in this area.';
    }
  }

  String _generateConclusion(String input, List<AdvisorOpinionModel> advisors) {
    return 'Based on your personality profile and the various perspectives shared, I recommend approaching this situation with a structured plan that aligns with your analytical nature. Break down the challenge into manageable components, set clear metrics for success, and allocate specific time for reflection on your progress. This approach leverages your strengths while addressing potential blind spots.';
  }
}

extension PersonaModelCopyWith on PersonaModel {
  PersonaModel copyWith({
    String? id,
    String? userId,
    Map<String, dynamic>? basicInfo,
    PersonalityModel? personality,
    List<EmotionalStateModel>? emotionalStates,
    EmotionalStateModel? currentEmotionalState,
    List<GoalModel>? goals,
    BehaviorMetricsModel? behaviorMetrics,
    List<MotivationFactorModel>? motivationFactors,
    InteractionPreferenceModel? interactionPreference,
    List<String>? insights,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return PersonaModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      basicInfo: basicInfo ?? this.basicInfo,
      personality: personality ?? this.personality,
      emotionalStates: emotionalStates ?? this.emotionalStates,
      currentEmotionalState: currentEmotionalState ?? this.currentEmotionalState,
      goals: goals ?? this.goals,
      behaviorMetrics: behaviorMetrics ?? this.behaviorMetrics,
      motivationFactors: motivationFactors ?? this.motivationFactors,
      interactionPreference: interactionPreference ?? this.interactionPreference,
      insights: insights ?? this.insights,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}
