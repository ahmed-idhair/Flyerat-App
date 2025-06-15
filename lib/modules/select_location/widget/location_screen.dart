import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/app/widgets/buttons/app_button.dart';
import 'package:offers/modules/select_location/widget/city_selection_widget.dart';
import 'package:offers/modules/select_location/widget/country_selection_widget.dart';
import 'package:offers/modules/select_location/controller/user_location_controller.dart';

import '../view/location_permission_screen.dart';

class LocationScreen extends StatelessWidget {
  final UserLocationController controller = Get.put(UserLocationController());
  final bool isChangingLocation;

  LocationScreen({super.key, this.isChangingLocation = false});

  @override
  Widget build(BuildContext context) {
    final isInitialSetup = !controller.storage.hasLocationData() && !isChangingLocation;

    // If changing location, reset selections to allow new choices
    if (isChangingLocation) {
      controller.resetSelections();
    }

    return PopScope(
      canPop: !isInitialSetup,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // إذا كان الإعداد الأولي، لا تسمح بالرجوع
        if (isInitialSetup) {
          Get.snackbar(
            "تنبيه",
            "يجب إكمال اختيار الموقع",
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        // السماح بالرجوع
        Get.back();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title:
              isChangingLocation
                  ? LangKeys.changeLocation.tr
                  : LangKeys.selectLocation.tr,
          isShowBack: !isInitialSetup,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
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
                        // if (isChangingLocation) {
                        //   // If changing location, go back to the previous screen
                        //   Get.back();
                        // } else {
                        // Navigate to location permission screen
                        Get.off(
                          () => LocationPermissionScreen(
                            fromLocationChange: isChangingLocation,
                          ),
                        );
                        // }
                      });
                      return Center(
                        child: CircularProgressIndicator(),
                      ); // Placeholder while navigating
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
                        if (controller.selectedCountry.value != null &&
                            controller.selectedCity.value != null) {
                          // Save to storage
                          controller.storage.saveSelectedCountry(
                            controller.selectedCountry.value!,
                          );
                          controller.storage.saveSelectedCity(
                            controller.selectedCity.value!,
                          );
                          // Update location coordinates if available
                          if (controller.hasLocationPermission.value) {
                            controller.storage.saveUserLocation(
                              controller.latitude.value,
                              controller.longitude.value,
                            );
                          }
                        }
                        Get.to(
                          () => LocationPermissionScreen(
                            fromLocationChange: isChangingLocation,
                          ),
                        );
                        // if (isChangingLocation) {
                        //   // If changing location, just go back
                        //   Get.back();
                        // } else {
                        //   // Navigate to location permission screen
                        //
                        // }
                      },
                    );
                  }
                  return SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
