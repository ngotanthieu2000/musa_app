import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../bloc/tasks_bloc.dart';

class AddReminderDialog extends StatefulWidget {
  final String taskId;

  const AddReminderDialog({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  @override
  State<AddReminderDialog> createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<AddReminderDialog> {
  final TextEditingController _messageController = TextEditingController();
  DateTime _reminderDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _reminderTime = TimeOfDay.now();
  String _reminderType = 'push';
  final _formKey = GlobalKey<FormState>();

  final List<String> _reminderTypes = ['push', 'email', 'sms'];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Reminder'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  hintText: 'Enter reminder message',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
                maxLines: 2,
                autofocus: true,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectReminderDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${_reminderDate.day}/${_reminderDate.month}/${_reminderDate.year}',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectReminderTime,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Time',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  child: Text(
                    '${_reminderTime.hour}:${_reminderTime.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Reminder Type',
                ),
                value: _reminderType,
                items: _reminderTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _reminderType = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addReminder,
          child: const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _selectReminderDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _reminderDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (picked != null && picked != _reminderDate) {
      setState(() {
        _reminderDate = picked;
      });
    }
  }

  Future<void> _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );

    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  void _addReminder() {
    if (_formKey.currentState!.validate()) {
      final reminderDateTime = DateTime(
        _reminderDate.year,
        _reminderDate.month,
        _reminderDate.day,
        _reminderTime.hour,
        _reminderTime.minute,
      );

      context.read<TasksBloc>().add(
            AddReminder(
              taskId: widget.taskId,
              message: _messageController.text.trim(),
              time: reminderDateTime,
              type: _reminderType,
            ),
          );
      Navigator.of(context).pop();
    }
  }
}
