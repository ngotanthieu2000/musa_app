// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musa App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const TasksPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Musa App Demo'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Nhiệm vụ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cá nhân',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildFinanceSummary(context),
          const SizedBox(height: 24),
          _buildTaskList(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xin chào, Người dùng',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Chào mừng bạn quay lại!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceSummary(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng quan tài chính',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFinanceItem(context, 'Số dư', '5.000.000₫', Colors.blue),
                _buildFinanceItem(context, 'Thu nhập', '8.500.000₫', Colors.green),
                _buildFinanceItem(context, 'Chi tiêu', '3.500.000₫', Colors.red),
              ],
            ),
            const SizedBox(height: 16),
            const LinearProgressIndicator(
              value: 0.65,
              backgroundColor: Colors.grey,
              color: Colors.blue,
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              'Tiết kiệm: 65% mục tiêu đạt được',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceItem(BuildContext context, String title, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          amount,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nhiệm vụ hôm nay',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Xem tất cả'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildTaskItem(context, 'Họp nhóm dự án', '10:00 AM', true),
            const Divider(),
            _buildTaskItem(context, 'Gửi báo cáo tuần', '14:00 PM', false),
            const Divider(),
            _buildTaskItem(context, 'Tập thể dục', '18:00 PM', false),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, String title, String time, bool completed) {
    return Row(
      children: [
        Checkbox(
          value: completed,
          onChanged: (value) {},
        ),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              decoration: completed ? TextDecoration.lineThrough : null,
              color: completed ? Colors.grey : null,
            ),
          ),
        ),
        Text(
          time,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danh sách nhiệm vụ',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildTaskFilter(context),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildTaskItem(context, 'Họp nhóm dự án', 'Chuẩn bị tài liệu trước buổi họp', 'Công việc', true),
                _buildTaskItem(context, 'Gửi báo cáo tuần', 'Tổng hợp dữ liệu từ các bộ phận', 'Công việc', false),
                _buildTaskItem(context, 'Tập thể dục', 'Chạy bộ 5km', 'Sức khỏe', false),
                _buildTaskItem(context, 'Mua thực phẩm', 'Mua rau củ và thịt cho bữa tối', 'Mua sắm', false),
                _buildTaskItem(context, 'Học tiếng Anh', 'Hoàn thành bài tập Unit 5', 'Học tập', false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Thêm nhiệm vụ mới'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskFilter(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm nhiệm vụ',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.filter_list),
          tooltip: 'Lọc',
        ),
      ],
    );
  }

  Widget _buildTaskItem(BuildContext context, String title, String description, String category, bool completed) {
    Color categoryColor;
    IconData categoryIcon;
    
    switch (category.toLowerCase()) {
      case 'công việc':
        categoryColor = Colors.blue;
        categoryIcon = Icons.work;
        break;
      case 'sức khỏe':
        categoryColor = Colors.red;
        categoryIcon = Icons.favorite;
        break;
      case 'mua sắm':
        categoryColor = Colors.orange;
        categoryIcon = Icons.shopping_cart;
        break;
      case 'học tập':
        categoryColor = Colors.green;
        categoryIcon = Icons.school;
        break;
      default:
        categoryColor = Colors.grey;
        categoryIcon = Icons.circle;
    }
    
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            categoryIcon,
            color: categoryColor,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            decoration: completed ? TextDecoration.lineThrough : null,
            fontWeight: completed ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
        trailing: Checkbox(
          value: completed,
          onChanged: (value) {},
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: 24),
          _buildGoalsList(context),
          const SizedBox(height: 24),
          _buildSettings(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Người dùng',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'user@example.com',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatItem(context, '28', 'Nhiệm vụ'),
                _buildDivider(),
                _buildStatItem(context, '15', 'Đã hoàn thành'),
                _buildDivider(),
                _buildStatItem(context, '5', 'Mục tiêu'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _buildStatItem(BuildContext context, String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildGoalsList(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mục tiêu của bạn',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Thêm mục tiêu'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildGoalItem(
              context,
              'Tiết kiệm 10 triệu đồng',
              'Tài chính',
              0.65,
              Colors.blue,
              Icons.attach_money,
            ),
            const SizedBox(height: 12),
            _buildGoalItem(
              context,
              'Tập thể dục 3 lần/tuần',
              'Sức khỏe',
              0.33,
              Colors.red,
              Icons.favorite,
            ),
            const SizedBox(height: 12),
            _buildGoalItem(
              context,
              'Học tiếng Anh 30 phút/ngày',
              'Học tập',
              0.8,
              Colors.green,
              Icons.school,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem(
    BuildContext context,
    String title,
    String category,
    double progress,
    Color color,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.withOpacity(0.2),
          color: color,
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildSettings(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cài đặt',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(context, Icons.person, 'Chỉnh sửa hồ sơ'),
            const Divider(),
            _buildSettingItem(context, Icons.notifications, 'Thông báo'),
            const Divider(),
            _buildSettingItem(context, Icons.color_lens, 'Giao diện'),
            const Divider(),
            _buildSettingItem(context, Icons.language, 'Ngôn ngữ'),
            const Divider(),
            _buildSettingItem(context, Icons.security, 'Bảo mật'),
            const Divider(),
            _buildSettingItem(context, Icons.logout, 'Đăng xuất', isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, IconData icon, String title, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : null,
        ),
      ),
      trailing: isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}
