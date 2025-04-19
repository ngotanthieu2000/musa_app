import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_error_display.dart';
import '../bloc/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }
  
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }
  
  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mật khẩu không khớp'),
            backgroundColor: AppColors.errorLight,
          ),
        );
        return;
      }
      
      context.read<AuthBloc>().add(
        AuthEvent.registerRequested(
          name: _nameController.text.trim(),
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
      appBar: AppBar(
        title: const Text('Đăng ký'),
        centerTitle: true,
      ),
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
                        // Tiêu đề
                        Text(
                          'Tạo tài khoản mới',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.spacingS),
                        Text(
                          'Vui lòng điền đầy đủ thông tin để đăng ký',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDarkMode
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.spacingXXL),
                        
                        // Form đăng ký
                        AppTextField(
                          controller: _nameController,
                          label: 'Họ và tên',
                          hint: 'Nhập họ và tên của bạn',
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        const SizedBox(height: AppDimensions.spacingL),
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
                          textInputAction: TextInputAction.next,
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
                        const SizedBox(height: AppDimensions.spacingL),
                        AppTextField(
                          controller: _confirmPasswordController,
                          label: 'Xác nhận mật khẩu',
                          hint: 'Nhập lại mật khẩu của bạn',
                          obscureText: !_isConfirmPasswordVisible,
                          textInputAction: TextInputAction.done,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: _toggleConfirmPasswordVisibility,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingXL),
                        
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
                        
                        // Nút đăng ký
                        AppButton(
                          text: 'Đăng ký',
                          isFullWidth: true,
                          isLoading: state is AuthLoading,
                          onPressed: _register,
                          type: AppButtonType.primary,
                          size: AppButtonSize.large,
                        ),
                        const SizedBox(height: AppDimensions.spacingL),
                        
                        // Hoặc đăng ký với
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacingM,
                              ),
                              child: Text('Hoặc đăng ký với'),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacingL),
                        
                        // Đăng ký với mạng xã hội
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton(
                              icon: Icons.g_mobiledata,
                              onPressed: () {
                                // TODO: Implement Google Sign Up
                              },
                            ),
                            const SizedBox(width: AppDimensions.spacingL),
                            _buildSocialButton(
                              icon: Icons.facebook,
                              onPressed: () {
                                // TODO: Implement Facebook Sign Up
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacingXXL),
                        
                        // Đăng nhập
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Đã có tài khoản?',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                context.go('/login');
                              },
                              child: const Text('Đăng nhập'),
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