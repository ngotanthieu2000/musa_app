import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/persona_bloc.dart';
import '../widgets/ai_advisor_chat.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_display.dart';

class AIAdvisorPage extends StatelessWidget {
  const AIAdvisorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Advisor'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About AI Advisor',
            onPressed: () {
              _showAboutDialog(context);
            },
          ),
        ],
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
                  Text('Loading your AI Advisor...'),
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
                  Text('Loading your AI Advisor...'),
                ],
              ),
            );
          } else if (state is PersonaLoaded) {
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
                    persona: state.persona,
                    onAnalyze: (input) {
                      context.read<PersonaBloc>().add(AnalyzeWithAIAdvisorEvent(input));
                    },
                  ),
                ),
              ],
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

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.psychology,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('About AI Advisor'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The AI Advisor provides personalized advice based on your AI Persona profile.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Features:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildFeatureItem(context, 'Personalized responses based on your personality'),
            _buildFeatureItem(context, 'Multiple advisor perspectives (Career, Psychology, etc.)'),
            _buildFeatureItem(context, 'Insights that help improve your AI Persona'),
            _buildFeatureItem(context, 'Secure and private conversations'),
          ],
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

  Widget _buildFeatureItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
