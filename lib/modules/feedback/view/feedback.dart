import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/app/widgets/common/app_loading_view.dart';
import 'package:offers/app/widgets/forms/app_drop_down.dart';
import 'package:offers/core/models/feedback_reasons.dart';

import '../../../app/widgets/buttons/app_button.dart';
import '../../../app/widgets/forms/app_text_field.dart';
import '../controller/feedback_controller.dart';

/// Screen for submitting user feedback
/// Allows users to select a feedback question and enter comments
class Feedback extends StatelessWidget {
  Feedback({super.key});

  // Initialize controller
  final FeedbackController controller = Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.feedback.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Feedback question dropdown
              GetBuilder<FeedbackController>(
                id: "selectQuestion",
                builder: (controller) {
                  if (controller.isLoadingReason.isTrue) {
                    return const AppLoadingView();
                  }
                  return AppDropdown<FeedbackReasons>(
                    label: LangKeys.feedbackQuestion.tr,
                    items: controller.items,
                    isRequired: true,
                    selectedItem: controller.selectQuestion.value,
                    itemAsString: (reason) => reason.question ?? "",
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectQuestion.value = value;
                        controller.update(['selectQuestion']);
                      }
                    },
                  );
                },
              ),
              20.verticalSpace,

              // Comment text field
              AppTextField(
                label: LangKeys.comment.tr,
                maxLines: 4,
                maxLength: 180,
                showCounter: true,
                counterColor: AppTheme.primaryColor,
                hintText: LangKeys.enterComment.tr,
                controller: controller.commentController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
              ),
              41.verticalSpace,

              // Submit button
              Obx(
                    () => AppButton(
                  text: LangKeys.send.tr,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.validation,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}