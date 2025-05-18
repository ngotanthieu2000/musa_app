import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../bloc/persona_bloc.dart';
import '../../domain/entities/goal.dart';
import '../../../../core/widgets/app_button.dart';

class AddGoalPage extends StatefulWidget {
  const AddGoalPage({Key? key}) : super(key: key);

  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'personal';
  String _selectedTimeframe = 'medium-term';
  int _progress = 0;

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
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Goal'),
      ),
      body: BlocListener<PersonaBloc, PersonaState>(
        listener: (context, state) {
          if (state is GoalAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Goal added successfully'),
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
                  'Initial Progress',
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
                    onPressed: _addGoal,
                    text: 'Add Goal',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addGoal() {
    if (_formKey.currentState?.validate() ?? false) {
      final goal = Goal(
        id: const Uuid().v4(),
        category: _selectedCategory,
        description: _descriptionController.text.trim(),
        timeframe: _selectedTimeframe,
        progress: _progress,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      context.read<PersonaBloc>().add(AddGoalEvent(goal));
    }
  }
}
