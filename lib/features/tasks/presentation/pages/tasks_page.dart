import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title: Text(
              'Nhiệm vụ của tôi',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            floating: true,
            pinned: true,
            forceElevated: innerBoxIsScrolled,
            bottom: _buildTabBar(),
            backgroundColor: colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            elevation: innerBoxIsScrolled ? 2 : 0,
            scrolledUnderElevation: 2,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  color: colorScheme.onSurface,
                ),
                tooltip: 'Tìm kiếm nhiệm vụ',
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.surfaceVariant.withOpacity(0.5),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      width: MediaQuery.of(context).size.width * 0.9,
                      content: const Text('Tính năng tìm kiếm sẽ sớm ra mắt'),
                      backgroundColor: AppColors.infoDark,
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  Icons.filter_list_rounded,
                  color: colorScheme.onSurface,
                ),
                tooltip: 'Lọc nhiệm vụ',
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.surfaceVariant.withOpacity(0.5),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      width: MediaQuery.of(context).size.width * 0.9,
                      content: const Text('Tính năng lọc sẽ sớm ra mắt'),
                      backgroundColor: AppColors.infoDark,
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
            ],
          ),
        ];
      },
      body: Container(
        color: colorScheme.surface,
        child: BlocBuilder<TasksBloc, TasksState>(
          builder: (context, state) {
            if (state is TasksInitial) {
              return Center(
                child: Text(
                  'Khởi tạo nhiệm vụ của bạn',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              );
            } else if (state is TasksLoading) {
              return _buildLoadingState();
            } else if (state is TasksLoaded) {
              return _buildTasksContent(state.tasks);
            } else if (state is TaskActionSuccess) {
              return _buildTasksContent(state.tasks);
            } else if (state is TasksError) {
              return _buildErrorState(state.userFriendlyMessage);
            } else {
              return Center(
                child: Text(
                  'Trạng thái không xác định',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTabBar() {
    final colorScheme = Theme.of(context).colorScheme;

    return TabBar(
      controller: _tabController,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: Colors.transparent,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: colorScheme.primaryContainer,
      ),
      labelColor: colorScheme.onPrimaryContainer,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      indicatorPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      tabs: [
        Tab(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text('Tất cả'),
          ),
        ),
        Tab(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text('Đang làm'),
          ),
        ),
        Tab(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text('Hoàn thành'),
          ),
        ),
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
          const SizedBox(height: 24),
          Text(
            'Đang tải nhiệm vụ của bạn...',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vui lòng đợi trong giây lát',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.errorLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: AppColors.errorLight.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppColors.errorLight,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Đã xảy ra lỗi',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                message,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                context.read<TasksBloc>().add(FetchTasks());
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'Thử lại',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    final colorScheme = Theme.of(context).colorScheme;

    return FloatingActionButton.extended(
      onPressed: () {
        _showAddTaskBottomSheet(context);
      },
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      label: const Text(
        'Thêm nhiệm vụ',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      icon: const Icon(Icons.add_rounded, size: 20),
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