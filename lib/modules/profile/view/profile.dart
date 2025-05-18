import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';

import '../../../app/widgets/common/app_bottom_sheet.dart';
import '../../../app/widgets/core/app_avatar.dart';
import '../controller/profile_controller.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.profile.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large profile avatar with edit button
              GetBuilder<ProfileController>(
                id: 'updateUser',
                builder: (controller) {
                  return Column(
                    children: [
                      _buildProfileAvatar(),
                      // Personal Details section
                      _buildSectionHeader(
                        LangKeys.personalDetails.tr,
                        onTap: () {
                          Get.toNamed(AppRoutes.editProfile);
                        },
                      ),
                      // User info items
                      _buildInfoItem(
                        icon: "ic_user_profile",
                        label: controller.user?.name ?? "",
                        isVerified: true,
                      ),

                      _buildInfoItem(
                        icon: "ic_phone_profile",
                        label: controller.formatPhoneNumberMasked(
                          controller.user?.mobile ?? "",
                        ),
                        isVerified: true,
                      ),
                      _buildInfoItem(
                        icon: "ic_mail_profile",
                        label: controller.maskEmail(
                          controller.user?.email ?? "",
                        ),
                        isVerified: true,
                      ),
                    ],
                  );
                },
              ),

              // Account Settings section
              _buildSectionHeader(
                LangKeys.accountSettings.tr,
                isShowDivider: true,
              ),

              // Account settings items
              _buildSettingsItem(
                icon: "ic_change_password",
                iconColor: Colors.orange,
                label: LangKeys.changePassword.tr,
                hasArrow: true,
                onTap: () {
                  Get.toNamed(AppRoutes.changePassword);
                },
              ),
              _buildSettingsItem(
                icon: "ic_delete_account",
                iconColor: Colors.red,
                label: LangKeys.deleteAccount.tr,
                hasArrow: true,
                onTap: () {
                  showAccountDeactivateBottomSheet(context, () {
                    Get.back(closeOverlays: true);
                    controller.logout(true);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Profile avatar with edit button
  Widget _buildProfileAvatar() {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: 0.h, bottom: 40.h),
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            // Avatar
            AppAvatar(
              size: 80.r,
              text: controller.user?.name ?? "",
              imageUrl: controller.user?.image,
            ),
            // Edit button
            Positioned(
              right: 0,
              bottom: 0,
              child: InkWell(
                onTap: () {
                  controller.selectImage();
                },
                child: Container(
                  padding: EdgeInsets.all(2.r),
                  decoration: BoxDecoration(
                    color: HexColor("A27169"),
                    border: Border.all(color: Colors.white, width: 1.43.w),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit, color: Colors.white, size: 20.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section header with optional edit button
  Widget _buildSectionHeader(
    String title, {
    Function()? onTap,
    isShowDivider = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(
          top:
              isShowDivider == true
                  ? BorderSide(color: HexColor("D4D4D4"), width: 0.5.w)
                  : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppCustomText(
            text: title,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: HexColor("B0B0B0"),
          ),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: SvgPicture.asset(
                AppUtils.getIconPath("ic_edit_profile"),
                width: 20.w,
                height: 20.h,
              ),
            ),
        ],
      ),
    );
  }

  // Info item with icon and verification mark
  Widget _buildInfoItem({
    required String icon,
    required String label,
    bool isVerified = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12.h),
      child: Row(
        children: [
          // Left icon
          SvgPicture.asset(
            AppUtils.getIconPath(icon),
            width: 22.w,
            height: 22.h,
          ),
          13.horizontalSpace,
          // Label
          Expanded(
            child: AppCustomText(
              text: label,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: HexColor("525252"),
            ),
          ),
          // Verification icon if verified
          if (isVerified)
            SvgPicture.asset(
              AppUtils.getIconPath("ic_verify"),
              width: 18.w,
              height: 18.h,
            ),
        ],
      ),
    );
  }

  // Settings item with icon and optional arrow
  Widget _buildSettingsItem({
    required String icon,
    required Color iconColor,
    required String label,
    bool hasArrow = false,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 12.h),
        child: Row(
          children: [
            // Left icon
            SvgPicture.asset(
              AppUtils.getIconPath(icon),
              width: 22.w,
              height: 22.h,
            ),
            13.horizontalSpace,
            // Label
            Expanded(
              child: AppCustomText(
                text: label,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            // Arrow if needed
            if (hasArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 14.sp,
                color: AppTheme.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
