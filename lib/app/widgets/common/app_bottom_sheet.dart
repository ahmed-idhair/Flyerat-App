import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/widgets/buttons/app_button.dart';
import 'package:offers/app/widgets/common/app_loading_view.dart';

import '../../extensions/color.dart';
import '../../routes/app_routes.dart';
import '../../services/storage_service.dart';
import '../../translations/lang_keys.dart';
import '../../utils/app_utils.dart';
import '../forms/app_custom_text.dart';

showErrorBottomSheet(String message, {VoidCallback? onClick, String? textBtn}) {
  if (Get.isBottomSheetOpen != null && !Get.isBottomSheetOpen!) {
    Get.bottomSheet(
      backgroundColor: Colors.white,
      SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: 9.w,
            end: 9.w,
            top: 30.h,
            bottom: 30.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                AppUtils.getIconPath("ic_error"),
                width: 100.0.w,
                height: 100.h,
              ),
              SizedBox(height: 16.0.h),
              AppCustomText(
                text: LangKeys.error.tr,
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
                color: HexColor("ED3A3A"),
              ),
              16.verticalSpace,
              AppCustomText(
                text: message,
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
                textAlign: TextAlign.center,
                color: AppTheme.text17,
              ),
              30.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0.w),
                child: AppButton(
                  // color: HexColor("FF1161"),
                  text: textBtn ?? LangKeys.ok.tr,
                  onPressed:
                      onClick ??
                      () {
                        Get.back();
                      },
                ),
              ),
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0.r),
          topRight: Radius.circular(16.0.r),
        ),
      ),
    );
  }
}

showLogoutBottomSheet(String message) {
  if (Get.isBottomSheetOpen != null && !Get.isBottomSheetOpen!) {
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: EdgeInsets.all(18.0.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 25.0.h),
              SvgPicture.asset(
                AppUtils.getIconPath("ic_error"),
                width: 130.0.w,
                height: 90.h,
              ),
              SizedBox(height: 20.0.h),
              AppCustomText(
                text: message,
                fontSize: 15.sp,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.0.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                child: AppButton(
                  text: LangKeys.ok.tr,
                  onPressed: () {
                    Get.back();
                    Get.find<StorageService>().clearApp();
                    Get.offAllNamed(AppRoutes.signIn);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      isDismissible: false,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0.r),
          topRight: Radius.circular(20.0.r),
        ),
      ),
    );
  }
}

showLogOutBottomSheet(BuildContext context, Function()? function) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0.r),
        topRight: Radius.circular(16.0.r),
      ),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: 17.w,
            end: 17.w,
            top: 16.h,
            bottom: 16.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30.0.h),
              SvgPicture.asset(
                AppUtils.getIconPath("ic_log_out_bh"),
                width: 135.44.w,
                height: 101.6.h,
                placeholderBuilder: (BuildContext context) => AppLoadingView(),
              ),
              SizedBox(height: 20.0.h),
              Text(
                LangKeys.sureLoggedOut.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0.sp, color: Colors.black),
              ),
              SizedBox(height: 22.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: AppButton(
                      text: LangKeys.logOut.tr,
                      onPressed: function!,
                    ),
                  ),
                  SizedBox(width: 16.0.w),
                  Expanded(
                    flex: 1,
                    child: AppButton(
                      text: LangKeys.cancel.tr,
                      onPressed: () {
                        Get.back();
                      },
                      variant: ButtonVariant.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

//accountDeactivateMsg
showAccountDeactivateBottomSheet(BuildContext context, Function()? function) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0.r),
        topRight: Radius.circular(16.0.r),
      ),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: 17.w,
            end: 17.w,
            top: 16.h,
            bottom: 16.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30.0.h),
              SvgPicture.asset(
                AppUtils.getIconPath("ic_log_out_bh"),
                width: 135.44.w,
                height: 101.6.h,
                placeholderBuilder: (BuildContext context) => AppLoadingView(),
              ),
              SizedBox(height: 20.0.h),
              AppCustomText(
                text: LangKeys.accountDeactivateMsg.tr,
                fontWeight: FontWeight.w400,
                fontSize: 15.0.sp,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 22.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: AppButton(
                      text: LangKeys.delete.tr,
                      onPressed: function!,
                    ),
                  ),
                  SizedBox(width: 16.0.w),
                  Expanded(
                    flex: 1,
                    child: AppButton(
                      text: LangKeys.cancel.tr,
                      variant: ButtonVariant.outline,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

changeLanguageBottomSheet(BuildContext context) {
  var controller = Get.find<StorageService>();
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0.r),
        topRight: Radius.circular(16.0.r),
      ),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: 24.w,
            end: 24.w,
            top: 16.h,
            bottom: 16.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppCustomText(
                text: LangKeys.language.tr,
                fontWeight: FontWeight.w500,
                fontSize: 16.0.sp,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.0.h),
              AppButton(
                text: LangKeys.arabic.tr,
                textColor:
                    controller.getLanguageCode() == "ar"
                        ? AppTheme.primaryColor
                        : Colors.black.withValues(alpha: .50),
                color:
                    controller.getLanguageCode() == "ar"
                        ? AppTheme.primaryColor
                        : Colors.black.withValues(alpha: .50),
                onPressed: () {
                  if (controller.getLanguageCode() != "ar") {
                    // if(controller.isAuth()){
                    //   Get.find<SettingsPageController>().updateLanguage("ar");
                    // }else{
                    // Get.find<LanguageController>().updateLocale("ar");
                    // }
                  }
                },
              ),
              SizedBox(height: 22.0.h),
              AppButton(
                text: LangKeys.english.tr,
                textColor:
                    controller.getLanguageCode() == "en"
                        ? AppTheme.primaryColor
                        : Colors.black.withValues(alpha: .50),
                color:
                    controller.getLanguageCode() == "en"
                        ? AppTheme.primaryColor
                        : Colors.black.withValues(alpha: .50),
                onPressed: () {
                  if (controller.getLanguageCode() != "en") {
                    // if(controller.isAuth()){
                    //   Get.find<SettingsPageController>().updateLanguage("ar");
                    // }else{
                    // Get.find<LanguageController>().updateLocale("ar");
                    // }
                  }
                },
              ),
              SizedBox(height: 30.0.h),
            ],
          ),
        ),
      );
    },
  );
}

confirmDeleteBottomSheet(
  String title,
  String description,
  VoidCallback? function, {
  String delete = "",
  String cancel = "",
}) {
  if (delete.isEmpty) {
    delete = LangKeys.delete.tr;
  }
  if (cancel.isEmpty) {
    cancel = LangKeys.cancel.tr;
  }
  Get.bottomSheet(
    SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(18.0.r),
          child: Column(
            children: [
              SizedBox(height: 10.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: AppCustomText(
                      text: title,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0.sp,
                      color: HexColor("ED3A3A"),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.0.h),
              SvgPicture.asset(
                AppUtils.getIconPath("ic_delete_confirm"),
                width: 265.0.w,
                height: 148.0.h,
              ),
              SizedBox(height: 36.0.h),
              AppCustomText(
                text: title,
                fontWeight: FontWeight.w500,
                fontSize: 16.0.sp,
                color: AppTheme.text17,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: AppButton(
                      text: delete,
                      onPressed:
                          function ??
                          () {
                            Get.back();
                          },
                    ),
                  ),
                  SizedBox(width: 16.0.w),
                  Expanded(
                    flex: 1,
                    child: AppButton(
                      text: cancel,
                      variant: ButtonVariant.outline,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    backgroundColor: Colors.white,
    enableDrag: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0.r),
        topRight: Radius.circular(20.0.r),
      ),
    ),
  );
}

confirmBottomSheet() {
  Get.bottomSheet(
    barrierColor: Colors.black.withValues(alpha: 0.70),
    SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(18.0.r),
          child: Column(
            children: [
              SizedBox(height: 10.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: AppCustomText(
                      text: LangKeys.signIn.tr,
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.0.h),
              SvgPicture.asset(
                AppUtils.getIconPath("ic_login_bs"),
                width: 265.0.w,
                height: 160.0.h,
              ),
              SizedBox(height: 36.0.h),
              AppCustomText(
                text: LangKeys.pleaseLoginProcess.tr,
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 20.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: AppButton(
                      text: LangKeys.signIn.tr,
                      onPressed: () {
                        Get.back();
                        Get.toNamed(AppRoutes.signIn);
                      },
                    ),
                  ),
                  SizedBox(width: 16.0.w),
                  Expanded(
                    flex: 1,
                    child: AppButton(
                      text: LangKeys.cancel.tr,
                      variant: ButtonVariant.outline,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    backgroundColor: Colors.white,
    enableDrag: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0.r),
        topRight: Radius.circular(20.0.r),
      ),
    ),
  );
}

showSuccessBottomSheet(
  String message, {
  VoidCallback? onClick,
  String? textBtn,
}) {
  if (Get.isBottomSheetOpen != null && !Get.isBottomSheetOpen!) {
    Get.bottomSheet(
      PopScope(
        canPop: false,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: 9.w,
              end: 9.w,
              top: 30.h,
              bottom: 30.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SvgPicture.asset(
                  AppUtils.getIconPath("ic_sucsess"),
                  width: 100.0.w,
                  height: 100.h,
                ),
                SizedBox(height: 16.0.h),
                AppCustomText(
                  text: LangKeys.success.tr,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: HexColor("ED3A3A"),
                ),
                SizedBox(height: 16.0.h),
                AppCustomText(
                  text: message,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                  textAlign: TextAlign.center,
                  color: AppTheme.text17,
                ),
                SizedBox(height: 30.0.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0.w),
                  child: AppButton(
                    text: textBtn ?? LangKeys.ok.tr,
                    onPressed:
                        onClick ??
                        () {
                          Get.back();
                        },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0.r),
          topRight: Radius.circular(16.0.r),
        ),
      ),
    );
  }
}
