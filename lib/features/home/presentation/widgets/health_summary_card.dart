// health_summary_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../bloc/home_bloc.dart';

class HealthSummaryCard extends StatelessWidget {
  const HealthSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        // Default health data
        Map<String, dynamic> healthData = {
          'steps': 6548,
          'target_steps': 10000,
          'calories': 1250,
          'water': 1.5,
          'sleep': 7.2,
        };
        
        // Get health data from state if available
        if (state is HomeLoaded && state.homeData.healthData != null) {
          healthData = state.homeData.healthData!;
        }
        
        return AppCard(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.spacingS),
                    decoration: BoxDecoration(
                      color: isDarkMode 
                          ? AppColors.successDark.withOpacity(0.2) 
                          : AppColors.successLight.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: isDarkMode 
                          ? AppColors.successDark 
                          : AppColors.successLight,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: Text(
                      'Sức khỏe của bạn',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      // TODO: Show more health info
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingL),
              Row(
                children: [
                  Expanded(
                    child: _buildProgressCircle(
                      context,
                      healthData['steps'],
                      healthData['target_steps'],
                      label: 'Bước chân',
                      color: isDarkMode 
                          ? AppColors.primaryDark 
                          : AppColors.primaryLight,
                      icon: Icons.directions_walk,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      Icons.local_fire_department,
                      '${healthData['calories']} Calo',
                      'Đã đốt cháy',
                      color: isDarkMode 
                          ? AppColors.warningDark 
                          : AppColors.warningLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingL),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      Icons.water_drop,
                      '${healthData['water']} L',
                      'Nước đã uống',
                      color: isDarkMode 
                          ? AppColors.infoDark 
                          : AppColors.infoLight,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      Icons.nightlight,
                      '${healthData['sleep']} giờ',
                      'Thời gian ngủ',
                      color: isDarkMode 
                          ? AppColors.secondaryDark 
                          : AppColors.secondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildProgressCircle(
    BuildContext context,
    int value,
    int target, {
    required String label,
    required Color color,
    required IconData icon,
  }) {
    final progress = value / target;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        SizedBox(
          height: 80,
          width: 80,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    backgroundColor: isDarkMode 
                        ? AppColors.surfaceDark 
                        : AppColors.surfaceLight,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value.toString(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          'Mục tiêu: $target',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDarkMode 
                ? AppColors.textSecondaryDark 
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label, {
    required Color color,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDarkMode 
                ? AppColors.textSecondaryDark 
                : AppColors.textSecondaryLight,
          ),
      ),
      ],
    );
  }
}
