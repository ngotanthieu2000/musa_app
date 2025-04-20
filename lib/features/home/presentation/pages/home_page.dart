import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../widgets/buttons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const AuthenticatedHomePage();
        } else if (state is AuthGuestMode) {
          return const GuestHomePage();
        } else {
          return const UnauthenticatedHomePage();
        }
      },
    );
  }
}

class GuestHomePage extends StatefulWidget {
  const GuestHomePage({super.key});

  @override
  State<GuestHomePage> createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.background,
        title: Row(
          children: [
            Icon(Icons.api_rounded, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Musa',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {
                debugPrint('Sign In button tapped (top-right corner)');
                // Exit guest mode and directly navigate to login
                context.read<AuthBloc>().add(AuthExitGuestModeEvent());
                context.go('/login');
              },
              borderRadius: BorderRadius.circular(30),
              child: Ink(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.primaryContainer],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.login, size: 18, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Sign In',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Main content
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildHomeTab(context),
                _buildTasksTab(context),
                _buildSettingsTab(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          onDestinationSelected: _onNavItemTapped,
          selectedIndex: _selectedIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.task_outlined),
              selectedIcon: Icon(Icons.task),
              label: 'Tasks',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHomeTab(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Welcome Banner
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primary.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Musa',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You\'re in guest mode with limited features',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                text: "Create account",
                onPressed: () {
                  context.read<AuthBloc>().add(
                    AuthExitGuestModeEvent(),
                  );
                  context.go('/register');
                },
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Section Title
        Row(
          children: [
            Text(
              'Available Features',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                showUpgradeDialog(context);
              },
              child: const Text('View All'),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Feature Tiles
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildFeatureTile(
              context,
              title: 'Tasks',
              description: 'Basic task tracking',
              icon: Icons.task_alt,
              color: Colors.blue,
              isLocked: false,
              onTap: () => setState(() => _selectedIndex = 1),
            ),
            _buildFeatureTile(
              context,
              title: 'Calendar',
              description: 'View your schedule',
              icon: Icons.calendar_today,
              color: Colors.orange,
              isLocked: false,
              onTap: () {
                _showFeatureSnackBar(context, 'Calendar feature is coming soon');
              },
            ),
            _buildFeatureTile(
              context,
              title: 'Reminders',
              description: 'Premium feature',
              icon: Icons.alarm,
              color: Colors.purple,
              isLocked: true,
              onTap: () {
                showUpgradeDialog(context);
              },
            ),
            _buildFeatureTile(
              context,
              title: 'Analytics',
              description: 'Premium feature',
              icon: Icons.bar_chart,
              color: Colors.green,
              isLocked: true,
              onTap: () {
                showUpgradeDialog(context);
              },
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Tips Section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Tips',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildTipItem(
                context,
                icon: Icons.lightbulb_outline,
                text: 'Swipe to mark tasks as complete',
              ),
              _buildTipItem(
                context,
                icon: Icons.dark_mode,
                text: 'Dark mode available in settings',
              ),
              _buildTipItem(
                context,
                icon: Icons.login,
                text: 'Sign in to sync across devices',
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildTasksTab(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    return Column(
      children: [
        // Tab Bar
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(30),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: colorScheme.onSurface,
            labelStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            indicator: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(30),
            ),
            tabs: const [
              Tab(text: 'Today'),
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        
        // Task List
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTaskList(
                context,
                [
                  {'title': 'Check emails', 'done': false},
                  {'title': 'Team meeting', 'done': false},
                  {'title': 'Update documentation', 'done': false},
                ],
              ),
              _buildEmptyState(
                context,
                icon: Icons.event,
                title: 'No upcoming tasks',
                message: 'Add new tasks or sign in to see your upcoming schedule',
              ),
              _buildEmptyState(
                context,
                icon: Icons.check_circle_outline,
                title: 'No completed tasks',
                message: 'Tasks you complete will appear here',
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildSettingsTab(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Settings',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        
        // App Settings
        _buildSettingsSection(
          context,
          title: 'Application',
          items: [
            _buildSettingsItem(
              context,
              title: 'Theme',
              subtitle: 'Light/Dark mode',
              icon: Icons.brightness_6,
              onTap: () {
                _showFeatureSnackBar(context, 'Theme settings are available in guest mode');
              },
            ),
            _buildSettingsItem(
              context,
              title: 'Notifications',
              subtitle: 'Manage alerts (Premium)',
              icon: Icons.notifications,
              isPremium: true,
              onTap: () {
                showUpgradeDialog(context);
              },
            ),
            _buildSettingsItem(
              context,
              title: 'Language',
              subtitle: 'Choose your language',
              icon: Icons.language,
              onTap: () {
                _showFeatureSnackBar(context, 'Language settings are available in guest mode');
              },
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Account Settings
        _buildSettingsSection(
          context,
          title: 'Account',
          items: [
            _buildSettingsItem(
              context,
              title: 'Create New Account',
              subtitle: 'Register to sync data across devices',
              icon: Icons.person_add,
              onTap: () {
                debugPrint('Create Account settings item tapped - Going to Register page');
                // Exit guest mode before navigating
                context.read<AuthBloc>().add(AuthExitGuestModeEvent());
                // Navigate to login page
                Future.delayed(const Duration(milliseconds: 100), () {
                  context.go('/login');
                });
              },
            ),
            _buildSettingsItem(
              context,
              title: 'Data Backup',
              subtitle: 'Backup your data (Premium)',
              icon: Icons.backup,
              isPremium: true,
              onTap: () {
                showUpgradeDialog(context);
              },
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // About
        _buildSettingsSection(
          context,
          title: 'About',
          items: [
            _buildSettingsItem(
              context,
              title: 'Version',
              subtitle: 'v1.0.0',
              icon: Icons.info,
              onTap: () {
                _showFeatureSnackBar(context, 'Version information is available in guest mode');
              },
            ),
            _buildSettingsItem(
              context,
              title: 'Help & Support',
              subtitle: 'Get assistance',
              icon: Icons.help,
              onTap: () {
                _showFeatureSnackBar(context, 'Help & Support is available in guest mode');
              },
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildFeatureTile(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool isLocked,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isLocked ? Colors.grey.withOpacity(0.1) : color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: isLocked ? Colors.grey : color,
                      size: 24,
                    ),
                  ),
                  if (isLocked)
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                      size: 16,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isLocked ? Colors.grey : null,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: textTheme.bodySmall?.copyWith(
                  color: isLocked ? Colors.grey : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTipItem(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: colorScheme.secondary,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTaskList(BuildContext context, List<Map<String, dynamic>> tasks) {
    if (tasks.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.task,
        title: 'No tasks for today',
        message: 'Add new tasks to get started',
      );
    }
    
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: tasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskItem(
          context,
          title: task['title'],
          isDone: task['done'],
          onChanged: null, // Login required to change status
        );
      },
    );
  }
  
  Widget _buildTaskItem(
    BuildContext context, {
    required String title,
    required bool isDone,
    ValueChanged<bool>? onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDone ? colorScheme.primary : colorScheme.outline,
              width: 2,
            ),
            color: isDone ? colorScheme.primary.withOpacity(0.1) : Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: isDone
                ? Icon(Icons.check, size: 16, color: colorScheme.primary)
                : const SizedBox(width: 16, height: 16),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            decoration: isDone ? TextDecoration.lineThrough : null,
            color: isDone ? colorScheme.onSurface.withOpacity(0.7) : colorScheme.onSurface,
          ),
        ),
        trailing: onChanged != null
            ? Checkbox(
                value: isDone,
                onChanged: (value) => onChanged(value!),
                activeColor: colorScheme.primary,
              )
            : IconButton(
                icon: const Icon(Icons.lock),
                onPressed: () {
                  showUpgradeDialog(context);
                },
                tooltip: 'Sign in to modify tasks',
              ),
      ),
    );
  }
  
  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: colorScheme.outline.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                debugPrint('Sign In button tapped in EmptyState');
                // Exit guest mode and navigate to login
                context.read<AuthBloc>().add(AuthExitGuestModeEvent());
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
  
  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    bool isPremium = false,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Xác định màu nổi bật cho nút Create Account
    final Color itemColor = title == 'Create New Account' 
        ? colorScheme.primary 
        : (isPremium ? colorScheme.tertiary : colorScheme.primary);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Log hành động cho việc gỡ lỗi
          debugPrint('Settings item tapped: $title');
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isPremium 
                      ? colorScheme.tertiaryContainer.withOpacity(0.5)
                      : colorScheme.primaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: itemColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        // Làm nổi bật chữ cho Create Account
                        color: title == 'Create New Account' ? colorScheme.primary : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (isPremium)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.lock,
                    color: colorScheme.tertiary,
                    size: 16,
                  ),
                ),
              // Thêm icon đặc biệt cho Create Account
              if (title == 'Create New Account')
                Icon(Icons.arrow_forward, color: colorScheme.primary)
              else
                const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showFeatureSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
  
  void showUpgradeDialog(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.star, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text('Premium Feature'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This feature requires a full account.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Benefits of signing up:',
              style: textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            _buildBenefitItem(context, 'Sync across all devices'),
            _buildBenefitItem(context, 'Advanced task management'),
            _buildBenefitItem(context, 'Reminders and notifications'),
            _buildBenefitItem(context, 'Data backup and restore'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              debugPrint('Sign In button tapped in UpgradeDialog');
              Navigator.pop(context);
              // Exit guest mode and navigate to login
              context.read<AuthBloc>().add(AuthExitGuestModeEvent());
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            child: const Text('Sign In'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
  
  Widget _buildBenefitItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

// Temporary Login page implementation for direct navigation
class LoginRoute extends StatelessWidget {
  const LoginRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.login, size: 80),
              const SizedBox(height: 32),
              Text(
                'Sign In',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Sign in to access all features and sync your data across devices',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Redirect to the real login page
                  context.go('/login');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Keep original classes for authenticated and unauthenticated pages
class AuthenticatedHomePage extends StatelessWidget {
  const AuthenticatedHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: SafeArea(
                child: CustomScrollView(
                  slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
                      pinned: true,
              elevation: 0,
              backgroundColor: theme.scaffoldBackgroundColor,
              title: Row(
                children: [
                  Icon(
                    Icons.assistant_rounded,
                    color: theme.colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Musa App',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                _buildProfileAvatar(context),
              ],
            ),
            
            // Main Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Header
                    _buildWelcomeHeader(context),
                    
                    // Stats Overview
                    _buildStatsOverview(context),
                    
                    // Dashboard Title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 32, 8, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dashboard',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Coming soon')),
                              );
                            },
                            icon: const Icon(Icons.tune, size: 18),
                            label: const Text('Customize'),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Feature Cards
                    _buildFeatureCards(context),
                    
                    // Recent Activity
                    _buildRecentActivity(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add new task')),
          );
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildProfileAvatar(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(0, 56),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      icon: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Row(
            children: [
              Icon(Icons.person_outline),
              SizedBox(width: 12),
              Text('Profile'),
            ],
          ),
          onTap: () {
            // Handle profile tap
          },
        ),
        PopupMenuItem(
          child: const Row(
            children: [
              Icon(Icons.settings_outlined),
              SizedBox(width: 12),
              Text('Settings'),
            ],
          ),
          onTap: () {
            // Handle settings tap
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 12),
              Text(
                'Sign Out',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
          onTap: () {
            Future.delayed(
              const Duration(milliseconds: 200),
              () => context.read<AuthBloc>().add(AuthLogoutEvent()),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildWelcomeHeader(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    String greeting;
    
    if (now.hour < 12) {
      greeting = 'Good Morning';
    } else if (now.hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }
    
    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome back, User!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You have 3 tasks remaining today',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.go('/tasks');
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('View Tasks'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.task_alt,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatsOverview(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        children: [
          _buildStatCard(
            context,
            icon: Icons.check_circle,
            iconColor: Colors.green,
            title: '12',
            subtitle: 'Completed',
          ),
          _buildStatCard(
            context,
            icon: Icons.pending_actions,
            iconColor: Colors.orange,
            title: '5',
            subtitle: 'In Progress',
          ),
          _buildStatCard(
            context,
            icon: Icons.calendar_today,
            iconColor: Colors.blue,
            title: '3',
            subtitle: 'Upcoming',
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Card(
        elevation: 0,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Column(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFeatureCards(BuildContext context) {
    final features = [
      {
        'icon': Icons.task_alt,
        'color': Colors.blue,
        'label': 'Tasks',
        'route': '/tasks'
      },
      {
        'icon': Icons.calendar_today,
        'color': Colors.orange,
        'label': 'Calendar',
        'route': '/calendar'
      },
      {
        'icon': Icons.notifications,
        'color': Colors.purple,
        'label': 'Reminders',
        'route': '/reminders'
      },
      {
        'icon': Icons.analytics,
        'color': Colors.green,
        'label': 'Analytics',
        'route': '/analytics'
      },
    ];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.3,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return _buildFeatureCard(
          context,
          icon: features[index]['icon'] as IconData,
          color: features[index]['color'] as Color,
          label: features[index]['label'] as String,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${features[index]['label']} coming soon')),
            );
          },
        );
      },
    );
  }
  
  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildRecentActivity(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 32, 8, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('View all coming soon')),
                  );
                },
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        _buildActivityItem(
          context,
          title: 'Project Review Meeting',
          description: 'Scheduled for 2:00 PM',
          icon: Icons.calendar_today,
          color: Colors.blue,
          time: '1 hour ago',
        ),
        _buildActivityItem(
          context,
          title: 'UI Design Task Completed',
          description: 'You completed a task',
          icon: Icons.check_circle,
          color: Colors.green,
          time: '3 hours ago',
        ),
        _buildActivityItem(
          context,
          title: 'New Task Assigned',
          description: 'Backend Implementation',
          icon: Icons.assignment,
          color: Colors.orange,
          time: 'Yesterday',
        ),
      ],
    );
  }
  
  Widget _buildActivityItem(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String time,
  }) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomNavigationBar(BuildContext context) {
    final theme = Theme.of(context);
    
    return NavigationBar(
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.task_outlined),
          selectedIcon: Icon(Icons.task),
          label: 'Tasks',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_today_outlined),
          selectedIcon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedIndex: 0,
      onDestinationSelected: (index) {
        if (index != 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(index == 3 
                ? 'Settings available in guest mode'
                : '${['Home', 'Tasks', 'Calendar', 'Settings'][index]} (Limited in guest mode)'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }
}

class UnauthenticatedHomePage extends StatelessWidget {
  const UnauthenticatedHomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Musa App'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.login),
            label: const Text('Sign In'),
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.assistant_rounded,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Musa App',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Smart Task Management Assistant',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            Text(
              'Key Features',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              context,
              icon: Icons.task_alt,
              title: 'Task Management',
              description: 'Create and track your daily tasks with ease',
            ),
            _buildFeatureItem(
              context,
              icon: Icons.calendar_today,
              title: 'Smart Calendar',
              description: 'Schedule events with automatic reminders',
            ),
            _buildFeatureItem(
              context,
              icon: Icons.analytics,
              title: 'Reports & Analytics',
              description: 'View reports on your productivity over time',
            ),
            const SizedBox(height: 48),
            Center(
              child: Column(
                children: [
                  PrimaryButton(
                    text: "Sign In",
                    onPressed: () {
                      debugPrint('Sign In button tapped');
                      context.go('/login');
                    },
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    text: "Create Account",
                    onPressed: () {
                      debugPrint('Create Account button tapped');
                      context.go('/register');
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sign in for full access to all features',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
