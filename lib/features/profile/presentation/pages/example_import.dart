import 'package:flutter/material.dart';

// Phương pháp 1: Sử dụng barrel files
import '../../../../core/index.dart';
import '../../../index.dart' as profile;
import '../../../../features/auth/index.dart' as auth;

// Phương pháp 2: Sử dụng Paths helper
import '../../../../core/constants/paths.dart';
import '${Paths.relativeCoreDi}/injection_container.dart';
import '${Paths.relativeAuthDomain}/entities/user.dart';

/// Ví dụ class minh họa cách sử dụng các phương pháp import khác nhau
class ExampleImport extends StatelessWidget {
  const ExampleImport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sử dụng components từ barrel files
    return const LoadingIndicator(
      message: 'Đang tải...',
    );
  }
} 