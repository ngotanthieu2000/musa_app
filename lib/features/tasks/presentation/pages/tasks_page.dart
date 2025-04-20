import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tasks_bloc.dart';
import '../widgets/task_list.dart';
import '../widgets/add_task_button.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TasksError) {
            return Center(child: Text(state.message));
          }

          if (state is TasksLoaded) {
            return Column(
              children: [
                Expanded(
                  child: TaskList(tasks: state.tasks),
                ),
                const AddTaskButton(),
              ],
            );
          }

          return const Center(child: Text('No tasks found'));
        },
      ),
    );
  }
} 