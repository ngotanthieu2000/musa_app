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
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../bloc/home_bloc.dart';
import '../widgets/home_header.dart';
import '../widgets/today_tasks_section.dart';
import '../widgets/goals_section.dart';
import '../widgets/assistant_card.dart';
import '../widgets/health_summary_card.dart';
import '../widgets/finance_summary_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  void _loadHomeData() {
    context.read<HomeBloc>().add(const HomeEvent.fetchData());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode 
          ? AppColors.backgroundDark 
          : AppColors.backgroundLight,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (homeData) => RefreshIndicator(
              onRefresh: () async => _loadHomeData(),
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    // Header
                    const SliverPersistentHeader(
                      delegate: _SliverHomeHeaderDelegate(),
                      pinned: true,
                    ),
                    
                    // Body
                    SliverPadding(
                      padding: const EdgeInsets.only(
                        left: AppDimensions.spacingL,
                        right: AppDimensions.spacingL,
                        top: AppDimensions.spacingS,
                        bottom: AppDimensions.spacingXL,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Reminder Card
                          if (homeData.reminder != null) _buildReminderCard(homeData.reminder!),
                          
                          // Today's Tasks
                          const TodayTasksSection(),
                          const SizedBox(height: AppDimensions.spacingL),
                          
                          // Goals
                          const GoalsSection(),
                          const SizedBox(height: AppDimensions.spacingL),
                          
                          // Assistant Card
                          const AssistantCard(),
                          const SizedBox(height: AppDimensions.spacingL),
                          
                          // Health Summary Card
                          const HealthSummaryCard(),
                          const SizedBox(height: AppDimensions.spacingL),
                          
                          // Finance Summary Card
                          const FinanceSummaryCard(),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.errorLight,
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingL),
                  ElevatedButton(
                    onPressed: _loadHomeData,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildReminderCard(String reminder) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingL),
      child: AppCard(
        backgroundColor: isDarkMode 
            ? AppColors.infoLight.withOpacity(0.1) 
            : AppColors.infoLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: Row(
          children: [
            const Icon(
              Icons.notifications_active,
              color: AppColors.infoLight,
              size: 24,
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Text(
                reminder,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverHomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _SliverHomeHeaderDelegate();
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color = isDarkMode 
        ? AppColors.surfaceDark 
        : AppColors.surfaceLight;
    
    return Container(
      color: color,
      child: const HomeHeader(),
    );
  }
  
  @override
  double get maxExtent => 150.0;
  
  @override
  double get minExtent => 100.0;
  
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
