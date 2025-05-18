import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/persona_bloc.dart';
import '../widgets/persona_header.dart';
import '../widgets/emotional_state_card.dart';
import '../widgets/goals_section.dart';
import '../widgets/personality_section.dart';
import '../widgets/insights_section.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_display.dart';

class PersonaPage extends StatelessWidget {
  const PersonaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My AI Persona'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              context.read<PersonaBloc>().add(GetPersonaEvent());
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Chat with AI Advisor',
            onPressed: () {
              context.pushNamed('aiAdvisor');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed('aiAdvisor');
        },
        icon: const Icon(Icons.psychology),
        label: const Text('AI Advisor'),
      ),
      body: BlocBuilder<PersonaBloc, PersonaState>(
        builder: (context, state) {
          if (state is PersonaInitial) {
            // Trigger loading of persona
            context.read<PersonaBloc>().add(GetPersonaEvent());
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingIndicator(),
                  SizedBox(height: 16),
                  Text('Loading your AI Persona...'),
                ],
              ),
            );
          } else if (state is PersonaLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingIndicator(),
                  SizedBox(height: 16),
                  Text('Loading your AI Persona...'),
                ],
              ),
            );
          } else if (state is PersonaLoaded) {
            final persona = state.persona;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PersonaBloc>().add(GetPersonaEvent());
              },
              child: SingleChildScrollView(
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
                      child: PersonaHeader(persona: persona),
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
                              emotionalState: persona.currentEmotionalState,
                              onUpdate: () {
                                context.pushNamed('emotionalState');
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
                              goals: persona.goals,
                              onAddGoal: () {
                                context.pushNamed('addGoal');
                              },
                              onUpdateGoal: (goal) {
                                context.pushNamed('editGoal', pathParameters: {'id': goal.id});
                              },
                              onDeleteGoal: (goalId) {
                                _showDeleteConfirmationDialog(context, goalId);
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
                              personality: persona.personality,
                              onUpdate: () {
                                context.pushNamed('personality');
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
                              insights: persona.insights,
                              onRefresh: () {
                                context.read<PersonaBloc>().add(GenerateInsightsEvent());
                              },
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is PersonaError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ErrorDisplay(
                  message: state.message,
                  onRetry: () {
                    context.read<PersonaBloc>().add(GetPersonaEvent());
                  },
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String goalId) {
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
              context.read<PersonaBloc>().add(DeleteGoalEvent(goalId));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
