import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/core/app_avatar.dart';
import 'package:offers/app/widgets/forms/app_custom_switch.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';

import '../../../app/utils/app_utils.dart';
import '../../../app/widgets/common/app_bottom_sheet.dart';
import '../controller/settings_page_controller.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  SettingsPageController controller = Get.put(SettingsPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile info section with avatar, name and phone
                _buildProfileInfoCard(),
                // My Account section
                Visibility(
                  visible: controller.storage.isAuth(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(LangKeys.myAccount.tr),
                      _buildMenuItem(
                        icon: "ic_user_settings",
                        title: LangKeys.profile.tr,
                        hasArrow: true,
                        isShowDivider: true,
                        onTap: () {
                          Get.toNamed(AppRoutes.profile);
                        },
                      ),
                    ],
                  ),
                ),
                // Settings section
                _buildSectionTitle(LangKeys.settings.tr),
                Visibility(
                  visible: controller.storage.isAuth(),
                  child: _buildMenuItem(
                    icon: "ic_notifications_settings",
                    title: LangKeys.notifications.tr,
                    hasToggle: true,
                    isShowDivider: false,
                    onTap: () {
                      controller.updateNotifications();
                    },
                    isToggled: controller.isNotificationsEnabled,
                    onToggle: (value) => controller.toggleNotifications(value),
                  ),
                ),
                _buildMenuItem(
                  icon: "ic_language_settings",
                  title: LangKeys.language.tr,
                  hasArrow: true,
                  isShowDivider: true,
                  onTap: () {},
                ),
                // Others section
                _buildSectionTitle(LangKeys.others.tr),
                _buildMenuItem(
                  icon: "ic_about_us",
                  title: LangKeys.aboutUs.tr,
                  hasArrow: true,
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.pageView,
                      arguments: {
                        "title": LangKeys.aboutUs.tr,
                        "key": "about_us",
                      },
                    );
                  },
                ),
                _buildMenuItem(
                  icon: "ic_contact_us",
                  title: LangKeys.contactUs.tr,
                  hasArrow: true,
                  onTap: () {
                    Get.toNamed(AppRoutes.contactUs);
                  },
                ),
                _buildMenuItem(
                  icon: "ic_share_app",
                  title: LangKeys.shareApp.tr,
                  hasArrow: true,
                  onTap: () {
                    controller.shareAppLink();
                  },
                ),
                Visibility(
                  visible: controller.storage.isAuth(),
                  child: _buildMenuItem(
                    icon: "ic_feedback",
                    title: LangKeys.feedback.tr,
                    hasArrow: true,
                    onTap: () {
                      Get.toNamed(AppRoutes.feedback);
                    },
                  ),
                ),
                _buildMenuItem(
                  icon: "ic_privacy_policy",
                  title: LangKeys.privacyPolicy.tr,
                  hasArrow: true,
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.pageView,
                      arguments: {
                        "title": LangKeys.privacyPolicy.tr,
                        "key": "privacy_policy",
                      },
                    );
                  },
                ),
                Visibility(
                  visible: controller.storage.isAuth(),
                  child: _buildMenuItem(
                    icon: "ic_help_and_support",
                    title: LangKeys.helpSupport.tr,
                    hasArrow: true,
                    onTap: () {
                      Get.toNamed(AppRoutes.helpSupport);
                    },
                  ),
                ),
                _buildMenuItem(
                  icon: "ic_terms",
                  title: LangKeys.termsAndConditions.tr,
                  hasArrow: true,
                  isShowDivider: controller.storage.isAuth(),
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.pageView,
                      arguments: {
                        "title": LangKeys.termsAndConditions.tr,
                        "key": "terms_and_conditions",
                      },
                    );
                  },
                ),
                Visibility(
                  visible: controller.storage.isAuth(),
                  child: _buildMenuItem(
                    icon: "ic_logout",
                    title: LangKeys.logOut.tr,
                    hasArrow: true,
                    isShowDivider: false,
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () {
                      showLogOutBottomSheet(context, () {
                        Get.back(closeOverlays: true);
                        // controller.storage.clearApp();
                        // Get.offAllNamed(AppRoutes.signIn);
                        controller.logout(false);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Profile info card with avatar, name and phone number
  Widget _buildProfileInfoCard() {
    return GetBuilder<SettingsPageController>(
      id: 'updateUser',
      builder: (controller) {
        if (!controller.storage.isAuth()) {
          return SizedBox();
        }
        return Container(
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            image: DecorationImage(
              image: AssetImage(AppUtils.getImagePath("bg_profile_settings")),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                HexColor("D9D9D9").withValues(alpha: 0.8),
                BlendMode.srcOver,
              ),
            ),
          ),
          child: Column(
            children: [
              // Profile avatar with verification badge
              AppAvatar(
                size: 50.r,
                text: controller.user?.name ?? "",
                imageUrl: controller.user?.image,
              ),
              10.verticalSpace,
              // User name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppCustomText(
                    text: controller.user?.name ?? "",
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                  8.horizontalSpace,
                  SvgPicture.asset(
                    AppUtils.getIconPath("ic_verify"),
                    width: 18.w,
                    height: 18.h,
                  ),
                ],
              ),
              5.verticalSpace,
              // Phone number
              AppCustomText(
                text: controller.user?.mobile ?? "",
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: HexColor("4E4E4E"),
              ),
            ],
          ),
        );
      },
    );
  }

  // Section title (My Account, Settings, Others)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 16.h, bottom: 5.h),
      child: AppCustomText(
        text: title,
        fontWeight: FontWeight.w400,
        fontSize: 14.sp,
        color: HexColor("B0B0B0"),
      ),
    );
  }

  // Menu item with icon, title and action (arrow or toggle)
  Widget _buildMenuItem({
    required String icon,
    required String title,
    bool hasArrow = false,
    bool hasToggle = false,
    bool isShowDivider = false,
    RxBool? isToggled,
    Color iconColor = Colors.redAccent,
    Color textColor = Colors.black,
    Function()? onTap,
    Function(bool)? onToggle,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom:
                isShowDivider == true
                    ? BorderSide(color: HexColor("D4D4D4"), width: 0.5.w)
                    : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            // Left icon
            SvgPicture.asset(
              AppUtils.getIconPath(icon),
              width: 20.w,
              height: 20.h,
            ),
            13.horizontalSpace,
            // Title
            Expanded(
              child: AppCustomText(
                text: title,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: textColor,
              ),
            ),

            // Right element: arrow or toggle
            if (hasArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 14.r,
                color: AppTheme.primaryColor,
              ),
            if (hasToggle && isToggled != null)
              Obx(
                () => AppCustomSwitch(
                  value: isToggled.value,
                  onChanged: null,
                  height: 27.h,
                  width: 45.w,
                  toggleSize: 18.r,
                  activeColor: Colors.green,
                  inactiveColor: Colors.grey[300]!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
