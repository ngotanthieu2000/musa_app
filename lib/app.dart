import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dartz/dartz.dart' hide State;

import 'core/error/failures.dart';
import 'core/theme/app_theme.dart';
import 'core/usecases/usecase.dart';
import 'features/auth/domain/entities/auth_tokens.dart';
import 'features/auth/domain/entities/user.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/refresh_token_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/widgets/auth_wrapper.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/welcome/presentation/pages/welcome_page.dart';
import 'features/tasks/presentation/pages/tasks_page.dart';
import 'injection_container.dart' as di;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              di.sl<AuthBloc>()..add(AuthCheckStatusEvent()),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final GoRouter _router;
  final _refreshNotifier = GoRouterRefreshNotifier();

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const WelcomePage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/tasks',
          builder: (context, state) => const TasksPage(),
        ),
      ],
      initialLocation: '/splash',
      debugLogDiagnostics: true,
      refreshListenable: _refreshNotifier,
      redirect: (BuildContext context, GoRouterState state) {
        final authBloc = BlocProvider.of<AuthBloc>(context);
        final authState = authBloc.state;
        
        // Handle splash screen
        if (state.uri.path == '/splash') {
          if (authState is AuthInitial || authState is AuthLoading) {
            debugPrint('Loading auth status, staying at splash');
            return null; // Stay on splash while loading
          }
          
          if (authState is AuthAuthenticated) {
            debugPrint('User is authenticated, redirecting to home page');
            return '/';
          }
          
          // Always redirect to welcome page if not authenticated
          debugPrint('User is not authenticated, redirecting to welcome page');
          return '/welcome';
        }
        
        // Allow direct access to welcome, login and register pages
        if (state.uri.path == '/welcome' || 
            state.uri.path == '/login' || 
            state.uri.path == '/register') {
          // If already authenticated and trying to go to login page, redirect to home
          if (authState is AuthAuthenticated) {
            return '/';
          }
          return null;
        }
        
        // For home page and other protected routes
        if (state.uri.path == '/' || state.uri.path.startsWith('/dashboard')) {
          // If authenticated, allow access
          if (authState is AuthAuthenticated) {
            debugPrint('User is authenticated, allowing access to ${state.uri.path}');
            return null;
          }
          
          // If user is on loading or initial state, don't redirect
          if (authState is AuthLoading || authState is AuthInitial) {
            return null;
          }
          
          // For root path when not authenticated, show login page
          debugPrint('User is not authenticated, redirecting to login page');
          return '/login';
        }
        
        return null; // No redirect needed
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Musa App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

// Helper class to refresh the router when the auth state changes
class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier() {
    _authChangeSub = di.sl<AuthBloc>().stream.listen(
      (state) {
        debugPrint('Auth state changed: $state');
        notifyListeners();
      },
    );
  }

  late final StreamSubscription<AuthState> _authChangeSub;

  @override
  void dispose() {
    _authChangeSub.cancel();
    super.dispose();
  }
} 