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
            WidgetsBinding.instance.addPostFrameCallback((_) {
              print('Login Page: Navigating to home');
              try {
                context.go('/');
              } catch (e) {
                print('Login Page: Navigation error: $e');
                // Phương án dự phòng nếu GoRouter gặp vấn đề
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'Chào mừng trở lại',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Đăng nhập để tiếp tục',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    AppTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      validator: _validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _passwordController,
                      labelText: 'Mật khẩu',
                      validator: _validatePassword,
                      obscureText: _obscurePassword,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Navigate to forgot password page
                        },
                        child: const Text('Quên mật khẩu?'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      text: 'Đăng nhập',
                      isLoading: false, // Sử dụng dialog loading bên ngoài
                      onPressed: _login,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Chưa có tài khoản?'),
                        TextButton(
                          onPressed: () {
                            context.go('/register');
                          },
                          child: const Text('Đăng ký ngay'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 