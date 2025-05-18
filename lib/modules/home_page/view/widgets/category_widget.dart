import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:offers/core/models/home/category.dart';
import 'package:offers/modules/home_page/controller/home_page_controller.dart';

class CategoryWidget extends StatelessWidget {
  final List<Category> categories;

  const CategoryWidget({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final HomePageController controller = Get.find<HomePageController>();
    return Container(
      height: 43.h,
      margin: EdgeInsetsDirectional.only(top: 20.h, bottom: 6.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 2.5.h),
        itemBuilder: (context, index) {
          final category = categories[index];
          final int categoryId = category.id ?? 0;
          return Obx(() {
            final bool isSelected =
                controller.selectedCategoryId.value == categoryId;
            return GestureDetector(
              onTap: () => controller.selectCategory(categoryId),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: _buildCategoryItem(
                  category.name ?? "",
                  category.partnersCount ?? 0,
                  isSelected,
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildCategoryItem(String title, int partnersCount, bool isSelected) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsetsDirectional.symmetric(vertical: 8.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 1,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppCustomText(
            text: title,
            fontSize: 12.sp,
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
          Visibility(visible: partnersCount != 0, child: SizedBox(width: 8.h)),
          Visibility(
            visible: partnersCount != 0,
            child: Container(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 6.w,
                vertical: 3.h,
              ),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : AppTheme.primaryColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadiusDirectional.all(
                  Radius.circular(20.r),
                ),
              ),
              child: AppCustomText(
                text: partnersCount.toString(),
                fontSize: 12.sp,
                height: 0,
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
