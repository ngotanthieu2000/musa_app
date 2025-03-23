import 'package:flutter/material.dart';
import 'auth_dialog.dart';

class AuthButtons extends StatelessWidget {
  const AuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => _showAuthDialog(context, true),
          child: const Text('Đăng nhập'),
        ),
        const SizedBox(width: 16),
        OutlinedButton(
          onPressed: () => _showAuthDialog(context, false),
          child: const Text('Đăng ký'),
        ),
      ],
    );
  }

  void _showAuthDialog(BuildContext context, bool isLogin) {
    showDialog(
      context: context,
      builder: (context) => AuthDialog(isLogin: isLogin),
    );
  }
}
