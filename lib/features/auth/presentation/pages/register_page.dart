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
  final _emailFocusNode = FocusNode();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // Thêm listener để cập nhật UI khi mật khẩu thay đổi
    _passwordController.addListener(_updatePasswordRequirements);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_updatePasswordRequirements);
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _updatePasswordRequirements() {
    // Cập nhật UI khi mật khẩu thay đổi
    setState(() {});
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

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    // Kiểm tra có ít nhất 1 chữ hoa, 1 chữ thường và 1 số
    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = value.contains(RegExp(r'[a-z]'));
    bool hasDigits = value.contains(RegExp(r'[0-9]'));

    List<String> requirements = [];
    if (!hasUppercase) requirements.add('uppercase letter');
    if (!hasLowercase) requirements.add('lowercase letter');
    if (!hasDigits) requirements.add('number');

    if (requirements.isNotEmpty) {
      return 'Password must contain: ${requirements.join(', ')}';
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
      final fullName = _nameController.text.trim();
      final nameParts = fullName.split(' ');

      // Tách họ và tên
      String firstName = '';
      String lastName = '';

      if (nameParts.length > 1) {
        lastName = nameParts.last;
        firstName = nameParts.take(nameParts.length - 1).join(' ');
      } else {
        firstName = fullName;
        lastName = fullName;
      }

      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;

      debugPrint('Registering user: $firstName $lastName, $email');

      // Hiển thị thông tin đăng ký cho người dùng
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đang đăng ký với: $firstName $lastName, $email'),
          duration: const Duration(seconds: 2),
        ),
      );

      // Đăng ký tài khoản
      context.read<AuthBloc>().add(
        AuthRegisterEvent(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: MusaAppBar(
        title: 'Tạo tài khoản',
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

            // Kiểm tra nếu là lỗi email đã tồn tại
            final bool isEmailExistsError = state.message.toLowerCase().contains('email already exists') ||
                                           state.message.toLowerCase().contains('email đã tồn tại');

            if (isEmailExistsError) {
              // Hiển thị thông báo lỗi cụ thể cho email đã tồn tại
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Email này đã được đăng ký. Vui lòng sử dụng email khác hoặc đăng nhập.'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 5),
                  action: SnackBarAction(
                    label: 'Đăng nhập',
                    onPressed: () {
                      context.go('/login');
                    },
                  ),
                ),
              );

              // Focus vào trường email để người dùng có thể sửa
              _emailFocusNode.requestFocus();

              // Không hiển thị dialog lỗi chi tiết cho trường hợp này
            } else {
              // Hiển thị thông báo lỗi
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lỗi: ${state.message}'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 5),
                  action: state.errorType == ApiErrorType.network
                    ? SnackBarAction(
                        label: 'Thử lại',
                        onPressed: _register,
                      )
                    : null,
                ),
              );

              // Hiển thị dialog lỗi chi tiết
              BlocHelper.handleError(
                context,
                UnexpectedFailure(
                  message: state.message,
                  errorType: state.errorType ?? ApiErrorType.unknown,
                ),
                onRetry: state.errorType == ApiErrorType.network ? _register : null,
              );
            }
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
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header with illustration
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Icon(
                              Icons.person_add_rounded,
                              size: 70,
                              color: colorScheme.primary,
                            ),
                          ],
                        ),
                      ),

                      // Title and subtitle
                      Text(
                        'Tham gia cùng chúng tôi',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tạo tài khoản để bắt đầu hành trình của bạn',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Registration form
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
                              // Full name field
                              AppTextField(
                                controller: _nameController,
                                labelText: 'Họ và tên',
                                validator: _validateName,
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: colorScheme.primary,
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 16),

                              // Email field
                              AppTextField(
                                controller: _emailController,
                                focusNode: _emailFocusNode,
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

                              // Password field with requirements
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                    textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(height: 8),

                                  // Password requirements
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Yêu cầu mật khẩu:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        _buildPasswordRequirement(
                                          'Ít nhất 8 ký tự',
                                          _passwordController.text.length >= 8,
                                          colorScheme,
                                        ),
                                        _buildPasswordRequirement(
                                          'Ít nhất 1 chữ hoa',
                                          _passwordController.text.contains(RegExp(r'[A-Z]')),
                                          colorScheme,
                                        ),
                                        _buildPasswordRequirement(
                                          'Ít nhất 1 chữ thường',
                                          _passwordController.text.contains(RegExp(r'[a-z]')),
                                          colorScheme,
                                        ),
                                        _buildPasswordRequirement(
                                          'Ít nhất 1 số',
                                          _passwordController.text.contains(RegExp(r'[0-9]')),
                                          colorScheme,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Confirm password field
                              AppTextField(
                                controller: _confirmPasswordController,
                                labelText: 'Xác nhận mật khẩu',
                                validator: _validateConfirmPassword,
                                obscureText: _obscureConfirmPassword,
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: colorScheme.primary,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: colorScheme.primary.withOpacity(0.7),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword = !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                textInputAction: TextInputAction.done,
                                onEditingComplete: _register,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Create account button
                      AppButton(
                        text: 'Tạo tài khoản',
                        isLoading: state is AuthLoading,
                        onPressed: _register,
                        borderRadius: BorderRadius.circular(30),
                      ),

                      const SizedBox(height: 24),

                      // Sign in link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Đã có tài khoản?',
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.go('/login');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                            ),
                            child: const Text(
                              'Đăng nhập',
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

  Widget _buildPasswordRequirement(String text, bool isMet, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 14,
            color: isMet ? Colors.green : colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isMet ? Colors.green : colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}