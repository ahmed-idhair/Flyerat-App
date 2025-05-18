import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/buttons/app_button.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';

import '../../../../app/widgets/common/app_network_image.dart';

class ItemOnBoarding extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final int currentIndex;
  final int totalPages;
  final bool isLastPage;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const ItemOnBoarding({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.currentIndex,
    required this.totalPages,
    required this.isLastPage,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: HexColor("F9B9AD"), // Salmon/peach background color
        child: Column(
          children: [
            70.verticalSpace,
            AppNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              width: 232.w,
              height: 228.h,
              borderRadius: 0,
            ),
            70.verticalSpace,
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 28.h),
                decoration: BoxDecoration(
                  color: Color(0xFFE25E3E), // Orange/coral color
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    // Page indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        totalPages,
                        (index) => Container(
                          width: index == currentIndex ? 32.w : 15.w,
                          height: 4,
                          margin: EdgeInsets.symmetric(horizontal: 3.w),
                          decoration: BoxDecoration(
                            color:
                                index == currentIndex
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                      ),
                    ),
                    24.verticalSpace,
                    // Title
                    AppCustomText(
                      text: title,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    16.verticalSpace,
                    // Description
                    AppCustomText(
                      text: description,
                      fontSize: 14.sp,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    24.verticalSpace,
                    // Skip button
                    if (!isLastPage)
                      TextButton(
                        onPressed: onSkip,
                        child: AppCustomText(
                          text: LangKeys.skip.tr,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 17.sp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    8.verticalSpace,
                    // Next button
                    AppButton(
                      text: isLastPage ? 'Get Started' : LangKeys.next.tr,
                      onPressed: onNext,
                      textColor: AppTheme.primaryColor,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
