import 'dart:ui' as ui;

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:offers/app/widgets/forms/app_text_field.dart';
import 'package:offers/modules/edit_profile/controller/edit_profile_controller.dart';

import '../../../app/config/app_theme.dart';
import '../../../app/widgets/buttons/app_button.dart';
import '../../../app/widgets/forms/app_phone_input.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});

  EditProfileController controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.editPersonalDetails.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          child: Column(
            children: [
              AppTextField(
                label: LangKeys.fullName.tr,
                hintText: LangKeys.enterFullName.tr,
                controller: controller.fullNameController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              20.verticalSpace,
              AppPhoneInput(
                controller: controller.phoneController,
                // hintText: 'Enter your phone number',
                labelText: LangKeys.mobileNumber.tr,
                initialPhoneNumber: controller.user?.mobile,
                // Pass existing number here
                onPhoneChanged: controller.onPhoneChanged,
              ),
              20.verticalSpace,
              AppTextField(
                label: LangKeys.email.tr,
                enabled: false,
                hintText: LangKeys.enterEmail.tr,
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              31.verticalSpace,
              Obx(
                () => AppButton(
                  text: LangKeys.save.tr,
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
