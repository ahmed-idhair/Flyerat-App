import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/common/app_network_image.dart';
import 'package:offers/modules/home_page/view/home_page.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../home/controller/home_controller.dart';
import '../../controller/home_page_controller.dart';
import 'package:offers/core/models/home/banner.dart' as bn;

class BannerWidget extends StatelessWidget {
  final List<bn.Banner> banners;

  const BannerWidget({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    // final HomePageController controller = Get.find<HomePageController>();

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 150.h,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              // controller.changeBanner(index);
            },
          ),
          items:
              banners.map((banner) {
                return InkWell(
                  onTap: () {
                    if (banner.type == "partner" &&
                        banner.partnerId != null &&
                        banner.partnerId != 0) {
                      Get.toNamed(
                        AppRoutes.partnerDetails,
                        arguments: {"id": banner.partnerId},
                      );
                    } else if (banner.type == "flyer" &&
                        banner.flyerId != null &&
                        banner.flyerId != 0) {
                      Get.toNamed(
                        AppRoutes.flyerDetails,
                        arguments: {
                          "id": banner.flyerId,
                          "title": LangKeys.details.tr,
                        },
                      );
                    } else if (banner.type == "url") {
                      AppUtils.openUrlBrowser(banner.url ?? "");
                    }
                  },
                  child: AppNetworkImage(
                    borderRadius: 14.r,
                    imageUrl: banner.image ?? "",
                    fit: BoxFit.cover,
                    width: ScreenUtil().screenWidth,
                    height: 150.h,
                  ),
                );
              }).toList(),
        ),
        // SizedBox(height: 10.h),
        // Obx(
        //   () => Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children:
        //         banners.asMap().entries.map((entry) {
        //           return Container(
        //             width: 8.w,
        //             height: 8.h,
        //             margin: EdgeInsets.symmetric(horizontal: 4.w),
        //             decoration: BoxDecoration(
        //               shape: BoxShape.circle,
        //               color:
        //                   controller.currentBannerIndex.value == entry.key
        //                       ? Colors.deepOrange
        //                       : Colors.grey,
        //             ),
        //           );
        //         }).toList(),
        //   ),
        // ),
      ],
    );
  }
}
