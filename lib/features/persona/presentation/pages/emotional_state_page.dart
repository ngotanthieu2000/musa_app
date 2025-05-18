import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/persona_bloc.dart';
import '../../domain/entities/emotional_state.dart';
import '../../../../core/widgets/app_button.dart';

class EmotionalStatePage extends StatefulWidget {
  const EmotionalStatePage({Key? key}) : super(key: key);

  @override
  State<EmotionalStatePage> createState() => _EmotionalStatePageState();
}

class _EmotionalStatePageState extends State<EmotionalStatePage> {
  String _selectedMood = 'neutral';
  int _stressLevel = 5;
  int _energyLevel = 5;

  final List<MoodOption> _moodOptions = [
    MoodOption(
      mood: 'happy',
      icon: Icons.sentiment_very_satisfied,
      color: Colors.amber,
    ),
    MoodOption(
      mood: 'calm',
      icon: Icons.sentiment_satisfied,
      color: Colors.blue,
    ),
    MoodOption(
      mood: 'neutral',
      icon: Icons.sentiment_neutral,
      color: Colors.grey,
    ),
    MoodOption(
      mood: 'sad',
      icon: Icons.sentiment_dissatisfied,
      color: Colors.indigo,
    ),
    MoodOption(
      mood: 'anxious',
      icon: Icons.sentiment_very_dissatisfied,
      color: Colors.purple,
    ),
    MoodOption(
      mood: 'angry',
      icon: Icons.mood_bad,
      color: Colors.red,
    ),
    MoodOption(
      mood: 'motivated',
      icon: Icons.emoji_events,
      color: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How are you feeling?'),
      ),
      body: BlocListener<PersonaBloc, PersonaState>(
        listener: (context, state) {
          if (state is EmotionalStateRecorded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Emotional state updated'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          } else if (state is PersonaError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select your mood',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _moodOptions.length,
                itemBuilder: (context, index) {
                  final option = _moodOptions[index];
                  final isSelected = option.mood == _selectedMood;
                  return _buildMoodOption(option, isSelected);
                },
              ),
              const SizedBox(height: 32),
              const Text(
                'Stress Level',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _stressLevel.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: _stressLevel.toString(),
                onChanged: (value) {
                  setState(() {
                    _stressLevel = value.round();
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Low'),
                  Text(
                    _stressLevel.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('High'),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Energy Level',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _energyLevel.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: _energyLevel.toString(),
                activeColor: Colors.orange,
                onChanged: (value) {
                  setState(() {
                    _energyLevel = value.round();
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Low'),
                  Text(
                    _energyLevel.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('High'),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onPressed: _saveEmotionalState,
                  text: 'Save',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodOption(MoodOption option, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedMood = option.mood;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? option.color.withOpacity(0.3)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: option.color, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              option.icon,
              color: option.color,
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              option.mood[0].toUpperCase() + option.mood.substring(1),
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveEmotionalState() {
    final emotionalState = EmotionalState(
      mood: _selectedMood,
      stressLevel: _stressLevel,
      energy: _energyLevel,
      timestamp: DateTime.now(),
    );

    context.read<PersonaBloc>().add(RecordEmotionalStateEvent(emotionalState));
  }
}

class MoodOption {
  final String mood;
  final IconData icon;
  final Color color;

  MoodOption({
    required this.mood,
    required this.icon,
    required this.color,
  });
}
