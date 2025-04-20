// finance_summary_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../bloc/home_bloc.dart';

class FinanceSummaryCard extends StatelessWidget {
  const FinanceSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        // Default finance data
        Map<String, dynamic> financeData = {
          'balance': 12500000,
          'income': 8200000,
          'expenses': 5700000,
          'savings': 1500000,
          'currency': 'VND',
        };
        
        // Get finance data from state if available
        if (state is HomeLoaded && state.homeData.financeData != null) {
          financeData = state.homeData.financeData!;
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
                          ? AppColors.accentDark.withOpacity(0.2) 
                          : AppColors.accentLight.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: isDarkMode 
                          ? AppColors.accentDark 
                          : AppColors.accentLight,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: Text(
                      'Tài chính của bạn',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      // TODO: Navigate to finance details
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingL),
              Text(
                'Số dư hiện tại',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode 
                      ? AppColors.textSecondaryDark 
                      : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXS),
              Text(
                _formatCurrency(financeData['balance'], financeData['currency']),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? AppColors.primaryDark
                      : AppColors.primaryLight,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              Row(
                children: [
                  Expanded(
                    child: _buildFinanceItem(
                      context,
                      'Thu nhập',
                      _formatCurrency(financeData['income'], financeData['currency']),
                      Icons.arrow_downward,
                      isDarkMode 
                          ? AppColors.successDark 
                          : AppColors.successLight,
                    ),
                  ),
                  Expanded(
                    child: _buildFinanceItem(
                      context,
                      'Chi tiêu',
                      _formatCurrency(financeData['expenses'], financeData['currency']),
                      Icons.arrow_upward,
                      isDarkMode 
                          ? AppColors.errorDark 
                          : AppColors.errorLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingL),
              _buildSavingsProgress(
                context,
                financeData['savings'],
                financeData['balance'],
                financeData['currency'],
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildFinanceItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? AppColors.surfaceDark 
            : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: isDarkMode 
              ? AppColors.dividerDark 
              : AppColors.dividerLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingXS),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDarkMode 
                      ? AppColors.textSecondaryDark 
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSavingsProgress(
    BuildContext context,
    int savings,
    int balance,
    String currency,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final savingsPercentage = savings / balance;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tiết kiệm',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              '${(savingsPercentage * 100).toInt()}%',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isDarkMode 
                    ? AppColors.primaryDark 
                    : AppColors.primaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingS),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
          child: LinearProgressIndicator(
            value: savingsPercentage,
            minHeight: 8,
            backgroundColor: isDarkMode 
                ? AppColors.surfaceDark 
                : AppColors.surfaceLight,
            valueColor: AlwaysStoppedAnimation<Color>(
              isDarkMode 
                  ? AppColors.primaryDark 
                  : AppColors.primaryLight,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Text(
          _formatCurrency(savings, currency),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  String _formatCurrency(int amount, String currency) {
    // Format large numbers with commas
    final formattedAmount = amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    
    if (currency == 'VND') {
      return '$formattedAmount đ';
    } else {
      return '$currency $formattedAmount';
    }
  }
}
