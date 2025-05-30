import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/app/widgets/common/app_bottom_sheet.dart';
import 'package:offers/app/widgets/common/app_loading_view.dart';
import 'package:offers/app/widgets/core/app_avatar.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:offers/core/models/comments/comment.dart';

import '../../../app/translations/lang_keys.dart';
import '../../../app/widgets/common/app_empty_state.dart';
import '../../../app/widgets/common/app_shimmer_loading.dart';
import '../../../core/models/user/user.dart';
import '../controller/comments_controller.dart';

class CommentsScreen extends StatelessWidget {
  CommentsScreen({Key? key}) : super(key: key);

  final CommentsController controller = Get.put(CommentsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: ""),
      body: Padding(
        padding: EdgeInsetsDirectional.only(start: 16.w, end: 16.w),
        child: Column(
          children: [
            // Comments stats
            _buildCommentStats(),
            16.verticalSpace,

            // Divider
            Divider(color: HexColor("D2D2D2"), thickness: 0.5.h, height: 0.h),
            16.verticalSpace,
            // Comments list
            Expanded(
              flex: 1,
              child: GetBuilder<CommentsController>(
                id: 'updateList',
                builder: (controller) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.pagingController.refresh();
                    },
                    color: AppTheme.primaryColor,
                    child: PagedListView<int, Comment>(
                      pagingController: controller.pagingController,
                      shrinkWrap: true,
                      primary: true,
                      padding: EdgeInsetsDirectional.only(
                        start: 0.w,
                        end: 0.w,
                        top: 0.h,
                        bottom: 100.h,
                      ),
                      builderDelegate: PagedChildBuilderDelegate<Comment>(
                        itemBuilder: (context, item, index) {
                          return _buildCommentItem(item);
                        },
                        firstPageErrorIndicatorBuilder: (_) {
                          return AppEmptyState(
                            message: controller.pagingController.error,
                          );
                        },
                        noItemsFoundIndicatorBuilder:
                            (_) => AppEmptyState(
                              message: LangKeys.noCommentsAvailable.tr,
                              // img: "ic_no_notification",
                            ),
                        newPageErrorIndicatorBuilder:
                            (_) => AppEmptyState(
                              message: controller.pagingController.error,
                            ),
                        firstPageProgressIndicatorBuilder:
                            (_) => SizedBox(
                              // Explicitly give it width constraints
                              width: ScreenUtil().screenWidth,
                              height: 400.h, // or another reasonable height
                              child: const ShimmerLoading(
                                type: ShimmerType.list,
                                itemCount: 6,
                                // Optionally set aspectRatio to match your actual items
                                aspectRatio: 0.9,
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
              ),
            ),
          ],
        ),
      ),
      // Comment input field at the bottom
      bottomSheet: _buildCommentInput(),
    );
  }

  Widget _buildCommentStats() {
    return Padding(
      padding: EdgeInsets.all(0.r),
      child: Row(
        children: [
          // Like count
          Row(
            children: [
              Icon(Icons.thumb_up, size: 18.r, color: Colors.blue),
              8.horizontalSpace,
              AppCustomText(
                text: "(${controller.flyer?.likesCount ?? 0})",
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: HexColor("464646"),
              ),
            ],
          ),

          Spacer(),

          // Comment and share count
          Row(
            children: [
              AppCustomText(
                text: "${controller.flyer?.commentsCount ?? 0} Comment",
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: HexColor("464646"),
              ),
              4.horizontalSpace,
              AppCustomText(text: "•", fontSize: 14.sp, color: Colors.black),
              4.horizontalSpace,
              AppCustomText(
                text: "${controller.flyer?.sharesCount ?? 0} Share",
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

  Widget _buildCommentItem(Comment comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main comment
        Padding(
          padding: EdgeInsetsDirectional.symmetric(vertical: 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User avatar
              AppAvatar(
                imageUrl: comment.user?.image,
                text: comment.user?.name,
                size: 38.r,
              ),
              // _buildUserAvatar(comment.user!),
              8.horizontalSpace,
              // Comment content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User name and comment text
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 11.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: HexColor("FAFAFA"),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User name
                          AppCustomText(
                            text: comment.user?.name ?? "",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          4.verticalSpace,
                          // Comment text
                          AppCustomText(
                            text: comment.comment ?? "",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor("8B8B8B"),
                          ),
                        ],
                      ),
                    ),

                    // Time and actions
                    Padding(
                      padding: EdgeInsets.only(top: 4.h, left: 8.w),
                      child: Row(
                        children: [
                          // Time
                          AppCustomText(
                            text: comment.createdAt?.human ?? "",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          // SizedBox(width: 16.w),

                          // // Like button
                          // _buildActionButton('Like', () {
                          //   // controller.likeComment(comment.id);
                          // }),
                          // SizedBox(width: 16.w),
                          //
                          // // Reply button
                          // _buildActionButton('Reply', () {
                          //   // controller.replyToComment(comment.id);
                          // }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Replies (if any)
        if (comment.replies != null)
          Padding(
            padding: EdgeInsetsDirectional.only(start: 40.w),
            child: Column(
              children:
                  comment.replies!.map((reply) {
                    return _buildReplyItem(reply);
                  }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildReplyItem(Comment reply) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          AppAvatar(
            imageUrl: reply.user?.image,
            text: reply.user?.name,
            size: 38.r,
          ),
          // _buildUserAvatar(reply.user!),
          8.horizontalSpace,
          // Reply content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User name and reply text
                Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 11.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: HexColor("FAFAFA"),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User name
                      AppCustomText(
                        text: reply.user?.name ?? "",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      4.verticalSpace,
                      // Reply text
                      AppCustomText(
                        text: reply.comment ?? "",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: HexColor("8B8B8B"),
                      ),
                    ],
                  ),
                ),

                // Time and actions
                Padding(
                  padding: EdgeInsets.only(top: 4.h, left: 8.w),
                  child: Row(
                    children: [
                      // Time
                      AppCustomText(
                        text: reply.createdAt?.human ?? "",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      // SizedBox(width: 16.w),

                      // // Like button
                      // _buildActionButton('Like', () {
                      //   // controller.likeReply(reply.id);
                      // }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, -1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          // User avatar
          // AppAvatar(
          //   imageUrl: controller.storage.getUser()?.image,
          //   text: controller.storage.getUser()?.name,
          //   size: 38.r,
          // ),
          // // _buildUserAvatar(controller.storage.getUser()!),
          // SizedBox(width: 8.w),

          // Comment text field
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: HexColor("F0F0F3"),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TextField(
                controller: controller.commentController,
                decoration: InputDecoration(
                  hintText: 'Type a comment...',
                  hintStyle: TextStyle(
                    color: HexColor("0D1217"),
                    fontSize: 14.sp,
                  ),
                  border: InputBorder.none,
                ),
                maxLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) {
                  if (controller.storage.isAuth()) {
                    controller.addFlyerComment();
                  } else {
                    confirmBottomSheet();
                  }
                },
              ),
            ),
          ),

          // Send button
          SizedBox(width: 8.w),
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                AppUtils.getIconPath("ic_send"),
                width: 21.w,
                height: 21.h,
              ),
              onPressed: () {
                if (controller.storage.isAuth()) {
                  controller.addFlyerComment();
                } else {
                  confirmBottomSheet();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
