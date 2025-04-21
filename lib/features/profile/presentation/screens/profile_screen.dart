import 'package:flutter/material.dart';
import '../widgets/profile_completion_widget.dart';
import '../widgets/profile_section_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final double _completionPercentage = 70.0;
  final List<String> _missingFields = [
    'Ảnh đại diện',
    'Thông tin liên hệ khẩn cấp',
    'Mục tiêu cá nhân'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Hồ sơ của tôi'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileCompletionWidget(
                completionPercentage: _completionPercentage,
                missingFields: _missingFields,
                onCompleteProfile: _completeProfile,
              ),
              const SizedBox(height: 24),
              const Text(
                'Các phần hồ sơ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ProfileSectionCard(
                    title: 'Thông tin cơ bản',
                    description: 'Cập nhật thông tin cá nhân của bạn',
                    icon: Icons.person,
                    color: Colors.blue,
                    isCompleted: true,
                    onTap: () => _navigateToSection('basic'),
                  ),
                  ProfileSectionCard(
                    title: 'Tùy chọn hồ sơ',
                    description: 'Thiết lập các tùy chọn và sở thích',
                    icon: Icons.settings,
                    color: Colors.purple,
                    isCompleted: false,
                    onTap: () => _navigateToSection('preferences'),
                  ),
                  ProfileSectionCard(
                    title: 'Mục tiêu',
                    description: 'Quản lý mục tiêu cá nhân và nghề nghiệp',
                    icon: Icons.flag,
                    color: Colors.orange,
                    isCompleted: false,
                    onTap: () => _navigateToSection('goals'),
                  ),
                  ProfileSectionCard(
                    title: 'Tài chính',
                    description: 'Thiết lập mục tiêu và quản lý tài chính',
                    icon: Icons.account_balance_wallet,
                    color: Colors.green,
                    isCompleted: true,
                    onTap: () => _navigateToSection('financial'),
                  ),
                  ProfileSectionCard(
                    title: 'Học tập',
                    description: 'Sở thích và mục tiêu học tập cá nhân',
                    icon: Icons.school,
                    color: Colors.red,
                    isCompleted: false,
                    onTap: () => _navigateToSection('learning'),
                  ),
                  ProfileSectionCard(
                    title: 'Năng lượng',
                    description: 'Quản lý thói quen và năng lượng hàng ngày',
                    icon: Icons.battery_charging_full,
                    color: Colors.teal,
                    isCompleted: false,
                    onTap: () => _navigateToSection('energy'),
                  ),
                  ProfileSectionCard(
                    title: 'Sức khỏe tinh thần',
                    description: 'Theo dõi và cải thiện sức khỏe tinh thần',
                    icon: Icons.psychology,
                    color: Colors.indigo,
                    isCompleted: true,
                    onTap: () => _navigateToSection('mental'),
                  ),
                  ProfileSectionCard(
                    title: 'Xã hội',
                    description: 'Quản lý kết nối và quan hệ xã hội',
                    icon: Icons.people,
                    color: Colors.amber,
                    isCompleted: false,
                    onTap: () => _navigateToSection('social'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.smart_toy,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tùy chỉnh AI',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Cấu hình AI để phù hợp với nhu cầu cá nhân của bạn',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: () => _navigateToSection('ai'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _completeProfile() {
    // Logic để hoàn thành hồ sơ
    print('Completing profile...');
  }

  void _navigateToSection(String section) {
    // Điều hướng đến phần tương ứng
    print('Navigating to $section section...');
  }
} 