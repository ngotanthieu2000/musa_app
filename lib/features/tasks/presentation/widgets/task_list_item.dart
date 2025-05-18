import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task.dart';
import '../bloc/tasks_bloc.dart';
import 'add_task_bottom_sheet.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  const TaskListItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      background: _buildDismissibleBackground(context, DismissDirection.startToEnd),
      secondaryBackground: _buildDismissibleBackground(context, DismissDirection.endToStart),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Delete
          context.read<TasksBloc>().add(DeleteTask(task.id));
          return true;
        } else if (direction == DismissDirection.startToEnd) {
          // Toggle completion
          context.read<TasksBloc>().add(ToggleTaskCompletion(task.id));
          return false;
        }
        return false;
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showTaskDetailsDialog(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCheckbox(context),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                color: task.isCompleted
                                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (task.priority != null && task.priority != TaskPriority.medium)
                            _buildPriorityIndicator(context),
                        ],
                      ),
                      if (task.description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            task.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const SizedBox(height: 8),
                      _buildTaskMetadata(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        context.read<TasksBloc>().add(ToggleTaskCompletion(task.id));
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: task.isCompleted
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: 2,
          ),
          color: task.isCompleted
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Colors.transparent,
        ),
        child: task.isCompleted
            ? Icon(
                Icons.check,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
      ),
    );
  }

  Widget _buildPriorityIndicator(BuildContext context) {
    Color priorityColor;
    IconData iconData;
    String tooltip;

    switch (task.priority) {
      case TaskPriority.high:
        priorityColor = Colors.red;
        iconData = Icons.priority_high;
        tooltip = 'High Priority';
        break;
      case TaskPriority.critical:
        priorityColor = Colors.purple;
        iconData = Icons.warning_amber;
        tooltip = 'Critical Priority';
        break;
      case TaskPriority.low:
        priorityColor = Colors.green;
        iconData = Icons.arrow_downward;
        tooltip = 'Low Priority';
        break;
      default:
        priorityColor = Colors.orange;
        iconData = Icons.remove;
        tooltip = 'Medium Priority';
    }

    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: priorityColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          iconData,
          size: 16,
          color: priorityColor,
        ),
      ),
    );
  }

  Widget _buildTaskMetadata(BuildContext context) {
    return Row(
      children: [
        if (task.dueDate != null) ...[
          Icon(
            Icons.calendar_today,
            size: 14,
            color: _isOverdue()
                ? Colors.red
                : Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            DateFormat('MMM dd').format(task.dueDate!),
            style: TextStyle(
              fontSize: 12,
              color: _isOverdue()
                  ? Colors.red
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 16),
        ],
        if (task.progress > 0 && !task.isCompleted) ...[
          _buildProgressChip(context),
        ],
      ],
    );
  }

  Widget _buildProgressChip(BuildContext context) {
    final Color progressColor = Colors.blue;
    final String progressText = '${task.progress}%';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: progressColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: progressColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        progressText,
        style: TextStyle(
          fontSize: 10,
          color: progressColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDismissibleBackground(BuildContext context, DismissDirection direction) {
    final bool isDeleteAction = direction == DismissDirection.endToStart;

    return Container(
      alignment: isDeleteAction ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: isDeleteAction ? 0 : 20,
        right: isDeleteAction ? 20 : 0,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDeleteAction
            ? Colors.red.shade100
            : Colors.green.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        isDeleteAction ? Icons.delete : Icons.check,
        color: isDeleteAction ? Colors.red : Colors.green,
      ),
    );
  }

  void _showTaskDetailsDialog(BuildContext context) {
    // Use GoRouter for navigation
    GoRouter.of(context).push('/tasks/detail/${task.id}');
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
}