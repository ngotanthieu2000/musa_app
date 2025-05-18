import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../domain/entities/task.dart';
import '../bloc/tasks_bloc.dart';
import 'add_task_bottom_sheet.dart';

class TaskListItem extends StatefulWidget {
  final Task task;
  final VoidCallback? onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskListItem({
    Key? key,
    required this.task,
    this.onToggle,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  Task get task => widget.task;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isCompleted = task.isCompleted;

    // Xác định màu dựa trên mức độ ưu tiên của task
    Color priorityColor;
    switch (task.priority) {
      case TaskPriority.low:
        priorityColor = AppColors.priorityLow;
        break;
      case TaskPriority.high:
        priorityColor = AppColors.priorityHigh;
        break;
      case TaskPriority.critical:
        priorityColor = AppColors.priorityCritical;
        break;
      case TaskPriority.medium:
      default:
        priorityColor = AppColors.priorityMedium;
    }

    // Xác định màu dựa trên danh mục của task
    Color categoryColor;
    switch (task.category) {
      case 'work':
        categoryColor = AppColors.categoryWork;
        break;
      case 'personal':
        categoryColor = AppColors.categoryPersonal;
        break;
      case 'shopping':
        categoryColor = AppColors.categoryShopping;
        break;
      case 'health':
        categoryColor = AppColors.categoryHealth;
        break;
      case 'general':
      default:
        categoryColor = AppColors.categoryGeneral;
    }

    return Dismissible(
      key: Key(task.id),
      background: _buildDismissibleBackground(context, DismissDirection.startToEnd),
      secondaryBackground: _buildDismissibleBackground(context, DismissDirection.endToStart),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Delete
          if (widget.onDelete != null) {
            widget.onDelete!();
          } else {
            context.read<TasksBloc>().add(DeleteTask(task.id));
          }
          return true;
        } else if (direction == DismissDirection.startToEnd) {
          // Toggle completion
          _playToggleAnimation();
          if (widget.onToggle != null) {
            widget.onToggle!();
          } else {
            context.read<TasksBloc>().add(ToggleTaskCompletion(task.id));
          }
          return false;
        }
        return false;
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: isCompleted
                  ? priorityColor.withOpacity(0.3)
                  : colorScheme.outlineVariant.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showTaskDetailsDialog(context),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCheckbox(context),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        task.title,
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                                          color: isCompleted
                                              ? colorScheme.onSurface.withOpacity(0.6)
                                              : colorScheme.onSurface,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (task.priority != null && task.priority != TaskPriority.medium)
                                      _buildPriorityIndicator(context),
                                  ],
                                ),
                                if (task.description.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    task.description,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurface.withOpacity(0.7),
                                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              color: colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            position: PopupMenuPosition.under,
                            onSelected: (value) {
                              if (value == 'edit') {
                                if (widget.onEdit != null) {
                                  widget.onEdit!();
                                } else {
                                  _showEditTaskBottomSheet(context);
                                }
                              } else if (value == 'delete') {
                                if (widget.onDelete != null) {
                                  widget.onDelete!();
                                } else {
                                  _showDeleteConfirmation(context);
                                }
                              } else if (value == 'toggle') {
                                _playToggleAnimation();
                                if (widget.onToggle != null) {
                                  widget.onToggle!();
                                } else {
                                  context.read<TasksBloc>().add(ToggleTaskCompletion(task.id));
                                }
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'toggle',
                                child: Row(
                                  children: [
                                    Icon(
                                      isCompleted ? Icons.refresh : Icons.check_circle_outline,
                                      size: 18,
                                      color: priorityColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(isCompleted
                                        ? 'Đánh dấu chưa hoàn thành'
                                        : 'Đánh dấu hoàn thành'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit_outlined,
                                      size: 18,
                                      color: colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('Chỉnh sửa'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      size: 18,
                                      color: colorScheme.error,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('Xóa'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTaskMetadata(context, categoryColor),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _playToggleAnimation() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  Widget _buildCheckbox(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompleted = task.isCompleted;

    // Xác định màu dựa trên mức độ ưu tiên của task
    Color priorityColor;
    switch (task.priority) {
      case TaskPriority.low:
        priorityColor = AppColors.priorityLow;
        break;
      case TaskPriority.high:
        priorityColor = AppColors.priorityHigh;
        break;
      case TaskPriority.critical:
        priorityColor = AppColors.priorityCritical;
        break;
      case TaskPriority.medium:
      default:
        priorityColor = AppColors.priorityMedium;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        _playToggleAnimation();
        if (widget.onToggle != null) {
          widget.onToggle!();
        } else {
          context.read<TasksBloc>().add(ToggleTaskCompletion(task.id));
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isCompleted ? priorityColor : colorScheme.outline,
            width: 2,
          ),
          color: isCompleted
              ? priorityColor.withOpacity(0.15)
              : Colors.transparent,
          boxShadow: isCompleted ? [
            BoxShadow(
              color: priorityColor.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 1,
            )
          ] : null,
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: Curves.elasticOut,
                ),
                child: child,
              );
            },
            child: isCompleted
                ? Icon(
                    Icons.check,
                    key: const ValueKey('checked'),
                    size: 16,
                    color: priorityColor,
                  )
                : const SizedBox(
                    key: ValueKey('unchecked'),
                    height: 16,
                    width: 16,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(BuildContext context) {
    Color priorityColor;
    IconData iconData;
    String tooltip;

    switch (task.priority) {
      case TaskPriority.high:
        priorityColor = AppColors.priorityHigh;
        iconData = Icons.arrow_upward_rounded;
        tooltip = 'Ưu tiên cao';
        break;
      case TaskPriority.critical:
        priorityColor = AppColors.priorityCritical;
        iconData = Icons.priority_high_rounded;
        tooltip = 'Ưu tiên quan trọng';
        break;
      case TaskPriority.low:
        priorityColor = AppColors.priorityLow;
        iconData = Icons.arrow_downward_rounded;
        tooltip = 'Ưu tiên thấp';
        break;
      default:
        priorityColor = AppColors.priorityMedium;
        iconData = Icons.remove_rounded;
        tooltip = 'Ưu tiên trung bình';
    }

    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: priorityColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: priorityColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          iconData,
          size: 16,
          color: priorityColor,
        ),
      ),
    );
  }

  Widget _buildTaskMetadata(BuildContext context, [Color? categoryColor]) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final List<Widget> metadata = [];

    // Nếu không có categoryColor được truyền vào, sử dụng màu mặc định
    categoryColor ??= AppColors.categoryGeneral;

    // Due date
    if (task.dueDate != null) {
      final bool isOverdue = _isOverdue();
      metadata.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isOverdue
                ? colorScheme.error.withOpacity(0.1)
                : colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isOverdue
                  ? colorScheme.error.withOpacity(0.3)
                  : colorScheme.outlineVariant.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.event_outlined,
                size: 14,
                color: isOverdue
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                DateFormat('dd MMM yyyy').format(task.dueDate!),
                style: textTheme.labelSmall?.copyWith(
                  color: isOverdue
                      ? colorScheme.error
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Category
    if (task.category.isNotEmpty) {
      metadata.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: categoryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getCategoryIcon(task.category),
                size: 14,
                color: categoryColor,
              ),
              const SizedBox(width: 4),
              Text(
                _getCategoryName(task.category),
                style: textTheme.labelSmall?.copyWith(
                  color: categoryColor.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Progress
    if (task.progress > 0 && !task.isCompleted) {
      metadata.add(_buildProgressChip(context));
    }

    // Tags
    if (task.tags.isNotEmpty) {
      metadata.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.secondary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tag_outlined,
                size: 14,
                color: colorScheme.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                task.tags.join(', '),
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (metadata.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: metadata,
    );
  }

  Widget _buildProgressChip(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final Color progressColor = AppColors.infoLight;
    final String progressText = '${task.progress}%';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: progressColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: progressColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.pie_chart_outline,
            size: 14,
            color: progressColor,
          ),
          const SizedBox(width: 4),
          Text(
            progressText,
            style: textTheme.labelSmall?.copyWith(
              color: progressColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissibleBackground(BuildContext context, DismissDirection direction) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isDeleteAction = direction == DismissDirection.endToStart;

    final Color backgroundColor = isDeleteAction
        ? AppColors.errorLight.withOpacity(0.1)
        : AppColors.successLight.withOpacity(0.1);

    final Color iconColor = isDeleteAction
        ? AppColors.errorLight
        : AppColors.successLight;

    final IconData iconData = isDeleteAction
        ? Icons.delete_outline_rounded
        : Icons.check_circle_outline_rounded;

    final String text = isDeleteAction ? 'Xóa' : 'Hoàn thành';

    return Container(
      alignment: isDeleteAction ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: isDeleteAction ? 0 : 20,
        right: isDeleteAction ? 20 : 0,
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isDeleteAction) ...[
            Icon(
              iconData,
              color: iconColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else ...[
            Text(
              text,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              iconData,
              color: iconColor,
              size: 20,
            ),
          ],
        ],
      ),
    );
  }

  void _showTaskDetailsDialog(BuildContext context) {
    // Use GoRouter for navigation
    GoRouter.of(context).push('/tasks/detail/${task.id}');
  }

  void _showEditTaskBottomSheet(BuildContext context) {
    // Lấy TasksBloc từ context hiện tại
    final tasksBloc = context.read<TasksBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: tasksBloc,
        child: AddTaskBottomSheet(
          taskToEdit: task,
          tasksBloc: tasksBloc,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa nhiệm vụ'),
        content: Text('Bạn có chắc chắn muốn xóa "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<TasksBloc>().add(DeleteTask(task.id));

              // Hiển thị Snackbar với nút Undo
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã xóa "${task.title}"'),
                  action: SnackBarAction(
                    label: 'Hoàn tác',
                    onPressed: () {
                      // Thêm lại task đã xóa
                      context.read<TasksBloc>().add(AddTask(
                        title: task.title,
                        description: task.description,
                        dueDate: task.dueDate,
                        priority: task.priority,
                        category: task.category,
                        tags: task.tags,
                      ));
                    },
                  ),
                  duration: const Duration(seconds: 5),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'Xóa',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDetailItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditTaskSheet(BuildContext context) {
    // Lấy TasksBloc từ context hiện tại
    final tasksBloc = context.read<TasksBloc>();
    print('*** _showEditTaskSheet: TasksBloc found ***');
    print('*** _showEditTaskSheet: TasksBloc = $tasksBloc ***');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: tasksBloc,
        child: AddTaskBottomSheet(
          taskToEdit: task,
          tasksBloc: tasksBloc, // Truyền TasksBloc vào AddTaskBottomSheet
        ),
      ),
    );
  }

  Widget _buildSubTasksList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 8),
          child: Row(
            children: [
              Icon(
                Icons.list,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Subtasks (${task.subTasks.length})',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        ...task.subTasks.map((subTask) => _buildSubTaskItem(context, subTask)),
        const Divider(height: 16),
      ],
    );
  }

  Widget _buildSubTaskItem(BuildContext context, SubTask subTask) {
    return Padding(
      padding: const EdgeInsets.only(left: 26, bottom: 8),
      child: Row(
        children: [
          Icon(
            subTask.isCompleted ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: subTask.isCompleted
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              subTask.title,
              style: TextStyle(
                fontSize: 14,
                decoration: subTask.isCompleted ? TextDecoration.lineThrough : null,
                color: subTask.isCompleted
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          if (subTask.dueDate != null)
            Text(
              DateFormat('MM/dd').format(subTask.dueDate!),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
        ],
      ),
    );
  }

  String _getPriorityText() {
    switch (task.priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.critical:
        return 'Critical';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
      default:
        return 'Medium';
    }
  }

  bool _isOverdue() {
    if (task.dueDate == null || task.isCompleted) {
      return false;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(
      task.dueDate!.year,
      task.dueDate!.month,
      task.dueDate!.day,
    );

    return dueDate.isBefore(today);
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return Icons.work_outline_rounded;
      case 'personal':
        return Icons.person_outline_rounded;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      case 'health':
        return Icons.favorite_border_rounded;
      case 'education':
        return Icons.school_outlined;
      case 'finance':
        return Icons.account_balance_outlined;
      case 'travel':
        return Icons.flight_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'general':
      default:
        return Icons.category_outlined;
    }
  }

  String _getCategoryName(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return 'Công việc';
      case 'personal':
        return 'Cá nhân';
      case 'shopping':
        return 'Mua sắm';
      case 'health':
        return 'Sức khỏe';
      case 'education':
        return 'Học tập';
      case 'finance':
        return 'Tài chính';
      case 'travel':
        return 'Du lịch';
      case 'home':
        return 'Nhà cửa';
      case 'general':
      default:
        return 'Chung';
    }
  }
}