// // features/home/presentation/pages/home_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/home_bloc.dart';
// import '../widgets/feature_card.dart';
// import '../../../auth/presentation/widgets/auth_dialog.dart';
// import '../../domain/entities/feature.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Musa App'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.login),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => const AuthDialog(isLogin: true),
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.person_add),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => const AuthDialog(isLogin: false),
//               );
//             },
//           ),
//         ],
//       ),
//       body: BlocBuilder<HomeBloc, HomeState>(
//         builder: (context, state) {
//           if (state is HomeLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (state is HomeError) {
//             return Center(child: Text(state.message));
//           }
//           if (state is HomeLoaded) {
//             return GridView.builder(
//               padding: const EdgeInsets.all(16),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 1,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//               ),
//               itemCount: state.features.length,
//               itemBuilder: (context, index) {
//                 final homeFeature = state.features[index];
//                 final feature = Feature(
//                   title: homeFeature.title,
//                   icon: homeFeature.icon,
//                   route:
//                       '/${homeFeature.title.toLowerCase().replaceAll(' ', '_')}',
//                 );
//                 return FeatureCard(feature: feature);
//               },
//             );
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../widgets/home_header.dart';
import '../widgets/welcome_section.dart';
import '../widgets/today_tasks.dart';
import '../widgets/quick_actions_sidebar.dart';
import '../widgets/ai_assistant_card.dart';
import '../widgets/health_summary_card.dart';
import '../widgets/finance_summary_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF2F4F8),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: HomeHeader(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeSection(),
            SizedBox(height: 20),
            TodayTasks(),
            SizedBox(height: 20),
            QuickActionsSidebar(),
            SizedBox(height: 20),
            AiAssistantCard(),
            SizedBox(height: 20),
            HealthSummaryCard(),
            SizedBox(height: 20),
            FinanceSummaryCard(),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   type: BottomNavigationBarType.fixed,
      //   selectedItemColor: Colors.blueAccent,
      //   unselectedItemColor: Colors.grey,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
      //     BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      // ),
    );
  }
}
