import 'package:flutter/material.dart';
import '../widgets/profile_completion_widget.dart';
import '../widgets/profile_section_card.dart';

class ProfileSectionsScreen extends StatelessWidget {
  const ProfileSectionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ của bạn'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileCompletionWidget(
                completionPercentage: 65.0,
                missingFields: ['Mục tiêu', 'Tài chính', 'Năng lượng'],
                onCompleteProfile: () {
                  // Xử lý khi người dùng nhấn nút hoàn thành hồ sơ
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Các phần hồ sơ',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  ProfileSectionCard(
                    title: 'Thông tin cơ bản',
                    description: 'Thông tin cá nhân, liên hệ và các thông tin cơ bản khác',
                    icon: Icons.person,
                    color: Colors.blue,
                    isCompleted: true,
                    onTap: () => _navigateToSection(context, 'basic'),
                  ),
                  ProfileSectionCard(
                    title: 'Tùy chọn cá nhân',
                    description: 'Sở thích, thói quen và các tùy chỉnh khác',
                    icon: Icons.settings,
                    color: Colors.purple,
                    isCompleted: false,
                    onTap: () => _navigateToSection(context, 'preferences'),
                  ),
                  ProfileSectionCard(
                    title: 'Mục tiêu',
                    description: 'Thiết lập và theo dõi các mục tiêu cá nhân',
                    icon: Icons.flag,
                    color: Colors.orange,
                    isCompleted: false,
                    onTap: () => _navigateToSection(context, 'goals'),
                  ),
                  ProfileSectionCard(
                    title: 'Tài chính',
                    description: 'Quản lý thu nhập, chi tiêu và các mục tiêu tài chính',
                    icon: Icons.account_balance_wallet,
                    color: Colors.green,
                    isCompleted: true,
                    onTap: () => _navigateToSection(context, 'financial'),
                  ),
                  ProfileSectionCard(
                    title: 'Học tập',
                    description: 'Quản lý mục tiêu học tập và theo dõi tiến độ',
                    icon: Icons.school,
                    color: Colors.amber,
                    isCompleted: false,
                    onTap: () => _navigateToSection(context, 'learning'),
                  ),
                  ProfileSectionCard(
                    title: 'Năng lượng',
                    description: 'Quản lý mức năng lượng và tiến độ cải thiện',
                    icon: Icons.bolt,
                    color: Colors.red,
                    isCompleted: false,
                    onTap: () => _navigateToSection(context, 'energy'),
                  ),
                  ProfileSectionCard(
                    title: 'Tinh thần',
                    description: 'Quản lý sức khỏe tinh thần và các hoạt động',
                    icon: Icons.spa,
                    color: Colors.teal,
                    isCompleted: true,
                    onTap: () => _navigateToSection(context, 'mental'),
                  ),
                  ProfileSectionCard(
                    title: 'Xã hội',
                    description: 'Quản lý các mối quan hệ và hoạt động xã hội',
                    icon: Icons.people,
                    color: Colors.indigo,
                    isCompleted: false,
                    onTap: () => _navigateToSection(context, 'social'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToSection(BuildContext context, String section) {
    // Điều hướng đến màn hình tương ứng dựa trên section
    // Có thể xử lý sau khi đã tạo các màn hình con
  }
} 