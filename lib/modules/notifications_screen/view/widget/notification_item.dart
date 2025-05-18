import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:offers/core/models/notifications/notifications_obj.dart';

class NotificationItem extends StatelessWidget {
  // The notification data to display
  final NotificationsObj notification;

  // Callback for when notification is tapped
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: notification.isRead == true ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1.h),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification icon in a red circle
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: HexColor("F04F32").withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_outlined,
                color: AppTheme.primaryColor,
                size: 26.r,
              ),
            ),

            SizedBox(width: 12.w),

            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with unread indicator dot
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppCustomText(
                          text: notification.title ?? "",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: HexColor("121212"),
                        ),
                      ),
                      // Unread indicator dot (only for unread notifications)
                      if (notification.isRead == false)
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  3.verticalSpace,
                  // Message body
                  AppCustomText(
                    text: notification.content ?? "",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: HexColor("898989"),
                  ),

                  SizedBox(height: 8.h),

                  // Time stamp
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: AppCustomText(
                      text: AppUtils.timeAgo(
                        notification.createdAtFormatted ?? "",
                      ),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withValues(alpha: 0.30),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Format time as AM/PM
  String _formatTime(DateTime time) {
    return "";
    // return DateFormat('h:mm a').format(time);
  }
}
