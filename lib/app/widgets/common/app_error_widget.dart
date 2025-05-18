import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/buttons/app_button.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';

/// Error widget for displaying errors
class AppErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    this.title = 'Error Occurred',
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 80.w, color: AppTheme.errorColor),
            SizedBox(height: AppTheme.spacing16),
            Text(
              title,
              style: AppTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppTheme.spacing8),
            Text(
              message,
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: AppTheme.spacing24),
              AppButton(
                text: LangKeys.retry.tr,
                variant: ButtonVariant.primary,
                onPressed: onRetry!,
                leadingIcon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Creates a custom error widget with retry option
  factory AppErrorWidget.withRetry({
    required String message,
    required VoidCallback onRetry,
    String retryButtonText = 'Retry',
  }) {
    return AppErrorWidget(message: message, onRetry: onRetry);
  }

  /// Creates a network error widget
  factory AppErrorWidget.network({VoidCallback? onRetry}) {
    return AppErrorWidget(
      title: 'Network Error',
      message: 'Please check your internet connection and try again.',
      onRetry: onRetry,
    );
  }

  /// Creates a server error widget
  factory AppErrorWidget.server({VoidCallback? onRetry}) {
    return AppErrorWidget(
      title: 'Server Error',
      message: 'Something went wrong on our server. Please try again later.',
      onRetry: onRetry,
    );
  }

  /// Creates a custom error with specific error code
  factory AppErrorWidget.withCode({
    required String message,
    required String errorCode,
    VoidCallback? onRetry,
  }) {
    return AppErrorWidget(
      title: 'Error ($errorCode)',
      message: message,
      onRetry: onRetry,
    );
  }
}
