import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/feedback/app_toast.dart';
import 'package:offers/core/api/api_response.dart';
import 'package:offers/core/models/global_model.dart';
import 'package:offers/modules/base_controller.dart';

import '../../../core/api/api_constant.dart';
import '../../../core/api/http_service.dart';

/// Controller for the Contact Us screen
/// Handles form validation and API communication for contact requests
class ContactUsController extends BaseController {
  // Text controllers for form fields
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final commentController = TextEditingController();

  // Status variable for UI state management
  final RxBool isLoading = false.obs;

  @override
  void dispose() {
    // Clean up controllers when the widget is removed
    fullNameController.dispose();
    emailController.dispose();
    commentController.dispose();
    super.dispose();
  }

  /// Validates all form inputs before submission
  void validation() {
    // Check if full name is entered
    if (fullNameController.text.isEmpty) {
      AppToast.error(LangKeys.enterFullName.tr);
      return;
    }

    // Check if email is entered
    if (emailController.text.isEmpty) {
      AppToast.error(LangKeys.enterEmail.tr);
      return;
    }

    // Validate email format
    if (!GetUtils.isEmail(emailController.text)) {
      AppToast.error(LangKeys.emailNotValid.tr);
      return;
    }

    if (subjectController.text.isEmpty) {
      AppToast.error(LangKeys.enterSubject.tr);
      return;
    } // Check if comment is entered
    if (commentController.text.isEmpty) {
      AppToast.error(LangKeys.enterComment.tr);
      return;
    }

    // If all validations pass, proceed with contact request
    contactUs();
  }

  /// Sends contact request to API
  Future<void> contactUs() async {
    try {
      // Prepare request body
      Map<String, String> body = {
        "name": fullNameController.text,
        "email": emailController.text.trim(),
        "subject": subjectController.text,
        "message": commentController.text,
      };

      // Show loading indicator
      isLoading(true);

      // Make API request
      final result = await httpService.request(
        url: ApiConstant.contactUs,
        method: Method.POST,
        params: body,
      );

      // Process response
      if (result != null) {
        var data = ApiResponse<void>.fromJson(result.data);
        if (data.status == true) {
          // Show success message and reset form
          AppToast.success(data.message ?? "");
          _resetForm();
        } else {
          // Show error message
          AppToast.error(data.message ?? "");
        }
      }
    } finally {
      // Hide loading indicator regardless of outcome
      isLoading(false);
    }
  }

  /// Resets all form fields to initial state
  void _resetForm() {
    fullNameController.clear();
    emailController.clear();
    subjectController.clear();
    commentController.clear();
  }
}
