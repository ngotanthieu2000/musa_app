import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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

    // Đăng ký lắng nghe sự kiện khi tab thay đổi để refresh dữ liệu
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    // Khi người dùng chuyển tab, refresh dữ liệu để đảm bảo hiển thị dữ liệu mới nhất
    if (_tabController.indexIsChanging) {
      context.read<TasksBloc>().add(FetchTasks());
    }
  }

  @override
  void dispose() {
    // Hủy đăng ký lắng nghe sự kiện trước khi dispose
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksBloc, TasksState>(
      listener: (context, state) {
        if (state is TaskActionSuccess) {
          // Hiển thị thông báo khi thực hiện các hành động thành công
          _showSuccessSnackBar(context, state.message, state.actionType);
        } else if (state is TasksError) {
          // Hiển thị thông báo khi có lỗi
          _showErrorSnackBar(context, state.userFriendlyMessage);
        }
      },
      builder: (context, state) {
        // Sử dụng builder để cập nhật UI dựa trên state
        return Scaffold(
          body: _buildBody(),
          floatingActionButton: _buildFloatingActionButton(),
        );
      },
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message, ActionType actionType) {
    // Xác định icon dựa trên loại hành động
    IconData iconData;
    switch (actionType) {
      case ActionType.create:
        iconData = Icons.add_task_rounded;
        break;
      case ActionType.update:
        iconData = Icons.edit_note_rounded;
        break;
      case ActionType.delete:
        iconData = Icons.delete_outline_rounded;
        break;
      case ActionType.toggle:
        iconData = Icons.check_circle_outline_rounded;
        break;
      default:
        iconData = Icons.check_circle_outline_rounded;
    }

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            iconData,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.successLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.only(
        bottom: 20,
        left: 16,
        right: 16,
      ),
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.errorLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.only(
        bottom: 20,
        left: 16,
        right: 16,
      ),
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                letterSpacing: -0.3,
              ),
            ),
            floating: true,
            pinned: true,
            forceElevated: innerBoxIsScrolled,
            bottom: _buildTabBar(),
            backgroundColor: colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 2,
            shadowColor: colorScheme.shadow.withOpacity(0.05),
            toolbarHeight: 70,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.search_rounded,
                    color: colorScheme.onSurface,
                    size: 24,
                  ),
                  tooltip: 'Tìm kiếm nhiệm vụ',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        width: MediaQuery.of(context).size.width * 0.9,
                        content: Text(
                          'Tính năng tìm kiếm sẽ sớm ra mắt',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.filter_list_rounded,
                    color: colorScheme.onSurface,
                    size: 24,
                  ),
                  tooltip: 'Lọc nhiệm vụ',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        width: MediaQuery.of(context).size.width * 0.9,
                        content: Text(
                          'Tính năng lọc sẽ sớm ra mắt',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),
              ),
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
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      labelStyle: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        letterSpacing: 0.2,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0.1,
      ),
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: colorScheme.primary.withOpacity(0.1),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      indicatorPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      splashBorderRadius: BorderRadius.circular(50),
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
    // Lấy TasksBloc từ context
    final tasksBloc = context.read<TasksBloc>();

    return TabBarView(
      controller: _tabController,
      children: [
        TaskList(tasks: tasks, filter: null, tasksBloc: tasksBloc),
        TaskList(tasks: tasks, filter: 'active', tasksBloc: tasksBloc),
        TaskList(tasks: tasks, filter: 'completed', tasksBloc: tasksBloc),
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
          // Sử dụng Container để tạo hiệu ứng glow cho loading indicator
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                  // Thêm valueColor để tạo hiệu ứng animation màu sắc
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary.withOpacity(0.9),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Đang tải nhiệm vụ của bạn...',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withOpacity(0.8),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Vui lòng đợi trong giây lát',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface.withOpacity(0.6),
              height: 1.5,
              letterSpacing: 0.1,
            ),
            textAlign: TextAlign.center,
          ),
          // Thêm một animated container để tạo hiệu ứng loading dots
          const SizedBox(height: 24),
          _buildLoadingDots(),
        ],
      ),
    );
  }

  Widget _buildLoadingDots() {
    return SizedBox(
      width: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _LoadingDot(
              delay: Duration(milliseconds: index * 300),
            ),
          );
        }),
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
      backgroundColor: colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      label: Text(
        'Thêm nhiệm vụ',
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.2,
        ),
      ),
      icon: const Icon(Icons.add_rounded, size: 22),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    // Lấy TasksBloc từ context hiện tại
    final tasksBloc = context.read<TasksBloc>();

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
    ).then((_) {
      // Sau khi bottom sheet đóng, refresh dữ liệu để đảm bảo hiển thị dữ liệu mới nhất
      tasksBloc.add(FetchTasks());
    });
  }
}

// Widget hiệu ứng loading dots
class _LoadingDot extends StatefulWidget {
  final Duration delay;

  const _LoadingDot({
    Key? key,
    required this.delay,
  }) : super(key: key);

  @override
  State<_LoadingDot> createState() => _LoadingDotState();
}

class _LoadingDotState extends State<_LoadingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Delay the start of the animation
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.5 + (_animation.value * 0.5),
          child: Opacity(
            opacity: 0.4 + (_animation.value * 0.6),
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3 * _animation.value),
                    blurRadius: 6 * _animation.value,
                    spreadRadius: 1 * _animation.value,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}