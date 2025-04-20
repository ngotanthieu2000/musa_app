import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Timer _timer;
  
  @override
  void initState() {
    super.initState();
    _startTimer();
    print('Splash screen initialized');
  }
  
  void _startTimer() {
    _timer = Timer(const Duration(seconds: 3), () {
      print('Splash timer completed');
      if (!mounted) {
        print('Widget not mounted, skipping navigation');
        return;
      }
      
      try {
        final authState = context.read<AuthBloc>().state;
        print('Auth state: $authState');
        
        if (authState is AuthAuthenticated) {
          print('User is authenticated, navigating to home');
          context.go('/');
        } else {
          print('User is not authenticated, navigating to welcome');
          context.go('/welcome');
        }
      } catch (e) {
        print('Error during navigation: $e');
        // Fallback navigation
        context.go('/welcome');
      }
    });
  }
  
  @override
  void dispose() {
    _timer.cancel();
    print('Splash screen disposed');
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'Musa App',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
} 