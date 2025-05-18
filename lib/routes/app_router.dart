import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Import sử dụng barrel files
import '../features/profile/index.dart';
import '../features/home/index.dart';
import '../features/auth/index.dart';
import '../features/splash/index.dart';
import '../features/welcome/presentation/pages/welcome_page.dart';
import '../features/navigation/index.dart';
import '../features/tasks/presentation/pages/tasks_page.dart';
import '../features/tasks/presentation/pages/task_detail_page.dart';
import '../features/tasks/presentation/bloc/tasks_bloc.dart';
import '../features/chat/presentation/pages/chat_page.dart';
import '../features/persona/presentation/pages/minimal_persona_page.dart';
import '../features/persona/presentation/pages/minimal_ai_advisor_page.dart';
import '../core/index.dart' as core;

// Tạo một wrapper widget cho route Edit Profile để xử lý loading
class EditProfileWrapper extends StatefulWidget {
  const EditProfileWrapper({Key? key}) : super(key: key);

  @override
  State<EditProfileWrapper> createState() => _EditProfileWrapperState();
}

class _EditProfileWrapperState extends State<EditProfileWrapper> {
  bool _hasLoadedProfile = false;

  @override
  void initState() {
    super.initState();
    // Chỉ tải profile một lần khi khởi tạo
    _loadProfileData();
  }

  void _loadProfileData() {
    if (!_hasLoadedProfile) {
      print('DEBUG: Loading profile data in EditProfileWrapper');
      context.read<ProfileBloc>().add(const GetProfileEvent());
      _hasLoadedProfile = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return EditProfilePage(profile: state.profile);
        }

        // Nếu profile chưa được tải, trigger event load profile
        if (state is ProfileInitial && !_hasLoadedProfile) {
          _loadProfileData();
        }

        // Hiển thị loading trong khi chờ profile
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chỉnh sửa hồ sơ'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

// Scaffold với BottomNavigationBar dùng chung
class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => core.sl<NavigationBloc>(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            body: child,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _calculateSelectedIndex(context),
              onTap: (index) => _onItemTapped(index, context),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.task),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/tasks')) {
      return 1;
    }
    if (location.startsWith('/chat')) {
      return 2;
    }
    if (location.startsWith('/profile')) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/tasks');
        break;
      case 2:
        context.go('/chat');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/splash',
    routes: [
      // Auth and Splash routes (full-screen routes)
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const SplashPage(),
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const WelcomePage(),
        ),
      ),

      // Shell route cho main navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          // Home route
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const HomePage(),
            ),
          ),

          // Tasks route
          GoRoute(
            path: '/tasks',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: BlocProvider(
                create: (context) => core.sl<TasksBloc>(),
                child: const TasksPage(),
              ),
            ),
            routes: [
              // Task detail route
              GoRoute(
                path: 'detail/:id',
                name: 'task-detail',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) {
                  final taskId = state.pathParameters['id'] ?? '';
                  return MaterialPage<void>(
                    key: state.pageKey,
                    child: BlocProvider(
                      create: (context) => core.sl<TasksBloc>(),
                      child: TaskDetailPage(taskId: taskId),
                    ),
                  );
                },
              ),
            ],
          ),

          // Chat route
          GoRoute(
            path: '/chat',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const ChatPage(),
            ),
          ),

          // Profile route
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: BlocProvider(
                create: (context) => core.sl<ProfileBloc>(),
                child: const ProfilePage(),
              ),
            ),
            routes: [
              // Nested route for edit profile
              GoRoute(
                path: 'edit',
                name: 'profile-edit',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) => MaterialPage<void>(
                  key: state.pageKey,
                  child: BlocProvider(
                    create: (context) => core.sl<ProfileBloc>(),
                    child: const EditProfileWrapper(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      // Redirect legacy routes
      GoRoute(
        path: '/',
        redirect: (context, state) => '/home',
      ),

      // Change password page route
      GoRoute(
        path: '/change-password',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const ChangePasswordPage(),
        ),
      ),

      // AI Persona page route
      GoRoute(
        path: '/persona',
        name: 'persona',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const MinimalPersonaPage(),
        ),
        routes: [
          // AI Advisor page route
          GoRoute(
            path: 'ai-advisor',
            name: 'aiAdvisor',
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const MinimalAIAdvisorPage(),
            ),
          ),
        ],
      ),

      // Edit profile page route with profile data parameter (đường dẫn thay thế)
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: BlocProvider(
            create: (context) => core.sl<ProfileBloc>(),
            child: const EditProfileWrapper(),
          ),
        ),
      ),

      // Đảm bảo có route chính xác cho /profile/edit (không phải nested)
      GoRoute(
        path: '/profile/edit',
        name: 'profile-edit-legacy',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: BlocProvider(
            create: (context) => core.sl<ProfileBloc>(),
            child: const EditProfileWrapper(),
          ),
        ),
      ),
    ],
  );
}