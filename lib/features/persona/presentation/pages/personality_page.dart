import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/persona_bloc.dart';
import '../../domain/entities/personality.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/loading_indicator.dart';

class PersonalityPage extends StatefulWidget {
  const PersonalityPage({Key? key}) : super(key: key);

  @override
  State<PersonalityPage> createState() => _PersonalityPageState();
}

class _PersonalityPageState extends State<PersonalityPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedType = 'MBTI';
  String _selectedValue = 'INTJ';
  final _traitsController = TextEditingController();
  final _strengthsController = TextEditingController();
  final _weaknessesController = TextEditingController();
  Personality? _personality;

  final Map<String, List<String>> _personalityOptions = {
    'MBTI': ['INTJ', 'INTP', 'ENTJ', 'ENTP', 'INFJ', 'INFP', 'ENFJ', 'ENFP', 'ISTJ', 'ISFJ', 'ESTJ', 'ESFJ', 'ISTP', 'ISFP', 'ESTP', 'ESFP'],
    'BIG5': ['Openness', 'Conscientiousness', 'Extraversion', 'Agreeableness', 'Neuroticism'],
    'DISC': ['Dominance', 'Influence', 'Steadiness', 'Conscientiousness'],
  };

  @override
  void initState() {
    super.initState();
    _loadPersonality();
  }

  void _loadPersonality() {
    final state = context.read<PersonaBloc>().state;
    if (state is PersonaLoaded) {
      final personality = state.persona.personality;
      
      setState(() {
        _personality = personality;
        _selectedType = personality.type;
        _selectedValue = personality.value;
        _traitsController.text = personality.traits.join(', ');
        _strengthsController.text = personality.strengths.join(', ');
        _weaknessesController.text = personality.weaknesses.join(', ');
      });
    }
  }

  @override
  void dispose() {
    _traitsController.dispose();
    _strengthsController.dispose();
    _weaknessesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personality Assessment'),
      ),
      body: BlocListener<PersonaBloc, PersonaState>(
        listener: (context, state) {
          if (state is PersonalityUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Personality updated successfully'),
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
        child: _personality == null
            ? const LoadingIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Personality Type',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: _personalityOptions.keys.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedType = value;
                              _selectedValue = _personalityOptions[value]![0];
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Personality Value',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _personalityOptions[_selectedType]!.contains(_selectedValue)
                            ? _selectedValue
                            : _personalityOptions[_selectedType]![0],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: _personalityOptions[_selectedType]!.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedValue = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Key Traits (comma separated)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _traitsController,
                        decoration: const InputDecoration(
                          hintText: 'e.g., Analytical, Strategic, Independent',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter at least one trait';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Strengths (comma separated)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _strengthsController,
                        decoration: const InputDecoration(
                          hintText: 'e.g., Problem-solving, Strategic planning',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter at least one strength';
                          }
                          return null;
                        },
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Weaknesses (comma separated)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _weaknessesController,
                        decoration: const InputDecoration(
                          hintText: 'e.g., Perfectionism, Overthinking',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter at least one weakness';
                          }
                          return null;
                        },
                        maxLines: 3,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          onPressed: _updatePersonality,
                          text: 'Update Personality',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _updatePersonality() {
    if (_formKey.currentState?.validate() ?? false) {
      final traits = _traitsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
          
      final strengths = _strengthsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
          
      final weaknesses = _weaknessesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final updatedPersonality = Personality(
        type: _selectedType,
        value: _selectedValue,
        traits: traits,
        strengths: strengths,
        weaknesses: weaknesses,
        updatedAt: DateTime.now(),
      );

      context.read<PersonaBloc>().add(UpdatePersonalityEvent(updatedPersonality));
    }
  }
}
