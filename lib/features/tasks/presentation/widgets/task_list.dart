import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/tasks_bloc.dart';
import '../../domain/entities/task.dart';
import 'task_list_item.dart';
import 'add_task_bottom_sheet.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final String? filter;
  final TasksBloc tasksBloc;

  const TaskList({
    super.key,
    required this.tasks,
    this.filter,
    required this.tasksBloc,
  });

  @override
  Widget build(BuildContext context) {
    // Apply filter if provided
    final List<Task> filteredTasks;

    if (filter == null) {
      filteredTasks = tasks;
    } else if (filter == 'completed') {
      filteredTasks = tasks.where((task) => task.isCompleted).toList();
    } else if (filter == 'active') {
      filteredTasks = tasks.where((task) => !task.isCompleted).toList();
    } else {
      filteredTasks = tasks;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: filteredTasks.isEmpty
          ? _buildEmptyState(context)
          : _buildTaskList(context, filteredTasks),
    );
  }

  Widget _buildTaskList(BuildContext context, List<Task> taskList) {
    return RefreshIndicator(
      onRefresh: () async {
        // Thêm hiệu ứng haptic feedback
        HapticFeedback.mediumImpact();

        // Gọi API để lấy danh sách tasks mới nhất
        tasksBloc.add(FetchTasks());

        // Đợi một khoảng thời gian để hiển thị hiệu ứng refresh
        await Future.delayed(const Duration(milliseconds: 800));
      },
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      strokeWidth: 2.5,
      displacement: 40,
      child: ListView.builder(
        itemCount: taskList.length,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        itemBuilder: (context, index) {
          final task = taskList[index];

          // Sử dụng AnimatedSwitcher để tạo hiệu ứng khi task thay đổi
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  child: child,
                ),
              );
            },
            child: Padding(
              key: ValueKey('task-item-${task.id}-${task.isCompleted}'),
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Hero(
                tag: 'task-${task.id}',
                child: TaskListItem(
                  task: task,
                  onToggle: () {
                    tasksBloc.add(ToggleTaskCompletion(task.id));
                  },
                  onEdit: () {
                    // Sử dụng TasksBloc được truyền vào

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
                  },
                  onDelete: () {
                    _showDeleteConfirmation(context, task);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Task task) {
    final colorScheme = Theme.of(context).colorScheme;

    // Xác định màu dựa trên danh mục của task
    Color categoryColor;
    IconData categoryIcon;

    switch (task.category.toLowerCase()) {
      case 'work':
      case 'công việc':
        categoryColor = AppColors.categoryWork;
        categoryIcon = Icons.work_outline_rounded;
        break;
      case 'personal':
      case 'cá nhân':
        categoryColor = AppColors.categoryPersonal;
        categoryIcon = Icons.person_outline_rounded;
        break;
      case 'shopping':
      case 'mua sắm':
        categoryColor = AppColors.categoryShopping;
        categoryIcon = Icons.shopping_bag_outlined;
        break;
      case 'health':
      case 'sức khỏe':
        categoryColor = AppColors.categoryHealth;
        categoryIcon = Icons.favorite_border_rounded;
        break;
      case 'education':
      case 'học tập':
        categoryColor = Colors.purple;
        categoryIcon = Icons.school_outlined;
        break;
      case 'finance':
      case 'tài chính':
        categoryColor = Colors.green.shade700;
        categoryIcon = Icons.account_balance_outlined;
        break;
      case 'travel':
      case 'du lịch':
        categoryColor = Colors.blue.shade600;
        categoryIcon = Icons.flight_outlined;
        break;
      case 'home':
      case 'nhà cửa':
        categoryColor = Colors.brown.shade600;
        categoryIcon = Icons.home_outlined;
        break;
      case 'general':
      default:
        categoryColor = AppColors.categoryGeneral;
        categoryIcon = Icons.category_outlined;
    }

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
                    categoryIcon,
                    color: categoryColor,
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
              _deleteTaskWithUndo(context, task);
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

  void _deleteTaskWithUndo(BuildContext context, Task task) {
    // Thêm hiệu ứng haptic feedback
    HapticFeedback.mediumImpact();

    // Xóa task (với optimistic update)
    // TasksBloc sẽ tự động gọi API và cập nhật dữ liệu
    tasksBloc.add(DeleteTask(task.id));

    // Đảm bảo dữ liệu được cập nhật sau khi xóa
    Future.delayed(const Duration(milliseconds: 1000), () {
      // Gọi API để lấy danh sách tasks mới nhất sau khi xóa
      tasksBloc.add(FetchTasks());
    });

    // Hiển thị Snackbar với nút Undo
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
            // Thêm hiệu ứng haptic feedback
            HapticFeedback.mediumImpact();

            // Thêm lại task đã xóa
            // TasksBloc sẽ tự động gọi API và cập nhật dữ liệu
            tasksBloc.add(AddTask(
              title: task.title,
              description: task.description,
              dueDate: task.dueDate,
              priority: task.priority,
              category: task.category,
              tags: task.tags,
            ));

            // Đảm bảo dữ liệu được cập nhật sau khi hoàn tác
            Future.delayed(const Duration(milliseconds: 1000), () {
              tasksBloc.add(FetchTasks());
            });
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
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    String message;
    IconData iconData;
    String buttonText = 'Thêm nhiệm vụ mới';
    String description;

    VoidCallback onButtonPressed = () {
      // Thêm hiệu ứng haptic feedback
      HapticFeedback.mediumImpact();

      // Sử dụng TasksBloc được truyền vào

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => BlocProvider.value(
          value: tasksBloc,
          child: AddTaskBottomSheet(
            tasksBloc: tasksBloc, // Truyền TasksBloc vào AddTaskBottomSheet
          ),
        ),
      );
    };

    if (filter == null) {
      message = "Bạn chưa có nhiệm vụ nào";
      description = "Tạo nhiệm vụ mới để quản lý công việc hiệu quả hơn";
      iconData = Icons.assignment_outlined;
    } else {
      switch (filter) {
        case 'completed':
          message = "Bạn chưa hoàn thành nhiệm vụ nào";
          description = "Hoàn thành nhiệm vụ để theo dõi tiến độ công việc của bạn";
          iconData = Icons.task_alt;
          buttonText = 'Xem danh sách nhiệm vụ';
          break;
        case 'active':
          message = "Bạn không có nhiệm vụ đang thực hiện";
          description = "Tạo nhiệm vụ mới và bắt đầu thực hiện ngay";
          iconData = Icons.pending_actions;
          buttonText = 'Tạo nhiệm vụ mới';
          break;
        default:
          message = "Không tìm thấy nhiệm vụ nào";
          description = "Thử tìm kiếm với các bộ lọc khác";
          iconData = Icons.search_off_outlined;
      }
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Thêm hiệu ứng haptic feedback
        HapticFeedback.mediumImpact();

        // Gọi API để lấy danh sách tasks mới nhất
        tasksBloc.add(FetchTasks());

        // Đợi một khoảng thời gian để hiển thị hiệu ứng refresh
        await Future.delayed(const Duration(milliseconds: 800));
      },
      color: colorScheme.primary,
      backgroundColor: colorScheme.surface,
      strokeWidth: 2.5,
      displacement: 40,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.all(32),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.05),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
              gradient: RadialGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.1),
                  colorScheme.primary.withOpacity(0.05),
                ],
                stops: const [0.4, 1.0],
              ),
            ),
            child: Icon(
              iconData,
              size: 80,
              color: colorScheme.primary.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            message,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              letterSpacing: -0.3,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
              letterSpacing: 0.1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: onButtonPressed,
                icon: const Icon(Icons.add_rounded, size: 22),
                label: Text(
                  buttonText,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 0.2,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  shadowColor: colorScheme.primary.withOpacity(0.3),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {
                  // Thêm hiệu ứng haptic feedback
                  HapticFeedback.lightImpact();

                  // Gọi API để lấy danh sách tasks mới nhất
                  tasksBloc.add(FetchTasks());
                },
                icon: const Icon(Icons.refresh_rounded, size: 22),
                label: Text(
                  'Làm mới',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 0.2,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: BorderSide(
                    color: colorScheme.primary.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        ],
      ),
    );
  }
}