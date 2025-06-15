import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/widgets/buttons/app_button.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/extensions/color.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/services/fcm_service.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../../core/models/app_config/app_config.dart';
import '../../base_controller.dart';
import '../../select_location/controller/user_location_controller.dart';
import '../../select_location/widget/location_screen.dart';

class SplashController extends BaseController {
  var hasInternet = false.obs; // Observable for internet status
  var isLoading = true.obs;
  var locationSheetShown = false.obs;
  final fcmService = FCMService();

  // Update check variables
  var isCheckingUpdate = false.obs;
  var updateAvailable = false.obs;
  var forceUpdate = false.obs;
  var appConfig = <AppConfig>[].obs;

  @override
  void onInit() {
    super.onInit();
    checkInternetConnection();
  }

  void checkAuth() async {
    // Initialize FCM service
    await fcmService.init();
    // Check for app updates if internet is available
    if (hasInternet.value) {
      // isCheckingUpdate(true);
      await checkForUpdates();
    }
  }


  // Fetch app configuration and check for updates
  Future<void> checkForUpdates() async {
    try {
      EasyLoading.show();
      isCheckingUpdate(true);
      final result = await httpService.request(
        url: ApiConstant.appData,
        method: Method.GET,
      );

      if (result != null) {
        var response = ApiResponse.fromJsonList<AppConfig>(
          result.data,
          AppConfig.fromJson,
        );

        if (response.isSuccess &&
            response.data != null &&
            response.data != null) {
          // Store app config
          appConfig.value = response.data!;

          // Check if update is needed
          bool needsUpdate = await isUpdateAvailable();
          updateAvailable.value = needsUpdate;
          // Check if update is forced
          forceUpdate.value =
              needsUpdate && getConfigValue('app_update_force') == '1';

          // if (updateAvailable.value && forceUpdate.value) {
          //   showUpdateDialog();
          //   return;
          // }
          // If there's a non-force update, show dialog but also continue after delay
          if (updateAvailable.value) {
            showUpdateDialog();
            return;
          }

          if (!storage.hasLocationData() && !locationSheetShown.value) {
            locationSheetShown.value = true;
            // Show location bottom sheet
            Get.offAll(() => LocationScreen(isChangingLocation: false));
            // showLocationBottomSheet();
          } else {
            // Normal app flow
            navigateToNextScreen();
          }
        }
      }
    } catch (e) {
      print("Error checking for updates: $e");
    } finally {
      isCheckingUpdate(false);
      EasyLoading.dismiss();
    }
  }

  // Compare current app version with required version
  Future<bool> isUpdateAvailable() async {
    try {
      // Get current app version
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // Get required version based on platform
      String requiredVersion =
          GetPlatform.isIOS
              ? getConfigValue('app_version_ios')
              : getConfigValue('app_version_android');

      if (requiredVersion.isEmpty) return false;

      print('Log requiredVersion $requiredVersion');
      print('Log requiredVersion $currentVersion');
      // Compare versions
      return compareVersions(currentVersion, requiredVersion) < 0;
    } catch (e) {
      print("Error comparing versions: $e");
      return false;
    }
  }

  // Compare two version strings
  int compareVersions(String version1, String version2) {
    List<int> v1Parts =
        version1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    List<int> v2Parts =
        version2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    // Add zeroes if parts count differs
    while (v1Parts.length < v2Parts.length) {
      v1Parts.add(0);
    }
    while (v2Parts.length < v1Parts.length) {
      v2Parts.add(0);
    }

    // Compare each part
    for (int i = 0; i < v1Parts.length; i++) {
      if (v1Parts[i] < v2Parts[i]) {
        return -1; // First version is older
      } else if (v1Parts[i] > v2Parts[i]) {
        return 1; // First version is newer
      }
    }

    return 0; // Versions are equal
  }

  // Get config value by key
  String getConfigValue(String key) {
    final item = appConfig.firstWhereOrNull((item) => item.key == key);
    return item?.value ?? '';
  }

  // Get localized strings based on current language
  String getLocalizedConfigValue(String keyPrefix) {
    String langSuffix = storage.getLanguageCode() == 'ar' ? 'ar' : 'en';
    return getConfigValue('${keyPrefix}_$langSuffix');
  }

  void showUpdateDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: 14.w,
              end: 14.w,
              top: 16.h,
              bottom: 20.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  color: AppTheme.primaryColor,
                  size: 48.r,
                ),
                14.verticalSpace,
                AppCustomText(
                  text: getLocalizedConfigValue('app_update_title'),
                  fontSize: 14.sp,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                ),
                14.verticalSpace,
                AppCustomText(
                  text: getLocalizedConfigValue('app_update_message'),
                  fontSize: 13.sp,
                  textAlign: TextAlign.center,
                  color: HexColor("3E3E3F"),
                  fontWeight: FontWeight.w400,
                ),
                20.verticalSpace,
                AppButton(
                  text: getLocalizedConfigValue('text_update_now'),
                  onPressed: () => launchAppStore(),
                ),
                Visibility(
                  visible: !forceUpdate.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      12.verticalSpace,
                      AppButton(
                        text: getLocalizedConfigValue('text_update_later'),
                        variant: ButtonVariant.outline,
                        onPressed: () {
                          Get.back();
                          if (!storage.hasLocationData() &&
                              !locationSheetShown.value) {
                            locationSheetShown.value = true;
                            // Show location bottom sheet
                            Get.offAll(() => LocationScreen(isChangingLocation: false));
                          } else {
                            // Normal app flow
                            navigateToNextScreen();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> launchAppStore() async {
    String url =
        GetPlatform.isIOS
            ? getConfigValue('app_store_link')
            : getConfigValue('play_store_link');

    if (url.isNotEmpty) {
      try {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          // If not force update, close dialog after launching store
          // if (!forceUpdate.value) {
          //   Get.back();
          // }
        } else {
          print("Could not launch $url");
        }
      } catch (e) {
        print("Error launching store: $e");
      }
    }
  }


  void navigateToNextScreen() {
    if (storage.isIntro()) {
      if (storage.isAuth()) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.signIn);
      }
    } else {
      Get.offAllNamed(AppRoutes.onBoarding);
    }
  }

  Future<void> checkInternetConnection() async {
    isLoading.value = true; // Show splash screen
    final connectivityResults = await Connectivity().checkConnectivity();
    // Check if any result in the list indicates a connected state
    if (connectivityResults.contains(ConnectivityResult.mobile) ||
        connectivityResults.contains(ConnectivityResult.wifi)) {
      hasInternet.value = true;
    } else {
      hasInternet.value = false;
    }

    isLoading.value = false; // Hide splash screen when done
  }

  void retryConnection() {
    checkInternetConnection(); // Retry internet check
  }
}
