import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/feedback/app_toast.dart';
import 'package:offers/core/api/api_response.dart';
import 'package:offers/core/models/feedback_reasons.dart';
import 'package:offers/core/models/global_model.dart';
import 'package:offers/modules/base_controller.dart';

import '../../../core/api/api_constant.dart';
import '../../../core/api/http_service.dart';

/// Controller for the Feedback screen
/// Handles feedback reason selection, validation, and API communication
class FeedbackController extends BaseController {
  // Text controller for comment field
  final commentController = TextEditingController();

  // Status variables for UI state management
  final RxBool isLoading = false.obs;
  final RxBool isLoadingReason = false.obs;

  // List of feedback reasons and currently selected reason
  var items = <FeedbackReasons>[].obs;
  Rx<FeedbackReasons> selectQuestion =
      FeedbackReasons(question: LangKeys.selectQuestion.tr, id: 0).obs;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    feedbackReasons(); // Load feedback reasons when controller initializes
  }

  /// Validates form inputs before submission
  void validation() {
    // Check if a feedback question is selected
    if (selectQuestion.value.id == 0) {
      AppToast.error(LangKeys.selectQuestion.tr);
      return;
    }

    // Check if comment field is filled
    if (commentController.text.isEmpty) {
      AppToast.error(LangKeys.enterComment.tr);
      return;
    }

    // If all validations pass, proceed to submit feedback
    helpSupport();
  }

  /// Sends feedback request to API
  Future<void> helpSupport() async {
    try {
      // Prepare request body
      Map<String, dynamic> body = {
        "feedback_question_id": selectQuestion.value.id,
        "question": commentController.text,
      };

      // Show loading indicator
      isLoading(true);

      // Make API request
      final result = await httpService.request(
        url: ApiConstant.feedback,
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

  /// Fetches available feedback reasons from API
  Future<void> feedbackReasons() async {
    try {
      // Show loading indicator
      isLoadingReason(true);

      // Make API request
      final result = await httpService.request(
        url: ApiConstant.feedbackReasons,
        method: Method.GET,
      );
      // Process response
      if (result != null) {
        var response = ApiResponse.fromJsonList<FeedbackReasons>(
          result.data,
          FeedbackReasons.fromJson,
        );

        // Update feedback reasons list if successful
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
      update(['selectQuestion']);
    }
  }

  /// Resets form fields to initial state
  void _resetForm() {
    selectQuestion.value = FeedbackReasons(
      question: LangKeys.selectQuestion.tr,
      id: 0,
    );
    commentController.clear();
    update(['selectQuestion']);
  }
}
