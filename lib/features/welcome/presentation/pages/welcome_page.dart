import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
              const SizedBox(height: 24),
              Text(
                'Please sign in to use all features',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => context.go('/register'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: theme.colorScheme.primary),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Create Account'),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
} 