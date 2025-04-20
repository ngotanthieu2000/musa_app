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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      // Ẩn bàn phím
      FocusScope.of(context).unfocus();
      
      // Lấy dữ liệu từ form
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      
      debugPrint('Registering user: $name, $email');
      
      // Đăng ký tài khoản
      context.read<AuthBloc>().add(
        AuthRegisterEvent(
          name: name,
          email: email,
          password: password,
        ),
      );
    } else {
      // Hiển thị thông báo lỗi nếu validate không thành công
      NotificationService().showErrorNotification(
        context,
        message: 'Vui lòng sửa các lỗi trước khi tiếp tục',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MusaAppBar(
        title: 'Create Account',
        routeOnBack: '/login',
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            // Hiển thị dialog loading
            BlocHelper.showLoading(context, message: 'Đang tạo tài khoản...');
          } else if (state is AuthAuthenticated) {
            // Ẩn dialog loading nếu có
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            
            // Hiển thị thông báo đăng nhập thành công
            NotificationService().showSuccessNotification(
              context,
              message: 'Tài khoản đã được tạo thành công! Đang chuyển hướng...',
            );
            
            // Chuyển đến trang chính
            Future.delayed(const Duration(milliseconds: 500), () {
              context.go('/');
            });
          } else if (state is AuthError) {
            // Ẩn dialog loading nếu có
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            
            // Hiển thị thông báo lỗi
            BlocHelper.handleError(
              context, 
              UnexpectedFailure(
                message: state.message,
                errorType: state.errorType ?? ApiErrorType.unknown,
              ),
              onRetry: state.errorType == ApiErrorType.network ? _register : null,
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
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'Join Us Today',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create an account to get started',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    AppTextField(
                      controller: _nameController,
                      labelText: 'Full Name',
                      validator: _validateName,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    const SizedBox(height: 16),
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
                      labelText: 'Password',
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
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      validator: _validateConfirmPassword,
                      obscureText: _obscureConfirmPassword,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      text: 'Create Account',
                      isLoading: state is AuthLoading,
                      onPressed: _register,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () {
                            context.go('/login');
                          },
                          child: const Text('Sign In'),
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