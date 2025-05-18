import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:offers/modules/change_password/controller/change_password_controller.dart';

import '../../../app/widgets/buttons/app_button.dart';
import '../../../app/widgets/forms/app_text_field.dart';
import '../controller/new_password_controller.dart';

/// Screen for changing user password
/// Allows users to enter old password and set a new one
class NewPassword extends StatelessWidget {
  NewPassword({super.key});

  // Initialize controller
  final NewPasswordController controller = Get.put(NewPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.newPassword.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          child: Column(
            children: [
              // Instruction text
              AppCustomText(
                text: LangKeys.newPasswordMsg.tr,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: HexColor("000B12").withValues(alpha: 0.93),
              ),
              24.verticalSpace,
              // New password field
              Obx(
                () => AppTextField(
                  label: LangKeys.newPassword.tr,
                  hintText: LangKeys.enterNewPassword.tr,
                  controller: controller.newPasswordController,
                  obscureText: !controller.isPasswordVisible.value,
                  textInputAction: TextInputAction.next,
                  suffixIcon:
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                  onSuffixIconPressed: controller.togglePasswordVisibility,
                ),
              ),
              20.verticalSpace,
              // Confirm password field
              Obx(
                () => AppTextField(
                  label: LangKeys.confirmPassword.tr,
                  hintText: LangKeys.enterConfirmPassword.tr,
                  controller: controller.confirmPasswordController,
                  obscureText: !controller.isPasswordVisible.value,
                  textInputAction: TextInputAction.done,
                  suffixIcon:
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                  onSuffixIconPressed: controller.togglePasswordVisibility,
                ),
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
