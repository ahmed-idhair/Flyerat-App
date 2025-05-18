import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/app/widgets/common/app_bottom_sheet.dart';

import '../../../app/config/app_theme.dart';
import '../../../app/extensions/color.dart';
import '../../../app/widgets/common/app_empty_state.dart';
import '../../../app/widgets/common/app_loading_view.dart';
import '../../../app/widgets/common/app_network_image.dart';
import '../../../app/widgets/common/app_shimmer_loading.dart';
import '../../../app/widgets/forms/app_custom_text.dart';
import '../../../app/widgets/forms/app_search_field.dart';
import '../../../core/models/favorites/favorite.dart';
import '../../../core/models/products/product.dart';
import '../../../core/models/home/category.dart' as cat;
import '../controller/favorites_controller.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  FavoritesController controller = Get.put(FavoritesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildHeader(), Expanded(child: _buildProductsList())],
        ),
      ),
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
            text: LangKeys.allWishlists.tr,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          Spacer(),
          Obx(
            () => AppCustomText(
              text: '( ${controller.totalResult} ${LangKeys.results.tr} )',
              fontSize: 14.sp,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return GetBuilder<FavoritesController>(
      id: 'updateList',
      builder: (controller) {
        return RefreshIndicator(
          onRefresh: () async {
            controller.pagingController.refresh();
          },
          child: PagedGridView<int, Favorite>(
            pagingController: controller.pagingController,
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 16.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 0.66, // Adjust this value based on your design
            ),
            builderDelegate: PagedChildBuilderDelegate<Favorite>(
              itemBuilder: (context, product, index) {
                return _buildGridProductItem(product.product!);
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
                  (_) =>
                      AppEmptyState(message: LangKeys.noProductsAvailable.tr),
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
                      type: ShimmerType.grid,
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
          ),
        );
      },
    );
  }

  // New method for grid item layout
  Widget _buildGridProductItem(Product product) {
    final discountPercentage = product.discountPercentage ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: HexColor("CBCBCB"), width: 0.3.w),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 5,
        //     offset: Offset(0, 2),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image with discount badge and favorite button
          AppNetworkImage(
            imageUrl:
                product.media != null &&
                        product.media!.isNotEmpty &&
                        product.media!.first.path != null
                    ? product.media!.first.path ?? ""
                    : "",
            fit: BoxFit.cover,

            width: double.infinity,
            height: 130.h,
            topStart: 10.r,
            topEnd: 10.r,
          ),

          // Product details
          Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 6.w,
              vertical: 11.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                Row(
                  children: [
                    Expanded(
                      child: AppCustomText(
                        text: product.name ?? '',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                        color: HexColor("2C3131"),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    10.horizontalSpace,
                    GestureDetector(
                      onTap: () {
                        if (controller.storage.isAuth()) {
                          controller.toggleFavorite(product);
                        } else {
                          confirmBottomSheet();
                        }
                      },
                      child: SvgPicture.asset(
                        AppUtils.getIconPath("ic_fav"),
                        width: 18.w,
                        height: 18.h,
                      ),
                    ),
                  ],
                ),
                4.verticalSpace,

                // Price and discount
                Row(
                  children: [
                    // New price
                    AppCustomText(
                      text:
                          '${product.newPrice} ${controller.storage.getSelectedCountry()?.currencySymbol ?? ""}',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                    // Old price
                    // if discounted
                    if (product.hasDiscount ?? false)
                      Expanded(
                        child: Row(
                          children: [
                            4.horizontalSpace,
                            AppCustomText(
                              text:
                                  '${product.price} ${controller.storage.getSelectedCountry()?.currencySymbol ?? ""}',
                              textAlign: TextAlign.start,
                              fontSize: 12.sp,
                              color: Colors.black.withValues(alpha: 0.29),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                4.verticalSpace,

                // Remaining time
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppUtils.getIconPath("ic_clock"),
                            width: 16.w,
                            height: 16.h,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: AppCustomText(
                              text: AppUtils.getDaysLeft(product.endDate),
                              fontSize: 11.sp,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              color: HexColor("2C3131"),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (product.hasDiscount == true)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 2.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(25.r)),
                        ),
                        child: AppCustomText(
                          text: '$discountPercentage%',
                          fontSize: 9.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                Divider(
                  color: HexColor("D2D2D2"),
                  thickness: 0.5.h,
                  height: 16.h,
                ),
                Row(
                  children: [
                    // Partner logo
                    Container(
                      // width: 36.w,
                      // height: 27.h,
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 6.5.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(6.r)),
                        border: Border.all(
                          color: HexColor("C0C0C0"),
                          width: 0.3.w,
                        ),
                      ),
                      margin: EdgeInsetsDirectional.only(end: 6.w),
                      child: AppNetworkImage(
                        imageUrl: product.partner?.image ?? "",
                        fit: BoxFit.contain,
                        borderRadius: 0.r,
                        width: 23.w,
                        height: 23.h,
                      ),
                    ),

                    // Partner name
                    Expanded(
                      child: AppCustomText(
                        text: product.partner?.name ?? '',
                        fontSize: 10.sp,
                        color: HexColor("2C3131"),
                        maxLines: 1,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Partner info
        ],
      ),
    );
  }
}
