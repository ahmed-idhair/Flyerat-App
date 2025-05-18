import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/app/widgets/buttons/app_button.dart';
import 'package:offers/app/widgets/common/app_bottom_sheet.dart';
import 'package:offers/app/widgets/common/app_empty_state.dart';
import 'package:offers/app/widgets/common/app_loading_view.dart';
import 'package:offers/app/widgets/common/app_network_image.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:offers/modules/flyer_details/controller/flyer_details_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../app/config/app_theme.dart';
import 'media_viewer_screen.dart';

class FlyerDetails extends StatefulWidget {
  const FlyerDetails({super.key});

  @override
  State<FlyerDetails> createState() => _FlyerDetailsState();
}

class _FlyerDetailsState extends State<FlyerDetails> {
  late FlyerDetailsController controller;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      FlyerDetailsController(),
    ); // استخدام المتحكم الموجود مسبقًا
    pageController = PageController();
    // استمع لتغييرات الصفحة وقم بتشغيل الفيديو إذا كان موجودًا
    pageController.addListener(_handlePageChange);
  }

  int _lastPage = 0;

  void _handlePageChange() {
    if (pageController.page == null) return;

    int currentPage = pageController.page!.round();
    if (currentPage != _lastPage) {
      _lastPage = currentPage;

      // تحديث المؤشر الحالي في المتحكم
      controller.currentPage.value = currentPage;
    }
  }

  @override
  void dispose() {
    pageController.removeListener(_handlePageChange);
    pageController.dispose();
    // لا تتخلص من controller هنا لأننا استخدمنا Get.find بدلاً من Get.put
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FlyerDetailsController>(
      id: "updateDetails",
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(title: controller.title.value),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: AppLoadingView());
            }
            if (controller.flyer.value?.id == null ||
                controller.flyer.value?.id == 0) {
              return AppEmptyState(message: LangKeys.noData.tr);
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                child: Column(
                  children: [
                    if (controller.flyerImages.isNotEmpty)
                      _buildFlyerImageViewer(),
                    _buildFlyerInfo(),
                    _buildInteractionButtons(),
                    _buildActionButton(),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildFlyerImageViewer() {
    return Column(
      children: [
        // Page View for flyer images
        SizedBox(
          height: 300.h,
          child: PageView.builder(
            controller: pageController,
            itemCount: controller.flyerImages.length,
            onPageChanged: (index) {
              controller.currentPage.value = index;
            },
            itemBuilder: (context, index) {
              final isVideo =
                  controller.flyer.value?.mediaType?.toLowerCase() == 'video';

              final media = controller.flyerImages[index];
              String imageUrl =
                  isVideo
                      ? controller.flyer.value?.videoCover ?? ""
                      : media.path ?? "";
              return GestureDetector(
                onTap: () {
                  Get.to(
                    () => MediaViewerScreen(
                      mediaList: controller.flyerImages,
                      initialIndex: index,
                    ),
                    // transition: Transition.fade,
                  );
                },
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    AppNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: ScreenUtil().screenWidth,
                      height: 300.h,
                      borderRadius: 4.r,
                    ),
                    Visibility(
                      visible: isVideo,
                      child: Container(
                        width: ScreenUtil().screenWidth,
                        height: 300.h,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadiusDirectional.circular(4.r),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isVideo,
                      child: Icon(
                        Icons.play_circle,
                        size: 70.r,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        12.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => SmoothPageIndicator(
                controller: pageController,
                count: controller.flyerImages.length,
                effect: WormEffect(
                  dotHeight: 8.h,
                  dotWidth: 8.w,
                  activeDotColor: AppTheme.primaryColor,
                  dotColor: AppTheme.primaryColor.withValues(alpha: 0.19),
                ),
              ),
            ),

            10.horizontalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.19),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Obx(
                () => AppCustomText(
                  text:
                      "${controller.currentPage.value + 1} / ${controller.flyerImages.length}",
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFlyerInfo() {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 20.h, bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: HexColor("D2D2D2"), height: 0, thickness: 0.5.h),
          16.verticalSpace,
          // Flyer title and date
          AppCustomText(
            text: controller.flyer.value?.title ?? '',
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 4.h),
          AppCustomText(
            text:
                "${AppUtils.formatDatedMMMMyyyy(controller.flyer.value?.startDate ?? "")} - ${AppUtils.formatDatedMMMMyyyy(controller.flyer.value?.endDate ?? "")}",
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          12.verticalSpace,
          // Like and comment count
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.thumb_up,
                      color: HexColor("1869F9"),
                      size: 16.sp,
                    ),
                    6.horizontalSpace,
                    AppCustomText(
                      text:
                          "(${controller.flyer.value?.likesCount.toString()})",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: HexColor("464646"),
                    ),
                  ],
                ),
              ),
              10.horizontalSpace,
              AppCustomText(
                text:
                    "${controller.flyer.value?.commentsCount.toString()} ${LangKeys.comment.tr}",
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: HexColor("464646"),
              ),
              4.horizontalSpace,
              Text("•", style: TextStyle(color: Colors.black)),
              4.horizontalSpace,
              AppCustomText(
                text:
                    "${controller.flyer.value?.sharesCount.toString()} ${LangKeys.share.tr}",
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: HexColor("464646"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Like button
            _buildInteractionButton(
              icon: Icons.thumb_up_outlined,
              label: LangKeys.like.tr,
              isActive: controller.flyer.value?.isLiked ?? false,
              onTap: () {
                if (controller.storage.isAuth()) {
                  controller.flyerLiked();
                } else {
                  confirmBottomSheet();
                }
              },
            ),
            // Comment button
            _buildInteractionButton(
              icon: Icons.comment_outlined,
              label: LangKeys.comment.tr,
              onTap: () {
                Get.toNamed(
                  AppRoutes.commentsScreen,
                  arguments: {"flyer": controller.flyer.value},
                );
              },
            ),
            // Share button
            _buildInteractionButton(
              icon: Icons.share_outlined,
              label: LangKeys.share.tr,
              onTap: () {
                if (controller.storage.isAuth()) {
                  controller.flyerShare();
                } else {
                  confirmBottomSheet();
                }
              },
            ),
          ],
        ),
        16.verticalSpace,
        Divider(color: HexColor("D2D2D2"), height: 0, thickness: 0.5.h),
      ],
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Row(
        children: [
          Icon(
            icon,
            color: isActive ? AppTheme.primaryColor : HexColor("707070"),
            size: 20.r,
          ),
          SizedBox(width: 8.w),
          AppCustomText(
            text: label,
            color: isActive ? AppTheme.primaryColor : HexColor("707070"),
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Visibility(
      visible:
          controller.flyer.value?.externalUrl != null &&
          controller.flyer.value?.externalUrl != "",
      child: Column(
        children: [
          30.verticalSpace,
          AppButton(
            text: LangKeys.shopOnline.tr,
            onPressed: () {
              AppUtils.openUrlBrowser(
                controller.flyer.value?.externalUrl ?? "",
              );
            },
            leadingIcon: Icons.shopping_bag_outlined,
            variant: ButtonVariant.outline,
          ),
        ],
      ),
    );
  }
}
