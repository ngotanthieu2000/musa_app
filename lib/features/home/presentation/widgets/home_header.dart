import 'package:flutter/material.dart';
import 'package:musa_app/features/auth/presentation/widgets/auth_dialog.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Life Assistant',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('Super App Home',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black87),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.login),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const AuthDialog(isLogin: true),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const AuthDialog(isLogin: false),
            );
          },
        ),
      ],
    );
  }
}
