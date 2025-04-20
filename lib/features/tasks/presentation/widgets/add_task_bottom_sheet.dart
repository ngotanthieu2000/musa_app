import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tasks_bloc.dart';
import '../../domain/entities/task.dart';
import 'package:intl/intl.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final Task? taskToEdit;

  const AddTaskBottomSheet({super.key, this.taskToEdit});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dueDateController;
  String _priority = 'medium';
  String _category = 'general';
  DateTime? _dueDate;
  bool _isSubmitting = false;

  bool get isEditing => widget.taskToEdit != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.taskToEdit?.title ?? '');
    _descriptionController = TextEditingController(text: widget.taskToEdit?.description ?? '');
    _dueDateController = TextEditingController();
    
    if (isEditing) {
      _priority = widget.taskToEdit!.priority?.toString().split('.').last ?? 'medium';
      _category = widget.taskToEdit!.category ?? 'general';
      if (widget.taskToEdit!.dueDate != null) {
        _dueDate = widget.taskToEdit!.dueDate;
        _dueDateController.text = DateFormat('dd/MM/yyyy').format(_dueDate!);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildTitleField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 16),
              _buildDueDateField(context),
              const SizedBox(height: 16),
              _buildPrioritySelector(),
              const SizedBox(height: 16),
              _buildCategorySelector(),
              const SizedBox(height: 24),
              _buildSubmitButton(isEditing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isEditing ? 'Chỉnh sửa công việc' : 'Thêm công việc mới',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          tooltip: 'Đóng',
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Tiêu đề',
        hintText: 'Nhập tiêu đề công việc',
        prefixIcon: const Icon(Icons.title),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Vui lòng nhập tiêu đề';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      maxLength: 100,
      buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
        return Text(
          '$currentLength/$maxLength',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: currentLength > 80 
                ? Theme.of(context).colorScheme.error 
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        );
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Mô tả',
        hintText: 'Nhập mô tả công việc (không bắt buộc)',
        prefixIcon: const Icon(Icons.description),
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
    );
  }

  Widget _buildDueDateField(BuildContext context) {
    final formattedDate = _dueDate != null
        ? DateFormat('dd/MM/yyyy').format(_dueDate!)
        : 'Chọn ngày hết hạn';
        
    bool isOverdue = _dueDate != null && _dueDate!.isBefore(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ngày hết hạn',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _selectDueDate,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isOverdue
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: isOverdue
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: isOverdue
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                if (_dueDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _dueDate = null;
                        _dueDateController.clear();
                      });
                    },
                    tooltip: 'Xóa ngày',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
        if (isOverdue)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              'Ngày đã qua!',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Mức độ ưu tiên',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 16,
            ),
          ),
        ),
        SegmentedButton<String>(
          segments: [
            ButtonSegment(
              value: 'low',
              label: const Text('Thấp'),
              icon: const Icon(Icons.arrow_downward),
            ),
            ButtonSegment(
              value: 'medium',
              label: const Text('Trung bình'),
              icon: const Icon(Icons.remove),
            ),
            ButtonSegment(
              value: 'high',
              label: const Text('Cao'),
              icon: const Icon(Icons.arrow_upward),
            ),
          ],
          selected: <String>{_priority},
          onSelectionChanged: (selected) {
            setState(() {
              _priority = selected.first;
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return Theme.of(context).colorScheme.primaryContainer;
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Danh mục',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _category,
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.primary,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'general',
                  child: Row(
                    children: [
                      Icon(Icons.category),
                      SizedBox(width: 12),
                      Text('Chung'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'work',
                  child: Row(
                    children: [
                      Icon(Icons.work),
                      SizedBox(width: 12),
                      Text('Công việc'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'personal',
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 12),
                      Text('Cá nhân'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'shopping',
                  child: Row(
                    children: [
                      Icon(Icons.shopping_cart),
                      SizedBox(width: 12),
                      Text('Mua sắm'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'health',
                  child: Row(
                    children: [
                      Icon(Icons.favorite),
                      SizedBox(width: 12),
                      Text('Sức khỏe'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _category = value ?? 'general';
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isEditing) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            child: const Text('Hủy bỏ'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FilledButton(
            onPressed: _saveTask,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(isEditing ? 'Cập nhật' : 'Thêm mới'),
          ),
        ),
      ],
    );
  }

  void _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
        _dueDateController.text = DateFormat('dd/MM/yyyy').format(_dueDate!);
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      
      if (isEditing) {
        final updatedTask = widget.taskToEdit!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _getPriorityEnum(_priority),
          category: _category,
          dueDate: _dueDate,
          updatedAt: now,
        );
        
        context.read<TasksBloc>().add(UpdateTask(updatedTask));
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cập nhật công việc thành công',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      } else {
        final newTask = Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          completed: false,
          priority: _getPriorityEnum(_priority),
          category: _category,
          dueDate: _dueDate,
          createdAt: now,
          updatedAt: now,
        );
        
        context.read<TasksBloc>().add(AddTask(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
        ));
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Thêm công việc thành công',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
      
      Navigator.of(context).pop();
    }
  }

  TaskPriority? _getPriorityEnum(String priority) {
    switch(priority.toLowerCase()) {
      case 'low':
        return TaskPriority.low;
      case 'medium':
        return TaskPriority.medium;
      case 'high':
        return TaskPriority.high;
      default:
        return TaskPriority.medium;
    }
  }
} 