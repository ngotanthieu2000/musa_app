import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class MusaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showActionButton;
  final String? actionButtonText;
  final IconData? actionButtonIcon;
  final VoidCallback? onActionButtonPressed;
  final String? routeOnBack;
  
  const MusaAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.showActionButton = false,
    this.actionButtonText,
    this.actionButtonIcon,
    this.onActionButtonPressed,
    this.routeOnBack,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (routeOnBack != null) {
                  GoRouter.of(context).go(routeOnBack!);
                } else {
                  Navigator.maybePop(context);
                }
              },
            )
          : null,
      actions: [
        if (showActionButton && actionButtonText != null)
          TextButton.icon(
            icon: Icon(actionButtonIcon ?? Icons.login),
            label: Text(actionButtonText!),
            onPressed: onActionButtonPressed ?? () {},
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
      ],
      centerTitle: true,
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 