import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../profile/domain/entities/goal.dart';
import '../bloc/home_bloc.dart';

class GoalsSection extends StatelessWidget {
  const GoalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mục tiêu của bạn',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                context.go('/profile');
              },
              child: const Text('Xem tất cả'),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingM),
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return state.maybeWhen(
              loaded: (homeData) {
                if (homeData.goals.isEmpty) {
                  return const AppEmptyState(
                    title: 'Chưa có mục tiêu nào',
                    message: 'Bạn chưa đặt mục tiêu nào. Hãy tạo mục tiêu để theo dõi tiến độ của bạn.',
                    icon: Icons.flag_outlined,
                  );
                }
                
                return SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: homeData.goals.length,
                    itemBuilder: (context, index) {
                      return _buildGoalCard(context, homeData.goals[index]);
                    },
                  ),
                );
              },
              orElse: () => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildGoalCard(BuildContext context, Goal goal) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final progress = goal.progress / goal.targetValue;
    
    // Get color based on category
    Color categoryColor;
    IconData categoryIcon;
    
    switch (goal.category) {
      case GoalCategory.health:
        categoryColor = AppColors.successLight;
        categoryIcon = Icons.favorite;
        break;
      case GoalCategory.finance:
        categoryColor = AppColors.accentLight;
        categoryIcon = Icons.attach_money;
        break;
      case GoalCategory.career:
        categoryColor = AppColors.primaryLight;
        categoryIcon = Icons.work;
        break;
      case GoalCategory.education:
        categoryColor = AppColors.infoLight;
        categoryIcon = Icons.school;
        break;
      default:
        categoryColor = AppColors.secondaryLight;
        categoryIcon = Icons.flag;
        break;
    }
    
    return SizedBox(
      width: 200,
      child: AppCard(
        onTap: () {
          // TODO: Navigate to goal details
        },
        margin: const EdgeInsets.only(right: AppDimensions.spacingM),
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            categoryColor.withOpacity(isDarkMode ? 0.15 : 0.1),
            categoryColor.withOpacity(isDarkMode ? 0.05 : 0.05),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Icon(
                    categoryIcon,
                    color: categoryColor,
                    size: 20,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingM,
                    vertical: AppDimensions.spacingXS,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                  ),
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: categoryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              goal.title,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: isDarkMode
                    ? AppColors.surfaceDark
                    : AppColors.surfaceLight,
                valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              '${goal.progress} / ${goal.targetValue}${goal.unit != null ? ' ${goal.unit}' : ''}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDarkMode
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 