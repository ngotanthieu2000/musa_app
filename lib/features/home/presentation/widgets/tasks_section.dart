import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../bloc/home_bloc.dart';
import '../../domain/entities/task.dart';

class TasksSection extends StatelessWidget {
  const TasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingL,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nhiệm vụ hôm nay',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to all tasks
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Xem tất cả',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacingXS),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            if (state is HomeLoaded) ...[
              if (state.homeData.tasks.isEmpty)
                const AppEmptyState(
                  icon: Icons.task_alt,
                  message: 'Không có nhiệm vụ nào cho hôm nay',
                  subMessage: 'Thêm nhiệm vụ để quản lý công việc tốt hơn',
                )
              else
                ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingL,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.homeData.tasks.length,
                  separatorBuilder: (context, index) => 
                      const SizedBox(height: AppDimensions.spacingM),
                  itemBuilder: (context, index) {
                    final task = state.homeData.tasks[index];
                    return _buildTaskItem(context, task);
                  },
                ),
            ] else if (state is HomeLoading) ...[
              const Center(child: CircularProgressIndicator()),
            ] else ...[
              // Placeholder for error or initial state
              const AppEmptyState(
                icon: Icons.task_alt,
                message: 'Không có dữ liệu nhiệm vụ',
                subMessage: 'Vui lòng thử lại sau',
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildTaskItem(BuildContext context, Task task) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = task.isComplete;
    
    final taskCategoryInfo = _getTaskCategoryInfo(task.category);
    
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
        ),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Toggle task completion or navigate to details
          context.read<HomeBloc>().add(
            HomeTaskToggled(taskId: task.id),
          );
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isCompleted 
                      ? Colors.grey.withOpacity(0.2)
                      : taskCategoryInfo.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                child: Icon(
                  isCompleted ? Icons.check : taskCategoryInfo.icon,
                  color: isCompleted 
                      ? Colors.grey
                      : taskCategoryInfo.color,
                  size: 20,
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
                            ? isDarkMode 
                                ? AppColors.textSecondaryDark 
                                : AppColors.textSecondaryLight
                            : isDarkMode 
                                ? AppColors.textPrimaryDark 
                                : AppColors.textPrimaryLight,
                        fontWeight: isCompleted ? FontWeight.normal : FontWeight.bold,
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
                          decoration: isCompleted 
                              ? TextDecoration.lineThrough 
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: AppDimensions.spacingXS),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: isDarkMode 
                              ? AppColors.textSecondaryDark 
                              : AppColors.textSecondaryLight,
                        ),
                        const SizedBox(width: AppDimensions.spacingXS),
                        Text(
                          _formatTime(task.dueDate),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _isTaskOverdue(task) && !isCompleted
                                ? isDarkMode 
                                    ? AppColors.errorDark 
                                    : AppColors.errorLight
                                : isDarkMode 
                                    ? AppColors.textSecondaryDark 
                                    : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacingS),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacingS,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: taskCategoryInfo.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
                          ),
                          child: Text(
                            taskCategoryInfo.label,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: taskCategoryInfo.color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: isCompleted,
                onChanged: (_) {
                  context.read<HomeBloc>().add(
                    HomeTaskToggled(taskId: task.id),
                  );
                },
                shape: const CircleBorder(),
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  TaskCategoryInfo _getTaskCategoryInfo(String category) {
    final Map<String, TaskCategoryInfo> categoryMap = {
      'work': TaskCategoryInfo(
        icon: Icons.work,
        color: Colors.blue,
        label: 'Công việc',
      ),
      'personal': TaskCategoryInfo(
        icon: Icons.person,
        color: Colors.purple,
        label: 'Cá nhân',
      ),
      'health': TaskCategoryInfo(
        icon: Icons.favorite,
        color: Colors.red,
        label: 'Sức khỏe',
      ),
      'shopping': TaskCategoryInfo(
        icon: Icons.shopping_cart,
        color: Colors.orange,
        label: 'Mua sắm',
      ),
      'education': TaskCategoryInfo(
        icon: Icons.school,
        color: Colors.green,
        label: 'Học tập',
      ),
    };
    
    return categoryMap[category.toLowerCase()] ?? 
        TaskCategoryInfo(
          icon: Icons.check_circle, 
          color: Colors.grey,
          label: 'Khác',
        );
  }
  
  String _formatTime(DateTime date) {
    final now = DateTime.now();
    
    if (date.year == now.year && 
        date.month == now.month && 
        date.day == now.day) {
      return 'Hôm nay, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (date.year == now.year && 
        date.month == now.month && 
        date.day == now.day + 1) {
      return 'Ngày mai, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (date.year == now.year && 
        date.month == now.month && 
        date.day == now.day - 1) {
      return 'Hôm qua, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
  
  bool _isTaskOverdue(Task task) {
    return !task.isComplete && task.dueDate.isBefore(DateTime.now());
  }
}

class TaskCategoryInfo {
  final IconData icon;
  final Color color;
  final String label;
  
  const TaskCategoryInfo({
    required this.icon,
    required this.color,
    required this.label,
  });
} 