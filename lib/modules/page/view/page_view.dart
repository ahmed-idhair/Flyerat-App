import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/common/app_loading_view.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../app/widgets/app_bar/custom_app_bar.dart';
import '../controller/page_view_controller.dart';

/// Screen for displaying static content pages in a WebView
/// Shows loading indicator while content is being fetched
class PageView extends StatelessWidget {
  PageView({super.key});

  // Initialize controller
  final PageViewController controller = Get.put(PageViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: controller.title),
      body: SafeArea(
        child: Obx(
          () =>
              // Show content when loaded, loading indicator otherwise
              controller.isLoading.isFalse
                  ? Padding(
                    padding: EdgeInsets.all(5.0.r),
                    child: Column(
                      children: [
                        Expanded(
                          child: WebViewWidget(
                            controller: controller.webViewController,
                          ),
                        ),

                        // Social media buttons
                        Obx(() {
                          // Filter out items with null values
                          final validSocialMedia =
                              controller.socialMediaList
                                  .where(
                                    (item) =>
                                        item.value != null &&
                                        item.value!.isNotEmpty,
                                  )
                                  .toList();

                          // If no valid social media links, don't show the container
                          if (validSocialMedia.isEmpty) {
                            return SizedBox();
                          }
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 16.0.h),
                            // width: ScreenUtil().screenWidth,
                            decoration: BoxDecoration(
                              // border: Border(
                              //   top: BorderSide(
                              //     color: Colors.grey.shade300,
                              //     width: 0.5,
                              //   ),
                              // ),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children:
                                    validSocialMedia.map((item) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                        ),
                                        child: _socialButton(
                                          item.name ?? "",
                                          controller.getIconKey(item.key ?? ""),
                                          () =>
                                              controller.launchURL(item.value),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  )
                  : AppLoadingView(),
        ),
      ),
    );
  }

  Widget _socialButton(String label, String iconPath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppUtils.getIconPath(iconPath),
            width: 43.w,
            height: 43.h,
          ),
          4.verticalSpace,
          AppCustomText(
            text: label,
            color: HexColor("206A5D"),
            fontSize: 12.sp,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}
