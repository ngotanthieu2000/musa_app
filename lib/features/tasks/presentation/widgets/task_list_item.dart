import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
    switch (task.category.toLowerCase()) {
      case 'work':
      case 'công việc':
        categoryColor = AppColors.categoryWork;
        break;
      case 'personal':
      case 'cá nhân':
        categoryColor = AppColors.categoryPersonal;
        break;
      case 'shopping':
      case 'mua sắm':
        categoryColor = AppColors.categoryShopping;
        break;
      case 'health':
      case 'sức khỏe':
        categoryColor = AppColors.categoryHealth;
        break;
      case 'education':
      case 'học tập':
        categoryColor = Colors.purple;
        break;
      case 'finance':
      case 'tài chính':
        categoryColor = Colors.green.shade700;
        break;
      case 'travel':
      case 'du lịch':
        categoryColor = Colors.blue.shade600;
        break;
      case 'home':
      case 'nhà cửa':
        categoryColor = Colors.brown.shade600;
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
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
                spreadRadius: 1,
              ),
            ],
            border: Border.all(
              color: isCompleted
                  ? priorityColor.withOpacity(0.2)
                  : colorScheme.outlineVariant.withOpacity(0.2),
              width: 1.5,
            ),
            gradient: isCompleted
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.surface,
                      colorScheme.surface.withOpacity(0.95),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.surface,
                      priorityColor.withOpacity(0.08),
                    ],
                  ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showTaskDetailsDialog(context),
                splashColor: priorityColor.withOpacity(0.1),
                highlightColor: priorityColor.withOpacity(0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section with title, checkbox and menu
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCheckbox(context),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category and priority indicators
                                Row(
                                  children: [
                                    if (task.category.isNotEmpty)
                                      _buildCategoryBadge(context, categoryColor),
                                    const SizedBox(width: 8),
                                    if (task.priority != null && task.priority != TaskPriority.medium)
                                      _buildPriorityIndicator(context),
                                    const Spacer(),
                                    // Due date indicator if exists and is close or overdue
                                    if (task.dueDate != null && (_isCloseToDueDate() || _isOverdue()))
                                      _buildDueDateBadge(context),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Task title with improved typography
                                Text(
                                  task.title,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                                    color: isCompleted
                                        ? colorScheme.onSurface.withOpacity(0.5)
                                        : colorScheme.onSurface,
                                    height: 1.3,
                                    letterSpacing: -0.2,
                                    // Add subtle shadow for better readability
                                    shadows: isCompleted
                                        ? []
                                        : [
                                            Shadow(
                                              color: Colors.black.withOpacity(0.05),
                                              offset: const Offset(0, 1),
                                              blurRadius: 1,
                                            ),
                                          ],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (task.description.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    task.description,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: isCompleted
                                          ? colorScheme.onSurface.withOpacity(0.5)
                                          : colorScheme.onSurface.withOpacity(0.7),
                                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                                      height: 1.5,
                                      letterSpacing: 0.1,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceVariant.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_horiz_rounded,
                                color: colorScheme.onSurfaceVariant,
                                size: 22,
                              ),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
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
                                        isCompleted ? Icons.refresh_rounded : Icons.check_circle_outline_rounded,
                                        size: 20,
                                        color: priorityColor,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        isCompleted ? 'Đánh dấu chưa hoàn thành' : 'Đánh dấu hoàn thành',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit_outlined,
                                        size: 20,
                                        color: colorScheme.primary,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Chỉnh sửa',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline_rounded,
                                        size: 20,
                                        color: colorScheme.error,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Xóa',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Progress bar section (if task has progress)
                    if (task.progress > 0) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      task.progress >= 100
                                          ? Icons.check_circle_outline_rounded
                                          : Icons.pie_chart_outline_rounded,
                                      size: 16,
                                      color: isCompleted
                                          ? colorScheme.onSurface.withOpacity(0.5)
                                          : task.progress >= 100
                                              ? AppColors.successLight
                                              : AppColors.infoLight,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Tiến độ',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: isCompleted
                                            ? colorScheme.onSurface.withOpacity(0.5)
                                            : colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isCompleted
                                        ? colorScheme.onSurface.withOpacity(0.5)
                                        : task.progress >= 100
                                            ? AppColors.successLight
                                            : AppColors.infoLight,
                                  ),
                                  child: Text('${task.progress}%'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Animated progress indicator
                            TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeOutCubic,
                              tween: Tween<double>(
                                begin: 0,
                                end: task.progress / 100,
                              ),
                              builder: (context, value, _) => Stack(
                                children: [
                                  // Background track
                                  Container(
                                    height: 8,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: isCompleted
                                          ? colorScheme.surfaceVariant.withOpacity(0.2)
                                          : colorScheme.surfaceVariant.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  // Foreground progress
                                  Container(
                                    height: 8,
                                    width: MediaQuery.of(context).size.width * value,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: isCompleted
                                            ? [
                                                colorScheme.onSurfaceVariant.withOpacity(0.3),
                                                colorScheme.onSurfaceVariant.withOpacity(0.3),
                                              ]
                                            : task.progress >= 100
                                                ? [
                                                    AppColors.successLight.withOpacity(0.7),
                                                    AppColors.successLight,
                                                  ]
                                                : [
                                                    AppColors.infoLight.withOpacity(0.7),
                                                    AppColors.infoLight,
                                                  ],
                                      ),
                                      boxShadow: isCompleted
                                          ? []
                                          : [
                                              BoxShadow(
                                                color: task.progress >= 100
                                                    ? AppColors.successLight.withOpacity(0.3)
                                                    : AppColors.infoLight.withOpacity(0.3),
                                                blurRadius: 4,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Metadata section (tags, due date, category)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: _buildTaskMetadata(context, categoryColor),
                    ),
                  ],
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
      if (mounted) {
        _animationController.reverse();
      }
    });

    // Thêm hiệu ứng haptic feedback
    HapticFeedback.mediumImpact();
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

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow effect with animation
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isCompleted
                ? RadialGradient(
                    colors: [
                      priorityColor.withOpacity(0.25),
                      priorityColor.withOpacity(0.0),
                    ],
                    stops: const [0.5, 1.0],
                  )
                : null,
          ),
        ),

        // Main checkbox container with improved animation
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted ? priorityColor : colorScheme.outline.withOpacity(0.6),
              width: isCompleted ? 2 : 1.5,
            ),
            color: isCompleted
                ? priorityColor.withOpacity(0.15)
                : Colors.transparent,
            gradient: isCompleted
                ? RadialGradient(
                    colors: [
                      priorityColor.withOpacity(0.3),
                      priorityColor.withOpacity(0.05),
                    ],
                    stops: const [0.4, 1.0],
                  )
                : null,
            boxShadow: isCompleted
                ? [
                    BoxShadow(
                      color: priorityColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: CurvedAnimation(
                    parent: animation,
                    curve: Curves.elasticOut,
                  ),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: isCompleted
                  ? Icon(
                      Icons.check_rounded,
                      key: const ValueKey('checked'),
                      size: 20,
                      color: priorityColor,
                    )
                  : const SizedBox(
                      key: ValueKey('unchecked'),
                      height: 20,
                      width: 20,
                    ),
            ),
          ),
        ),

        // Ripple effect on tap with improved feedback
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              splashColor: priorityColor.withOpacity(0.4),
              highlightColor: priorityColor.withOpacity(0.2),
              onTap: () {
                _playToggleAnimation();
                // Thêm hiệu ứng haptic feedback
                HapticFeedback.lightImpact();
                if (widget.onToggle != null) {
                  widget.onToggle!();
                } else {
                  context.read<TasksBloc>().add(ToggleTaskCompletion(task.id));
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityIndicator(BuildContext context) {
    Color priorityColor;
    IconData iconData;
    String tooltip;
    String label;

    switch (task.priority) {
      case TaskPriority.high:
        priorityColor = AppColors.priorityHigh;
        iconData = Icons.arrow_upward_rounded;
        tooltip = 'Ưu tiên cao';
        label = 'Cao';
        break;
      case TaskPriority.critical:
        priorityColor = AppColors.priorityCritical;
        iconData = Icons.priority_high_rounded;
        tooltip = 'Ưu tiên quan trọng';
        label = 'Quan trọng';
        break;
      case TaskPriority.low:
        priorityColor = AppColors.priorityLow;
        iconData = Icons.arrow_downward_rounded;
        tooltip = 'Ưu tiên thấp';
        label = 'Thấp';
        break;
      default:
        priorityColor = AppColors.priorityMedium;
        iconData = Icons.remove_rounded;
        tooltip = 'Ưu tiên trung bình';
        label = 'Trung bình';
    }

    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: priorityColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: priorityColor.withOpacity(0.3),
            width: 1,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              priorityColor.withOpacity(0.15),
              priorityColor.withOpacity(0.05),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: priorityColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: 16,
              color: priorityColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: priorityColor,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskMetadata(BuildContext context, [Color? categoryColor]) {
    final colorScheme = Theme.of(context).colorScheme;
    final List<Widget> metadata = [];
    final isCompleted = task.isCompleted;

    // Nếu không có categoryColor được truyền vào, sử dụng màu mặc định
    categoryColor ??= AppColors.categoryGeneral;

    // Due date
    if (task.dueDate != null) {
      final bool isOverdue = _isOverdue();
      final bool isCloseToDue = _isCloseToDueDate();

      Color dateColor = isOverdue
          ? AppColors.errorLight
          : isCloseToDue
              ? AppColors.warningLight
              : colorScheme.onSurfaceVariant;

      if (isCompleted) {
        dateColor = colorScheme.onSurfaceVariant.withOpacity(0.7);
      }

      IconData dateIcon = isOverdue
          ? Icons.event_busy_rounded
          : isCloseToDue
              ? Icons.event_available_rounded
              : Icons.event_outlined;

      metadata.add(
        _buildMetadataChip(
          context: context,
          icon: dateIcon,
          label: DateFormat('dd MMM yyyy').format(task.dueDate!),
          color: dateColor,
          backgroundColor: isCompleted
              ? colorScheme.surfaceVariant.withOpacity(0.3)
              : dateColor.withOpacity(0.1),
          borderColor: isCompleted
              ? colorScheme.outlineVariant.withOpacity(0.3)
              : dateColor.withOpacity(0.3),
          fontWeight: (isOverdue || isCloseToDue) && !isCompleted ? FontWeight.w600 : FontWeight.w500,
          gradient: isCompleted
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    dateColor.withOpacity(0.15),
                    dateColor.withOpacity(0.05),
                  ],
                ),
        ),
      );
    }

    // Progress
    if (task.progress > 0) {
      final Color progressColor = task.progress >= 100
          ? AppColors.successLight
          : AppColors.infoLight;

      metadata.add(
        _buildMetadataChip(
          context: context,
          icon: task.progress >= 100
              ? Icons.check_circle_outline_rounded
              : Icons.pie_chart_outline_rounded,
          label: '${task.progress}%',
          color: isCompleted
              ? colorScheme.onSurfaceVariant.withOpacity(0.7)
              : progressColor,
          backgroundColor: isCompleted
              ? colorScheme.surfaceVariant.withOpacity(0.3)
              : progressColor.withOpacity(0.1),
          borderColor: isCompleted
              ? colorScheme.outlineVariant.withOpacity(0.3)
              : progressColor.withOpacity(0.3),
          fontWeight: FontWeight.w600,
          gradient: isCompleted
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    progressColor.withOpacity(0.15),
                    progressColor.withOpacity(0.05),
                  ],
                ),
        ),
      );
    }

    // Tags
    if (task.tags.isNotEmpty) {
      final Color tagColor = isCompleted
          ? colorScheme.onSurfaceVariant.withOpacity(0.7)
          : colorScheme.secondary;

      metadata.add(
        _buildMetadataChip(
          context: context,
          icon: Icons.tag_rounded,
          label: task.tags.join(', '),
          color: tagColor,
          backgroundColor: isCompleted
              ? colorScheme.surfaceVariant.withOpacity(0.3)
              : colorScheme.secondaryContainer.withOpacity(0.3),
          borderColor: isCompleted
              ? colorScheme.outlineVariant.withOpacity(0.3)
              : colorScheme.secondary.withOpacity(0.2),
          fontWeight: FontWeight.w500,
          gradient: isCompleted
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.secondaryContainer.withOpacity(0.4),
                    colorScheme.secondaryContainer.withOpacity(0.2),
                  ],
                ),
        ),
      );
    }

    if (metadata.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: metadata,
      ),
    );
  }

  Widget _buildMetadataChip({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required Color backgroundColor,
    required Color borderColor,
    FontWeight fontWeight = FontWeight.w500,
    Gradient? gradient,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: fontWeight,
              color: color,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChip(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color progressColor = task.progress >= 100
        ? AppColors.successLight
        : AppColors.infoLight;

    return _buildMetadataChip(
      context: context,
      icon: Icons.pie_chart_outline_rounded,
      label: '${task.progress}%',
      color: progressColor,
      backgroundColor: progressColor.withOpacity(0.1),
      borderColor: progressColor.withOpacity(0.3),
      fontWeight: FontWeight.w600,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          progressColor.withOpacity(0.15),
          progressColor.withOpacity(0.05),
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
        : task.isCompleted
            ? Icons.refresh_rounded
            : Icons.check_circle_outline_rounded;

    final String text = isDeleteAction
        ? 'Xóa'
        : task.isCompleted
            ? 'Đánh dấu chưa hoàn thành'
            : 'Đánh dấu hoàn thành';

    return Container(
      alignment: isDeleteAction ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: isDeleteAction ? 0 : 24,
        right: isDeleteAction ? 24 : 0,
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1.5,
        ),
        gradient: LinearGradient(
          begin: isDeleteAction ? Alignment.centerRight : Alignment.centerLeft,
          end: isDeleteAction ? Alignment.centerLeft : Alignment.centerRight,
          colors: [
            backgroundColor.withOpacity(0.9),
            backgroundColor.withOpacity(0.3),
          ],
          stops: const [0.3, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isDeleteAction) ...[
            Icon(
              iconData,
              color: iconColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: iconColor,
                letterSpacing: 0.1,
              ),
            ),
          ] else ...[
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: iconColor,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              iconData,
              color: iconColor,
              size: 24,
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
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warningLight,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Xóa nhiệm vụ',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bạn có chắc chắn muốn xóa nhiệm vụ này?',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getCategoryIcon(task.category),
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      task.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: colorScheme.outline,
                width: 1.5,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Text(
              'Hủy',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<TasksBloc>().add(DeleteTask(task.id));

              // Hiển thị Snackbar với nút Hoàn tác
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Đã xóa "${task.title}"',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: AppColors.errorDark,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.delete_outline_rounded, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Xóa',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        buttonPadding: const EdgeInsets.symmetric(horizontal: 8),
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

  bool _isCloseToDueDate() {
    if (task.dueDate == null || task.isCompleted || _isOverdue()) {
      return false;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(
      task.dueDate!.year,
      task.dueDate!.month,
      task.dueDate!.day,
    );

    // Trả về true nếu deadline trong vòng 2 ngày tới
    final difference = dueDate.difference(today).inDays;
    return difference <= 2;
  }

  Widget _buildCategoryBadge(BuildContext context, Color categoryColor) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompleted = task.isCompleted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted
            ? colorScheme.surfaceVariant.withOpacity(0.3)
            : categoryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? colorScheme.outlineVariant.withOpacity(0.3)
              : categoryColor.withOpacity(0.3),
          width: 1,
        ),
        gradient: isCompleted
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  categoryColor.withOpacity(0.15),
                  categoryColor.withOpacity(0.05),
                ],
              ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCategoryIcon(task.category),
            size: 14,
            color: isCompleted
                ? colorScheme.onSurfaceVariant.withOpacity(0.7)
                : categoryColor,
          ),
          const SizedBox(width: 4),
          Text(
            task.category,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isCompleted
                  ? colorScheme.onSurfaceVariant.withOpacity(0.7)
                  : categoryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDueDateBadge(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompleted = task.isCompleted;
    final isOverdue = _isOverdue();
    final isCloseToDue = _isCloseToDueDate();

    Color badgeColor = isOverdue
        ? AppColors.errorLight
        : isCloseToDue
            ? AppColors.warningLight
            : colorScheme.primary;

    if (isCompleted) {
      badgeColor = colorScheme.onSurfaceVariant.withOpacity(0.7);
    }

    IconData iconData = isOverdue
        ? Icons.event_busy_rounded
        : isCloseToDue
            ? Icons.event_available_rounded
            : Icons.event_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted
            ? colorScheme.surfaceVariant.withOpacity(0.3)
            : badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? colorScheme.outlineVariant.withOpacity(0.3)
              : badgeColor.withOpacity(0.3),
          width: 1,
        ),
        gradient: isCompleted
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  badgeColor.withOpacity(0.15),
                  badgeColor.withOpacity(0.05),
                ],
              ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            size: 14,
            color: isCompleted
                ? colorScheme.onSurfaceVariant.withOpacity(0.7)
                : badgeColor,
          ),
          const SizedBox(width: 4),
          Text(
            DateFormat('dd/MM').format(task.dueDate!),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isCompleted
                  ? colorScheme.onSurfaceVariant.withOpacity(0.7)
                  : badgeColor,
            ),
          ),
        ],
      ),
    );
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