// lib/modules/splash/view/country_selection_widget.dart
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

import '../controller/user_location_controller.dart';

class CountrySelectionWidget extends StatelessWidget {
  final UserLocationController controller = Get.find<UserLocationController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // // Illustration
        // SvgPicture.asset(
        //   AppUtils.getIconPath("ic_country_selection"),
        //   width: 120.w,
        //   height: 120.h,
        // ),
        // SizedBox(height: 24.h),

        // Title
        AppCustomText(
          text: LangKeys.chooseCountry.tr,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        10.verticalSpace,
        // Subtitle
        AppCustomText(
          text: LangKeys.pleaseChooseYourCountry.tr,
          fontSize: 14.sp,
          color: HexColor("7D7D7D"),
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
        ),
        Divider(color: HexColor("D2D2D2"), thickness: 0.5, height: 19.h),
        // Countries list
        Expanded(
          child: Obx(() {
            if (controller.isLoadingCountries.value) {
              return Center(child: AppLoadingView());
            }

            if (controller.countries.isEmpty) {
              return AppEmptyState(
                message: LangKeys.noCountriesAvailable.tr,
                actionText: LangKeys.retry.tr,
                onActionPressed: () {
                  controller.fetchCountries();
                },
              );
            }
            return ListView.builder(
              itemCount: controller.countries.length,
              // separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final country = controller.countries[index];
                return ListTile(
                  title: AppCustomText(
                    text: country.name ?? "",
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: HexColor("2C2C2E"),
                  ),
                  leading: Transform.scale(
                    scale: 0.9, // Adjust this value to control the size
                    child: Radio<int>(
                      value: country.id ?? 0,
                      groupValue: controller.selectedCity.value?.id,
                      onChanged: (_) => controller.selectCountry(country),
                      activeColor: AppTheme.primaryColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // Reduces the tap target size
                      visualDensity:
                          VisualDensity
                              .compact, // Makes the widget more compact
                    ),
                  ),
                  dense: true,
                  // Makes the ListTile more compact
                  contentPadding: EdgeInsets.symmetric(horizontal: 0.w),
                  // Adjust tile padding
                  onTap: () => controller.selectCountry(country),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
