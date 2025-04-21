import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Import sử dụng barrel files
import '../features/profile/index.dart';
import '../features/home/index.dart';
import '../features/auth/index.dart';
import '../features/splash/index.dart';
import '../features/navigation/index.dart';
import '../core/index.dart' as core;

// Tạo một wrapper widget cho route Edit Profile để xử lý loading
class EditProfileWrapper extends StatefulWidget {
  const EditProfileWrapper({Key? key}) : super(key: key);

  @override
  State<EditProfileWrapper> createState() => _EditProfileWrapperState();
}

class _EditProfileWrapperState extends State<EditProfileWrapper> {
  @override
  void initState() {
    super.initState();
    // Luôn tải dữ liệu profile mới nhất khi vào trang chỉnh sửa
    context.read<ProfileBloc>().add(const GetProfileEvent());
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
        if (state is ProfileInitial) {
          context.read<ProfileBloc>().add(const GetProfileEvent());
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

class AppRouter {
  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();
  
  static final GoRouter router = GoRouter(
    navigatorKey: _navigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/splash',
    routes: [
      // Auth and Splash routes
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
      
      // Main app navigation
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const AppNavigation(),
        ),
      ),
      
      // Profile page route
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const ProfilePage(),
        ),
        routes: [
          // Nested route for edit profile
          GoRoute(
            path: 'edit',
            name: 'profile-edit',
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
      
      // Change password page route
      GoRoute(
        path: '/change-password',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const ChangePasswordPage(),
        ),
      ),
      
      // Edit profile page route with profile data parameter (đường dẫn thay thế)
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
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