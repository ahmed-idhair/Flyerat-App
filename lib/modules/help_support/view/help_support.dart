import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/app/widgets/common/app_loading_view.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:offers/app/widgets/forms/app_drop_down.dart';
import 'package:offers/core/models/support_reasons.dart';

import '../../../app/widgets/buttons/app_button.dart';
import '../../../app/widgets/forms/app_text_field.dart';
import '../controller/help_support_controller.dart';

/// Screen for submitting help and support requests
/// Allows users to select a support reason and enter comments
class HelpSupport extends StatelessWidget {
  HelpSupport({super.key});

  // Initialize controller
  final HelpSupportController controller = Get.put(HelpSupportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.helpSupport.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Support reason dropdown
              GetBuilder<HelpSupportController>(
                id: "selectedReason",
                builder: (controller) {
                  if (controller.isLoadingReason.isTrue) {
                    return const AppLoadingView();
                  }
                  return AppDropdown<SupportReasons>(
                    label: LangKeys.selectReason.tr,
                    items: controller.items,
                    isRequired: true,
                    selectedItem: controller.selectReason.value,
                    itemAsString: (supportReasons) => supportReasons.reason ?? "",
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectReason.value = value;
                        controller.update(['selectedReason']);
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