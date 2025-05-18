import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/utils/bloc_helper.dart';
import '../../../../core/utils/notification_service.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/api_error_type.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email không được để trống';
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Email không hợp lệ';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }

    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }

    return null;
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      // Ẩn bàn phím
      FocusScope.of(context).unfocus();

      // Lấy dữ liệu từ form
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Đăng nhập
      context.read<AuthBloc>().add(
        AuthLoginEvent(
          email: email,
          password: password,
        ),
      );
    } else {
      // Hiển thị thông báo lỗi nếu validate không thành công
      NotificationService().showErrorNotification(
        context,
        message: 'Vui lòng điền đầy đủ thông tin đăng nhập',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: MusaAppBar(
        title: 'Đăng nhập',
        routeOnBack: '/welcome',
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            // Hiển thị dialog loading
            BlocHelper.showLoading(context, message: 'Đang đăng nhập...');
          } else if (state is AuthAuthenticated) {
            // Ẩn dialog loading nếu có
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }

            print('Login Page: Authenticated state received, user: ${state.user}');

            // Hiển thị thông báo đăng nhập thành công
            NotificationService().showSuccessNotification(
              context,
              message: 'Đăng nhập thành công!',
            );

            // Đảm bảo chuyển hướng đúng cách
            print('Login Page: Authentication successful, preparing to navigate');

            // Use a slight delay to ensure the UI has time to update
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                print('Login Page: Navigating to home');
                try {
                  context.go('/home');
                } catch (e) {
                  print('Login Page: Navigation error: $e');
                  // Phương án dự phòng nếu GoRouter gặp vấn đề
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                }
              }
            });
          } else if (state is AuthError) {
            // Ẩn dialog loading nếu có
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }

            print('Login Page: Error state received: ${state.message}');

            // Hiển thị thông báo lỗi
            BlocHelper.handleError(
              context,
              UnexpectedFailure(
                message: state.message,
                errorType: state.errorType ?? ApiErrorType.unknown,
              ),
              onRetry: state.errorType == ApiErrorType.network ? _login : null,
            );
          } else if (state is AuthUnauthenticated) {
            // Ẩn dialog loading nếu có
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primary.withOpacity(0.05),
                    colorScheme.surface,
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.screenPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo hoặc icon ứng dụng
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 20, bottom: 30),
                        child: Hero(
                          tag: 'app_logo',
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.psychology,
                              size: 60,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),

                      // Tiêu đề
                      Text(
                        'Chào mừng trở lại',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Đăng nhập để tiếp tục hành trình của bạn',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // Form đăng nhập
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: colorScheme.outline.withOpacity(0.1),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Email field
                              AppTextField(
                                controller: _emailController,
                                labelText: 'Email',
                                validator: _validateEmail,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: colorScheme.primary,
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 16),

                              // Password field
                              AppTextField(
                                controller: _passwordController,
                                labelText: 'Mật khẩu',
                                validator: _validatePassword,
                                obscureText: _obscurePassword,
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: colorScheme.primary,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: colorScheme.primary.withOpacity(0.7),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                textInputAction: TextInputAction.done,
                                onEditingComplete: _login,
                              ),

                              // Forgot password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    // TODO: Navigate to forgot password page
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Tính năng đang được phát triển'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: colorScheme.primary,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text('Quên mật khẩu?'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Login button
                      AppButton(
                        text: 'Đăng nhập',
                        isLoading: false, // Sử dụng dialog loading bên ngoài
                        onPressed: _login,
                        borderRadius: BorderRadius.circular(30),
                      ),

                      const SizedBox(height: 24),

                      // Register link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Chưa có tài khoản?',
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.go('/register');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                            ),
                            child: const Text(
                              'Đăng ký ngay',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}