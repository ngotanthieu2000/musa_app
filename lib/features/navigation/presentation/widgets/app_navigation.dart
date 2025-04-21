import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../tasks/presentation/pages/tasks_page.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import '../bloc/navigation_bloc.dart';
import 'bottom_nav_bar.dart';
import '../../../../core/di/injection_container.dart' as di;

class AppNavigation extends StatelessWidget {
  const AppNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomePage(),
      const TasksPage(),
      const ChatPage(),
    ];

    return BlocProvider<NavigationBloc>.value(
      value: di.sl<NavigationBloc>(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            body: pages[state.currentIndex],
            bottomNavigationBar: BottomNavBar(
              currentIndex: state.currentIndex,
              onTap: (index) {
                context.read<NavigationBloc>().add(NavigationTabChanged(index));
              },
            ),
          );
        },
      ),
    );
  }
}
