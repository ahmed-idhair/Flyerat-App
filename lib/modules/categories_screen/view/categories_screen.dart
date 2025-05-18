import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/app/widgets/common/app_empty_state.dart';
import 'package:offers/core/models/home/category.dart';
import 'package:offers/modules/categories_screen/controller/categories_controller.dart';

import '../../../app/config/app_theme.dart';
import '../../../app/widgets/common/app_loading_view.dart';
import '../../../app/widgets/common/app_network_image.dart';
import '../../../app/widgets/common/app_shimmer_loading.dart';
import '../../../app/widgets/forms/app_custom_text.dart';
import '../../../app/widgets/forms/app_search_field.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  CategoriesController controller = Get.put(CategoriesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          controller.partner != null
              ? CustomAppBar(
                title:
                    controller.partner != null
                        ? controller.partner?.name ?? ""
                        : LangKeys.categories.tr,
              )
              : null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: EdgeInsetsDirectional.only(bottom: 16.h),
              child: AppSearchField(
                hintText: LangKeys.search.tr,
                onChanged: (value) {
                  controller.searchQuery.value = value;
                },
                onSubmitted: () {
                  controller.fetchCategories();
                },
                showActionButton: true,
                onActionButtonPressed: () {
                  controller.fetchDepartments();
                },
              ),
            ),
            // Department tabs
            Obx(() {
              if (controller.isLoadingDepartments.value) {
                return Center(child: AppLoadingView());
              }
              if (controller.departments.isEmpty) {
                return SizedBox();
              }
              return SizedBox(
                height: 45.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: 0.w,
                    vertical: 2.5.h,
                  ),
                  itemCount: controller.departments.length,
                  itemBuilder: (context, index) {
                    final department = controller.departments[index];
                    return Obx(() {
                      final isSelected =
                          controller.selectedDepartmentId.value ==
                          department.id;
                      return _buildDepartmentTab(department, isSelected);
                    });
                  },
                ),
              );
            }),

            // All Categories header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 16.h),
              child: AppCustomText(
                text: LangKeys.allCategories.tr,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            // Categories grid
            Expanded(
              child: Obx(() {
                if (controller.isLoadingCategories.value) {
                  return SizedBox(
                    // Explicitly give it width constraints
                    width: ScreenUtil().screenWidth,
                    // height: 200.h, // or another reasonable height
                    child: const ShimmerLoading(
                      itemCount: 6,
                      type: ShimmerType.grid,
                      // Optionally set aspectRatio to match your actual items
                    ),
                  );
                }

                if (controller.categories.isEmpty) {
                  return AppEmptyState(message: LangKeys.noCategoriesFound.tr);
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchCategories(),
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 0.w,
                      vertical: 8.h,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 14.h,
                      crossAxisSpacing: 14.w,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];
                      return _buildCategoryItem(category);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentTab(Category department, bool isSelected) {
    return GestureDetector(
      onTap: () {
        controller.selectDepartment(department.id ?? 0);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsetsDirectional.symmetric(
          vertical: 8.h,
          horizontal: 10.w,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 1,
              spreadRadius: 0,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: AppCustomText(
            text: department.name ?? "",
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(Category category) {
    return GestureDetector(
      onTap: () {
        controller.navigateToCategory(category);
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: ScreenUtil().screenWidth,
              padding: EdgeInsetsDirectional.all(4.r),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: HexColor("ACACAC"), width: 0.2.w),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: AppNetworkImage(
                imageUrl: category.image ?? "",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
                borderRadius: 0,
              ),
            ),
          ),

          // Category Name
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Row(
              children: [
                Expanded(
                  child: AppCustomText(
                    text: category.name ?? "",
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                Visibility(
                  visible: category.productsCount != 0,
                  child: Container(
                    margin: EdgeInsetsDirectional.only(start: 4.w),
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 5.w,
                      vertical: 1.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadiusDirectional.all(
                        Radius.circular(20.r),
                      ),
                    ),
                    child: AppCustomText(
                      text: category.productsCount.toString(),
                      fontSize: 10.sp,
                      height: 0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
