import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musa_app/core/error/failures.dart';
import 'package:musa_app/core/utils/notification_service.dart';

class BlocHelper {
  /// Helper method to show loading
  static void showLoading(BuildContext context, {String? message}) {
    NotificationService().showLoadingDialog(
      context,
      message: message ?? 'Đang xử lý...',
    );
  }
  
  /// Helper method to hide loading
  static void hideLoading(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
  
  /// Helper method to handle errors
  static void handleError(BuildContext context, Failure failure, {VoidCallback? onRetry}) {
    NotificationService().showErrorNotification(
      context,
      message: failure.userFriendlyMessage,
      onRetry: onRetry,
    );
  }
  
  /// Helper method to show dialog error
  static void showErrorDialog(BuildContext context, Failure failure, {VoidCallback? onRetry}) {
    NotificationService().showAlertDialog(
      context,
      title: 'Đã xảy ra lỗi',
      message: failure.userFriendlyMessage,
      isError: true,
      confirmText: 'OK',
      cancelText: onRetry != null ? 'Thử lại' : null,
      onCancel: onRetry,
    );
  }
  
  /// Helper method to show success
  static void showSuccess(BuildContext context, String message) {
    NotificationService().showSuccessNotification(
      context,
      message: message,
    );
  }
  
  /// Helper method to listen for state changes and handle loading and errors
  static Widget blocListener<B extends BlocBase<S>, S>({
    required BuildContext context,
    required BlocWidgetListener<S> listener,
    required Widget child,
    BlocListenerCondition<S>? listenWhen,
  }) {
    return BlocListener<B, S>(
      listener: listener,
      listenWhen: listenWhen,
      child: child,
    );
  }
  
  /// Helper method to handle calling APIs
  static Future<void> callApi<T>({
    required BuildContext context,
    required Future<T> Function() apiCall,
    required Function(T result) onSuccess,
    String? loadingMessage,
    Function(Failure failure)? onError,
    bool showLoading = true,
    bool showError = true,
    bool showSuccess = false,
    String? successMessage,
  }) async {
    try {
      if (showLoading) {
        BlocHelper.showLoading(context, message: loadingMessage);
      }
      
      final result = await apiCall();
      
      if (showLoading) {
        BlocHelper.hideLoading(context);
      }
      
      onSuccess(result);
      
      if (showSuccess && successMessage != null) {
        BlocHelper.showSuccess(context, successMessage);
      }
    } on Failure catch (failure) {
      if (showLoading) {
        BlocHelper.hideLoading(context);
      }
      
      if (onError != null) {
        onError(failure);
      }
      
      if (showError) {
        BlocHelper.handleError(context, failure);
      }
    } catch (e) {
      if (showLoading) {
        BlocHelper.hideLoading(context);
      }
      
      final failure = UnexpectedFailure(message: e.toString());
      
      if (onError != null) {
        onError(failure);
      }
      
      if (showError) {
        BlocHelper.handleError(context, failure);
      }
    }
  }
}

/// Extension for BlocBuilder with error handling
extension BlocBuilderExtension on BuildContext {
  /// Builder that handles loading and error states automatically
  Widget blocBuilderWithError<B extends BlocBase<S>, S>({
    required BlocWidgetBuilder<S> builder,
    required S Function(S) getViewState,
    required bool Function(S) isLoading,
    required bool Function(S) hasError,
    required Failure Function(S) getError,
    Widget Function()? loadingBuilder,
    Widget Function(Failure)? errorBuilder,
    BlocBuilderCondition<S>? buildWhen,
  }) {
    return BlocBuilder<B, S>(
      buildWhen: buildWhen,
      builder: (context, state) {
        final viewState = getViewState(state);
        
        if (isLoading(state)) {
          return loadingBuilder?.call() ?? 
            const Center(child: CircularProgressIndicator());
        }
        
        if (hasError(state)) {
          return errorBuilder?.call(getError(state)) ?? 
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    getError(state).userFriendlyMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Retry logic
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
        }
        
        return builder(context, viewState);
      },
    );
  }
} 