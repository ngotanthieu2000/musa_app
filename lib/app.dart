import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/welcome/presentation/pages/welcome_page.dart';
import 'features/tasks/presentation/pages/tasks_page.dart';
import 'core/theme/app_colors.dart';
import 'core/di/injection_container.dart' as di;
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/navigation/presentation/bloc/navigation_bloc.dart';
import 'routes/app_router.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  StreamSubscription<AuthState>? _authChangeSub;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _authChangeSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Apply Material 3 status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(
          value: di.sl<AuthBloc>()..add(AuthCheckStatusEvent()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => di.sl<ProfileBloc>(),
        ),
        BlocProvider<NavigationBloc>(
          create: (context) => di.sl<NavigationBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Musa App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('vi', 'VN'),
          Locale('en', 'US'),
        ],
        locale: const Locale('vi', 'VN'),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to auth state changes to update router
    _authChangeSub = di.sl<AuthBloc>().stream.listen(
      (state) {
        if (state is AuthAuthenticated || state is AuthUnauthenticated) {
          setState(() {
            // This will trigger a rebuild and re-evaluate routes
          });
        }
      },
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