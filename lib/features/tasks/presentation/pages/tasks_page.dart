import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../bloc/tasks_bloc.dart';
import '../widgets/task_list.dart';
import '../widgets/add_task_bottom_sheet.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Fetch tasks when the page is loaded
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
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title: const Text('My Tasks'),
            floating: true,
            pinned: true,
            forceElevated: innerBoxIsScrolled,
            bottom: _buildTabBar(),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Search Tasks',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      width: MediaQuery.of(context).size.width * 0.9,
                      content: const Text('Search functionality coming soon'),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                tooltip: 'Filter Tasks',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      width: MediaQuery.of(context).size.width * 0.9,
                      content: const Text('Filter functionality coming soon'),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ];
      },
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state is TasksInitial) {
            return const Center(child: Text('Initialize your tasks'));
          } else if (state is TasksLoading) {
            return _buildLoadingState();
          } else if (state is TasksLoaded) {
            return _buildTasksContent(state.tasks);
          } else if (state is TaskActionSuccess) {
            return _buildTasksContent(state.tasks);
          } else if (state is TasksError) {
            return _buildErrorState(state.userFriendlyMessage);
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  PreferredSizeWidget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: Colors.transparent,
      tabs: const [
        Tab(text: 'All'),
        Tab(text: 'In Progress'),
        Tab(text: 'Completed'),
      ],
    );
  }

  Widget _buildTasksContent(List<Task> tasks) {
    return TabBarView(
      controller: _tabController,
      children: [
        TaskList(tasks: tasks, filter: null),
        TaskList(tasks: tasks, filter: 'active'),
        TaskList(tasks: tasks, filter: 'completed'),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading your tasks...',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.error_outline,
              size: 60,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              context.read<TasksBloc>().add(FetchTasks());
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        _showAddTaskBottomSheet(context);
      },
      label: const Text('Add Task'),
      icon: const Icon(Icons.add),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    // Lấy TasksBloc từ context hiện tại
    final tasksBloc = context.read<TasksBloc>();
    print('*** _showAddTaskBottomSheet: TasksBloc found ***');
    print('*** _showAddTaskBottomSheet: TasksBloc = $tasksBloc ***');

    // Hiển thị bottom sheet với BlocProvider để đảm bảo TasksBloc có sẵn
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bottomSheetContext) {
        // Sử dụng BlocProvider.value để truyền TasksBloc hiện có
        return BlocProvider.value(
          value: tasksBloc,
          child: AddTaskBottomSheet(
            tasksBloc: tasksBloc,
          ),
        );
      },
    );
    print('*** _showAddTaskBottomSheet: Bottom sheet shown ***');
  }
}