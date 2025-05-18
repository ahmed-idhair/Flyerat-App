import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/core/models/lives/older.dart';
import 'package:offers/modules/lives_screen/controller/lives_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/config/app_theme.dart';
import '../../../app/widgets/common/app_empty_state.dart';
import '../../../app/widgets/common/app_loading_view.dart';
import '../../../app/widgets/common/app_network_image.dart';
import '../../../app/widgets/common/app_shimmer_loading.dart';
import '../../../app/widgets/forms/app_custom_text.dart';
import '../../../core/models/lives/live.dart';

class LivesScreen extends StatelessWidget {
  LivesScreen({super.key});

  LivesController controller = Get.put(LivesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.lives.tr),
      body: Obx(() {
        return Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with lives count
              _buildHeader(),
              // List of lives with pagination
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    controller.pagingController.refresh();
                  },
                  color: AppTheme.primaryColor,
                  child: _buildPaginatedLivesList(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withValues(alpha: 0.05),
        //     blurRadius: 2,
        //     offset: Offset(0, 1),
        //   ),
        // ],
      ),
      child: Row(
        children: [
          AppCustomText(
            text: LangKeys.allLives.tr,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          Spacer(),
          AppCustomText(
            text: '( ${controller.totalLives} ${LangKeys.results.tr} )',
            fontSize: 14.sp,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPaginatedLivesList() {
    return PagedListView<int, Older>(
      pagingController: controller.pagingController,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      builderDelegate: PagedChildBuilderDelegate<Older>(
        itemBuilder: (context, section, index) {
          return _buildDateSection(section.date ?? "", section.items!);
        },
        firstPageErrorIndicatorBuilder: (_) {
          return AppEmptyState(
            message: controller.pagingController.error,
            actionText: LangKeys.retry.tr,
            onActionPressed: () {
              controller.pagingController.refresh();
            },
          );
        },
        noItemsFoundIndicatorBuilder:
            (_) => AppEmptyState(message: LangKeys.noFlyersAvailable.tr),
        newPageErrorIndicatorBuilder:
            (_) => AppEmptyState(
              message: controller.pagingController.error,
              actionText: LangKeys.retry.tr,
              onActionPressed: () {
                controller.pagingController.refresh();
              },
            ),
        firstPageProgressIndicatorBuilder:
            (_) => SizedBox(
              // Explicitly give it width constraints
              width: ScreenUtil().screenWidth,
              height: 400.h, // or another reasonable height
              child: const ShimmerLoading(
                itemCount: 6,
                // Optionally set aspectRatio to match your actual items
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
    );
  }

  Widget _buildDateSection(String date, List<Live> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Padding(
          padding: EdgeInsetsDirectional.only(bottom: 16.h, top: 16.h),
          child: AppCustomText(
            text: date,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        // Live items for this date
        ...items.map((item) => _buildLiveItem(item)),
      ],
    );
  }

  Widget _buildLiveItem(Live item) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: HexColor("FAFAFA"),
        borderRadius: BorderRadius.circular(4.r),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 2,
        //     offset: Offset(0, 1),
        //   ),
        // ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(4.r),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: () {
            AppUtils.openUrlBrowser(item.url ?? "");
          },
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 9.w,
              vertical: 15.h,
            ),
            child: Row(
              children: [
                // Partner logo
                Container(
                  // width: 41.w,
                  // height: 31.h,
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 9.w,
                    vertical: 4.h,
                  ),
                  margin: EdgeInsetsDirectional.only(end: 10.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: HexColor("C0C0C0"), width: 0.3.w),
                    borderRadius: BorderRadius.all(Radius.circular(6.r)),
                  ),
                  child: AppNetworkImage(
                    imageUrl: item.partner?.image ?? '',
                    width: 23.w,
                    height: 23.h,
                    borderRadius: 0,
                    fit: BoxFit.contain,
                  ),
                ),
                // Live details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Partner name
                      AppCustomText(
                        text: item.partner?.name ?? "",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: HexColor("2C3131"),
                      ),
                      // Live URL
                      AppCustomText(
                        text: item.url ?? "",
                        fontSize: 10.sp,
                        color: HexColor("1869F9"),
                        maxLines: 1,
                        decoration: TextDecoration.underline,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
