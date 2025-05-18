import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/buttons/app_button.dart';
import 'package:offers/app/widgets/forms/app_checkbox.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:offers/app/widgets/forms/app_phone_input.dart';
import 'package:offers/app/widgets/forms/app_text_field.dart';

import '../../../app/widgets/app_bar/custom_app_bar.dart';
import '../controller/sign_up_controller.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  SignUpController controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.signUp.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              30.verticalSpace,
              SvgPicture.asset(
                AppUtils.getIconPath("ic_login"),
                width: 60.68.w,
                height: 49.h,
              ),
              30.verticalSpace,
              AppCustomText(
                text: LangKeys.createAnAccount.tr,
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
              ),
              10.verticalSpace,
              AppCustomText(
                text: LangKeys.signUpNowToGetStartedWithAnAccount.tr,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: HexColor("747474"),
              ),
              40.verticalSpace,
              AppTextField(
                label: LangKeys.fullName.tr,
                hintText: LangKeys.enterFullName.tr,
                controller: controller.fullNameController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              20.verticalSpace,
              // Phone field - now much simpler!
              AppPhoneInput(
                controller: controller.phoneController,
                // hintText: 'Enter your phone number',
                labelText: LangKeys.mobileNumber.tr,
                // initialPhoneNumber: "+962790123456", // Pass existing number here
                onPhoneChanged: controller.onPhoneChanged,
              ),
              20.verticalSpace,
              AppTextField(
                label: LangKeys.email.tr,
                hintText: LangKeys.enterEmail.tr,
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              20.verticalSpace,
              Obx(
                () => AppTextField(
                  label: LangKeys.password.tr,
                  hintText: LangKeys.enterPassword.tr,
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  textInputAction: TextInputAction.done,
                  suffixIcon:
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                  onSuffixIconPressed: controller.togglePasswordVisibility,
                ),
              ),
              20.verticalSpace,
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
              11.verticalSpace,
              Row(
                children: [
                  Obx(
                    () => AppCheckbox(
                      value: controller.isAgreeTerms.value,
                      onChanged: (value) {
                        controller.isAgreeTerms(value);
                      },
                      label: "",
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text.rich(
                        textAlign: TextAlign.start,
                        TextSpan(
                          text: LangKeys.iHaveReadAndAgreeToThe.tr,
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: LangKeys.termsOfService.tr,
                              style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                                color: AppTheme.primaryColor,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.toNamed(
                                        AppRoutes.pageView,
                                        arguments: {
                                          "title":
                                              LangKeys.termsAndConditions.tr,
                                          "key": "terms_and_conditions",
                                        },
                                      );
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //SizedBox
                ],
              ),
              31.verticalSpace,
              Obx(
                () => AppButton(
                  text: LangKeys.signUp.tr,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.validate,
                ),
              ),
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppCustomText(
                    text: LangKeys.alreadyHaveAnAccount.tr,
                    fontSize: 14.0.sp,
                    color: HexColor("1E232C"),
                    fontWeight: FontWeight.w400,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: AppCustomText(
                      text: LangKeys.signIn.tr,
                      fontSize: 14.0.sp,
                      color: AppTheme.primaryColor,
                      // decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
