import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/common/app_empty_state.dart';
import 'package:offers/app/widgets/common/app_loading_view.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:offers/core/models/home/location_data.dart';

import '../controller/locations_controller.dart';

class LocationsBottomSheet extends StatelessWidget {
  const LocationsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationsController controller = Get.put(LocationsController());

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.r),
          topRight: Radius.circular(15.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with title and close button
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  padding: EdgeInsetsDirectional.zero,
                  onPressed: () => Get.back(),
                ),
                Expanded(
                  child: AppCustomText(
                    textAlign: TextAlign.center,
                    text: LangKeys.locations.tr,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.transparent),
                  onPressed: () {},
                ),
                // SizedBox(width: 40.w),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppCustomText(
                  text: LangKeys.allAvailableLocations.tr,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: HexColor("7D7D7D"),
                ),
                // Divider
                Divider(
                  color: HexColor("D2D2D2"),
                  height: 20.h,
                  thickness: 0.5.h,
                ),

                // Locations list
                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.r),
                        child: AppLoadingView(),
                      ),
                    );
                  }

                  if (controller.locations.isEmpty) {
                    return Center(
                      child: AppEmptyState(message: LangKeys.noData.tr),
                    );
                  }

                  return Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: controller.locations.length,
                      itemBuilder: (context, index) {
                        final location = controller.locations[index];
                        return _buildLocationItem(location, controller);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          // All locations subtitle
        ],
      ),
    );
  }

  Widget _buildLocationItem(
    LocationData location,
    LocationsController controller,
  ) {
    return InkWell(
      onTap: () => controller.selectLocation(location),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location name
                  AppCustomText(
                    text: location.name ?? "",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 4.h),
                  // Location address or description
                  AppCustomText(
                    text: location.address ?? "",
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            // Location icon
            SvgPicture.asset(
              AppUtils.getIconPath("ic_marker"),
              width: 18.w,
              height: 18.h,
            ),
          ],
        ),
      ),
    );
  }
}
