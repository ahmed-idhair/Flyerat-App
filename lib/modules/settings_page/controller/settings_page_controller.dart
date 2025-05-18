import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:offers/core/models/user/user.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/services/fcm_service.dart';
import '../../../app/widgets/feedback/app_toast.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../base_controller.dart';

class SettingsPageController extends BaseController {
  final RxBool isNotificationsEnabled = false.obs;
  final RxBool isLoading = false.obs;
  User? user;
  final FCMService _fcmService = FCMService();

  @override
  void onInit() {
    super.onInit();
    if (storage.isAuth()) {
      updateUser();
      getProfile();
    }
  }

  // Toggle notifications
  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;
  }

  void updateUser() {
    user = storage.getUser();
    toggleNotifications(user?.notifications ?? false);
    print('Log isNotificationsEnabled.value ${isNotificationsEnabled.value}');
    update(['updateUser']);
  }

  Future<void> getProfile() async {
    try {
      isLoading(true);
      final result = await httpService.request(
        url: ApiConstant.getProfile,
        method: Method.GET,
      );
      if (result != null) {
        var response = ApiResponse.fromJsonModel(result.data, User.fromJson);
        if (response.isSuccess && response.data != null) {
          user = response.data!;
          storage.setUser(response.data!);
          updateUser();
        } else {
          AppToast.error(response.message);
        }
      }
    } finally {
      isLoading(false);
      update(['updateUser']);
    }
  }

  Future<void> updateNotifications() async {
    try {
      EasyLoading.show();
      Map<String, dynamic> body = {
        "notifications": isNotificationsEnabled.isTrue ? 0 : 1,
      };
      final result = await httpService.request(
        url: ApiConstant.updateNotifications,
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var response = ApiResponse.fromJsonModel(result.data, User.fromJson);
        if (response.isSuccess && response.data != null) {
          user = response.data!;
          storage.setUser(response.data!);
          updateUser();
        } else {
          AppToast.error(response.message);
        }
      }
    } finally {
      EasyLoading.dismiss();
      update(['updateUser']);
    }
  }

  void shareAppLink() {
    final String appName = 'Offers';
    final String appStoreLink = 'https://apps.apple.com/app/your-app-id';
    final String playStoreLink =
        'https://play.google.com/store/apps/details?id=your.package.name';
    final String message =
        '$appName\n\n'
        'Android: $playStoreLink\n\n'
        'iOS: $appStoreLink';

    Share.share(message);
  }

  Future<void> logout(bool isDeleteAccount) async {
    try {
      EasyLoading.show();
      final result = await httpService.request(
        url: ApiConstant.logout,
        method: Method.POST,
      );
      if (result != null) {
        var resp = ApiResponse<void>.fromJson(result.data);
        if (resp.isSuccess == true) {
          if (isDeleteAccount == false) {
            AppToast.success(resp.message ?? "");
          }
          await _fcmService.unsubscribeFromUser(storage.getUser()!.id!);
          await _fcmService.unsubscribeFromUsers();
          storage.clearApp();
          Get.offAllNamed(AppRoutes.signIn);
        } else {
          AppToast.error(resp.message ?? "");
        }
      }
    } finally {
      EasyLoading.dismiss(animation: true);
    }
  }
}
