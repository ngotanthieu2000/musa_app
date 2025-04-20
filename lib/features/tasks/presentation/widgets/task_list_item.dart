import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                                decoration: task.completed ? TextDecoration.lineThrough : null,
                                color: task.completed 
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
                              decoration: task.completed ? TextDecoration.lineThrough : null,
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
            color: task.completed 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.outline,
            width: 2,
          ),
          color: task.completed 
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Colors.transparent,
        ),
        child: task.completed
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
        if (task.status != null) ...[
          _buildStatusChip(context),
        ],
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color statusColor;
    String statusText = task.status?.toString().split('.').last ?? 'pending';

    switch (statusText.toLowerCase()) {
      case 'inprogress':
      case 'in_progress':
        statusColor = Colors.blue;
        statusText = 'In Progress';
        break;
      case 'completed':
        statusColor = Colors.green;
        statusText = 'Completed';
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = 'Cancelled';
        break;
      case 'pending':
      default:
        statusColor = Colors.grey;
        statusText = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 10,
          color: statusColor,
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.pop(context);
                  _showEditTaskSheet(context);
                },
                tooltip: 'Edit Task',
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.description.isNotEmpty) ...[
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Divider(height: 24),
                ],
                if (task.status != null)
                  _buildTaskDetailItem(
                    context, 
                    'Status', 
                    task.status.toString().split('.').last,
                    Icons.assignment,
                  ),
                if (task.priority != null)
                  _buildTaskDetailItem(
                    context, 
                    'Priority', 
                    _getPriorityText(),
                    Icons.flag,
                  ),
                if (task.dueDate != null)
                  _buildTaskDetailItem(
                    context, 
                    'Due Date', 
                    DateFormat('MMMM dd, yyyy').format(task.dueDate!),
                    Icons.calendar_today,
                  ),
                if (task.createdAt != null)
                  _buildTaskDetailItem(
                    context, 
                    'Created', 
                    DateFormat('MMMM dd, yyyy').format(task.createdAt!),
                    Icons.access_time,
                  ),
                if (task.completedAt != null)
                  _buildTaskDetailItem(
                    context, 
                    'Completed', 
                    DateFormat('MMMM dd, yyyy').format(task.completedAt!),
                    Icons.check_circle,
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              icon: Icon(
                task.completed ? Icons.close : Icons.check,
                size: 18,
              ),
              label: Text(
                task.completed ? 'Mark Incomplete' : 'Mark Complete',
              ),
              onPressed: () {
                context.read<TasksBloc>().add(ToggleTaskCompletion(task.id));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTaskBottomSheet(),
    );
  }

  String _getPriorityText() {
    switch (task.priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
      default:
        return 'Medium';
    }
  }

  bool _isOverdue() {
    if (task.dueDate == null || task.completed) {
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