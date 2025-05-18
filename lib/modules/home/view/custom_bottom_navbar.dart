import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:offers/modules/home/controller/home_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.find<HomeController>();

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor, // Orange color from the image
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNavItem(
                      "ic_home",
                      LangKeys.home.tr,
                      controller.selectedIndex.value == 0,
                      onTap: () => controller.changeIndex(0),
                    ),
                    _buildNavItem(
                      "ic_cat",
                      LangKeys.category.tr,
                      controller.selectedIndex.value == 1,
                      onTap: () => controller.changeIndex(1),
                    ),
                    _buildNavItem(
                      "ic_fav_home",
                      LangKeys.wishlist.tr,
                      controller.selectedIndex.value == 2,
                      // isCenter: true,
                      onTap: () => controller.changeIndex(2),
                    ),
                    _buildNavItem(
                      "ic_settings",
                      LangKeys.settings.tr,
                      controller.selectedIndex.value == 3,
                      onTap: () => controller.changeIndex(3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // // Indicator line
          // Container(
          //   height: 4.h,
          //   margin: EdgeInsets.symmetric(horizontal: 65.w, vertical: 8.h),
          //   decoration: BoxDecoration(
          //     color: Colors.white.withOpacity(0.3),
          //     borderRadius: BorderRadius.circular(2.r),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Custom Navigation Item
  Widget _buildNavItem(
    String iconName,
    String title,
    bool isSelected, {
    bool isCenter = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        padding: EdgeInsets.symmetric(
          horizontal: isCenter ? 10.w : (isSelected ? 12.w : 5.w),
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: isCenter || isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppUtils.getIconPath(iconName),
              width: 22.w,
              height: 22.h,
              colorFilter: ColorFilter.mode(
                isSelected ? AppTheme.primaryColor : Colors.white,
                BlendMode.srcIn,
              ),
            ),
            if (isCenter || isSelected) ...[
              SizedBox(width: 5.w),
              AppCustomText(
                text: title,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: AppTheme.primaryColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
