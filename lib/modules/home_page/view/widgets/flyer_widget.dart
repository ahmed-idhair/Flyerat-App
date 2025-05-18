import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/common/app_network_image.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:offers/core/models/home/flyer.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/models/home/partner.dart';

class FlyerWidget extends StatelessWidget {
  final String title;
  final List<Flyer> flyers;

  const FlyerWidget({super.key, required this.title, required this.flyers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.verticalSpace,
        AppCustomText(
          text: title,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        20.verticalSpace,
        if (flyers.isNotEmpty) _buildGridView(),
        20.verticalSpace,
      ],
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 7.w,
        mainAxisSpacing: 10.h,
      ),
      // padding: EdgeInsets.symmetric(horizontal: 15.w),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: flyers.length,
      itemBuilder: (context, index) {
        return _buildFlyerItem(flyers[index]);
      },
    );
  }

  Widget _buildFlyerItem(Flyer flyer) {
    final isVideo = flyer.mediaType?.toLowerCase() == 'video';
    return InkWell(
      onTap: () {
        Get.toNamed(
          AppRoutes.flyerDetails,
          arguments: {"id": flyer.id, "title": flyer.partner?.name ?? ""},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: HexColor("CBCBCB"), width: 0.3.w),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.2),
          //     spreadRadius: 1,
          //     blurRadius: 3,
          //     offset: Offset(0, 2),
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flyer image
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                AppNetworkImage(
                  imageUrl:
                      isVideo
                          ? flyer.videoCover ?? ""
                          : flyer.media != null && flyer.media!.isNotEmpty
                          ? flyer.media![0].path ?? ''
                          : "",
                  fit: BoxFit.cover,
                  width: ScreenUtil().screenWidth,
                  height: 150.h,
                  topEnd: 10.r,
                  topStart: 10.r,
                  borderRadius: 0.r,
                ),
                Visibility(
                  visible: isVideo,
                  child: Container(
                    width: ScreenUtil().screenWidth,
                    height: 150.h,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadiusDirectional.only(
                        topEnd: Radius.circular(10.r),
                        topStart: Radius.circular(10.r),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isVideo,
                  child: Icon(
                    Icons.play_circle,
                    size: 50.r,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            // Bottom container with type and days left
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 6.w,
                vertical: 10.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCustomText(
                    text: flyer.title ?? "",
                    fontSize: 14.sp,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: HexColor("2C3131"),
                    fontWeight: FontWeight.w400,
                  ),
                  // Type and days left
                  5.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AppUtils.getIconPath("ic_clock"),
                        width: 18.w,
                        height: 18.h,
                      ),
                      6.horizontalSpace,
                      AppCustomText(
                        text: AppUtils.getDaysLeft(flyer.endDate),
                        fontSize: 12.sp,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        color: HexColor("2C3131"),
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  Divider(color: HexColor("D2D2D2"), thickness: 0.5),
                  // Partner info
                  if (flyer.partner != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (flyer.partner?.image != null)
                          _buildPartnerItem(flyer.partner!),
                        Expanded(
                          child: AppCustomText(
                            text: flyer.partner?.name ?? "",
                            fontSize: 14.sp,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            color: HexColor("2C3131"),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerItem(Partner partner) {
    return Container(
      // width: 36.w,
      // height: 27.h,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 6.5.w,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        border: Border.all(color: HexColor("C0C0C0"), width: 0.3.w),
      ),
      margin: EdgeInsetsDirectional.only(end: 10.w),
      child: AppNetworkImage(
        imageUrl: partner.image ?? "",
        fit: BoxFit.contain,
        width: 23.w,
        borderRadius: 0,
        height: 23.h,
      ),
    );
  }
}
