import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/buttons/app_button.dart';
import 'package:offers/modules/select_location/widget/city_selection_widget.dart';
import 'package:offers/modules/select_location/widget/country_selection_widget.dart';
import 'package:offers/modules/select_location/controller/user_location_controller.dart';

class LocationBottomSheet extends StatelessWidget {
  final UserLocationController controller = Get.find<UserLocationController>();
  final bool isChangingLocation;

  LocationBottomSheet({super.key, this.isChangingLocation = false});

  @override
  Widget build(BuildContext context) {
    final isInitialSetup =
        !controller.storage.hasLocationData() && !isChangingLocation;
    // If changing location, reset selections to allow new choices
    if (isChangingLocation) {
      controller.resetSelections();
    }
    return WillPopScope(
      onWillPop: () async {
        // Prevent back button
        // Only prevent back button during initial setup
        return !isInitialSetup;
      },
      child: GestureDetector(
        // Prevent closing when tapping outside
        onTap: () {},
        child: Container(
          height: ScreenUtil().screenHeight * 0.75,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          child: Column(
            children: [
              // Handle at top
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              // Add close button when not in initial setup
              if (!isInitialSetup)
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ),

              // Content area
              Expanded(
                child: Obx(() {
                  if (controller.selectedCountry.value == null) {
                    // Step 1: Country selection
                    return CountrySelectionWidget();
                  } else if (controller.selectedCity.value == null) {
                    // Step 2: City selection
                    return CitySelectionWidget();
                  } else {
                    // Step 3: Navigate to location permission screen
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      // Close bottom sheet first
                      Get.back();
                      // Then navigate to location permission screen
                      Get.toNamed(AppRoutes.locationPermissionScreen);
                    });
                    return Container(); // Placeholder while navigating
                  }
                }),
              ),

              // Bottom action button - only shown if city is selected
              Obx(() {
                if (controller.selectedCountry.value != null &&
                    controller.selectedCity.value != null) {
                  return AppButton(
                    text: LangKeys.continueText.tr,
                    isLoading: controller.isLoadingLocation.value,
                    onPressed: () {
                      // Close bottom sheet
                      Get.back();
                      Get.toNamed(AppRoutes.locationPermissionScreen);
                      // Navigate to location permission screen
                    },
                  );
                }
                return SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
