import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/persona_bloc.dart';
import '../../domain/entities/goal.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/loading_indicator.dart';

class EditGoalPage extends StatefulWidget {
  final String goalId;

  const EditGoalPage({
    Key? key,
    required this.goalId,
  }) : super(key: key);

  @override
  State<EditGoalPage> createState() => _EditGoalPageState();
}

class _EditGoalPageState extends State<EditGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'personal';
  String _selectedTimeframe = 'medium-term';
  int _progress = 0;
  Goal? _goal;

  final List<String> _categories = [
    'personal',
    'career',
    'health',
    'finance',
    'education',
    'relationships',
    'other',
  ];

  final List<String> _timeframes = [
    'short-term',
    'medium-term',
    'long-term',
  ];

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  void _loadGoal() {
    final state = context.read<PersonaBloc>().state;
    if (state is PersonaLoaded) {
      final goal = state.persona.goals.firstWhere(
        (g) => g.id == widget.goalId,
        orElse: () => throw Exception('Goal not found'),
      );
      
      setState(() {
        _goal = goal;
        _descriptionController.text = goal.description;
        _selectedCategory = goal.category;
        _selectedTimeframe = goal.timeframe;
        _progress = goal.progress;
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Goal'),
      ),
      body: BlocListener<PersonaBloc, PersonaState>(
        listener: (context, state) {
          if (state is GoalUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Goal updated successfully'),
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
        child: _goal == null
            ? const LoadingIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Goal Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your goal',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a goal description';
                          }
                          return null;
                        },
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              category[0].toUpperCase() + category.substring(1),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Timeframe',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedTimeframe,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: _timeframes.map((timeframe) {
                          return DropdownMenuItem<String>(
                            value: timeframe,
                            child: Text(
                              timeframe[0].toUpperCase() + timeframe.substring(1),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedTimeframe = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: _progress.toDouble(),
                        min: 0,
                        max: 100,
                        divisions: 20,
                        label: '$_progress%',
                        onChanged: (value) {
                          setState(() {
                            _progress = value.round();
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('0%'),
                          Text(
                            '$_progress%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('100%'),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          onPressed: _updateGoal,
                          text: 'Update Goal',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _updateGoal() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedGoal = Goal(
        id: _goal!.id,
        category: _selectedCategory,
        description: _descriptionController.text.trim(),
        timeframe: _selectedTimeframe,
        progress: _progress,
        createdAt: _goal!.createdAt,
        updatedAt: DateTime.now(),
      );

      context.read<PersonaBloc>().add(UpdateGoalEvent(updatedGoal));
    }
  }
}
