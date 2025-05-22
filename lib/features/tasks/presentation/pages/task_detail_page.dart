import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/task.dart';
import '../bloc/tasks_bloc.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/add_subtask_dialog.dart';
import '../widgets/add_reminder_dialog.dart';

class TaskDetailPage extends StatefulWidget {
  final String taskId;

  const TaskDetailPage({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final TextEditingController _subTaskController = TextEditingController();
  final FocusNode _subTaskFocusNode = FocusNode();
  Task? _task;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  @override
  void dispose() {
    _subTaskController.dispose();
    _subTaskFocusNode.dispose();
    super.dispose();
  }

  void _loadTask() {
    print('*** _loadTask: Loading task with ID: ${widget.taskId} ***');

    // Đăng ký lắng nghe sự thay đổi của TasksBloc
    // Luôn gọi FetchTasks để đảm bảo dữ liệu mới nhất
    context.read<TasksBloc>().add(FetchTasks());
  }

  void _findTaskInState(List<Task> tasks) {
    print('*** _findTaskInState: Looking for task with ID: ${widget.taskId} ***');
    print('*** _findTaskInState: Number of tasks in state: ${tasks.length} ***');

    Task? task;
    try {
      task = tasks.firstWhere(
        (t) => t.id == widget.taskId,
      );
      print('*** _findTaskInState: Task found: ${task.id}, isCompleted: ${task.isCompleted} ***');
    } catch (e) {
      print('*** _findTaskInState: Task not found, using default task ***');
      task = Task(
        id: '',
        userId: '',
        title: 'Không tìm thấy nhiệm vụ',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    // Cập nhật _task và kích hoạt rebuild UI
    _updateTask(task);
  }

  void _updateTask(Task task) {
    print('*** _updateTask: Updating task: ${task.id}, isCompleted: ${task.isCompleted} ***');

    // Cập nhật _task và kích hoạt rebuild UI
    if (mounted) {
      setState(() {
        _task = task;
      });
    }
  }

  // Phương thức để cập nhật trạng thái task trực tiếp trong UI
  void _updateTaskCompletionStatus(bool isCompleted) {
    print('*** _updateTaskCompletionStatus: Updating task completion status: $isCompleted ***');

    if (_task != null) {
      // Tạo một bản sao của task hiện tại với trạng thái mới
      final updatedTask = Task(
        id: _task!.id,
        userId: _task!.userId,
        title: _task!.title,
        description: _task!.description,
        isCompleted: isCompleted,
        dueDate: _task!.dueDate,
        priority: _task!.priority,
        category: _task!.category,
        tags: _task!.tags,
        subTasks: _task!.subTasks,
        reminders: _task!.reminders,
        createdAt: _task!.createdAt,
        updatedAt: DateTime.now(),
        progress: _task!.progress,
      );

      // Cập nhật UI với task mới
      _updateTask(updatedTask);

      // Đảm bảo TasksBloc cũng được cập nhật với trạng thái mới
      final tasksBloc = context.read<TasksBloc>();
      final currentState = tasksBloc.state;

      if (currentState is TasksLoaded || currentState is TaskActionSuccess) {
        List<Task> currentTasks = [];

        if (currentState is TasksLoaded) {
          currentTasks = List.from(currentState.tasks);
        } else if (currentState is TaskActionSuccess) {
          currentTasks = List.from((currentState as TaskActionSuccess).tasks);
        }

        // Cập nhật task trong danh sách
        final taskIndex = currentTasks.indexWhere((t) => t.id == _task!.id);
        if (taskIndex != -1) {
          currentTasks[taskIndex] = updatedTask;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksBloc, TasksState>(
      listener: (context, state) {
        if (state is TasksLoaded) {
          _findTaskInState(state.tasks);
        } else if (state is TaskActionSuccess) {
          _findTaskInState(state.tasks);

          // Xử lý các loại hành động khác nhau
          if (state.actionType == ActionType.addSubTask) {
            _subTaskController.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã thêm công việc con')),
            );
          } else if (state.actionType == ActionType.updateSubTask) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã cập nhật công việc con')),
            );
          } else if (state.actionType == ActionType.toggle) {
            print('*** TaskDetailPage: Toggle action detected ***');
            print('*** TaskDetailPage: Task ID: ${widget.taskId} ***');
            print('*** TaskDetailPage: Old Is Completed: ${_task?.isCompleted} ***');

            // Tìm task đã cập nhật trong danh sách tasks mới
            Task? updatedTask;
            try {
              updatedTask = state.tasks.firstWhere(
                (t) => t.id == widget.taskId,
              );
              print('*** TaskDetailPage: Updated task found in tasks list: ${updatedTask.id}, isCompleted: ${updatedTask.isCompleted} ***');

              // Cập nhật UI với task mới từ danh sách tasks
              _updateTask(updatedTask);
            } catch (e) {
              print('*** TaskDetailPage: Updated task not found in tasks list: $e ***');

              // Nếu không tìm thấy task trong danh sách, kiểm tra state.data
              if (state.data != null && state.data is Task) {
                final dataTask = state.data as Task;
                print('*** TaskDetailPage: Updated task found in state.data: ${dataTask.id}, isCompleted: ${dataTask.isCompleted} ***');

                // Cập nhật UI với task từ state.data
                _updateTask(dataTask);
              } else {
                print('*** TaskDetailPage: Updated task not found in state.data ***');
              }
            }
          }
        }
      },
      builder: (context, state) {
        if (state is TasksLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (_task == null || _task!.id.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Chi tiết nhiệm vụ')),
            body: const Center(child: Text('Không tìm thấy nhiệm vụ')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Chi tiết nhiệm vụ',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _showEditTaskBottomSheet(),
                tooltip: 'Chỉnh sửa nhiệm vụ',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: () => _showDeleteConfirmation(),
                tooltip: 'Xóa nhiệm vụ',
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // Refresh dữ liệu khi kéo xuống
              context.read<TasksBloc>().add(FetchTasks());
              return Future.delayed(const Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTaskHeader(),
                    const SizedBox(height: 24),
                    if (_task!.progress > 0) ...[
                      _buildProgressSection(),
                      const SizedBox(height: 24),
                    ],
                    _buildTaskDetails(),
                    const Divider(height: 32),
                    _buildSubTasksSection(),
                    const Divider(height: 32),
                    _buildRemindersSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          bottomSheet: _buildAddSubTaskInput(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // Lưu trạng thái hiện tại để hiển thị thông báo đúng
              final wasCompleted = _task!.isCompleted;

              // Cập nhật UI trước khi gọi API
              _updateTaskCompletionStatus(!wasCompleted);

              // Lấy TasksBloc và gọi API để cập nhật trạng thái
              final tasksBloc = context.read<TasksBloc>();
              tasksBloc.add(ToggleTaskCompletion(_task!.id));

              // Hiển thị thông báo
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        wasCompleted ? Icons.refresh : Icons.check_circle_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        !wasCompleted
                          ? 'Đã đánh dấu hoàn thành công việc'
                          : 'Đã đánh dấu chưa hoàn thành công việc',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: wasCompleted
                    ? Theme.of(context).colorScheme.primary
                    : AppColors.successLight,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: Icon(_task!.isCompleted ? Icons.refresh : Icons.check),
            label: Text(
              _task!.isCompleted ? 'Đánh dấu chưa hoàn thành' : 'Đánh dấu hoàn thành',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            backgroundColor: _task!.isCompleted
              ? Theme.of(context).colorScheme.primary
              : AppColors.successLight,
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskHeader() {
    final colorScheme = Theme.of(context).colorScheme;

    // Xác định màu dựa trên mức độ ưu tiên của task
    Color priorityColor;
    switch (_task!.priority) {
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
    switch (_task!.category.toLowerCase()) {
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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: _task!.isCompleted
              ? priorityColor.withOpacity(0.2)
              : colorScheme.outlineVariant.withOpacity(0.2),
          width: 1.5,
        ),
        gradient: _task!.isCompleted
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.surface,
                  priorityColor.withOpacity(0.05),
                ],
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with priority and completion status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCheckbox(priorityColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildPriorityIndicator(),
                        const SizedBox(width: 12),
                        if (_task!.category.isNotEmpty)
                          _buildCategoryChip(categoryColor),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _task!.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        decoration: _task!.isCompleted ? TextDecoration.lineThrough : null,
                        color: _task!.isCompleted
                            ? colorScheme.onSurface.withOpacity(0.6)
                            : colorScheme.onSurface,
                        height: 1.3,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Description
          if (_task!.description.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              _task!.description,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: _task!.isCompleted
                    ? colorScheme.onSurface.withOpacity(0.6)
                    : colorScheme.onSurface.withOpacity(0.8),
                height: 1.5,
                letterSpacing: 0.1,
              ),
            ),
          ],

          // Metadata chips
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_task!.dueDate != null)
                _buildInfoChip(
                  Icons.calendar_today,
                  DateFormat('dd MMM yyyy').format(_task!.dueDate!),
                  _task!.isOverdue() ? AppColors.errorLight : null,
                ),
              if (_task!.tags.isNotEmpty)
                _buildInfoChip(
                  Icons.tag_rounded,
                  _task!.tags.join(', '),
                  colorScheme.secondary,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(Color priorityColor) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompleted = _task!.isCompleted;

    return GestureDetector(
      onTap: () {
        // Lưu trạng thái hiện tại
        final wasCompleted = isCompleted;

        // Cập nhật UI trước khi gọi API
        _updateTaskCompletionStatus(!wasCompleted);

        // Lấy TasksBloc và gọi API để cập nhật trạng thái
        final tasksBloc = context.read<TasksBloc>();
        tasksBloc.add(ToggleTaskCompletion(_task!.id));
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow effect
          if (isCompleted)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    priorityColor.withOpacity(0.2),
                    priorityColor.withOpacity(0.0),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),

          // Main checkbox container
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
              boxShadow: isCompleted ? [
                BoxShadow(
                  color: priorityColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ] : null,
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

          // Ripple effect on tap
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                splashColor: priorityColor.withOpacity(0.3),
                highlightColor: priorityColor.withOpacity(0.1),
                onTap: () {
                  // Lưu trạng thái hiện tại
                  final wasCompleted = isCompleted;

                  // Cập nhật UI trước khi gọi API
                  _updateTaskCompletionStatus(!wasCompleted);

                  // Lấy TasksBloc và gọi API để cập nhật trạng thái
                  final tasksBloc = context.read<TasksBloc>();
                  tasksBloc.add(ToggleTaskCompletion(_task!.id));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    final colorScheme = Theme.of(context).colorScheme;
    final Color progressColor = _task!.progress >= 100
        ? AppColors.successLight
        : AppColors.infoLight;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: progressColor.withOpacity(0.2),
          width: 1.5,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surface,
            progressColor.withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tiến độ công việc',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: progressColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${_task!.progress}%',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: progressColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: _task!.progress / 100,
              backgroundColor: colorScheme.surfaceVariant.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                _task!.progress >= 100 ? AppColors.successLight : AppColors.infoLight,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          if (_task!.subTasks.isNotEmpty) ...[
            Text(
              '${_task!.subTasks.where((st) => st.isCompleted).length}/${_task!.subTasks.length} công việc con đã hoàn thành',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    Color priorityColor;
    IconData iconData;
    String tooltip;
    String label;

    switch (_task!.priority) {
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

  Widget _buildCategoryChip(Color categoryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: categoryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: categoryColor.withOpacity(0.3),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            categoryColor.withOpacity(0.15),
            categoryColor.withOpacity(0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCategoryIcon(_task!.category),
            size: 16,
            color: categoryColor,
          ),
          const SizedBox(width: 6),
          Text(
            _getCategoryName(_task!.category),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: categoryColor,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, [Color? color]) {
    final colorScheme = Theme.of(context).colorScheme;
    final chipColor = color ?? colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: chipColor.withOpacity(0.3),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            chipColor.withOpacity(0.15),
            chipColor.withOpacity(0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: chipColor.withOpacity(0.1),
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
            color: chipColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: chipColor,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDetails() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chi tiết',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailItem(
            'Ngày tạo',
            DateFormat('dd/MM/yyyy HH:mm').format(_task!.createdAt),
            Icons.calendar_month_outlined,
          ),
          _buildDetailItem(
            'Cập nhật',
            DateFormat('dd/MM/yyyy HH:mm').format(_task!.updatedAt),
            Icons.update_outlined,
          ),
          if (_task!.tags.isNotEmpty)
            _buildDetailItem(
              'Tags',
              _task!.tags.join(', '),
              Icons.tag_outlined,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 20,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTasksSection() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Công việc con (${_task!.subTasks.length})',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddSubTaskDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Thêm'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          if (_task!.subTasks.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '${_task!.subTasks.where((st) => st.isCompleted).length}/${_task!.subTasks.length} công việc con đã hoàn thành',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (_task!.subTasks.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(
                    Icons.check_box_outline_blank,
                    size: 48,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Chưa có công việc con nào',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Thêm công việc con để chia nhỏ nhiệm vụ',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _task!.subTasks.length,
              itemBuilder: (context, index) {
                final subTask = _task!.subTasks[index];
                return _buildSubTaskItem(subTask);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSubTaskItem(SubTask subTask) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: subTask.isCompleted
            ? colorScheme.surfaceVariant.withOpacity(0.3)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: subTask.isCompleted
              ? colorScheme.outlineVariant.withOpacity(0.2)
              : colorScheme.outlineVariant.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.read<TasksBloc>().add(
                  UpdateSubTask(
                    taskId: _task!.id,
                    subTaskId: subTask.id,
                    isCompleted: !subTask.isCompleted,
                  ),
                );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Checkbox(
                  value: subTask.isCompleted,
                  onChanged: (value) {
                    context.read<TasksBloc>().add(
                          UpdateSubTask(
                            taskId: _task!.id,
                            subTaskId: subTask.id,
                            isCompleted: value,
                          ),
                        );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: BorderSide(
                    color: colorScheme.outline.withOpacity(0.6),
                    width: 1.5,
                  ),
                  activeColor: AppColors.successLight,
                ),
                Expanded(
                  child: Text(
                    subTask.title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: subTask.isCompleted ? TextDecoration.lineThrough : null,
                      color: subTask.isCompleted
                          ? colorScheme.onSurface.withOpacity(0.6)
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
                if (subTask.dueDate != null)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      DateFormat('dd/MM').format(subTask.dueDate!),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  onPressed: () {
                    // Hiển thị dialog xác nhận xóa
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Xóa công việc con'),
                        content: Text('Bạn có chắc chắn muốn xóa "${subTask.title}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Implement delete subtask
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Đã xóa "${subTask.title}"'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Text(
                              'Xóa',
                              style: TextStyle(color: colorScheme.error),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  color: colorScheme.onSurfaceVariant,
                  splashRadius: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRemindersSection() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nhắc nhở (${_task!.reminders.length})',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddReminderDialog,
                icon: const Icon(Icons.add_alarm, size: 18),
                label: const Text('Thêm'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_task!.reminders.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 48,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Chưa có nhắc nhở nào',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Thêm nhắc nhở để không bỏ lỡ thời hạn',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _task!.reminders.length,
              itemBuilder: (context, index) {
                final reminder = _task!.reminders[index];
                return _buildReminderItem(reminder);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildReminderItem(Reminder reminder) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isUpcoming = reminder.time.isAfter(DateTime.now());
    final Color reminderColor = isUpcoming ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Hiển thị chi tiết reminder
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: reminderColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: reminderColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    reminder.type == 'email' ? Icons.email_outlined : Icons.notifications_outlined,
                    size: 22,
                    color: reminderColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.message,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: isUpcoming ? colorScheme.primary : colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(reminder.time),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: isUpcoming ? FontWeight.w500 : FontWeight.w400,
                              color: isUpcoming ? colorScheme.primary : colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (isUpcoming) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Sắp tới',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: () {
                    // Hiển thị dialog xác nhận xóa
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Xóa nhắc nhở'),
                        content: Text('Bạn có chắc chắn muốn xóa nhắc nhở này?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Implement delete reminder
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Đã xóa nhắc nhở'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Text(
                              'Xóa',
                              style: TextStyle(color: colorScheme.error),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  color: colorScheme.onSurfaceVariant,
                  splashRadius: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddSubTaskInput() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -3),
            spreadRadius: 1,
          ),
        ],
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _subTaskController,
                focusNode: _subTaskFocusNode,
                decoration: InputDecoration(
                  hintText: 'Thêm công việc con mới',
                  hintStyle: GoogleFonts.inter(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  isDense: true,
                ),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _addSubTask();
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: _addSubTask,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.add_rounded,
                  color: colorScheme.onPrimary,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addSubTask() {
    final subTaskTitle = _subTaskController.text.trim();
    if (subTaskTitle.isEmpty) return;

    context.read<TasksBloc>().add(
          AddSubTask(
            taskId: _task!.id,
            title: subTaskTitle,
          ),
        );
  }

  void _showEditTaskBottomSheet() {
    // Lấy TasksBloc từ context hiện tại
    final tasksBloc = context.read<TasksBloc>();
    print('*** _showEditTaskBottomSheet: TasksBloc found ***');
    print('*** _showEditTaskBottomSheet: TasksBloc = $tasksBloc ***');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: tasksBloc,
        child: AddTaskBottomSheet(
          taskToEdit: _task,
          tasksBloc: tasksBloc, // Truyền TasksBloc vào AddTaskBottomSheet
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
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
                    _getCategoryIcon(_task!.category),
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _task!.title,
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

              // Xóa task và cập nhật danh sách
              final tasksBloc = context.read<TasksBloc>();

              // Thêm hiệu ứng haptic feedback
              HapticFeedback.mediumImpact();

              // Xóa task (với optimistic update)
              // TasksBloc sẽ tự động gọi API và cập nhật dữ liệu
              tasksBloc.add(DeleteTask(_task!.id));

              // Đảm bảo dữ liệu được cập nhật sau khi xóa
              Future.delayed(const Duration(milliseconds: 500), () {
                // Gọi API để lấy danh sách tasks mới nhất sau khi xóa
                tasksBloc.add(FetchTasks());
              });

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
                          'Đã xóa "${_task!.title}"',
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
                        title: _task!.title,
                        description: _task!.description,
                        dueDate: _task!.dueDate,
                        priority: _task!.priority,
                        category: _task!.category,
                        tags: _task!.tags,
                      ));

                      // Đảm bảo dữ liệu được cập nhật sau khi hoàn tác
                      Future.delayed(const Duration(milliseconds: 500), () {
                        // Gọi API để lấy danh sách tasks mới nhất sau khi hoàn tác
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

              // Đảm bảo dữ liệu được cập nhật trước khi quay lại
              Future.delayed(const Duration(milliseconds: 300), () {
                // Quay lại màn hình danh sách task
                Navigator.of(context).pop();
              });
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

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'work':
      case 'công việc':
        return Icons.work_outline_rounded;
      case 'personal':
      case 'cá nhân':
        return Icons.person_outline_rounded;
      case 'shopping':
      case 'mua sắm':
        return Icons.shopping_bag_outlined;
      case 'health':
      case 'sức khỏe':
        return Icons.favorite_border_rounded;
      case 'education':
      case 'học tập':
        return Icons.school_outlined;
      case 'finance':
      case 'tài chính':
        return Icons.account_balance_outlined;
      case 'travel':
      case 'du lịch':
        return Icons.flight_outlined;
      case 'home':
      case 'nhà cửa':
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

  void _showAddSubTaskDialog() {
    // Lấy TasksBloc từ context hiện tại
    final tasksBloc = context.read<TasksBloc>();

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: tasksBloc,
        child: AddSubTaskDialog(taskId: _task!.id),
      ),
    );
  }

  void _showAddReminderDialog() {
    // Lấy TasksBloc từ context hiện tại
    final tasksBloc = context.read<TasksBloc>();

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: tasksBloc,
        child: AddReminderDialog(taskId: _task!.id),
      ),
    );
  }
}
