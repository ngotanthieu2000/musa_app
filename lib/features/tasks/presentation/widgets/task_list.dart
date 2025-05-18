import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tasks_bloc.dart';
import '../../domain/entities/task.dart';
import 'task_list_item.dart';
import 'add_task_bottom_sheet.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final String? filter;

  const TaskList({
    super.key,
    required this.tasks,
    this.filter,
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
    return ListView.builder(
      itemCount: taskList.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final task = taskList[index];
        // Add staggered animation for list items
        return AnimatedSlide(
          offset: Offset(0, 0),
          duration: Duration(milliseconds: 300 + (index * 50)),
          curve: Curves.easeOutQuart,
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(milliseconds: 300 + (index * 50)),
            curve: Curves.easeInOut,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TaskListItem(task: task),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    String message;
    IconData iconData;
    String buttonText = 'Add a Task';
    VoidCallback onButtonPressed = () {
      // Lấy TasksBloc từ context hiện tại
      final tasksBloc = context.read<TasksBloc>();
      print('*** _buildEmptyState.onButtonPressed: TasksBloc found ***');
      print('*** _buildEmptyState.onButtonPressed: TasksBloc = $tasksBloc ***');

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
      message = "You don't have any tasks yet";
      iconData = Icons.assignment_outlined;
    } else {
      switch (filter) {
        case 'completed':
          message = "You haven't completed any tasks yet";
          iconData = Icons.task_alt;
          buttonText = 'Mark Tasks as Complete';
          break;
        case 'active':
          message = "You don't have any tasks in progress";
          iconData = Icons.pending_actions;
          buttonText = 'Start Working on a Task';
          break;
        default:
          message = "No tasks found with this status";
          iconData = Icons.search_off_outlined;
      }
    }

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(80),
            ),
            child: Icon(
              iconData,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Get organized by creating tasks and tracking your progress",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: onButtonPressed,
                icon: const Icon(Icons.add),
                label: Text(buttonText),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {
                  context.read<TasksBloc>().add(FetchTasks());
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}