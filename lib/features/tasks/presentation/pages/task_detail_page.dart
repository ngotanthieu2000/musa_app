import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
    final state = context.read<TasksBloc>().state;
    if (state is TasksLoaded) {
      _findTaskInState(state.tasks);
    } else if (state is TaskActionSuccess) {
      _findTaskInState(state.tasks);
    } else {
      context.read<TasksBloc>().add(FetchTasks());
    }
  }

  void _findTaskInState(List<Task> tasks) {
    final task = tasks.firstWhere(
      (t) => t.id == widget.taskId,
      orElse: () => Task(
        id: '',
        userId: '',
        title: 'Không tìm thấy nhiệm vụ',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    setState(() {
      _task = task;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksBloc, TasksState>(
      listener: (context, state) {
        if (state is TasksLoaded) {
          _findTaskInState(state.tasks);
        } else if (state is TaskActionSuccess) {
          _findTaskInState(state.tasks);
          if (state.actionType == ActionType.addSubTask) {
            _subTaskController.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã thêm công việc con')),
            );
          } else if (state.actionType == ActionType.updateSubTask) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã cập nhật công việc con')),
            );
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
            title: const Text('Chi tiết nhiệm vụ'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditTaskBottomSheet(),
                tooltip: 'Chỉnh sửa nhiệm vụ',
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showDeleteConfirmation(),
                tooltip: 'Xóa nhiệm vụ',
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTaskHeader(),
                const Divider(height: 32),
                _buildTaskDetails(),
                const Divider(height: 32),
                _buildSubTasksSection(),
                const Divider(height: 32),
                _buildRemindersSection(),
                const SizedBox(height: 100),
              ],
            ),
          ),
          bottomSheet: _buildAddSubTaskInput(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              context.read<TasksBloc>().add(ToggleTaskCompletion(_task!.id));
            },
            icon: Icon(_task!.isCompleted ? Icons.refresh : Icons.check),
            label: Text(_task!.isCompleted ? 'Đánh dấu chưa hoàn thành' : 'Đánh dấu hoàn thành'),
          ),
        );
      },
    );
  }

  Widget _buildTaskHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildPriorityIndicator(),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _task!.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: _task!.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                ),
              ),
              Checkbox(
                value: _task!.isCompleted,
                onChanged: (value) {
                  context.read<TasksBloc>().add(ToggleTaskCompletion(_task!.id));
                },
              ),
            ],
          ),
          if (_task!.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              _task!.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_task!.dueDate != null)
                _buildInfoChip(
                  Icons.calendar_today,
                  DateFormat('dd MMM yyyy').format(_task!.dueDate!),
                  _task!.isOverdue() ? Colors.red : null,
                ),
              if (_task!.category.isNotEmpty)
                _buildInfoChip(
                  Icons.category,
                  _task!.category,
                ),
              if (_task!.progress > 0)
                _buildInfoChip(
                  Icons.pie_chart,
                  '${_task!.progress}% hoàn thành',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    Color priorityColor;
    String priorityText;

    switch (_task!.priority) {
      case TaskPriority.low:
        priorityColor = Colors.green;
        priorityText = 'Thấp';
        break;
      case TaskPriority.high:
        priorityColor = Colors.red;
        priorityText = 'Cao';
        break;
      case TaskPriority.critical:
        priorityColor = Colors.purple;
        priorityText = 'Quan trọng';
        break;
      default:
        priorityColor = Colors.orange;
        priorityText = 'Trung bình';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: priorityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: priorityColor),
      ),
      child: Text(
        priorityText,
        style: TextStyle(
          color: priorityColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, [Color? color]) {
    final chipColor = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: chipColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: chipColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chi tiết',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildDetailItem('Ngày tạo', DateFormat('dd/MM/yyyy HH:mm').format(_task!.createdAt)),
          _buildDetailItem('Cập nhật', DateFormat('dd/MM/yyyy HH:mm').format(_task!.updatedAt)),
          if (_task!.tags.isNotEmpty)
            _buildDetailItem('Tags', _task!.tags.join(', ')),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTasksSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Công việc con (${_task!.subTasks.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Row(
                children: [
                  if (_task!.subTasks.isNotEmpty)
                    Text(
                      '${_task!.subTasks.where((st) => st.isCompleted).length}/${_task!.subTasks.length} hoàn thành',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _showAddSubTaskDialog,
                    tooltip: 'Thêm công việc con',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_task!.subTasks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'Chưa có công việc con nào',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
          ),
          Expanded(
            child: Text(
              subTask.title,
              style: TextStyle(
                decoration: subTask.isCompleted ? TextDecoration.lineThrough : null,
                color: subTask.isCompleted
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          if (subTask.dueDate != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                DateFormat('dd/MM').format(subTask.dueDate!),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: () {
              // Implement delete subtask
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nhắc nhở (${_task!.reminders.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.add_alarm),
                onPressed: _showAddReminderDialog,
                tooltip: 'Thêm nhắc nhở',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_task!.reminders.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'Chưa có nhắc nhở nào',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                reminder.type == 'email' ? Icons.email : Icons.notifications,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.message,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(reminder.time),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                // Implement delete reminder
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddSubTaskInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _subTaskController,
              focusNode: _subTaskFocusNode,
              decoration: const InputDecoration(
                hintText: 'Thêm công việc con mới',
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _addSubTask();
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: _addSubTask,
            color: Theme.of(context).colorScheme.primary,
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa nhiệm vụ'),
        content: Text('Bạn có chắc chắn muốn xóa "${_task!.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<TasksBloc>().add(DeleteTask(_task!.id));
              Navigator.of(context).pop();
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

  void _showAddSubTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddSubTaskDialog(taskId: _task!.id),
    );
  }

  void _showAddReminderDialog() {
    showDialog(
      context: context,
      builder: (context) => AddReminderDialog(taskId: _task!.id),
    );
  }
}
