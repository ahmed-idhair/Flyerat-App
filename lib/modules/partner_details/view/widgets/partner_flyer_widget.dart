import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/core/models/home/flyer.dart';

import '../../../../app/extensions/color.dart';
import '../../../../app/widgets/common/app_network_image.dart';
import '../../../../app/widgets/forms/app_custom_text.dart';

class PartnerFlyerWidget extends StatelessWidget {
  final Flyer data;

  const PartnerFlyerWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.flyerDetails, arguments: {"id": data.id});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppTheme.primaryColor, width: 0.3.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppNetworkImage(
              imageUrl:
                  data.media != null && data.media!.isNotEmpty
                      ? data.media![0].path ?? ''
                      : "",
              fit: BoxFit.cover,
              width: ScreenUtil().screenWidth,
              height: 150.h,
              topEnd: 10.r,
              topStart: 10.r,
            ),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 6.w,
                vertical: 10.h,
              ),
              child: AppCustomText(
                text: data.title ?? "",
                fontSize: 14.sp,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                color: HexColor("8F8F8F"),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
