import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/buttons/app_button.dart';
import 'package:offers/app/widgets/common/app_loading_view.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';

import '../../../app/translations/lang_keys.dart';
import '../controller/splash_controller.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SplashController controller = Get.put(SplashController());

  // @override
  // void initState() {
  //   super.initState();
  //   controller.checkAuth();
  // }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: AppLoadingView());
          } else if (!controller.hasInternet.value) {
            return Container(
              height: ScreenUtil().screenHeight,
              width: ScreenUtil().screenWidth,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppUtils.getIconPath("no_internet"),
                      width: 80.w,
                      colorFilter: ColorFilter.mode(
                        AppTheme.primaryColor,
                        BlendMode.srcIn,
                      ),
                      height: 80.h,
                    ),
                    22.verticalSpace,
                    AppCustomText(
                      text: LangKeys.notInternetConnection.tr,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 15.0.sp,
                    ),
                    22.verticalSpace,
                    Padding(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 40.w,
                      ),
                      child: AppButton(
                        isLoading: controller.isLoading.value,
                        onPressed: () {
                          controller.retryConnection();
                        },
                        text: LangKeys.retry.tr,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            controller.checkAuth();
            return Container(
              height: ScreenUtil().screenHeight,
              width: ScreenUtil().screenWidth,
              decoration: BoxDecoration(
                color: Colors.white,

                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: [
                //     const Color(0x0f43bafc).withValues(alpha: 1),
                //     const Color(0x0f000000).withValues(alpha: 1),
                //   ],
                // ),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Animate(
                      effects: const [FadeEffect(), ScaleEffect()],
                      delay: 1300.ms,
                      child: SvgPicture.asset(
                        AppUtils.getIconPath("ic_logo_sp"),
                        width: 144.w,
                        height: 55.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 46.0.w),
                ],
              ),
            ); // Empty screen while navigating
          }
        }),
      ),
    );
  }
}
