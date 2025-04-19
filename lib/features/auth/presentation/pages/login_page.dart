import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_error_display.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }
  
  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthEvent.loginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            authenticated: (_) {
              context.go('/');
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacingXL),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo và tiêu đề
                        Center(
                          child: Icon(
                            Icons.account_circle,
                            size: 80,
                            color: isDarkMode 
                                ? AppColors.primaryDark 
                                : AppColors.primaryLight,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingL),
                        Text(
                          'Đăng nhập',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.spacingS),
                        Text(
                          'Vui lòng đăng nhập để tiếp tục',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDarkMode
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.spacingXXL),
                        
                        // Form đăng nhập
                        AppTextField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'Nhập email của bạn',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        const SizedBox(height: AppDimensions.spacingL),
                        AppTextField(
                          controller: _passwordController,
                          label: 'Mật khẩu',
                          hint: 'Nhập mật khẩu của bạn',
                          obscureText: !_isPasswordVisible,
                          textInputAction: TextInputAction.done,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingM),
                        
                        // Quên mật khẩu
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Navigate to forgot password
                            },
                            child: const Text('Quên mật khẩu?'),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingL),
                        
                        // Hiển thị lỗi nếu có
                        state.maybeWhen(
                          error: (failure) => Column(
                            children: [
                              AppErrorDisplay(
                                message: failure.message,
                                details: failure.details,
                                showIcon: false,
                              ),
                              const SizedBox(height: AppDimensions.spacingL),
                            ],
                          ),
                          orElse: () => const SizedBox.shrink(),
                        ),
                        
                        // Nút đăng nhập
                        AppButton(
                          text: 'Đăng nhập',
                          isFullWidth: true,
                          isLoading: state is AuthLoading,
                          onPressed: _login,
                          type: AppButtonType.primary,
                          size: AppButtonType.primary,
                        ),
                        const SizedBox(height: AppDimensions.spacingL),
                        
                        // Hoặc đăng nhập với
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacingM,
                              ),
                              child: Text('Hoặc đăng nhập với'),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacingL),
                        
                        // Đăng nhập với mạng xã hội
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton(
                              icon: Icons.g_mobiledata,
                              onPressed: () {
                                // TODO: Implement Google Sign In
                              },
                            ),
                            const SizedBox(width: AppDimensions.spacingL),
                            _buildSocialButton(
                              icon: Icons.facebook,
                              onPressed: () {
                                // TODO: Implement Facebook Sign In
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacingXXL),
                        
                        // Đăng ký
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Chưa có tài khoản?',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                context.push('/register');
                              },
                              child: const Text('Đăng ký ngay'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
          border: Border.all(
            color: isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        child: Icon(
          icon,
          size: 30,
          color: isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
      ),
    );
  }
} 