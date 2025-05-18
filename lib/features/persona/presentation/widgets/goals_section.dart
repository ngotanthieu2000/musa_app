import 'package:flutter/material.dart';
import '../../domain/entities/goal.dart';
import 'goal_card.dart';

class GoalsSection extends StatelessWidget {
  final List<Goal> goals;
  final VoidCallback onAddGoal;
  final Function(Goal) onUpdateGoal;
  final Function(String) onDeleteGoal;

  const GoalsSection({
    Key? key,
    required this.goals,
    required this.onAddGoal,
    required this.onUpdateGoal,
    required this.onDeleteGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              onPressed: onAddGoal,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (goals.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No goals yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: onAddGoal,
                    child: const Text('Add your first goal'),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GoalCard(
                  goal: goal,
                  onUpdate: () => onUpdateGoal(goal),
                  onDelete: () => onDeleteGoal(goal.id),
                ),
              );
            },
          ),
      ],
    );
  }
}
