import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_error_display.dart';
import '../../../../core/widgets/app_bar.dart';
import '../bloc/auth_bloc.dart';
import 'register_page.dart';

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
      // Ẩn bàn phím
      FocusScope.of(context).unfocus();
      
      // Show a message that we're attempting to connect to the server
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connecting to server...'),
          duration: Duration(seconds: 1),
        ),
      );
      
      // Lưu thông tin đăng nhập vào bộ nhớ tạm nếu thành công
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      
      // Dispatch login event
      context.read<AuthBloc>().add(
        AuthLoginEvent(
          email: email,
          password: password,
        ),
      );
      
      // For debugging - print the attempt
      debugPrint('Login attempt with email: $email');
    } else {
      // Hiển thị thông báo lỗi nếu validate không thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors above before continuing'),
          backgroundColor: Colors.orange,
        ),
      );
    }
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
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      appBar: const MusaAppBar(
        title: 'Sign In',
        showBackButton: false,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to home page on successful authentication
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login successful! Redirecting to home page...'),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              GoRouter.of(context).go('/');
            });
          } else if (state is AuthGuestMode) {
            // Navigate to home page in guest mode
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Entering guest mode...'),
                backgroundColor: Colors.blue,
              ),
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              GoRouter.of(context).go('/');
            });
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Login failed', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(state.message),
                    const Text('Please try again or continue as guest', style: TextStyle(fontSize: 12)),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
              ),
            );
          }
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
                        // Logo and title
                        Center(
                          child: Icon(
                            Icons.account_circle,
                            size: 80,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingL),
                        Text(
                          'Welcome Back',
                          style: textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.spacingS),
                        Text(
                          'Sign in to continue',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.spacingXXL),
                        
                        // Login form
                        AppTextField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(Icons.email_outlined),
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: AppDimensions.spacingL),
                        AppTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: 'Enter your password',
                          obscureText: !_isPasswordVisible,
                          textInputAction: TextInputAction.done,
                          prefixIcon: const Icon(Icons.lock_outline),
                          validator: _validatePassword,
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
                        
                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Navigate to forgot password
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Feature under development'),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: colorScheme.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingL),
                        
                        // Login button
                        AppButton(
                          text: 'Sign In',
                          isFullWidth: true,
                          isLoading: state is AuthLoading,
                          onPressed: _login,
                          type: AppButtonType.primary,
                        ),
                        const SizedBox(height: AppDimensions.spacingM),
                        
                        // Guest login button
                        AppButton(
                          text: 'Continue as Guest',
                          isFullWidth: true,
                          onPressed: () {
                            context.read<AuthBloc>().add(AuthEnterGuestModeEvent());
                          },
                          type: AppButtonType.secondary,
                        ),
                        const SizedBox(height: AppDimensions.spacingM),
                        
                        // Use test credentials
                        Center(
                          child: TextButton.icon(
                            icon: const Icon(Icons.code, size: 16),
                            label: const Text('Use Test Credentials'),
                            onPressed: () {
                              // Fill with test credentials
                              _emailController.text = 'test@example.com';
                              _passwordController.text = 'password123';
                              // Show hint
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Test credentials filled. Press Sign In to continue.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingS),
                        
                        // Register
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                context.go('/register');
                              },
                              child: Text(
                                'Sign Up',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppDimensions.spacingL),
                        
                        // Or login with
                        Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacingM,
                              ),
                              child: Text(
                                'Or sign in with',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacingL),
                        
                        // Social login buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton(
                              icon: Icons.g_mobiledata,
                              color: Colors.redAccent,
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Feature under development'),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: AppDimensions.spacingL),
                            _buildSocialButton(
                              icon: Icons.facebook,
                              color: Colors.blue,
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Feature under development'),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: AppDimensions.spacingL),
                            _buildSocialButton(
                              icon: Icons.apple,
                              color: Colors.black,
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Feature under development'),
                                  ),
                                );
                              },
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
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      elevation: 1,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: Colors.white,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            size: 28,
            color: color,
          ),
        ),
      ),
    );
  }
} 