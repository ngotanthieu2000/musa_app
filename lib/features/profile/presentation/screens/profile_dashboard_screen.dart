import 'package:flutter/material.dart';
import '../widgets/profile_completion_widget.dart';
import '../widgets/profile_section_card.dart';

class ProfileDashboardScreen extends StatelessWidget {
  const ProfileDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data - in a real app, get this from a provider or bloc
    final completionPercentage = 45.0;
    final missingFields = [
      'Thông tin cá nhân',
      'Mục tiêu cá nhân',
      'Hồ sơ tài chính',
      'Hồ sơ học tập'
    ];

    final profileSections = [
      {
        'title': 'Hồ sơ cơ bản',
        'description': 'Thông tin cá nhân, liên hệ và địa chỉ',
        'icon': Icons.person,
        'color': Colors.blue,
        'isCompleted': true,
      },
      {
        'title': 'Tùy chọn hồ sơ',
        'description': 'Tùy chỉnh trải nghiệm người dùng',
        'icon': Icons.settings,
        'color': Colors.purple,
        'isCompleted': true,
      },
      {
        'title': 'Quản lý mục tiêu',
        'description': 'Thiết lập và theo dõi mục tiêu',
        'icon': Icons.flag,
        'color': Colors.orange,
        'isCompleted': false,
      },
      {
        'title': 'Quản lý tài chính',
        'description': 'Thu nhập, chi tiêu và mục tiêu tài chính',
        'icon': Icons.account_balance_wallet,
        'color': Colors.green,
        'isCompleted': false,
      },
      {
        'title': 'Hồ sơ học tập',
        'description': 'Sở thích học tập và kế hoạch phát triển',
        'icon': Icons.school,
        'color': Colors.amber,
        'isCompleted': false,
      },
      {
        'title': 'Quản lý năng lượng',
        'description': 'Theo dõi và tối ưu mức năng lượng',
        'icon': Icons.battery_charging_full,
        'color': Colors.red,
        'isCompleted': false,
      },
      {
        'title': 'Sức khỏe tinh thần',
        'description': 'Quản lý và cải thiện tâm trạng, stress',
        'icon': Icons.favorite,
        'color': Colors.pink,
        'isCompleted': false,
      },
      {
        'title': 'Hồ sơ xã hội',
        'description': 'Quản lý mối quan hệ và networking',
        'icon': Icons.people,
        'color': Colors.teal,
        'isCompleted': false,
      },
      {
        'title': 'Cá nhân hóa AI',
        'description': 'Tùy chỉnh AI trợ lý phù hợp với bạn',
        'icon': Icons.smart_toy,
        'color': Colors.indigo,
        'isCompleted': false,
      },
    ];

    return Scaffold(
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ProfileCompletionWidget(
              completionPercentage: completionPercentage,
              missingFields: missingFields,
              onCompleteProfile: () {
                // Navigate to profile completion guide
              },
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
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
              ),
              itemCount: profileSections.length,
              itemBuilder: (context, index) {
                final section = profileSections[index];
                return ProfileSectionCard(
                  title: section['title'] as String,
                  description: section['description'] as String,
                  icon: section['icon'] as IconData,
                  color: section['color'] as Color,
                  isCompleted: section['isCompleted'] as bool,
                  onTap: () {
                    // Navigate to the specific profile section
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 