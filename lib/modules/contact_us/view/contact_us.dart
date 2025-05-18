import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';

import '../../../app/widgets/buttons/app_button.dart';
import '../../../app/widgets/forms/app_text_field.dart';
import '../controller/contact_us_controller.dart';

/// Screen for contacting app support
/// Provides a form for users to send messages to the support team
class ContactUs extends StatelessWidget {
  ContactUs({super.key});

  // Initialize controller
  final ContactUsController controller = Get.put(ContactUsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.contactUs.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header text
              AppCustomText(
                text: LangKeys.welcomeHelpCenter.tr,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: HexColor("000B12").withValues(alpha: 0.93),
              ),
              6.verticalSpace,

              // Instructional message
              AppCustomText(
                text: LangKeys.contactUsMsg.tr,
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: HexColor("7D7D7D").withValues(alpha: 0.93),
              ),
              24.verticalSpace,

              // Full name field
              AppTextField(
                label: LangKeys.fullName.tr,
                hintText: LangKeys.enterFullName.tr,
                controller: controller.fullNameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              20.verticalSpace,

              // Email field
              AppTextField(
                label: LangKeys.email.tr,
                hintText: LangKeys.enterEmail.tr,
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              20.verticalSpace, // Email field
              AppTextField(
                label: LangKeys.subject.tr,
                hintText: LangKeys.enterSubject.tr,
                controller: controller.subjectController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              20.verticalSpace,

              // Comment field
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
