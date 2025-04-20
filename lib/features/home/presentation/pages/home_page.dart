import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/domain/entities/user.dart';
import '../widgets/buttons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return AuthenticatedHomePage(user: state.user);
        } else {
          // Redirect to login page if not authenticated
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login');
          });
          // Return loading indicator while redirecting
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class AuthenticatedHomePage extends StatefulWidget {
  final User user;
  const AuthenticatedHomePage({super.key, required this.user});

  @override
  State<AuthenticatedHomePage> createState() => _AuthenticatedHomePageState();
}

class _AuthenticatedHomePageState extends State<AuthenticatedHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Add animation when switching tabs
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
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
        scrolledUnderElevation: 3,
        backgroundColor: colorScheme.background,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.tertiary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.auto_awesome, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'Musa',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {
                // Logout and navigate to login
                context.read<AuthBloc>().add(AuthLogoutEvent());
              },
              borderRadius: BorderRadius.circular(30),
              child: Ink(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.error, colorScheme.errorContainer],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.error.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.logout_rounded, size: 18, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
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
          indicatorColor: colorScheme.primaryContainer.withOpacity(0.7),
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          animationDuration: const Duration(milliseconds: 500),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: _selectedIndex == 0 ? colorScheme.primary : null),
              selectedIcon: Icon(Icons.home_rounded, color: colorScheme.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.task_outlined, color: _selectedIndex == 1 ? colorScheme.primary : null),
              selectedIcon: Icon(Icons.task_rounded, color: colorScheme.primary),
              label: 'Tasks',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, color: _selectedIndex == 2 ? colorScheme.primary : null),
              selectedIcon: Icon(Icons.settings_rounded, color: colorScheme.primary),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWelcomeBanner(User? user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade500, Colors.blue.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name?.isNotEmpty == true
                          ? 'Welcome back, ${user!.name!}'
                          : 'Welcome to Musa Assistant',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Ready to be more productive today?',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Transform.rotate(
                angle: -0.1,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.task_alt,
                    color: Colors.white,
                    size:
                        32,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  context.go('/tasks');
                },
                icon: const Icon(Icons.add_task),
                label: const Text('New Task'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue.shade700,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Show help or tutorial
                  _showHelpDialog();
                },
                icon: const Icon(Icons.help_outline, color: Colors.white70),
                label: const Text(
                  'Need Help?',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildHomeTab(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        // Welcome banner
        _buildWelcomeBanner(widget.user),
        
        // Available Features Section Title with animation
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Features',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              TextButton(
                onPressed: () {
                  _showFeatureSnackBar(context, 'View all features coming soon');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View all',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Features Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Featured Task Management with attractive design
              GestureDetector(
                onTap: () => setState(() => _selectedIndex = 1),
                child: Container(
                  width: double.infinity,
                  height: 140,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        // Background pattern
                        Positioned(
                          right: -20,
                          bottom: -20,
                          child: Icon(
                            Icons.task_alt_rounded,
                            size: 120,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Featured',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Task Management',
                                      style: textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Create, organize, and track your tasks with ease',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.task_alt_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Ripple effect overlay for touch feedback
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => setState(() => _selectedIndex = 1),
                            splashColor: Colors.white.withOpacity(0.1),
                            highlightColor: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Other features in an attractive grid
              Row(
                children: [
                  // Calendar Feature
                  Expanded(
                    child: _buildAnimatedFeatureTile(
                      context,
                      title: 'Calendar',
                      description: 'View your schedule',
                      icon: Icons.calendar_today_rounded,
                      color: Colors.orange,
                      isLocked: false,
                      onTap: () {
                        _showFeatureSnackBar(context, 'Calendar feature is coming soon');
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Reminders Feature
                  Expanded(
                    child: _buildAnimatedFeatureTile(
                      context,
                      title: 'Reminders',
                      description: 'Set notifications',
                      icon: Icons.notifications_active_rounded,
                      color: Colors.purple,
                      isLocked: false,
                      onTap: () {
                        _showFeatureSnackBar(context, 'Reminders feature is coming soon');
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  // Analytics Feature
                  Expanded(
                    child: _buildAnimatedFeatureTile(
                      context,
                      title: 'Analytics',
                      description: 'View your stats',
                      icon: Icons.bar_chart_rounded,
                      color: Colors.green,
                      isLocked: false,
                      onTap: () {
                        _showFeatureSnackBar(context, 'Analytics feature is coming soon');
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Notes Feature
                  Expanded(
                    child: _buildAnimatedFeatureTile(
                      context,
                      title: 'Notes',
                      description: 'Coming soon',
                      icon: Icons.note_alt_rounded,
                      color: Colors.teal,
                      isNew: true,
                      onTap: () {
                        _showFeatureSnackBar(context, 'Notes feature is coming soon');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Tips Section with improved design
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colorScheme.secondary.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.lightbulb_rounded,
                        color: colorScheme.secondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Pro Tips',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildTipItem(
                  context,
                  icon: Icons.swipe_rounded,
                  text: 'Swipe to mark tasks as complete',
                ),
                _buildTipItem(
                  context,
                  icon: Icons.dark_mode_rounded,
                  text: 'Dark mode available in settings',
                ),
                _buildTipItem(
                  context,
                  icon: Icons.notifications_rounded,
                  text: 'Enable notifications for reminders',
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),
        
        // Help & Support Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiaryContainer.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.help_outline_rounded,
                        color: colorScheme.tertiary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Need Help?',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'If you need assistance or have questions, our support team is here to help.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showFeatureSnackBar(context, 'Help center feature coming soon');
                        },
                        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                        label: const Text('Help Center'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showFeatureSnackBar(context, 'Documentation feature coming soon');
                        },
                        icon: const Icon(Icons.menu_book_rounded, size: 18),
                        label: const Text('Documentation'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primaryContainer,
                          foregroundColor: colorScheme.onPrimaryContainer,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
      ],
    );
  }
  
  Widget _buildAnimatedFeatureTile(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    bool isLocked = false,
    bool isNew = false,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 140,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      size: 20,
                    ),
                  ),
                  if (isLocked)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_outline_rounded,
                            color: Colors.grey.shade600,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Locked',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (isNew)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: colorScheme.tertiary,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'New',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
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
          Icon(
            icon,
            size: 16,
            color: colorScheme.secondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFeatureSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }
  
  Widget _buildTasksTab(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return Column(
      children: [
        // TabBar for Task Status
        Container(
          margin: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: colorScheme.onPrimary,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
            indicator: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            dividerColor: Colors.transparent,
            labelStyle: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: textTheme.labelLarge,
            tabs: const [
              Tab(text: 'Today'),
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
            ],
            splashBorderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.all(4),
            onTap: (index) {
              // Extra feedback
              HapticFeedback.lightImpact();
            },
          ),
        ),
        
        // Add Task Button
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: GestureDetector(
            onTap: () {
              _showAddTaskDialog(context);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.add_task_rounded,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Task',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Create a task to stay organized',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Task List
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 12,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTaskList(
                    context,
                    [
                      {'title': 'Check emails', 'done': false, 'time': '09:00 AM', 'priority': 'High'},
                      {'title': 'Team meeting', 'done': false, 'time': '10:30 AM', 'priority': 'Medium'},
                      {'title': 'Update documentation', 'done': false, 'time': '02:00 PM', 'priority': 'Low'},
                    ],
                  ),
                  _buildTaskList(
                    context,
                    [
                      {'title': 'Design review', 'done': false, 'time': 'Tomorrow', 'priority': 'High'},
                      {'title': 'Client meeting', 'done': false, 'time': 'Dec 10', 'priority': 'Medium'},
                    ],
                  ),
                  _buildTaskList(
                    context,
                    [
                      {'title': 'Create wireframes', 'done': true, 'time': 'Yesterday', 'priority': 'Medium'},
                      {'title': 'Research competitors', 'done': true, 'time': 'Dec 5', 'priority': 'Low'},
                      {'title': 'Set up project', 'done': true, 'time': 'Dec 3', 'priority': 'High'},
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTaskList(BuildContext context, List<Map<String, dynamic>> tasks) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    if (tasks.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.task_rounded,
        title: 'No tasks found',
        message: 'Add new tasks to get started',
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      itemCount: tasks.length + 1, // Extra item for the header
      itemBuilder: (context, index) {
        if (index == 0) {
          // Header
          return Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Tasks',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${tasks.length} tasks',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }
        
        final task = tasks[index - 1];
        return _buildTaskItem(
          context,
          title: task['title'],
          isDone: task['done'],
          time: task['time'],
          priority: task['priority'],
          onChanged: (bool? value) {
            // In a real app, update the task status in your state management
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Task "${task['title']}" marked as ${value! ? 'completed' : 'pending'}'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildTaskItem(
    BuildContext context, {
    required String title,
    required bool isDone,
    required String time,
    required String priority,
    ValueChanged<bool?>? onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Set priority color
    Color priorityColor;
    switch (priority) {
      case 'High':
        priorityColor = Colors.redAccent;
        break;
      case 'Medium':
        priorityColor = Colors.orangeAccent;
        break;
      case 'Low':
        priorityColor = Colors.greenAccent;
        break;
      default:
        priorityColor = colorScheme.primary;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // In a real app, show task details
          _showFeatureSnackBar(context, 'Task details feature coming soon');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              // Priority indicator
              Container(
                width: 4,
                height: 36,
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              // Checkbox
              GestureDetector(
                onTap: onChanged != null 
                    ? () => onChanged(!isDone) 
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isDone 
                        ? colorScheme.primary.withOpacity(0.9)
                        : colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDone 
                          ? colorScheme.primary
                          : colorScheme.outline.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: isDone 
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              // Task content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: isDone 
                            ? TextDecoration.lineThrough
                            : null,
                        color: isDone 
                            ? theme.colorScheme.onSurface.withOpacity(0.5)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Priority badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  priority,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: priorityColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showAddTaskDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add New Task',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  hintText: 'Enter task title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title_rounded),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'Enter task description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.notes_rounded),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.calendar_today_rounded, size: 18),
                      label: const Text('Set Date'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.priority_high_rounded, size: 18),
                      label: const Text('Priority'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Task added successfully'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add Task',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: colorScheme.primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                _showAddTaskDialog(context);
              },
              icon: const Icon(Icons.add_task_rounded, size: 18),
              label: const Text('Add Task'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSettingsTab(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        // Profile Header
        _buildSettingsHeader(widget.user),
        
        // Application Settings Section
        _buildSettingsSection(
          context,
          title: 'Application',
          icon: Icons.settings_rounded,
          items: [
            _buildSettingsItem(
              context,
              title: 'Appearance',
              icon: Icons.palette_rounded,
              subtitle: 'Dark mode, theme colors',
              onTap: () {
                _showFeatureSnackBar(context, 'Appearance settings coming soon');
              },
            ),
            _buildSettingsItem(
              context,
              title: 'Notifications',
              icon: Icons.notifications_rounded,
              subtitle: 'Configure alerts and reminders',
              onTap: () {
                _showFeatureSnackBar(context, 'Notification settings coming soon');
              },
            ),
            _buildSettingsItem(
              context,
              title: 'Language',
              icon: Icons.language_rounded,
              subtitle: 'English (US)',
              onTap: () {
                _showFeatureSnackBar(context, 'Language settings coming soon');
              },
            ),
          ],
        ),
        
        // Account Settings Section
        _buildSettingsSection(
          context,
          title: 'Account',
          icon: Icons.account_circle_rounded,
          items: [
            _buildSettingsItem(
              context,
              title: 'Privacy',
              icon: Icons.privacy_tip_rounded,
              subtitle: 'Manage your data and privacy settings',
              onTap: () {
                _showFeatureSnackBar(context, 'Privacy settings coming soon');
              },
            ),
            _buildSettingsItem(
              context,
              title: 'Security',
              icon: Icons.security_rounded,
              subtitle: 'Password, authentication',
              onTap: () {
                _showFeatureSnackBar(context, 'Security settings coming soon');
              },
            ),
            _buildSettingsItem(
              context,
              title: 'Sync',
              icon: Icons.sync_rounded,
              subtitle: 'Sync settings and data',
              onTap: () {
                _showFeatureSnackBar(context, 'Sync settings coming soon');
              },
            ),
          ],
        ),
        
        // About Section
        _buildSettingsSection(
          context,
          title: 'About',
          icon: Icons.info_rounded,
          items: [
            _buildSettingsItem(
              context,
              title: 'Help & Support',
              icon: Icons.help_outline_rounded,
              subtitle: 'Get assistance, FAQs, contact us',
              onTap: () {
                _showFeatureSnackBar(context, 'Help & Support coming soon');
              },
            ),
            _buildSettingsItem(
              context,
              title: 'Terms of Service',
              icon: Icons.description_rounded,
              subtitle: 'Legal documents',
              onTap: () {
                _showFeatureSnackBar(context, 'Terms of Service coming soon');
              },
            ),
            _buildSettingsItem(
              context,
              title: 'Version',
              icon: Icons.new_releases_rounded,
              subtitle: '1.0.0',
              onTap: () {
                _showFeatureSnackBar(context, 'You are using the latest version');
              },
            ),
          ],
        ),
        
        // Logout button
        Padding(
          padding: const EdgeInsets.fromLTRB(64, 32, 64, 32),
          child: ElevatedButton.icon(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutEvent());
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSettingsHeader(User? user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.3),
            child: user?.name?.isNotEmpty == true
                ? Text(
                    user!.name![0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name?.isNotEmpty == true ? user!.name! : 'User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email?.isNotEmpty == true ? user!.email! : 'Create an account to save your data',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (user == null || user.email?.isEmpty != false)
            ElevatedButton(
              onPressed: () {
                // Navigate to create account page
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue.shade700,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Create Account'),
            ),
        ],
      ),
    );
  }
  
  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        
        // Section items
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
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
    required IconData icon,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            trailing ?? Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.help_outline,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'How to Use Musa',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildHelpItem(
                  icon: Icons.task_alt,
                  title: 'Create Tasks',
                  description: 'Add new tasks to organize your day.',
                ),
                const SizedBox(height: 12),
                _buildHelpItem(
                  icon: Icons.check_circle,
                  title: 'Complete Tasks',
                  description: 'Mark tasks as done when completed.',
                ),
                const SizedBox(height: 12),
                _buildHelpItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  description: 'Customize app preferences in the Settings tab.',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Got it!'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.blue.shade700,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
