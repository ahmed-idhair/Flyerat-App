import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/common/app_network_image.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:offers/core/models/home/partner.dart';

class PartnersWidget extends StatelessWidget {
  final List<Partner> partners;

  const PartnersWidget({super.key, required this.partners});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppCustomText(
              text: LangKeys.topPartners.tr,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 16.sp,
            ),
            // TextButton(
            //   onPressed: () {},
            //   child: AppCustomText(
            //     text: LangKeys.viewAll.tr,
            //     fontWeight: FontWeight.w500,
            //     color: AppTheme.primaryColor,
            //     fontSize: 14.sp,
            //     decoration: TextDecoration.underline,
            //   ),
            // ),
          ],
        ),
        8.verticalSpace,
        // SizedBox(height: 10.h),
        SizedBox(
          height: 62.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: partners.length,
            padding: EdgeInsetsDirectional.zero,
            itemBuilder: (context, index) {
              final partner = partners[index];
              return _buildPartnerItem(partner);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPartnerItem(Partner partner) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.partnerDetails, arguments: {"id": partner.id});
      },
      child: Container(
        width: 83.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          border: Border.all(color: HexColor("C0C0C0"), width: 0.3.w),
        ),
        margin: EdgeInsetsDirectional.only(end: 10.w),
        child: AppNetworkImage(
          imageUrl: partner.image ?? "",
          fit: BoxFit.contain,
          width: 50.w,
          borderRadius: 0,
          height: 50.h,
        ),
      ),
    );
  }
}
