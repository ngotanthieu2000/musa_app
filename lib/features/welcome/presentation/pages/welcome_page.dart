import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Icon(
                  Icons.assistant_rounded,
                  size: 120,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Welcome to\nMusa App',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Smart task management app for your daily life',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const Spacer(),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  // When state changes to guest mode, navigate to home
                  if (state is AuthGuestMode) {
                    context.go('/');
                  }
                },
                child: ElevatedButton(
                  onPressed: () {
                    // Dispatch event to enter guest mode
                    debugPrint('Dispatching AuthEnterGuestModeEvent');
                    context.read<AuthBloc>().add(AuthEnterGuestModeEvent());
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    textStyle: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Continue without signing in'),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => context.go('/login'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: theme.colorScheme.primary),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Sign In / Register'),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
} 