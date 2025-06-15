import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/buttons/app_button.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:offers/modules/select_location/controller/user_location_controller.dart';

import '../../../app/services/fcm_service.dart';

class LocationPermissionScreen extends StatelessWidget {
  final UserLocationController controller = Get.find<UserLocationController>();
  final bool fromLocationChange;
  final FCMService _fcmService = FCMService();

  LocationPermissionScreen({super.key, this.fromLocationChange = false});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: fromLocationChange,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // إذا لم يكن تغيير موقع ولا توجد بيانات موقع، لا تسمح بالرجوع
        if (!fromLocationChange && !controller.storage.hasLocationData()) {
          // اختياري: إظهار رسالة للمستخدم
          Get.snackbar(
            "تنبيه",
            "يجب اختيار الموقع للمتابعة",
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        // السماح بالرجوع
        Get.back();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                10.verticalSpace,
                // Spacer(flex: 1),

                // Location icon
                SvgPicture.asset(
                  AppUtils.getIconPath("ic_select_location"),
                  width: 80.w,
                  height: 80.h,
                ),

                24.verticalSpace,

                // Title
                AppCustomText(
                  text: LangKeys.whatIsYourLocation.tr,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: HexColor("323135"),
                ),

                16.verticalSpace,

                // Description
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: AppCustomText(
                    text: LangKeys.weNeedToKnowYourLocation.tr,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: HexColor("68656E"),
                    textAlign: TextAlign.center,
                  ),
                ),

                32.verticalSpace,

                // Selected country and city info
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppCustomText(
                            text: "${LangKeys.country.tr}:",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: HexColor("323135"),
                          ),
                          AppCustomText(
                            text: controller.selectedCountry.value?.name ?? "",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor("323135"),
                          ),
                        ],
                      ),
                      8.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppCustomText(
                            text: "${LangKeys.city.tr}:",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: HexColor("323135"),
                          ),
                          AppCustomText(
                            text: controller.selectedCity.value?.name ?? "",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor("323135"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                32.verticalSpace,

                // Location status indicator
                Obx(
                  () =>
                      controller.hasLocationPermission.value
                          ? _buildLocationSuccessWidget()
                          : _buildLocationButtonWidget(),
                ),

                Spacer(flex: 2),
                // Continue button
                Obx(
                  () => AppButton(
                    text:
                        fromLocationChange
                            ? LangKeys.save.tr
                            : LangKeys.continueText.tr,
                    isLoading: controller.isLoadingLocation.value,
                    onPressed: () async {
                      // Navigate to appropriate screen
                      if (fromLocationChange) {
                        Get.offAllNamed(AppRoutes.home);
                      } else {
                        if (controller.storage.isIntro()) {
                          if (controller.storage.isAuth()) {
                            controller.updateLocation();
                          } else {
                            await _fcmService.subscribeToCountry(
                              controller.storage.getSelectedCountry()!.id!,
                            );
                            await _fcmService.subscribeToCity(
                              controller.storage.getSelectedCity()!.id!,
                            );
                            Get.offAllNamed(AppRoutes.signIn);
                          }
                        } else {
                          await _fcmService.subscribeToCountry(
                            controller.storage.getSelectedCountry()!.id!,
                          );
                          await _fcmService.subscribeToCity(
                            controller.storage.getSelectedCity()!.id!,
                          );
                          Get.offAllNamed(AppRoutes.onBoarding);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSuccessWidget() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(Icons.check_circle, color: Colors.green, size: 32.r),
        ),

        16.verticalSpace,

        AppCustomText(
          text: LangKeys.locationAccessGranted.tr,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.green,
        ),

        8.verticalSpace,

        // Show location coordinates for confirmation
        AppCustomText(
          text:
              "${controller.latitude.value.toStringAsFixed(6)}, ${controller.longitude.value.toStringAsFixed(6)}",
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: HexColor("68656E"),
        ),
      ],
    );
  }

  Widget _buildLocationButtonWidget() {
    return Column(
      children: [
        // Allow location access button
        AppButton(
          text: LangKeys.allowLocationAccess.tr,
          onPressed: _handleLocationRequest,
        ),

        16.verticalSpace,

        // Skip option
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: AppCustomText(
            text: LangKeys.locationOptionalHint.tr,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: HexColor("68656E"),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Future<void> _handleLocationRequest() async {
    try {
      // Request location service to be enabled
      bool serviceEnabled = false;
      try {
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      } catch (e) {
        print("Error checking location services: $e");
      }

      if (!serviceEnabled) {
        // Try to request location service to be enabled
        try {
          serviceEnabled = await Geolocator.openLocationSettings();
        } catch (e) {
          print("Error opening location settings: $e");
        }

        if (!serviceEnabled) {
          _showLocationError(
            LangKeys.locationServicesDisabled.tr,
            LangKeys.pleaseEnableLocationServices.tr,
          );
          return;
        }
      }

      // Continue with permission checks
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.deniedForever) {
        _showLocationError(
          LangKeys.locationPermissionPermanentlyDenied.tr,
          LangKeys.pleaseEnableLocationInSettings.tr,
          showSettingsButton: true,
        );
        return;
      }

      // Try to get location
      final success = await controller.requestAndGetLocation();
      if (!success) {
        _showLocationError(
          LangKeys.locationPermissionDenied.tr,
          LangKeys.pleaseGrantLocationPermission.tr,
        );
      }
    } catch (e) {
      print("Error handling location request: $e");
      // Directly try to get location without preliminary checks
      _attemptDirectLocationRequest();
    }
  }

  // Alternative approach if Geolocator methods are causing issues
  void _attemptDirectLocationRequest() {
    // Directly try to get location without preliminary checks
    controller.requestAndGetLocation().then((success) {
      if (!success) {
        _showLocationError(
          LangKeys.locationError.tr,
          LangKeys.locationAccessFailed.tr,
        );
      }
    });
  }

  void _showLocationError(
    String title,
    String message, {
    bool showSettingsButton = false,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red[600],
      colorText: Colors.white,
      duration: Duration(seconds: 5),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(Icons.location_off, color: Colors.white),
      mainButton:
          showSettingsButton
              ? TextButton(
                onPressed: () => Geolocator.openAppSettings(),
                child: Text(
                  LangKeys.openSettings.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              : null,
    );
  }
}
