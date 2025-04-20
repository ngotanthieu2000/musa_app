import 'package:flutter/material.dart';
import 'settings_button.dart';
import 'settings_screen.dart';

class SettingsButtonExamples extends StatelessWidget {
  const SettingsButtonExamples({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Các mẫu nút Cài đặt',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(
                'Nút Cài đặt cơ bản',
                colorScheme,
                textTheme,
              ),
              const SizedBox(height: 16),
              _buildExample(
                'Nút đầy đủ (Standard Button)',
                const SettingsButton(),
                colorScheme,
                textTheme,
              ),
              const SizedBox(height: 24),
              _buildExample(
                'Nút nhỏ gọn (Compact Button)',
                const SettingsButton(isCompact: true),
                colorScheme,
                textTheme,
              ),
              const SizedBox(height: 32),
              
              _buildSectionTitle(
                'Nút Cài đặt có hiệu ứng (Animated)',
                colorScheme,
                textTheme,
              ),
              const SizedBox(height: 16),
              _buildExample(
                'Nút đầy đủ có hiệu ứng',
                const AnimatedSettingsButton(),
                colorScheme,
                textTheme,
              ),
              const SizedBox(height: 24),
              _buildExample(
                'Nút nhỏ gọn có hiệu ứng',
                const AnimatedSettingsButton(isCompact: true),
                colorScheme,
                textTheme,
              ),
              const SizedBox(height: 32),
              
              _buildSectionTitle(
                'Nút Cài đặt nổi (Floating)',
                colorScheme,
                textTheme,
              ),
              const SizedBox(height: 16),
              _buildExample(
                'Nút nổi góc màn hình',
                const FloatingSettingsButton(),
                colorScheme,
                textTheme,
              ),
              const SizedBox(height: 32),
              
              _buildSectionTitle(
                'Ví dụ tích hợp',
                colorScheme,
                textTheme,
              ),
              const SizedBox(height: 16),
              _buildUsageExample(context, colorScheme, textTheme),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.primary,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
            ),
          );
        },
        child: const Icon(Icons.settings),
      ),
    );
  }
  
  Widget _buildSectionTitle(
    String title,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Divider(color: colorScheme.primary.withOpacity(0.2)),
      ],
    );
  }
  
  Widget _buildExample(
    String title,
    Widget example,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: Center(child: example),
        ),
      ],
    );
  }
  
  Widget _buildUsageExample(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tích hợp vào giao diện ứng dụng',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
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
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tài khoản của tôi',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const AnimatedSettingsButton(isCompact: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Vị trí nút nổi (góc dưới bên phải)',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    'Nội dung ứng dụng',
                    style: textTheme.bodyLarge,
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: const FloatingSettingsButton(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sử dụng trong profile hoặc drawer',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  title: Text(
                    'Nguyen Van A',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'nguyenvana@gmail.com',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const Divider(),
                const SettingsButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 