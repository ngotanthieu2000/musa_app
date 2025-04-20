import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../tasks/domain/entities/task.dart';
import '../bloc/home_bloc.dart';

class TodayTasksSection extends StatelessWidget {
  const TodayTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Công việc hôm nay',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                context.go('/tasks');
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
                if (homeData.todayTasks.isEmpty) {
                  return const AppEmptyState(
                    title: 'Không có công việc nào',
                    message: 'Bạn chưa có công việc nào cho hôm nay',
                    icon: Icons.check_circle_outline,
                  );
                }
                
                return Column(
                  children: [
                    _buildProgressIndicator(
                      context, 
                      homeData.tasksCompleted, 
                      homeData.totalTasks,
                    ),
                    const SizedBox(height: AppDimensions.spacingL),
                    ...homeData.todayTasks
                        .take(3)
                        .map((task) => _buildTaskItem(context, task))
                        .toList(),
                  ],
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
  
  Widget _buildProgressIndicator(BuildContext context, int completed, int total) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final progress = total > 0 ? completed / total : 0.0;
    
    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tiến độ công việc',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '$completed/$total',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? AppColors.primaryDark
                      : AppColors.primaryLight,
                ),
              ),
            ],
            ),
          const SizedBox(height: AppDimensions.spacingM),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: isDarkMode
                  ? AppColors.surfaceDark
                  : AppColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDarkMode
                    ? AppColors.primaryDark
                    : AppColors.primaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTaskItem(BuildContext context, Task task) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color priorityColor;
    
    switch (task.priority) {
      case TaskPriority.high:
        priorityColor = AppColors.errorLight;
        break;
      case TaskPriority.medium:
        priorityColor = AppColors.warningLight;
        break;
      default:
        priorityColor = AppColors.successLight;
        break;
    }
    
    final isCompleted = task.status == TaskStatus.completed;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      child: AppCard(
        onTap: () {
          // TODO: Navigate to task details
        },
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: priorityColor,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      decoration: isCompleted 
                          ? TextDecoration.lineThrough 
                          : null,
                      color: isCompleted
                          ? (isDarkMode
                              ? AppColors.textTertiaryDark
                              : AppColors.textTertiaryLight)
                          : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (task.description != null && task.description!.isNotEmpty)
                    Text(
                      task.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDarkMode
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
                      ),
            const SizedBox(width: AppDimensions.spacingM),
            Theme(
              data: Theme.of(context).copyWith(
                checkboxTheme: CheckboxThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: BorderSide(
                    color: isDarkMode
                        ? AppColors.dividerDark
                        : AppColors.dividerLight,
                    width: 2,
                  ),
                ),
              ),
              child: Checkbox(
                value: isCompleted,
                onChanged: (value) {
                  // TODO: Change task status
                },
                activeColor: isDarkMode
                    ? AppColors.primaryDark
                    : AppColors.primaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 