import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/home_bloc.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String? userAvatar;
  final VoidCallback onNotificationTap;
  final VoidCallback onProfileTap;
  
  const HomeHeader({
    Key? key,
    required this.userName,
    this.userAvatar,
    required this.onNotificationTap,
    required this.onProfileTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingM,
        vertical: AppDimensions.spacingM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildUserInfo(context),
              _buildActions(context),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingL),
          _buildWelcomeMessage(context),
          const SizedBox(height: AppDimensions.spacingXL),
          _buildDateDisplay(context),
        ],
      ),
    );
  }
  
  Widget _buildUserInfo(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onProfileTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
            backgroundImage: userAvatar != null ? NetworkImage(userAvatar!) : null,
            child: userAvatar == null
                ? Icon(
                    Icons.person,
                    color: theme.colorScheme.primary,
                  )
                : null,
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Good day!',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: onNotificationTap,
        ),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }
  
  Widget _buildWelcomeMessage(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXS),
        Text(
          'Ready to be productive?',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildDateDisplay(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    
    // Get current date
    final now = DateTime.now();
    final today = '${_getDayName(now.weekday)}, ${now.day} ${_getMonthName(now.month)}';
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 18,
              color: colorScheme.primary,
            ),
            const SizedBox(width: AppDimensions.spacingXS),
            Text(
              today,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        AppButton(
          text: 'View Tasks',
          icon: const Icon(Icons.task_alt),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingS,
          ),
          onPressed: () {
            // Navigate to tasks page
          },
        ),
      ],
    );
  }
  
  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
  }
  
  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'January';
      case 2: return 'February';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'August';
      case 9: return 'September';
      case 10: return 'October';
      case 11: return 'November';
      case 12: return 'December';
      default: return '';
    }
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isDarkMode 
            ? AppColors.surfaceDark.withOpacity(0.8) 
            : AppColors.surfaceLight.withOpacity(0.8),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: isDarkMode 
              ? AppColors.dividerDark 
              : AppColors.dividerLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
            child: Icon(Icons.search),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm công việc, mục tiêu...',
                hintStyle: TextStyle(
                  color: isDarkMode 
                      ? AppColors.textTertiaryDark 
                      : AppColors.textTertiaryLight,
                  fontSize: 14,
        ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          AppButton(
            text: 'Tìm',
          onPressed: () {
              // TODO: Implement search functionality
            },
            type: AppButtonType.primary,
            size: AppButtonSize.small,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingXS,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          const SizedBox(width: AppDimensions.spacingS),
        ],
        ),
    );
  }
}
