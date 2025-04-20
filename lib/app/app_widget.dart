import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_theme_manager.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/tasks/presentation/pages/tasks_page.dart';
import '../features/chat/presentation/pages/chat_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import 'app_observer.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _setupRouter();
    Bloc.observer = AppBlocObserver();
  }

  void _setupRouter() {
    _router = GoRouter(
      initialLocation: '/',
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            return ScaffoldWithNavBar(child: child);
          },
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: '/tasks',
              builder: (context, state) => const TasksPage(),
            ),
            GoRoute(
              path: '/chat',
              builder: (context, state) => const ChatPage(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Musa App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          routerConfig: _router,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('vi', 'VN'),
            Locale('en', 'US'),
          ],
        );
      },
    );
  }
}

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_outlined),
            activeIcon: Icon(Icons.task),
            label: 'Nhiệm vụ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            activeIcon: Icon(Icons.chat),
            label: 'Trò chuyện',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Cá nhân',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    if (location.startsWith('/')) {
      if (location == '/') return 0;
      if (location.startsWith('/tasks')) return 1;
      if (location.startsWith('/chat')) return 2;
      if (location.startsWith('/profile')) return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/tasks');
        break;
      case 2:
        GoRouter.of(context).go('/chat');
        break;
      case 3:
        GoRouter.of(context).go('/profile');
        break;
    }
  }
} 