import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/app/services/storage_service.dart';
import 'package:offers/app/utils/app_utils.dart';

import '../../../modules/public_controller.dart';
import '../../../modules/select_location/controller/user_location_controller.dart';
import '../../../modules/select_location/widget/location_bottom_sheet.dart';
import '../common/app_bottom_sheet.dart';
import '../forms/app_custom_text.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomHomeAppBar({Key? key}) : super(key: key);

  final publicController = Get.find<StorageService>();

  @override
  Size get preferredSize {
    // Calculate the preferred height based on content
    // Base height for SafeArea + padding
    double baseHeight = kToolbarHeight;

    // Add extra height for the row content (adjust as needed)
    // This includes the vertical padding, text height, and any extra spacing
    double contentHeight = 56.h;
    return Size.fromHeight(baseHeight + contentHeight);
  }

  @override
  Widget build(BuildContext context) {
    final country = publicController.getSelectedCountry()?.name ?? "Jordan";
    final city = publicController.getSelectedCity()?.name ?? "Amman";
    // Initialize controller
    return Container(
      // Remove fixed height to allow container to wrap its content
      // height: preferredSize.height,
      decoration: BoxDecoration(
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.2),
        //     spreadRadius: 1,
        //     blurRadius: 5,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Location icon with circle background
              SvgPicture.asset(
                AppUtils.getIconPath("ic_location_home"),
                width: 34.w,
                height: 34.h,
              ),
              SizedBox(width: 16.w),
              // Location text
              Expanded(
                child: InkWell(
                  onTap: () {

                    _showLocationSelectionSheet(context);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min, // Important for wrapping
                    children: [
                      AppCustomText(
                        text: "Your Location",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: HexColor("898989"),
                      ),
                      4.verticalSpace,
                      AppCustomText(
                        text: "$country, $city",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: HexColor("A27169"),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.livesScreen);
                },
                icon: SvgPicture.asset(
                  AppUtils.getIconPath("ic_live_home"),
                  width: 25.w,
                  height: 25.h,
                ),
                padding: EdgeInsets.zero, // Reduce button padding
                constraints: const BoxConstraints(), // Remove constraints
              ),
              10.horizontalSpace,
              // Notification icon with badge
              Container(
                width: 50.w,
                height: 50.h,
                alignment: AlignmentDirectional.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        AppUtils.getIconPath("ic_notifications_home"),
                        width: 24.w,
                        height: 24.h,
                      ),
                      onPressed: () {
                        if (publicController.isAuth()) {
                          Get.toNamed(AppRoutes.notificationsScreen);
                        } else {
                          confirmBottomSheet();
                        }
                      },
                      padding: EdgeInsets.zero, // Reduce button padding
                      constraints: const BoxConstraints(), // Remove constraints
                    ),
                    Obx(
                      () =>
                          Get.find<PublicController>().notCount.value == 0
                              ? PositionedDirectional(
                                end: 12.w,
                                top: 9.h,
                                child: Container(
                                  width: 12.w,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.w,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                              : SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLocationSelectionSheet(BuildContext context) {
    // Check if the controller is already registered
    if (!Get.isRegistered<UserLocationController>()) {
      Get.put(UserLocationController());
    }

    final locationController = Get.find<UserLocationController>();

    // Load current values from storage or PublicController
    final publicController = locationController.storage;
    locationController.selectedCountry.value =
        publicController.getSelectedCountry();
    locationController.selectedCity.value = publicController.getSelectedCity();

    // Show bottom sheet
    Get.bottomSheet(
      LocationBottomSheet(isChangingLocation: true,),
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
    ).then((_) {
      // After bottom sheet is closed, update the values in PublicController
      if (locationController.selectedCountry.value != null &&
          locationController.selectedCity.value != null) {
        // Save to storage
        locationController.storage.saveSelectedCountry(
          locationController.selectedCountry.value!,
        );
        locationController.storage.saveSelectedCity(
          locationController.selectedCity.value!,
        );

        // Update location coordinates if available
        if (locationController.hasLocationPermission.value) {
          locationController.storage.saveUserLocation(
            locationController.latitude.value,
            locationController.longitude.value,
          );
        }
      }
    });
  }
}
