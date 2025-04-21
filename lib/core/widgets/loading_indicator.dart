import 'package:flutter/material.dart';

/// Widget hiển thị trạng thái đang tải với thông báo tùy chỉnh
class LoadingIndicator extends StatelessWidget {
  /// Thông báo hiển thị dưới loading indicator
  final String? message;
  
  /// Màu sắc của loading indicator, mặc định lấy theo colorScheme.primary
  final Color? color;
  
  /// Kích thước của loading indicator
  final double size;
  
  /// Độ dày của đường loading indicator
  final double strokeWidth;
  
  /// Constructor
  const LoadingIndicator({
    Key? key,
    this.message,
    this.color,
    this.size = 40,
    this.strokeWidth = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(color ?? colorScheme.primary),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onBackground.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
} 