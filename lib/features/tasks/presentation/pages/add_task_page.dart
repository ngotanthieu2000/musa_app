import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../bloc/tasks_bloc.dart';
import '../widgets/task_form.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Thêm công việc mới'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Đóng',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TaskForm(
              onSubmit: (title, description) {
                context.read<TasksBloc>().add(TasksAddEvent(
                  title: title,
                  description: description,
                ));
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }
} 