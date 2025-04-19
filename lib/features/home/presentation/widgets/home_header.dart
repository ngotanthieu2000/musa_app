import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/home_bloc.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spacingL,
        AppDimensions.spacingXL,
        AppDimensions.spacingL,
        AppDimensions.spacingL,
      ),
      child: Column(
        children: [
          Row(
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  final userName = state.maybeWhen(
                    loaded: (homeData) => homeData.userName,
                    orElse: () => 'User',
                  );
                  
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Xin chào,',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isDarkMode 
                                ? AppColors.textSecondaryDark 
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        Text(
                          userName,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: isDarkMode 
                    ? AppColors.primaryDark 
                    : AppColors.primaryLight,
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingL),
          const _SearchBar(),
        ],
      ),
    );
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
