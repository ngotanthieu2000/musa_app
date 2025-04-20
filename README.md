# AI Learning App

## Cách chạy ứng dụng

### Development
```bash
flutter run --dart-define=API_BASE_URL=http://localhost:8080/api/v1
```

### Staging
```bash
flutter run --dart-define=API_BASE_URL=https://staging-api.example.com/api/v1
```

### Production
```bash
flutter run --dart-define=API_BASE_URL=https://api.example.com/api/v1
```

## Cấu hình môi trường

Ứng dụng sử dụng các biến môi trường sau:

- `API_BASE_URL`: URL của API backend

## Cấu trúc thư mục

```
lib/
  ├── config/           # Cấu hình ứng dụng
  ├── features/         # Các tính năng
  │   ├── auth/        # Tính năng xác thực
  │   └── home/        # Tính năng trang chủ
  └── main.dart        # Entry point
```
