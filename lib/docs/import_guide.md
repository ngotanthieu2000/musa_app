# Hướng dẫn sử dụng Barrel Imports trong dự án Musa App

## Nguyên tắc chung

Trong dự án Musa App, chúng ta sử dụng **Barrel Files** (index.dart) để quản lý imports và giảm thiểu các imports tương đối dạng `../../../`.

## Cách sử dụng

### 1. Import từ các Barrel Files

```dart
// Thay vì sử dụng import tương đối:
import '../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/profile.dart';

// Hãy sử dụng barrel files:
import '../../../core/index.dart';
import '../../index.dart'; // Để import từ cùng một feature
```

### 2. Sử dụng Alias để tránh xung đột tên

```dart
// Import với alias để tránh xung đột tên
import '../../../core/index.dart' as core;
import '../../index.dart' as profile;

// Sử dụng
final profileBloc = core.sl<ProfileBloc>();
```

## Cấu trúc Barrel Files

### 1. File index.dart ở thư mục gốc của mỗi feature

```dart
// features/profile/index.dart
export 'domain/entities/profile.dart';
export 'presentation/bloc/profile_bloc.dart';
export 'presentation/pages/profile_page.dart';
// ...
```

### 2. File index.dart ở các thư mục con

```dart
// features/profile/domain/index.dart
export 'entities/profile.dart';
export 'repositories/profile_repository.dart';
export 'usecases/get_profile.dart';
// ...
```

## Lợi ích

1. **Code gọn gàng hơn**: Các imports dạng barrel files đơn giản và ngắn gọn hơn
2. **Dễ bảo trì**: Khi cấu trúc thay đổi, bạn chỉ cần cập nhật barrel files thay vì tất cả các imports
3. **Tăng tốc độ phát triển**: Giảm thời gian tìm đường dẫn chính xác
4. **Quản lý API rõ ràng**: Các barrel files giúp định nghĩa rõ ràng "public API" của mỗi module

## Lưu ý khi refactor

Khi chuyển từ imports tương đối trực tiếp sang barrel files:

1. Đảm bảo tạo đủ barrel files cho tất cả modules
2. Kiểm tra xung đột namespace nếu có
3. Sử dụng IDE để tự động cập nhật imports khi có thể

## Ví dụ thực tế

```dart
// Trước khi refactor
import 'package:flutter/material.dart';
import '../../../core/widgets/app_bar.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/user.dart';
import '../bloc/auth_bloc.dart';

// Sau khi refactor với barrel files
import 'package:flutter/material.dart';
import '../../../core/index.dart';
import '../../domain/index.dart';
import '../index.dart';

// Hoặc sử dụng alias để tránh xung đột
import 'package:flutter/material.dart';
import '../../../core/index.dart' as core;
import '../../domain/index.dart' as domain;
```

## Quy tắc đặt tên Barrel Files

1. Mỗi thư mục chính hoặc module nên có một file `index.dart`
2. Barrel file chỉ nên export các files cần thiết cho API công khai của module đó
3. Barrel files có thể export các barrel files khác để tạo thành hierarchy

## Ví dụ về cấu trúc thư mục với Barrel Files

```
lib/
├── core/
│   ├── index.dart (exports tất cả các module core)
│   ├── widgets/
│   │   ├── index.dart (exports tất cả widgets)
│   ├── utils/
│   │   ├── index.dart (exports tất cả utils)
│
├── features/
│   ├── auth/
│   │   ├── index.dart (exports tất cả auth)
│   │   ├── domain/
│   │   │   ├── index.dart (exports entities, repos, usecases)
│   │   ├── presentation/
│   │   │   ├── index.dart (exports blocs, pages, widgets)
``` 