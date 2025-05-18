import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../bloc/tasks_bloc.dart';
import '../widgets/task_list_item.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/empty_tasks.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Tất cả', 'Đang làm', 'Hoàn thành'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    context.read<TasksBloc>().add(FetchTasks());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.surface,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Nhiệm vụ',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                        Theme.of(context).colorScheme.surface,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: _buildTabBar(),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTaskList(TaskFilter.all),
            _buildTaskList(TaskFilter.active),
            _buildTaskList(TaskFilter.completed),
          ],
        ),
      ),
      floatingActionButton: _buildAddTaskButton(),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Theme.of(context).colorScheme.primary,
        indicatorWeight: 3,
        labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  Widget _buildTaskList(TaskFilter filter) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        if (state is TasksLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TasksLoaded || state is TaskActionSuccess) {
          final tasks = state is TasksLoaded
              ? state.tasks
              : (state as TaskActionSuccess).tasks;

          final filteredTasks = _getFilteredTasks(tasks, filter);

          if (filteredTasks.isEmpty) {
            return _buildEmptyState(filter);
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<TasksBloc>().add(FetchTasks());
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return TaskListItem(
                  task: task,
                  onToggle: () {
                    context.read<TasksBloc>().add(ToggleTaskCompletion(task.id));
                  },
                  onEdit: () {
                    _showAddTaskBottomSheet(task: task);
                  },
                  onDelete: () {
                    _showDeleteConfirmation(task);
                  },
                );
              },
            ),
          );
        } else if (state is TasksError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Đã xảy ra lỗi',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  state.userFriendlyMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<TasksBloc>().add(FetchTasks());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        return const Center(child: Text('Không có dữ liệu'));
      },
    );
  }

  Widget _buildEmptyState(TaskFilter filter) {
    String title;
    String message;
    IconData icon;

    switch (filter) {
      case TaskFilter.all:
        title = 'Chưa có nhiệm vụ nào';
        message = 'Hãy thêm nhiệm vụ mới để bắt đầu';
        icon = Icons.assignment_outlined;
        break;
      case TaskFilter.active:
        title = 'Không có nhiệm vụ đang làm';
        message = 'Bạn đã hoàn thành tất cả nhiệm vụ?';
        icon = Icons.check_circle_outline;
        break;
      case TaskFilter.completed:
        title = 'Chưa có nhiệm vụ hoàn thành';
        message = 'Hoàn thành nhiệm vụ để xem chúng ở đây';
        icon = Icons.done_all;
        break;
    }

    return EmptyTasks(
      title: title,
      message: message,
      icon: icon,
      onAddTask: filter != TaskFilter.completed ? () => _showAddTaskBottomSheet() : null,
      showAddButton: filter != TaskFilter.completed,
    );
  }

  Widget _buildAddTaskButton() {
    return FloatingActionButton(
      onPressed: () => _showAddTaskBottomSheet(),
      child: const Icon(Icons.add),
      tooltip: 'Thêm nhiệm vụ mới',
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  void _showAddTaskBottomSheet({Task? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTaskBottomSheet(task: task),
    );
  }

  void _showDeleteConfirmation(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa nhiệm vụ'),
        content: Text('Bạn có chắc chắn muốn xóa "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteTaskWithUndo(task);
            },
            child: Text(
              'Xóa',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteTaskWithUndo(Task task) {
    // Xóa task (với optimistic update)
    context.read<TasksBloc>().add(DeleteTask(task.id));

    // Hiển thị Snackbar với nút Undo
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa "${task.title}"'),
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () {
            // Thêm lại task đã xóa
            context.read<TasksBloc>().add(AddTask(
              title: task.title,
              description: task.description,
              dueDate: task.dueDate,
              priority: task.priority,
              category: task.category,
              tags: task.tags,
            ));
          },
        ),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<Task> _getFilteredTasks(List<Task> tasks, TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return tasks;
      case TaskFilter.active:
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted).toList();
    }
  }
}

enum TaskFilter { all, active, completed }