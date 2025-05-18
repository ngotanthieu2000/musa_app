import 'package:flutter/material.dart';

void main() {
  runApp(const PersonaSimpleDemo());
}

class PersonaSimpleDemo extends StatelessWidget {
  const PersonaSimpleDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Persona Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PersonaHomePage(),
    );
  }
}

class PersonaHomePage extends StatefulWidget {
  const PersonaHomePage({Key? key}) : super(key: key);

  @override
  State<PersonaHomePage> createState() => _PersonaHomePageState();
}

class _PersonaHomePageState extends State<PersonaHomePage> {
  final Map<String, dynamic> _mockPersona = {
    'name': 'Alex Johnson',
    'occupation': 'Software Developer',
    'location': 'San Francisco, CA',
    'personality': <String, dynamic>{
      'type': 'MBTI',
      'value': 'INTJ',
      'traits': <String>['Analytical', 'Strategic', 'Independent', 'Determined', 'Curious'],
      'strengths': <String>['Problem-solving', 'Strategic planning', 'Critical thinking', 'Independent work'],
      'weaknesses': <String>['Perfectionism', 'Overthinking', 'Difficulty expressing emotions', 'Impatience with others'],
    },
    'emotionalState': <String, dynamic>{
      'mood': 'motivated',
      'stressLevel': 5,
      'energy': 7,
    },
    'goals': <Map<String, dynamic>>[
      <String, dynamic>{
        'id': '1',
        'category': 'career',
        'description': 'Learn a new programming language',
        'timeframe': 'medium-term',
        'progress': 65,
      },
      <String, dynamic>{
        'id': '2',
        'category': 'health',
        'description': 'Exercise 3 times per week',
        'timeframe': 'short-term',
        'progress': 40,
      },
      <String, dynamic>{
        'id': '3',
        'category': 'personal',
        'description': 'Read 20 books this year',
        'timeframe': 'long-term',
        'progress': 25,
      },
    ],
    'insights': <String>[
      'You tend to be more productive in the morning hours.',
      'Your stress levels decrease after physical activity.',
      'You complete tasks more efficiently when they align with your personal goals.',
      'You learn best through practical application rather than theory.',
      'Your motivation increases when you track your progress visually.',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Persona Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildEmotionalStateCard(),
            const SizedBox(height: 16),
            _buildGoalsSection(),
            const SizedBox(height: 16),
            _buildPersonalitySection(),
            const SizedBox(height: 16),
            _buildInsightsSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAIAdvisorDialog();
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[200],
          child: Text(
            (_mockPersona['name'] as String)[0].toUpperCase(),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _mockPersona['name'] as String,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _mockPersona['occupation'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _mockPersona['location'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmotionalStateCard() {
    final emotionalState = _mockPersona['emotionalState'] as Map<String, dynamic>;
    final mood = emotionalState['mood'] as String;
    final stressLevel = emotionalState['stressLevel'] as int;
    final energy = emotionalState['energy'] as int;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Emotional State',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEmotionalStateDialog();
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildEmotionIcon(mood),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getMoodTitle(mood),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Updated recently',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricColumn('Stress', stressLevel, 10),
                _buildMetricColumn('Energy', energy, 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionIcon(String mood) {
    IconData iconData;
    Color color;

    switch (mood.toLowerCase()) {
      case 'happy':
        iconData = Icons.sentiment_very_satisfied;
        color = Colors.amber;
        break;
      case 'calm':
        iconData = Icons.sentiment_satisfied;
        color = Colors.blue;
        break;
      case 'sad':
        iconData = Icons.sentiment_dissatisfied;
        color = Colors.indigo;
        break;
      case 'anxious':
        iconData = Icons.sentiment_very_dissatisfied;
        color = Colors.purple;
        break;
      case 'angry':
        iconData = Icons.mood_bad;
        color = Colors.red;
        break;
      case 'motivated':
        iconData = Icons.emoji_events;
        color = Colors.orange;
        break;
      default:
        iconData = Icons.sentiment_neutral;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: color,
        size: 32,
      ),
    );
  }

  Widget _buildMetricColumn(String label, int value, int max) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' / $max',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getMoodTitle(String mood) {
    // Capitalize first letter
    return '${mood[0].toUpperCase()}${mood.substring(1)}';
  }

  Widget _buildGoalsSection() {
    final goals = _mockPersona['goals'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Goals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                _showAddGoalDialog();
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: goals.length,
          itemBuilder: (context, index) {
            final goal = goals[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildGoalCard(goal),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGoalCard(Map<String, dynamic> goal) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildCategoryChip(goal['category']),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () {
                    _showEditGoalDialog(goal);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () {
                    _showDeleteGoalDialog(goal['id']);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              goal['description'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  _getTimeframeText(goal['timeframe']),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Text(
                  '${goal['progress']}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: goal['progress'] / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(goal['progress'])),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getCategoryColor(category).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 12,
          color: _getCategoryColor(category),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'career':
        return Colors.blue;
      case 'personal':
        return Colors.purple;
      case 'health':
        return Colors.green;
      case 'finance':
        return Colors.orange;
      case 'education':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Color _getProgressColor(int progress) {
    if (progress < 30) {
      return Colors.red;
    } else if (progress < 70) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  String _getTimeframeText(String timeframe) {
    switch (timeframe.toLowerCase()) {
      case 'short-term':
        return 'Short-term';
      case 'medium-term':
        return 'Medium-term';
      case 'long-term':
        return 'Long-term';
      default:
        return timeframe;
    }
  }

  Widget _buildPersonalitySection() {
    final personality = _mockPersona['personality'] as Map<String, dynamic>;
    final type = personality['type'] as String;
    final value = personality['value'] as String;
    final traits = personality['traits'] as List<String>;
    final strengths = personality['strengths'] as List<String>;
    final weaknesses = personality['weaknesses'] as List<String>;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Personality',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showPersonalityDialog();
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getPersonalityColor(value).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '$type: $value',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _getPersonalityColor(value),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Key Traits',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: traits.map((trait) {
                return Chip(
                  label: Text(trait),
                  backgroundColor: Colors.grey[200],
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Strengths',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...strengths.map((strength) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 16,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  strength,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Weaknesses',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...weaknesses.map((weakness) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info,
                                size: 16,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  weakness,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPersonalityColor(String personalityValue) {
    // For MBTI types
    if (personalityValue.startsWith('I')) {
      return Colors.blue;
    } else if (personalityValue.startsWith('E')) {
      return Colors.orange;
    }
    return Colors.purple;
  }

  Widget _buildInsightsSection() {
    final insights = _mockPersona['insights'] as List<String>;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'AI Insights',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    _showGenerateInsightsDialog();
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: insights.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          insights[index],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEmotionalStateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Emotional State'),
        content: const Text('This would open a page to update your emotional state.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Goal'),
        content: const Text('This would open a page to add a new goal.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEditGoalDialog(Map<String, dynamic> goal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Goal'),
        content: Text('This would open a page to edit the goal: ${goal['description']}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteGoalDialog(String goalId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Goal'),
        content: const Text('Are you sure you want to delete this goal?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Goal deleted (simulated)'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showPersonalityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Personality'),
        content: const Text('This would open a page to update your personality assessment.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showGenerateInsightsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Insights'),
        content: const Text('This would generate new AI insights based on your data.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Insights generated (simulated)'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _showAIAdvisorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Advisor'),
        content: const SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('This would open the AI Advisor chat interface.'),
              SizedBox(height: 16),
              Text('The AI Advisor would provide personalized advice based on your AI Persona profile.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
