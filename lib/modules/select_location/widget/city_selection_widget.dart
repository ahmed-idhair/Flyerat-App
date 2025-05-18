// lib/modules/splash/view/city_selection_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/common/app_loading_view.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';

import '../../../app/extensions/color.dart';
import '../../../app/widgets/common/app_empty_state.dart';
import '../controller/user_location_controller.dart';

class CitySelectionWidget extends StatelessWidget {
  final UserLocationController controller = Get.find<UserLocationController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCustomText(
          text: LangKeys.chooseCity.tr,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        10.verticalSpace,
        // Subtitle
        AppCustomText(
          text: LangKeys.pleaseChooseYourCity.tr,
          fontSize: 14.sp,
          color: HexColor("7D7D7D"),
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
        ),
        Divider(color: HexColor("D2D2D2"), thickness: 0.5, height: 19.h),

        // Cities list
        Expanded(
          child: Obx(() {
            if (controller.isLoadingCities.value) {
              return Center(child: AppLoadingView());
            }

            if (controller.cities.isEmpty) {
              return AppEmptyState(
                message: LangKeys.noCitiesAvailable.tr,
                actionText: LangKeys.retry.tr,
                onActionPressed: () {
                  controller.fetchCountries();
                },
              );
            }
            return ListView.builder(
              itemCount: controller.cities.length,
              itemBuilder: (context, index) {
                final city = controller.cities[index];
                return ListTile(
                  title: AppCustomText(
                    text: city.name ?? "",
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: HexColor("2C2C2E"),
                  ),
                  leading: Transform.scale(
                    scale: 0.9, // Adjust this value to control the size
                    child: Radio<int>(
                      value: city.id ?? 0,
                      groupValue: controller.selectedCity.value?.id,
                      onChanged: (_) => controller.selectCity(city),
                      activeColor: AppTheme.primaryColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduces the tap target size
                      visualDensity: VisualDensity.compact, // Makes the widget more compact
                    ),
                  ),
                  dense: true,
                  // Makes the ListTile more compact
                  contentPadding: EdgeInsets.symmetric(horizontal: 0.w),
                  onTap: () => controller.selectCity(city),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
