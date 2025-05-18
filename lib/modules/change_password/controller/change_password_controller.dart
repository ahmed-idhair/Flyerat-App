import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers/modules/base_controller.dart';

import '../../../app/translations/lang_keys.dart';
import '../../../app/widgets/feedback/app_toast.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';

/// Controller for the Change Password screen
/// Handles password validation and API communication
class ChangePasswordController extends BaseController {
  // Controllers for form fields
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable variables for UI state
  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  /// Toggles password visibility for all password fields
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is removed
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  /// Validates the password fields before submission
  void validation() {
    // Check if old password is entered
    if (oldPasswordController.text.isEmpty) {
      AppToast.error(LangKeys.enterOldPassword.tr);
      return;
    }

    // Check if new password is entered
    if (newPasswordController.text.isEmpty) {
      AppToast.error(LangKeys.enterNewPassword.tr);
      return;
    }

    // Check if confirm password is entered
    if (confirmPasswordController.text.isEmpty) {
      AppToast.error(LangKeys.enterConfirmNewPassword.tr);
      return;
    }

    // Check if new password and confirm password match
    if (confirmPasswordController.text != newPasswordController.text) {
      AppToast.error(LangKeys.passwordNotMatch.tr);
      return;
    }

    // If all validations pass, proceed to change password
    changePassword();
  }

  /// Calls API to change the user's password
  Future<void> changePassword() async {
    try {
      // Prepare request body
      Map<String, dynamic> body = {
        "current_password": oldPasswordController.text.trim(),
        "password": newPasswordController.text.trim(),
        "password_confirmation": confirmPasswordController.text.trim(),
      };

      // Show loading indicator
      isLoading(true);

      // Make API request
      final result = await httpService.request(
        url: ApiConstant.changePassword,
        method: Method.POST,
        params: body,
      );

      // Process response
      if (result != null) {
        var data = ApiResponse<void>.fromJson(result.data);
        if (data.isSuccess == true) {
          // Return to previous screen on success
          Get.back();
          AppToast.success(data.message ?? "");
        } else {
          // Show error message on failure
          AppToast.error(data.message ?? "");
        }
      }
    } finally {
      // Hide loading indicator regardless of outcome
      isLoading(false);
    }
  }
}