import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/core/models/lives/older.dart';
import 'package:offers/core/models/notifications/notifications_obj.dart';
import 'package:offers/modules/lives_screen/controller/lives_controller.dart';
import 'package:offers/modules/notifications_screen/controller/notifications_controller.dart';
import 'package:offers/modules/notifications_screen/view/widget/notification_item.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/config/app_theme.dart';
import '../../../app/widgets/common/app_empty_state.dart';
import '../../../app/widgets/common/app_loading_view.dart';
import '../../../app/widgets/common/app_network_image.dart';
import '../../../app/widgets/common/app_shimmer_loading.dart';
import '../../../app/widgets/forms/app_custom_text.dart';
import '../../../core/models/lives/live.dart';
import '../../../core/models/notifications/notification_older.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  NotificationsController controller = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.notifications.tr),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab bar for notification filters (All, Read, Unread)
            10.verticalSpace,
            _buildTabBar(),

            // List of lives with pagination
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.pagingController.refresh();
                },
                color: AppTheme.primaryColor,
                child: _buildNotificationsList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tab bar with All, Read, Unread options
  Widget _buildTabBar() {
    return Container(
      // height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: HexColor("E5E5E5"), width: 1.h),
        ),
      ),
      child: Row(
        children: [
          // All Tab
          _buildTabItem(
            title: LangKeys.all.tr,
            isSelected: controller.selectedTab.value == NotificationTab.all,
            onTap: () => controller.setTab(NotificationTab.all),
          ),

          // Read Tab
          _buildTabItem(
            title: LangKeys.read.tr,
            isSelected: controller.selectedTab.value == NotificationTab.read,
            onTap: () => controller.setTab(NotificationTab.read),
          ),

          // Unread Tab
          _buildTabItem(
            title: LangKeys.unread.tr,
            isSelected: controller.selectedTab.value == NotificationTab.unread,
            onTap: () => controller.setTab(NotificationTab.unread),
            isUnread: true,
          ),
        ],
      ),
    );
  }

  // Individual tab item with selection indicator
  Widget _buildTabItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    bool isUnread = false,
  }) {
    final Color activeColor =
        isUnread ? AppTheme.primaryColor : AppTheme.primaryColor;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tab title
            AppCustomText(
              text: title,
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color:
                  isSelected
                      ? activeColor
                      : HexColor("121212").withValues(alpha: 0.31),
            ),
            8.verticalSpace,
            // Selection indicator line
            Container(
              height: 1.4.h,
              width: 60.w,
              color: isSelected ? activeColor : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    return PagedListView<int, NotificationOlder>(
      pagingController: controller.pagingController,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      builderDelegate: PagedChildBuilderDelegate<NotificationOlder>(
        itemBuilder: (context, section, index) {
          return _buildDateSection(section.date ?? "", section.items!);
        },
        firstPageErrorIndicatorBuilder: (_) {
          return AppEmptyState(
            message: controller.pagingController.error,
            icon: "ic_empty_notifications",
            actionText: LangKeys.retry.tr,
            onActionPressed: () {
              controller.pagingController.refresh();
            },
          );
        },
        noItemsFoundIndicatorBuilder:
            (_) => AppEmptyState(
              message: LangKeys.noNotifications.tr,
              icon: "ic_empty_notifications",
            ),
        newPageErrorIndicatorBuilder:
            (_) => AppEmptyState(
              icon: "ic_empty_notifications",
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

  Widget _buildDateSection(String date, List<NotificationsObj> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Padding(
          padding: EdgeInsetsDirectional.only(bottom: 16.h, top: 16.h),
          child: AppCustomText(
            text: date,
            fontSize: 14.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        // Live items for this date
        ...items.map(
          (item) => NotificationItem(notification: item, onTap: () {

          }),
        ),
      ],
    );
  }

}
