import 'package:flutter/material.dart';
import 'task_form.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const TaskForm(),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            SizedBox(width: 8),
            Text('Thêm công việc mới'),
          ],
        ),
      ),
    );
  }
}
