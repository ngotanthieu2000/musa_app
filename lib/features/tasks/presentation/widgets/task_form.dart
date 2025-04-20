import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';

class TaskForm extends StatefulWidget {
  final Task? initialTask;
  final Function(String title, String description) onSubmit;
  final VoidCallback onCancel;

  const TaskForm({
    super.key,
    this.initialTask,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  
  // Thêm bộ điều khiển cho các trường đầu vào mới
  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.medium;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTask?.title ?? '');
    _descriptionController = TextEditingController(text: widget.initialTask?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      
      widget.onSubmit(
        _titleController.text.trim(),
        _descriptionController.text.trim(),
      );
      
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  String _getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Thấp';
      case TaskPriority.medium:
        return 'Trung bình';
      case TaskPriority.high:
        return 'Cao';
    }
  }
  
  Color _getPriorityColor(TaskPriority priority) {
    final theme = Theme.of(context);
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialTask != null;
    final theme = Theme.of(context);
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Chỉnh sửa nhiệm vụ' : 'Thêm nhiệm vụ mới',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isEditing 
                      ? 'Cập nhật thông tin nhiệm vụ của bạn bên dưới.'
                      : 'Nhập thông tin cho nhiệm vụ mới của bạn.',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),
          
          // Form fields
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleField(theme),
                const SizedBox(height: 20),
                _buildDescriptionField(theme),
                const SizedBox(height: 32),
                _buildFormActions(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tiêu đề',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'Nhập tiêu đề nhiệm vụ',
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            prefixIcon: Icon(
              Icons.assignment_outlined,
              color: theme.colorScheme.primary,
            ),
          ),
          style: TextStyle(
            fontSize: 16,
            color: theme.colorScheme.onSurface,
          ),
          maxLines: 1,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Vui lòng nhập tiêu đề nhiệm vụ';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mô tả (Tùy chọn)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            hintText: 'Nhập mô tả chi tiết',
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            prefixIcon: Icon(
              Icons.description_outlined,
              color: theme.colorScheme.primary,
            ),
          ),
          style: TextStyle(
            fontSize: 16,
            color: theme.colorScheme.onSurface,
          ),
          maxLines: 3,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildFormActions(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Cancel button
        OutlinedButton.icon(
          onPressed: _isSubmitting ? null : widget.onCancel,
          icon: const Icon(Icons.close),
          label: const Text('Hủy'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Submit button
        FilledButton.icon(
          onPressed: _isSubmitting ? null : _handleSubmit,
          icon: _isSubmitting 
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : const Icon(Icons.check),
          label: Text(widget.initialTask != null ? 'Cập nhật' : 'Tạo'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
