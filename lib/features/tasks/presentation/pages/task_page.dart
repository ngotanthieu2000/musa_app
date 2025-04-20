import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../widgets/task_list_item.dart';
import '../widgets/add_task_bottom_sheet.dart';

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
    context.read<TaskBloc>().add(const LoadTasksEvent());
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
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TasksLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TasksLoaded) {
          final filteredTasks = _getFilteredTasks(state.tasks, filter);
          
          if (filteredTasks.isEmpty) {
            return _buildEmptyState(filter);
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              context.read<TaskBloc>().add(const LoadTasksEvent());
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return TaskListItem(
                  task: task,
                  onToggle: () {
                    context.read<TaskBloc>().add(ToggleTaskEvent(task.id));
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
                  state.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<TaskBloc>().add(const LoadTasksEvent());
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
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 72,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          if (filter != TaskFilter.completed)
            ElevatedButton.icon(
              onPressed: () => _showAddTaskBottomSheet(),
              icon: const Icon(Icons.add),
              label: const Text('Thêm nhiệm vụ mới'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
        ],
      ),
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
              context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Đã xóa nhiệm vụ'),
                  action: SnackBarAction(
                    label: 'Hoàn tác',
                    onPressed: () {
                      context.read<TaskBloc>().add(AddTaskEvent(task));
                    },
                  ),
                ),
              );
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

  List<Task> _getFilteredTasks(List<Task> tasks, TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return tasks;
      case TaskFilter.active:
        return tasks.where((task) => !task.completed).toList();
      case TaskFilter.completed:
        return tasks.where((task) => task.completed).toList();
    }
  }
}

enum TaskFilter { all, active, completed } 