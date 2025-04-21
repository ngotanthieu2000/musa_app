import 'package:flutter/material.dart';
import 'package:musa_app/features/profile/presentation/widgets/profile_completion_widget.dart';
import 'package:musa_app/features/profile/presentation/widgets/profile_section_card.dart';

class ProfileDashboardPage extends StatelessWidget {
  const ProfileDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data - Replace with actual data from API or providers
    final completionPercentage = 65.0;
    final missingFields = ['Mục tiêu cá nhân', 'Thông tin tài chính', 'Sở thích'];
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Hồ sơ của tôi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile info section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Text(
                      'NH',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nguyễn Hoàng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'nguyenhoang@example.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () {
                            // Navigate to edit profile
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Chỉnh sửa hồ sơ'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Profile completion section
            ProfileCompletionWidget(
              completionPercentage: completionPercentage,
              missingFields: missingFields,
              onCompleteProfile: () {
                // Handle complete profile action
              },
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Mục Hồ Sơ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Profile sections grid
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                ProfileSectionCard(
                  title: 'Thông tin cơ bản',
                  description: 'Thông tin cá nhân, liên hệ và dữ liệu cơ bản',
                  icon: Icons.person_outline,
                  color: Colors.blue,
                  isCompleted: true,
                  onTap: () {
                    // Navigate to basic profile
                  },
                ),
                ProfileSectionCard(
                  title: 'Tùy chọn hồ sơ',
                  description: 'Cài đặt và tùy chọn nâng cao cho hồ sơ',
                  icon: Icons.tune,
                  color: Colors.purple,
                  isCompleted: false,
                  onTap: () {
                    // Navigate to profile preferences
                  },
                ),
                ProfileSectionCard(
                  title: 'Mục tiêu cá nhân',
                  description: 'Quản lý các mục tiêu và kế hoạch cá nhân',
                  icon: Icons.flag_outlined,
                  color: Colors.orange,
                  isCompleted: false,
                  onTap: () {
                    // Navigate to goals management
                  },
                ),
                ProfileSectionCard(
                  title: 'Tài chính',
                  description: 'Quản lý tài chính và ngân sách cá nhân',
                  icon: Icons.account_balance_wallet_outlined,
                  color: Colors.green,
                  isCompleted: false,
                  onTap: () {
                    // Navigate to financial management
                  },
                ),
                ProfileSectionCard(
                  title: 'Học tập',
                  description: 'Hồ sơ và sở thích học tập',
                  icon: Icons.school_outlined,
                  color: Colors.brown,
                  isCompleted: true,
                  onTap: () {
                    // Navigate to learning profile
                  },
                ),
                ProfileSectionCard(
                  title: 'Năng lượng',
                  description: 'Quản lý năng lượng và sức khỏe thể chất',
                  icon: Icons.bolt_outlined,
                  color: Colors.red,
                  isCompleted: false,
                  onTap: () {
                    // Navigate to energy management
                  },
                ),
                ProfileSectionCard(
                  title: 'Sức khỏe tinh thần',
                  description: 'Quản lý sức khỏe tinh thần và cảm xúc',
                  icon: Icons.spa_outlined,
                  color: Colors.teal,
                  isCompleted: false,
                  onTap: () {
                    // Navigate to mental wellbeing
                  },
                ),
                ProfileSectionCard(
                  title: 'Mạng xã hội',
                  description: 'Quản lý hồ sơ xã hội và kết nối',
                  icon: Icons.people_outline,
                  color: Colors.indigo,
                  isCompleted: true,
                  onTap: () {
                    // Navigate to social profile
                  },
                ),
                ProfileSectionCard(
                  title: 'Cá nhân hóa AI',
                  description: 'Cài đặt cá nhân hóa trí tuệ nhân tạo',
                  icon: Icons.auto_awesome_outlined,
                  color: Colors.deepPurple,
                  isCompleted: false,
                  onTap: () {
                    // Navigate to AI personalization
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 