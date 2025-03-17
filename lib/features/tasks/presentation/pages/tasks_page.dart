import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tasks_bloc.dart';
import '../widgets/task_list.dart';
import '../widgets/add_task_button.dart';

class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Công việc'),
      ),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state is TasksLoading) {
            return Center(child: CircularProgressIndicator());
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
                AddTaskButton(),
              ],
            );
          }

          return Center(child: Text('Không có công việc nào'));
        },
      ),
    );
  }
} 