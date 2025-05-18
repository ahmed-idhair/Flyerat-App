import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/app/widgets/common/app_empty_state.dart';
import 'package:offers/app/widgets/common/app_loading_view.dart';
import 'package:offers/app/widgets/common/app_shimmer.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:offers/core/models/home/flyer.dart';
import 'package:offers/core/models/home/location_data.dart';
import 'package:offers/modules/categories_screen/controller/categories_controller.dart';
import 'package:offers/modules/partner_details/controller/partner_details_controller.dart';
import 'package:offers/modules/partner_details/view/widgets/partner_flyer_widget.dart';

import '../../../app/widgets/common/app_shimmer_loading.dart';
import '../../../app/widgets/forms/app_search_field.dart';
import '../controller/locations_controller.dart';
import 'locations_bottom_sheet.dart';

class PartnerDetails extends StatelessWidget {
  PartnerDetails({super.key});

  PartnerDetailsController controller = Get.put(PartnerDetailsController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PartnerDetailsController>(
      id: 'updatePartner',
      builder: (controller) {
        if (controller.isLoading.isTrue) {
          return AppLoadingView();
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: controller.partner?.name ?? "",
            actions: [
              IconButton(
                icon: SvgPicture.asset(
                  AppUtils.getIconPath("ic_locations"),
                  height: 24.h,
                  width: 24.w,
                ),
                onPressed: () {
                  showPartnerLocationsBottomSheet(
                    controller.partnerId.toString(),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                controller.partner != null
                    ? Column(
                      children: [
                        AppSearchField(
                          hintText: LangKeys.search.tr,
                          controller: controller.searchController,
                          onChanged: (value) {
                            if (value.isEmpty &&
                                controller.searchQuery.isNotEmpty) {
                              controller.clearSearch();
                            }
                          },
                          onSubmitted: () {
                            controller.performSearch();
                            // Do something when search is submitted
                          },
                          height: 48.h,
                        ),
                        16.verticalSpace,
                        // Nearest Branch Info
                        Obx(
                          () =>
                              controller.nearestLocation.value != null
                                  ? _buildNearestBranchInfo()
                                  : SizedBox(),
                        ),
                        _buildActionButtons(),
                      ],
                    )
                    : SizedBox(),
                _buildFlyersGrid(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNearestBranchInfo() {
    return Container(
      margin: EdgeInsetsDirectional.only(top: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppCustomText(
                  text: LangKeys.nearestBranch.tr,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
              ),
              InkWell(
                onTap: () {
                  AppUtils.openLocationInGoogleMaps(
                    controller.nearestLocation.value?.lat ?? "0.0",
                    controller.nearestLocation.value?.lng ?? "0.0",
                  );
                },
                child: SvgPicture.asset(
                  AppUtils.getIconPath("ic_marker"),
                  width: 18.w,
                  height: 18.h,
                ),
              ),
            ],
          ),
          8.verticalSpace,
          AppCustomText(
            text: controller.nearestLocation.value?.name ?? "",
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            color: HexColor("2C2C2E"),
          ),
          AppCustomText(
            text: controller.nearestLocation.value?.address ?? "",
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: HexColor("959595"),
          ),
          // 4.verticalSpace,
          Row(
            children: [
              AppCustomText(
                text: "${LangKeys.distance.tr}: ",
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: HexColor("5C5C5C"),
              ),
              Expanded(
                child: AppCustomText(
                  textAlign: TextAlign.start,
                  text: controller.nearestLocation.value?.distance ?? "",
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: HexColor("959595"),
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Divider(color: HexColor("D2D2D2"), thickness: 0.5, height: 0),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        16.verticalSpace,
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.local_offer_outlined,
                  size: 18.r,
                  color: Colors.white,
                ),
                label: AppCustomText(
                  text: LangKeys.offers.tr,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  // padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: () {},
              ),
            ),
            13.horizontalSpace,
            Expanded(
              child: ElevatedButton.icon(
                icon: SvgPicture.asset(
                  AppUtils.getIconPath("ic_view_products"),
                  width: 18.w,
                  height: 18.h,
                ),
                label: AppCustomText(
                  text: LangKeys.viewProducts.tr,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  // padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: () {
                  if (controller.partner != null) {
                    Get.delete<CategoriesController>();
                    Get.toNamed(
                      AppRoutes.categoriesScreen,
                      arguments: {"partner": controller.partner},
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFlyersGrid() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          controller.clearSearch();
        },
        color: AppTheme.primaryColor,
        child: PagedGridView<int, Flyer>(
          padding: EdgeInsetsDirectional.only(top: 16.h),
          pagingController: controller.pagingController,
          physics: AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 0.9,
          ),
          builderDelegate: PagedChildBuilderDelegate<Flyer>(
            itemBuilder: (context, flyer, index) {
              return PartnerFlyerWidget(data: flyer);
            },
            firstPageErrorIndicatorBuilder: (_) {
              return AppEmptyState(message: controller.pagingController.error);
            },
            noItemsFoundIndicatorBuilder:
                (_) => AppEmptyState(
                  message: LangKeys.noFlyersAvailable.tr,
                  // img: "ic_no_notification",
                ),
            newPageErrorIndicatorBuilder:
                (_) =>
                    AppEmptyState(message: controller.pagingController.error),
            firstPageProgressIndicatorBuilder:
                (_) => SizedBox(
                  // Explicitly give it width constraints
                  width: ScreenUtil().screenWidth,
                  height: 400.h, // or another reasonable height
                  child: const ShimmerLoading(
                    type: ShimmerType.grid,
                    itemCount: 6,
                    // Optionally set aspectRatio to match your actual items
                    aspectRatio: 0.9,
                  ),
                ),
            newPageProgressIndicatorBuilder:
                (_) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50.0.w,
                      height: 50.0.h,
                      child: const AppLoadingView(),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search here for any thing',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
          prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
        onPressed: () => Get.back(),
      ),
      title: Row(
        children: [
          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  'https://logo.clearbit.com/luluhypermarket.com',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            'Lulu Hypermarket',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.favorite_border, color: Colors.red, size: 24.sp),
          onPressed: () {},
        ),
      ],
    );
  }

  void showPartnerLocationsBottomSheet(String partnerId) {
    if (partnerId == "0" || partnerId.isEmpty) {
      return;
    }
    Get.delete<LocationsController>();
    Get.put(LocationsController(partnerId: partnerId));
    Get.bottomSheet(
      LocationsBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    ).then((selectedLocation) {
      if (selectedLocation != null) {
        LocationData locationData = selectedLocation;
        print('Log selectedLocation ${locationData.name}');
        AppUtils.openLocationInGoogleMaps(
          locationData.lat ?? "0.0",
          locationData.lng ?? "0.0",
        );
        // Handle the selected location
      }
    });
  }
}
