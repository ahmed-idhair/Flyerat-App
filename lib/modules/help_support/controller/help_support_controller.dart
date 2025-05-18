import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/feedback/app_toast.dart';
import 'package:offers/core/api/api_response.dart';
import 'package:offers/core/models/global_model.dart';
import 'package:offers/core/models/support_reasons.dart';
import 'package:offers/modules/base_controller.dart';

import '../../../core/api/api_constant.dart';
import '../../../core/api/http_service.dart';

/// Controller for the Help and Support screen
/// Handles support reason selection, validation, and API communication
class HelpSupportController extends BaseController {
  // Text controller for comment field
  final commentController = TextEditingController();

  // Status variables for UI state management
  final RxBool isLoading = false.obs;
  final RxBool isLoadingReason = false.obs;

  // List of support reasons and currently selected reason
  var items = <SupportReasons>[].obs;
  Rx<SupportReasons> selectReason = SupportReasons(reason: LangKeys.selectReason.tr, id: 0).obs;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    supportReasons(); // Load support reasons when controller initializes
  }

  /// Validates form inputs before submission
  void validation() {
    // Check if a support reason is selected
    if (selectReason.value.id == 0) {
      AppToast.error(LangKeys.selectReason.tr);
      return;
    }

    // Check if comment field is filled
    if (commentController.text.isEmpty) {
      AppToast.error(LangKeys.enterComment.tr);
      return;
    }

    // If all validations pass, proceed to submit support request
    helpSupport();
  }

  /// Sends help/support request to API
  Future<void> helpSupport() async {
    try {
      // Prepare request body
      Map<String, dynamic> body = {
        "support_reason_id": selectReason.value.id,
        "reason": commentController.text,
      };

      // Show loading indicator
      isLoading(true);

      // Make API request
      final result = await httpService.request(
        url: ApiConstant.helpSupport,
        method: Method.POST,
        params: body,
      );

      // Process response
      if (result != null) {
        var data = ApiResponse<void>.fromJson(result.data);
        if (data.isSuccess == true) {
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

  /// Fetches available support reasons from API
  Future<void> supportReasons() async {
    try {
      // Show loading indicator
      isLoadingReason(true);

      // Make API request
      final result = await httpService.request(
        url: ApiConstant.supportReasons,
        method: Method.GET,
      );

      // Process response
      if (result != null) {
        var response = ApiResponse.fromJsonList<SupportReasons>(
          result.data,
          SupportReasons.fromJson,
        );

        // Update support reasons list if successful
        if (response.isSuccess && response.data != null) {
          items.value = response.data!;
        } else {
          // Show error message
          AppToast.error(response.message);
        }
      }
    } finally {
      // Hide loading indicator and update UI
      isLoadingReason(false);
      update(['selectedReason']);
    }
  }

  /// Resets form fields to initial state
  void _resetForm() {
    selectReason.value = SupportReasons(reason: LangKeys.selectReason.tr, id: 0);
    commentController.clear();
    update(['selectedReason']);
  }
}