import 'package:flutter/material.dart';

// Primary button with filled background
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFullWidth;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        minimumSize: isFullWidth ? const Size(double.infinity, 48) : null,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Secondary button with outlined style
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFullWidth;

  const SecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
        side: BorderSide(color: theme.colorScheme.primary),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        minimumSize: isFullWidth ? const Size(double.infinity, 48) : null,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 