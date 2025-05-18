import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/core/api/api_response.dart';
import 'package:offers/core/models/user/user_data.dart';

import '../../../app/services/fcm_service.dart';
import '../../../app/translations/lang_keys.dart';
import '../../../app/widgets/feedback/app_toast.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/http_service.dart';
import '../../../core/models/user/user.dart';
import '../../base_controller.dart';

class SignInController extends BaseController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var rememberMe = false.obs;
  var isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;
  final FCMService _fcmService = FCMService();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void validation() {
    if (emailController.text.isEmpty) {
      AppToast.error(LangKeys.enterEmail.tr);
      return;
    }
    if (!GetUtils.isEmail(emailController.text)) {
      AppToast.error(LangKeys.emailNotValid.tr);
      return;
    }
    if (passwordController.text.isEmpty) {
      AppToast.error(LangKeys.enterPassword.tr);
      return;
    }
    login();
  }

  Future<void> login() async {
    try {
      Map<String, String> body = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };
      isLoading(true);
      final result = await httpService.request(
        url: ApiConstant.login,
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var data = ApiResponse.fromJsonModel(result.data, UserData.fromJson);
        if (data.isSuccess == true) {
          AppToast.success(data.message ?? "");
          if (data.data != null) {
            if (data.data?.user?.isVerified == true) {
              storage.setUserToken(data.data!.token!);
              storage.setUser(data.data!.user!);
              await _fcmService.subscribeToUsers();
              await _fcmService.subscribeToUser(data.data!.user!.id!);
              updateLocation();
              // Get.offAllNamed(AppRoutes.home);
            } else {
              print('Log asdasd');
            }
          }
        } else {
          AppToast.error(data.message ?? "");
          // showErrorBottomSheet(data.message ?? "");
        }
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateLocation() async {
    try {
      EasyLoading.show();
      Map<String, dynamic> body = {"city_id": storage.getSelectedCity()?.id};
      if (storage.getUserLocation() != null) {
        body['lat'] = storage.getUserLocation()!['latitude'];
        body['lng'] = storage.getUserLocation()!['longitude'];
      }
      final result = await httpService.request(
        url: ApiConstant.location,
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var response = ApiResponse.fromJsonModel(result.data, User.fromJson);
        if (response.isSuccess && response.data != null) {
          // storage.setUser(response.data!);
          // updateUser();
          await _fcmService.subscribeToCountry(
            storage.getSelectedCountry()!.id!,
          );
          await _fcmService.subscribeToCity(storage.getSelectedCity()!.id!);

          Get.offAllNamed(AppRoutes.home);
        } else {
          AppToast.error(response.message);
        }
      }
    } finally {
      EasyLoading.dismiss();
      // update(['updateUser']);
    }
  }
}
