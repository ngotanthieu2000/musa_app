import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../bloc/tasks_bloc.dart';

class AddSubTaskDialog extends StatefulWidget {
  final String taskId;

  const AddSubTaskDialog({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  @override
  State<AddSubTaskDialog> createState() => _AddSubTaskDialogState();
}

class _AddSubTaskDialogState extends State<AddSubTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _dueDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Subtask'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter subtask title',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              autofocus: true,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectDueDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Due Date (Optional)',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _dueDate == null
                      ? 'No date selected'
                      : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addSubTask,
          child: const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _addSubTask() {
    if (_formKey.currentState!.validate()) {
      context.read<TasksBloc>().add(
            AddSubTask(
              taskId: widget.taskId,
              title: _titleController.text.trim(),
              dueDate: _dueDate,
            ),
          );
      Navigator.of(context).pop();
    }
  }
}
