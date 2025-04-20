import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  bool _isDarkMode = false;
  bool _isNotificationsEnabled = true;
  bool _isBiometricEnabled = true;
  double _textSize = 1.0;
  String _selectedLanguage = 'Tiếng Việt';
  String _selectedTheme = 'Hệ thống';
  late AnimationController _animationController;
  
  final List<String> _languages = ['English', 'Tiếng Việt', '中文', '日本語', 'Español'];
  final List<String> _themes = ['Sáng', 'Tối', 'Hệ thống'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
      if (value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
    // Xử lý logic thay đổi theme sau khi thay đổi
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cài đặt',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            _buildProfileSection(colorScheme, textTheme),
            const SizedBox(height: 24),
            _buildGeneralSettingsSection(colorScheme, textTheme),
            const SizedBox(height: 24),
            _buildAppearanceSection(colorScheme, textTheme),
            const SizedBox(height: 24),
            _buildSecuritySection(colorScheme, textTheme),
            const SizedBox(height: 24),
            _buildAdvancedSection(colorScheme, textTheme),
            const SizedBox(height: 24),
            _buildAboutSection(colorScheme, textTheme),
            const SizedBox(height: 32),
            _buildSignOutButton(colorScheme, textTheme),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nguyen Van A',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'nguyenvana@gmail.com',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: colorScheme.primary),
                  onPressed: () {
                    // Mở trang chỉnh sửa hồ sơ
                    _showFeatureComingSoon(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _showFeatureComingSoon(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upgrade, size: 18, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Nâng cấp lên Premium',
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettingsSection(ColorScheme colorScheme, TextTheme textTheme) {
    return _buildSettingsSection(
      title: 'Cài đặt chung',
      icon: Icons.tune,
      colorScheme: colorScheme,
      textTheme: textTheme,
      children: [
        _buildSettingsTile(
          icon: Icons.language,
          title: 'Ngôn ngữ',
          subtitle: _selectedLanguage,
          colorScheme: colorScheme,
          textTheme: textTheme,
          onTap: () => _showLanguageBottomSheet(context),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.notifications_outlined,
          title: 'Thông báo',
          subtitle: _isNotificationsEnabled ? 'Đã bật' : 'Đã tắt',
          colorScheme: colorScheme,
          textTheme: textTheme,
          trailing: Switch.adaptive(
            value: _isNotificationsEnabled,
            activeColor: colorScheme.primary,
            onChanged: (value) {
              setState(() {
                _isNotificationsEnabled = value;
              });
              // Xử lý thay đổi cài đặt thông báo
            },
          ),
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.volume_up_outlined,
          title: 'Âm thanh',
          colorScheme: colorScheme,
          textTheme: textTheme,
          onTap: () => _showFeatureComingSoon(context),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.cloud_sync_outlined,
          title: 'Đồng bộ hóa',
          subtitle: 'Đồng bộ dữ liệu trên tất cả thiết bị',
          colorScheme: colorScheme,
          textTheme: textTheme,
          onTap: () => _showFeatureComingSoon(context),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(ColorScheme colorScheme, TextTheme textTheme) {
    return _buildSettingsSection(
      title: 'Giao diện',
      icon: Icons.palette_outlined,
      colorScheme: colorScheme,
      textTheme: textTheme,
      children: [
        _buildSettingsTile(
          icon: Icons.dark_mode_outlined,
          title: 'Chế độ tối',
          colorScheme: colorScheme,
          textTheme: textTheme,
          trailing: Switch.adaptive(
            value: _isDarkMode,
            activeColor: colorScheme.primary,
            onChanged: _toggleDarkMode,
          ),
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.color_lens_outlined,
          title: 'Chủ đề',
          subtitle: _selectedTheme,
          colorScheme: colorScheme,
          textTheme: textTheme,
          onTap: () => _showThemeBottomSheet(context),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.text_fields,
          title: 'Kích thước chữ',
          colorScheme: colorScheme,
          textTheme: textTheme,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18),
                onPressed: () {
                  setState(() {
                    _textSize = (_textSize - 0.1).clamp(0.7, 1.3);
                  });
                  // Xử lý thay đổi kích thước chữ
                },
              ),
              Text(
                '${(_textSize * 100).toInt()}%',
                style: textTheme.bodyMedium,
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: () {
                  setState(() {
                    _textSize = (_textSize + 0.1).clamp(0.7, 1.3);
                  });
                  // Xử lý thay đổi kích thước chữ
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(ColorScheme colorScheme, TextTheme textTheme) {
    return _buildSettingsSection(
      title: 'Bảo mật',
      icon: Icons.security,
      colorScheme: colorScheme,
      textTheme: textTheme,
      children: [
        _buildSettingsTile(
          icon: Icons.lock_outlined,
          title: 'Đổi mật khẩu',
          colorScheme: colorScheme,
          textTheme: textTheme,
          onTap: () => _showFeatureComingSoon(context),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.fingerprint,
          title: 'Xác thực sinh trắc học',
          subtitle: 'Sử dụng vân tay hoặc khuôn mặt để mở khóa ứng dụng',
          colorScheme: colorScheme,
          textTheme: textTheme,
          trailing: Switch.adaptive(
            value: _isBiometricEnabled,
            activeColor: colorScheme.primary,
            onChanged: (value) {
              setState(() {
                _isBiometricEnabled = value;
              });
              // Xử lý thay đổi cài đặt xác thực sinh trắc học
            },
          ),
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: 'Quyền riêng tư',
          colorScheme: colorScheme,
          textTheme: textTheme,
          onTap: () => _showFeatureComingSoon(context),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ],
    );
  }

  Widget _buildAdvancedSection(ColorScheme colorScheme, TextTheme textTheme) {
    return _buildSettingsSection(
      title: 'Nâng cao',
      icon: Icons.settings_outlined,
      colorScheme: colorScheme,
      textTheme: textTheme,
      children: [
        _buildSettingsTile(
          icon: Icons.data_usage,
          title: 'Sử dụng dữ liệu',
          colorScheme: colorScheme,
          textTheme: textTheme,
          onTap: () => _showFeatureComingSoon(context),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.storage_outlined,
          title: 'Lưu trữ và bộ nhớ cache',
          colorScheme: colorScheme,
          textTheme: textTheme,
          onTap: () => _showFeatureComingSoon(context),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.cloud_download_outlined,
          title: 'Cập nhật ứng dụng',
          subtitle: 'Phiên bản: 1.0.0',
          colorScheme: colorScheme,
          textTheme: textTheme,
          onTap: () => _showFeatureComingSoon(context),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Mới nhất',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(ColorScheme colorScheme, TextTheme textTheme) {
    return _buildSettingsSection(
      title: 'Thông tin',
      icon: Icons.info_outline,
      colorScheme: colorScheme,
      textTheme: textTheme,
      children: [
        _buildSettingsTile(
          icon: Icons.help_outline,
          title: 'Trợ giúp & Hỗ trợ',
          colorScheme: colorScheme,
          textTheme: textTheme,
          onTap: () => _showFeatureComingSoon(context),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.description_outlined,
          title: 'Điều khoản dịch vụ',
          colorScheme: colorScheme,
          textTheme: textTheme,
          onTap: () => _showFeatureComingSoon(context),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: 'Chính sách bảo mật',
          colorScheme: colorScheme,
          textTheme: textTheme,
          onTap: () => _showFeatureComingSoon(context),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.info_outline,
          title: 'Về chúng tôi',
          colorScheme: colorScheme,
          textTheme: textTheme,
          onTap: () => _showFeatureComingSoon(context),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ],
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
    );
  }

  Widget _buildSignOutButton(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () {
          // Xử lý đăng xuất
          _showLogoutDialog(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.errorContainer.withOpacity(0.2),
          foregroundColor: colorScheme.error,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: colorScheme.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Đăng xuất',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chọn ngôn ngữ',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ...List.generate(
                _languages.length,
                (index) => RadioListTile<String>(
                  title: Text(_languages[index]),
                  value: _languages[index],
                  groupValue: _selectedLanguage,
                  activeColor: colorScheme.primary,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.pop(context);
                    // Xử lý thay đổi ngôn ngữ
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chọn chủ đề',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ...List.generate(
                _themes.length,
                (index) => RadioListTile<String>(
                  title: Text(_themes[index]),
                  value: _themes[index],
                  groupValue: _selectedTheme,
                  activeColor: colorScheme.primary,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedTheme = value!;
                      _isDarkMode = value == 'Tối';
                      if (_isDarkMode) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                      }
                    });
                    Navigator.pop(context);
                    // Xử lý thay đổi chủ đề
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Đăng xuất',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản không?',
          style: textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Hủy',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Xử lý đăng xuất
              Navigator.pop(context);
              _showFeatureComingSoon(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: Text(
              'Đăng xuất',
              style: textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFeatureComingSoon(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tính năng này sẽ sớm được cập nhật!',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
} 