import 'package:flutter/material.dart';
import 'settings_screen.dart';

class SettingsButton extends StatelessWidget {
  final bool isCompact;
  final Color? iconColor;
  
  const SettingsButton({
    super.key, 
    this.isCompact = false, 
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    if (isCompact) {
      return IconButton(
        icon: Icon(
          Icons.settings_outlined,
          color: iconColor ?? colorScheme.primary,
        ),
        onPressed: () => _openSettingsScreen(context),
        tooltip: 'Cài đặt',
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () => _openSettingsScreen(context),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.settings_outlined,
                  color: colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Cài đặt',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openSettingsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }
}

// Animated Settings Button có hiệu ứng nổi bật hơn
class AnimatedSettingsButton extends StatefulWidget {
  final bool isCompact;
  final Color? iconColor;
  
  const AnimatedSettingsButton({
    super.key, 
    this.isCompact = false, 
    this.iconColor,
  });

  @override
  State<AnimatedSettingsButton> createState() => _AnimatedSettingsButtonState();
}

class _AnimatedSettingsButtonState extends State<AnimatedSettingsButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.125,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    if (widget.isCompact) {
      return MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: RotationTransition(
          turns: _rotationAnimation,
          child: IconButton(
            icon: Icon(
              Icons.settings,
              color: widget.iconColor ?? colorScheme.primary,
            ),
            onPressed: () => _openSettingsScreen(context),
            tooltip: 'Cài đặt',
          ),
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: GestureDetector(
          onTap: () => _openSettingsScreen(context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _isHovered
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceVariant.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? colorScheme.primary.withOpacity(0.2)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: _isHovered ? 15 : 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RotationTransition(
                  turns: _rotationAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? colorScheme.primary.withOpacity(0.2)
                          : colorScheme.primaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.settings,
                      color: colorScheme.primary,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Cài đặt',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _isHovered
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(
                    _isHovered ? 4.0 : 0.0,
                    0.0,
                    0.0,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: _isHovered
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openSettingsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }
}

// Mini Floating Settings Button dùng để thêm vào góc màn hình
class FloatingSettingsButton extends StatefulWidget {
  final VoidCallback? onPressed;
  
  const FloatingSettingsButton({super.key, this.onPressed});

  @override
  State<FloatingSettingsButton> createState() => _FloatingSettingsButtonState();
}

class _FloatingSettingsButtonState extends State<FloatingSettingsButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.125).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: GestureDetector(
        onTap: () {
          if (widget.onPressed != null) {
            widget.onPressed!();
          } else {
            _openSettingsScreen(context);
          }
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: RotationTransition(
              turns: _rotateAnimation,
              child: Icon(
                Icons.settings,
                color: colorScheme.primary,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openSettingsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }
} 