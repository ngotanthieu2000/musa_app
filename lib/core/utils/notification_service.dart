import 'package:flutter/material.dart';

class NotificationService {
  // Singleton instance
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Hiển thị thông báo dạng snackbar
  void showSnackBar(
    BuildContext context, {
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: duration,
      action: actionLabel != null && onAction != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: Colors.white,
              onPressed: onAction,
            )
          : null,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Hiển thị dialog thông báo
  Future<void> showAlertDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isError = false,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: isError ? Colors.red : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            if (cancelText != null)
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  if (onCancel != null) onCancel();
                },
                child: Text(cancelText),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (onConfirm != null) onConfirm();
              },
              child: Text(confirmText ?? 'OK'),
            ),
          ],
        );
      },
    );
  }

  // Hiển thị thông báo loading
  void showLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Text(message ?? 'Đang xử lý...'),
              ],
            ),
          ),
        );
      },
    );
  }

  // Đóng dialog
  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Hiển thị thông báo thành công
  void showSuccessNotification(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    showSnackBar(
      context,
      message: message,
      isError: false,
      duration: duration,
    );
  }

  // Hiển thị thông báo lỗi
  void showErrorNotification(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onRetry,
  }) {
    showSnackBar(
      context,
      message: message,
      isError: true,
      duration: duration,
      actionLabel: onRetry != null ? 'Thử lại' : null,
      onAction: onRetry,
    );
  }
} 