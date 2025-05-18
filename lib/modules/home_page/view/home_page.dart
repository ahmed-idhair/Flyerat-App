import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/common/app_empty_state.dart';
import 'package:offers/app/widgets/common/app_loading_view.dart';
import 'package:offers/modules/home_page/controller/home_page_controller.dart';
import 'package:offers/modules/home_page/view/widgets/banner_widget.dart';
import 'package:offers/modules/home_page/view/widgets/category_widget.dart';
import 'package:offers/modules/home_page/view/widgets/flyer_widget.dart';
import 'package:offers/modules/home_page/view/widgets/partner_widget.dart';

import '../../../app/widgets/forms/app_search_field.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  HomePageController controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: AppLoadingView());
        }
        if (controller.homeData.value.banners == null &&
            controller.homeData.value.starredFlyers == null &&
            controller.homeData.value.nearestFlyers == null &&
            controller.homeData.value.latestFlyers == null &&
            controller.homeData.value.availableCompetition == null &&
            controller.homeData.value.partnerCategories == null) {
          return Center(child: AppEmptyState(message: LangKeys.noData.tr));
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.getHome();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSearchField(
                    showActionButton: true,
                    hintText: LangKeys.search.tr,
                    controller: controller.searchController,
                    actionIconPath: "ic_refresh",
                    onActionButtonPressed: () {
                      controller.getHome();
                    },
                    onChanged: (value) {
                      // if (value.isEmpty && controller.searchQuery.isNotEmpty) {
                      //   controller.clearSearch();
                      // }
                    },
                    onSubmitted: () {
                      // controller.performSearch();
                      // Do something when search is submitted
                    },
                    height: 48.h,
                  ),
                  // Banner
                  controller.getBanners().isNotEmpty
                      ? Column(
                        children: [
                          16.verticalSpace,
                          BannerWidget(banners: controller.getBanners()),
                        ],
                      )
                      : SizedBox(),
                  // Categories (new placement - always show if available)
                  controller.getPartnerCategories().isNotEmpty
                      ? CategoryWidget(
                        categories: controller.getPartnerCategories(),
                      )
                      : SizedBox(),
                  // CategoryWidget(categories: controller.getPartnerCategories()),
                  // Partners based on selected category
                  // Partners based on selected category
                  controller.getPartnersForSelectedCategory().isNotEmpty
                      ? PartnersWidget(
                        partners: controller.getPartnersForSelectedCategory(),
                      )
                      : SizedBox(),
                  // Top Picks (Starred Flyers)
                  if (controller.getStarredFlyers().isNotEmpty)
                    FlyerWidget(
                      title: LangKeys.topPicks.tr,
                      flyers: controller.getStarredFlyers(),
                    ),
                  // Daily Incentive Card
                  controller.getAvailableCompetition() != null
                      ? _buildDailyIncentiveCard()
                      : SizedBox(),

                  // Nearest Flyers
                  if (controller.getNearestFlyers().isNotEmpty)
                    FlyerWidget(
                      title: LangKeys.nearest.tr,
                      flyers: controller.getNearestFlyers(),
                    ),
                  // Latest Flyers
                  if (controller.getLatestFlyers().isNotEmpty)
                    FlyerWidget(
                      title: LangKeys.latest.tr,
                      flyers: controller.getLatestFlyers(),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search here for anything',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          suffixIcon: Container(
            margin: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.refresh, color: Colors.white, size: 20.sp),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15.h),
        ),
      ),
    );
  }

  Widget _buildDailyIncentiveCard() {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.loyaltyQuizScreen);
      },
      child: Container(
        margin: EdgeInsets.all(15.r),
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Icon(Icons.card_giftcard, color: Colors.deepOrange, size: 30.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                '${controller.getAvailableCompetition()?.title ?? ""} : \n${controller.getAvailableCompetition()?.description ?? ""}',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
