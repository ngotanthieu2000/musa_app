import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tasks_bloc.dart';
import '../../domain/entities/task.dart';
import 'package:intl/intl.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final Task? taskToEdit;
  final TasksBloc? tasksBloc; // Tùy chọn, có thể lấy từ context

  const AddTaskBottomSheet({
    super.key,
    this.taskToEdit,
    this.tasksBloc, // Tùy chọn, có thể lấy từ context
  });

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
            ButtonSegment(
              value: 'critical',
              label: const Text('Quan trọng'),
              icon: const Icon(Icons.warning_amber),
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
            onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
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
            onPressed: _isSubmitting ? null : _saveTask,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isSubmitting
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(isEditing ? 'Đang cập nhật...' : 'Đang thêm...'),
                    ],
                  )
                : Text(isEditing ? 'Cập nhật' : 'Thêm mới'),
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
        // Lấy theme hiện tại của ứng dụng
        final ThemeData theme = Theme.of(context);

        // Tạo theme mới dựa trên theme hiện tại
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              // Giữ nguyên các màu chính từ theme hiện tại
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
              onSurface: theme.colorScheme.onSurface,
              // Thêm các màu cần thiết cho date picker
              surface: theme.colorScheme.surface,
              background: theme.colorScheme.background,
            ),
            // Đảm bảo dialog có màu nền đúng
            dialogBackgroundColor: theme.colorScheme.surface,
            // Đảm bảo text có màu đúng
            textTheme: theme.textTheme,
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
      print('*** _saveTask: Form validated ***');

      // Hiển thị loading indicator
      setState(() {
        _isSubmitting = true;
      });

      print('Title: ${_titleController.text.trim()}');
      print('Description: ${_descriptionController.text.trim()}');
      print('Due Date: $_dueDate');
      print('Priority: $_priority');
      print('Category: $_category');

      // Gọi API để tạo task TRƯỚC KHI đóng bottom sheet
      _createTask().then((_) {
        // Đóng bottom sheet sau khi tạo task thành công
        Navigator.of(context).pop();

        // Hiển thị thông báo thành công
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
      }).catchError((error) {
        // Hiển thị thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Lỗi: $error',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }).whenComplete(() {
        // Ẩn loading indicator
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      });
    } else {
      print('*** _saveTask: Form validation failed ***');
    }
  }

  // Phương thức mới để tạo task và trả về Future
  Future<void> _createTask() async {
    print('*** _createTask: Called ***');

    // Tìm TasksBloc
    TasksBloc? tasksBloc;

    // Thử sử dụng widget.tasksBloc
    if (widget.tasksBloc != null) {
      print('*** _createTask: Using widget.tasksBloc ***');
      tasksBloc = widget.tasksBloc;
    } else {
      // Thử lấy TasksBloc từ context
      try {
        tasksBloc = BlocProvider.of<TasksBloc>(context, listen: false);
        print('*** _createTask: Using TasksBloc from context ***');
      } catch (e) {
        print('*** _createTask: Cannot get TasksBloc from context - $e ***');
        throw Exception('Không thể kết nối với TasksBloc');
      }
    }

    if (tasksBloc == null) {
      print('*** _createTask: TasksBloc is null ***');
      throw Exception('TasksBloc không khả dụng');
    }

    print('*** _createTask: TasksBloc = $tasksBloc ***');

    // Gọi sự kiện AddTask
    print('*** _createTask: Dispatching AddTask event ***');
    tasksBloc.add(AddTask(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: _dueDate,
      priority: _getPriorityEnum(_priority),
      category: _category,
    ));

    // Đợi 1 giây để đảm bảo sự kiện được xử lý
    await Future.delayed(const Duration(seconds: 1));
  }



  TaskPriority _getPriorityEnum(String priority) {
    switch(priority.toLowerCase()) {
      case 'low':
        return TaskPriority.low;
      case 'medium':
        return TaskPriority.medium;
      case 'high':
        return TaskPriority.high;
      case 'critical':
        return TaskPriority.critical;
      default:
        return TaskPriority.medium;
    }
  }
}