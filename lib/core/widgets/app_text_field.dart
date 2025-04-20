import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? labelText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final int? maxLines;
  final int? minLines;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;
  final bool autofocus;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLength;
  final bool filled;
  final Color? fillColor;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? disabledBorder;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool expands;
  
  const AppTextField({
    Key? key,
    required this.controller,
    this.label,
    this.hint,
    this.labelText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.onEditingComplete,
    this.validator,
    this.inputFormatters,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.autofocus = false,
    this.focusNode,
    this.contentPadding,
    this.maxLength,
    this.filled = true,
    this.fillColor,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.disabledBorder,
    this.style,
    this.textAlign = TextAlign.start,
    this.expands = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final defaultContentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: contentPadding ?? defaultContentPadding,
            filled: filled,
            fillColor: fillColor ?? colorScheme.surfaceVariant.withOpacity(0.4),
            border: border,
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            errorBorder: errorBorder,
            disabledBorder: disabledBorder,
            isDense: true,
          ),
          style: style ?? theme.textTheme.bodyMedium,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          validator: validator,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          enabled: enabled,
          onTap: onTap,
          autofocus: autofocus,
          focusNode: focusNode,
          maxLength: maxLength,
          textAlign: textAlign,
          expands: expands,
        ),
      ],
    );
  }
} 