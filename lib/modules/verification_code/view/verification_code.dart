import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/app/widgets/buttons/app_button.dart';
import 'package:offers/app/widgets/feedback/app_toast.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:pinput/pinput.dart';

import '../../../app/extensions/color.dart';
import '../controller/verification_code_controller.dart';

class VerificationCode extends StatelessWidget {
  VerificationCode({super.key});

  var controller = Get.put(VerificationCodeController());

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    final defaultPinTheme = PinTheme(
      width: 48.w,
      height: 48.h,
      textStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: HexColor("F3F4F7").withValues(alpha: 0.43),
        border: Border.all(
          color: HexColor("E2E9F8"), // Border color
          width: 0.5.w, // Border width
        ),
        borderRadius: BorderRadius.circular(16.r), // R
      ),
    );
    final cursor = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 28.w,
          height: 1.h,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        10.verticalSpace,
      ],
    );
    final preFilledWidget = Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: HexColor("F3F4F7").withOpacity(0.43),
        border: Border.all(
          color: AppTheme.primaryColor, // Border color
          width: 0.5.w, // Border w// Border width
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.verificationCode.tr),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: LangKeys.otpHasBeenSentTo.tr,
                    // Initial text
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: HexColor("383737"),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' ${Get.arguments['email']}',
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: HexColor("383737"),
                        ),
                      ),
                    ],
                  ),
                ),
                30.verticalSpace,
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        flex: controller.start.value != 0 ? 1 : 4,
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Pinput(
                            length: 4,
                            pinAnimationType: PinAnimationType.slide,
                            controller: controller.pinController,
                            focusNode: focusNode,
                            defaultPinTheme: defaultPinTheme,
                            showCursor: true,
                            keyboardType: TextInputType.number,
                            cursor: cursor,
                            preFilledWidget: preFilledWidget,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.start.value == 0,
                        child: Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              8.horizontalSpace,
                              Flexible(
                                child: AppButton(
                                  color: HexColor("F2F2F2"),
                                  textColor: Colors.black,
                                  text: LangKeys.reSend.tr,
                                  isLoading: controller.isLoadingResend.value,
                                  onPressed: () {
                                    if (controller.from == AppRoutes.signIn ||
                                        controller.from == AppRoutes.signUp) {
                                      controller.sendVerificationCode();
                                    } else {
                                      controller
                                          .sendVerificationCodeForgetPassword();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                20.verticalSpace,
                Obx(
                  () =>
                      controller.start.value != 0
                          ? Wrap(
                            // Use Wrap instead of Row to allow text to wrap to next line
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 5.w, // horizontal spacing
                            children: [
                              AppCustomText(
                                text: LangKeys.resendOTPIn.tr,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: HexColor("383737"),
                              ),
                              AppCustomText(
                                text: controller.timeStr.value,
                                fontWeight: FontWeight.w800,
                                fontSize: 14.sp,
                                color: HexColor("00C851"),
                              ),
                            ],
                          )
                          : SizedBox(),
                ),
                100.verticalSpace,
                Obx(
                  () => AppButton(
                    // color: HexColor("FF1161"),
                    text: LangKeys.confirm.tr,
                    isLoading: controller.isLoadingVerify.value,
                    onPressed: () {
                      if (controller.pinController.text.length != 4) {
                        AppToast.error(
                          LangKeys.enterCompleteVerificationCode.tr,
                        );
                        return;
                      }
                      controller.verifyMobile();
                    },
                  ),
                ),

                SizedBox(height: 25.0.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
