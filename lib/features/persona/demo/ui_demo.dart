import 'package:flutter/material.dart';
import '../domain/entities/persona.dart';
import '../domain/entities/emotional_state.dart';
import '../domain/entities/goal.dart';
import '../domain/entities/personality.dart';
import '../domain/entities/interaction_preference.dart';
import '../domain/entities/motivation_factor.dart';
import '../domain/entities/behavior_metrics.dart';
import '../domain/entities/ai_advisor_analysis.dart';
import '../presentation/widgets/ai_advisor_chat.dart';
import '../presentation/widgets/emotional_state_card.dart';
import '../presentation/widgets/goals_section.dart';
import '../presentation/widgets/personality_section.dart';
import '../presentation/widgets/insights_section.dart';
import '../presentation/widgets/persona_header.dart';

void main() {
  runApp(const UIDemo());
}

class UIDemo extends StatelessWidget {
  const UIDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({Key? key}) : super(key: key);

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Persona _mockPersona = _createMockPersona();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Demo'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Persona'),
            Tab(text: 'AI Advisor'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPersonaTab(),
          _buildAIAdvisorTab(),
        ],
      ),
    );
  }

  Widget _buildPersonaTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero section with gradient background
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ],
              ),
            ),
            child: PersonaHeader(persona: _mockPersona),
          ),

          // Main content with cards
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Emotional state card with animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: EmotionalStateCard(
                    emotionalState: _mockPersona.currentEmotionalState,
                    onUpdate: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Update Emotional State')),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Goals section with improved UI
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: GoalsSection(
                    goals: _mockPersona.goals,
                    onAddGoal: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Add Goal')),
                      );
                    },
                    onUpdateGoal: (goal) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Update Goal: ${goal.description}')),
                      );
                    },
                    onDeleteGoal: (goalId) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Delete Goal: $goalId')),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Personality section with improved UI
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: PersonalitySection(
                    personality: _mockPersona.personality,
                    onUpdate: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Update Personality')),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Insights section with improved UI
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: InsightsSection(
                    insights: _mockPersona.insights,
                    onRefresh: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Generate Insights')),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIAdvisorTab() {
    return Column(
      children: [
        // Advisor info banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
                Theme.of(context).colorScheme.primary.withOpacity(0.6),
              ],
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Advisor',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Personalized advice based on your AI Persona',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Chat interface
        Expanded(
          child: AIAdvisorChat(
            persona: _mockPersona,
            onAnalyze: (input) {
              // Simulate AI response after a delay
              Future.delayed(const Duration(seconds: 2), () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Analyzing: $input')),
                );
              });
            },
          ),
        ),
      ],
    );
  }
}

// Helper function to create a mock persona for demo purposes
Persona _createMockPersona() {
  return Persona(
    id: 'mock-id',
    userId: 'user-123',
    basicInfo: {
      'name': 'Alex Johnson',
      'age': 32,
      'occupation': 'Software Developer',
      'location': 'San Francisco, CA',
    },
    personality: Personality(
      type: 'MBTI',
      value: 'INTJ',
      traits: const ['Analytical', 'Strategic', 'Independent', 'Determined', 'Curious'],
      strengths: const ['Problem-solving', 'Long-term planning', 'Independent thinking'],
      weaknesses: const ['May appear aloof', 'Perfectionist tendencies'],
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    emotionalStates: [
      EmotionalState(
        mood: 'Motivated',
        stressLevel: 5,
        energy: 7,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      EmotionalState(
        mood: 'Focused',
        stressLevel: 6,
        energy: 8,
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ],
    currentEmotionalState: EmotionalState(
      mood: 'Motivated',
      stressLevel: 5,
      energy: 7,
      timestamp: DateTime.now(),
    ),
    goals: [
      Goal(
        id: 'goal-1',
        category: 'career',
        description: 'Learn a new programming language',
        timeframe: 'medium-term',
        progress: 65,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Goal(
        id: 'goal-2',
        category: 'health',
        description: 'Exercise 3 times per week',
        timeframe: 'short-term',
        progress: 40,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Goal(
        id: 'goal-3',
        category: 'personal',
        description: 'Read 20 books this year',
        timeframe: 'long-term',
        progress: 25,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ],
    behaviorMetrics: BehaviorMetrics(
      todoCompletionRate: 0.75,
      avgTodoCompletionTime: 2.5,
      learningTimePerWeek: 8.5,
      reflectionFrequency: 3.0,
      appUsageFrequency: 12.0,
      lastUpdated: DateTime.now().subtract(const Duration(days: 3)),
    ),
    motivationFactors: [
      MotivationFactor(
        factor: 'Learning new skills',
        importance: 9,
        notes: 'Enjoys challenging technical problems',
        updatedAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      MotivationFactor(
        factor: 'Work-life balance',
        importance: 8,
        notes: 'Values time for personal projects',
        updatedAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      MotivationFactor(
        factor: 'Recognition',
        importance: 6,
        notes: 'Appreciates acknowledgment of achievements',
        updatedAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ],
    interactionPreference: InteractionPreference(
      communicationStyle: 'Direct and concise',
      responseLength: 'Medium',
      topicPreferences: const ['Technology', 'Science', 'Productivity'],
      avoidTopics: const ['Politics', 'Gossip'],
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    insights: [
      'You tend to be more productive in the morning hours.',
      'Your stress levels decrease after physical activity.',
      'You complete tasks more efficiently when they align with your personal goals.',
      'You learn best through practical application rather than theory.',
      'Your motivation increases when you track your progress visually.',
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 90)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
    version: 1,
  );
}
