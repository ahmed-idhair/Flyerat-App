import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';

class AppToast {
  static void success(String message, {Duration? duration}) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: AppTheme.successColor,
      colorText: Colors.white,
      margin: EdgeInsets.all(AppTheme.spacing16),
      borderRadius: AppTheme.borderRadiusMedium,
      snackPosition: SnackPosition.TOP,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void error(String message, {Duration? duration}) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: AppTheme.errorColor,
      colorText: Colors.white,
      margin: EdgeInsets.all(AppTheme.spacing16),
      borderRadius: AppTheme.borderRadiusMedium,
      snackPosition: SnackPosition.TOP,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void warning(String message, {Duration? duration}) {
    Get.snackbar(
      'Warning',
      message,
      backgroundColor: AppTheme.warningColor,
      colorText: Colors.white,
      margin: EdgeInsets.all(AppTheme.spacing16),
      borderRadius: AppTheme.borderRadiusMedium,
      snackPosition: SnackPosition.TOP,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void info(String message, {Duration? duration}) {
    Get.snackbar(
      'Info',
      message,
      backgroundColor: AppTheme.primaryColor,
      colorText: Colors.white,
      margin: EdgeInsets.all(AppTheme.spacing16),
      borderRadius: AppTheme.borderRadiusMedium,
      snackPosition: SnackPosition.TOP,
      duration: duration ?? const Duration(seconds: 3),
    );
  }
}