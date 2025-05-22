import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/responsive_size.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_section_card.dart';
import '../widgets/profile_completion_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with WidgetsBindingObserver {
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Tải profile khi khởi tạo
    _loadProfileData();
  }

  void _loadProfileData() {
    print('DEBUG: Loading profile data in ProfilePage');
    context.read<ProfileBloc>().add(const GetProfileEvent());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Tải lại profile khi ứng dụng trở lại foreground
      print('DEBUG: App resumed, reloading profile');
      _loadProfileData();
    }
  }

  // Đảm bảo tải lại dữ liệu khi quay lại từ các trang khác
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Chỉ gọi khi không phải lần tải đầu tiên (đã xử lý ở initState)
    if (!_isInitialLoad) {
      final route = ModalRoute.of(context);
      if (route != null && route.isCurrent) {
        // Trang profile đang active, tải lại dữ liệu
        print('DEBUG: ProfilePage became active again, reloading data');
        _loadProfileData();
      }
    } else {
      _isInitialLoad = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MusaAppBar(
        title: 'Hồ sơ của tôi',
        actions: [
          IconButton(
            onPressed: () => _navigateToEditProfile(context),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProfileBloc>().add(const GetProfileEvent());
        },
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            // Xử lý các trạng thái cần phản hồi
            if (state is ProfileActionSuccess) {
              // Khi nhận được thông báo thành công, hiển thị thông báo
              print('DEBUG: Received ProfileActionSuccess in ProfilePage');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );

              // Không cần gọi GetProfileEvent vì đã được xử lý trong Bloc
            } else if (state is ProfileLoaded) {
              // Khi nhận được dữ liệu profile mới, in ra để debug
              print('DEBUG: Received ProfileLoaded in ProfilePage');
              print('DEBUG: Profile data: ${state.profile}');
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Lỗi: ${state.message}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(const GetProfileEvent());
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileLoaded) {
              final user = state.user;
              final completionPercentage = state.completionPercentage;
              final missingFields = state.missingFields;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Avatar và thông tin cơ bản
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          backgroundImage: user.avatar != null
                              ? NetworkImage(user.avatar!)
                              : null,
                          child: user.avatar == null
                              ? Text(
                                  _getInitials(user.name ?? user.email ?? ''),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name ?? 'Chưa cập nhật tên',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.email ?? 'Chưa có email',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                onPressed: () => _navigateToEditProfile(context),
                                icon: const Icon(Icons.edit, size: 16),
                                label: const Text('Chỉnh sửa hồ sơ'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  backgroundColor: AppColors.primary.withOpacity(0.1),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Profile Completion Widget
                    ProfileCompletionWidget(
                      completionPercentage: completionPercentage,
                      missingFields: missingFields,
                      onCompleteProfile: () => _navigateToEditProfile(context),
                    ),

                    const SizedBox(height: 32),

                    // Các phân hệ tính năng
                    const Text(
                      'Tính năng cá nhân hóa',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Grid các tính năng
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                        ProfileSectionCard(
                          icon: Icons.flag_outlined,
                          title: 'Mục tiêu',
                          description: 'Thiết lập & theo dõi mục tiêu',
                          color: Colors.indigo,
                          isCompleted: false,
                          onTap: () => context.push('/goals'),
                        ),
                        ProfileSectionCard(
                          icon: Icons.account_balance_wallet_outlined,
                          title: 'Tài chính',
                          description: 'Quản lý thu nhập & chi tiêu',
                          color: Colors.green,
                          isCompleted: true,
                          onTap: () => context.push('/finance'),
                        ),
                        ProfileSectionCard(
                          icon: Icons.school_outlined,
                          title: 'Học tập',
                          description: 'Kỹ năng & khóa học',
                          color: Colors.amber,
                          isCompleted: false,
                          onTap: () => context.push('/learning'),
                        ),
                        ProfileSectionCard(
                          icon: Icons.bolt_outlined,
                          title: 'Hoạt động',
                          description: 'Theo dõi sức khỏe & hoạt động',
                          color: Colors.deepOrange,
                          isCompleted: false,
                          onTap: () => context.push('/activities'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            // Trạng thái mặc định khi không có dữ liệu
            return const Center(
              child: Text('Không có dữ liệu hồ sơ.'),
            );
          },
        ),
      ),
    );
  }

  // Hàm điều hướng đến trang chỉnh sửa hồ sơ
  void _navigateToEditProfile(BuildContext context) {
    try {
      // Sử dụng tên route thay vì đường dẫn trực tiếp
      context.goNamed('profile-edit');
    } catch (e) {
      print('Lỗi điều hướng: $e');
      // Nếu không tìm thấy route với tên, thử lại với path
      context.push('/profile/edit');
    }
  }

  // Lấy chữ cái đầu tiên từ tên
  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final names = name.split(' ');
    if (names.length > 1) {
      return '${names.first[0]}${names.last[0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}