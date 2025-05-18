import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:offers/app/widgets/feedback/app_toast.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/services/fcm_service.dart';
import '../../../app/translations/lang_keys.dart';
import '../../../app/widgets/common/app_bottom_sheet.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../../core/models/user/user.dart';
import '../../../core/models/user/user_data.dart';
import '../../base_controller.dart';

class VerificationCodeController extends BaseController {
  var pinController = TextEditingController();
  late Timer _timer;
  final RxInt start = 60.obs;
  var timeStr = "00:00".obs;
  String? from;
  String? token;
  var isLoadingVerify = false.obs;
  var isLoadingResend = false.obs;
  final FCMService _fcmService = FCMService();

  @override
  onInit() {
    super.onInit();
    from = Get.arguments['from'];
    token = Get.arguments['token'];
    // token = Get.arguments['token'] ?? "";
    startTimer();
  }

  Future<void> verifyMobile() async {
    try {
      Map<String, String> body = {
        'token': token ?? "",
        "code": pinController.text,
      };
      isLoadingVerify(true);
      final result = await httpService.request(
        url: ApiConstant.verify,
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var data = ApiResponse.fromJsonModel(result.data, UserData.fromJson);
        if (data.isSuccess == true) {
          if (Get.arguments['from'] == AppRoutes.signUp ||
              Get.arguments['from'] == AppRoutes.signIn) {
            // var data = UserModel.fromJson(result.data);
            if (data.data != null) {
              await _fcmService.subscribeToUsers();
              await _fcmService.subscribeToUser(data.data!.user!.id!);
              showSuccessBottomSheet(
                data.message ?? "",
                textBtn: LangKeys.continueText.tr,
                onClick: () {
                  storage.setUserToken(data.data!.token!);
                  storage.setUser(data.data!.user!);
                  Get.back();
                  updateLocation();
                  // Get.offAllNamed(AppRoutes.home);
                },
              );
            } else {
              AppToast.error(data.message);
            }
          } else if (Get.arguments['from'] == AppRoutes.forgotPassword) {
            Get.toNamed(AppRoutes.newPassword, arguments: {"token": token});
          }
        } else {
          showErrorBottomSheet(data.message);
          // UiErrorUtils.customSnackbar(
          //     title: LangKeys.error.tr, msg: data.message ?? "");
        }
      }
    } finally {
      isLoadingVerify(false);
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

  void startTimer() {
    start.value = 60;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (start.value == 0) {
        timer.cancel();
      } else {
        start.value == start.value--;
      }
      timeStr.value = intToTimeLeft(start.value);
    });
  }

  String intToTimeLeft(int value) {
    int h, m, s;

    h = value ~/ 3600;

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);
    //
    // String hourLeft = h.toString().length < 2 ? "0" + h.toString() : h.toString();

    String minuteLeft = m.toString().length < 2 ? "0$m" : m.toString();

    String secondsLeft = s.toString().length < 2 ? "0$s" : s.toString();

    String result = "$minuteLeft:$secondsLeft";

    return result;
  }

  Future<void> sendVerificationCode() async {
    try {
      Map<String, String> body = {"token": token ?? ""};
      isLoadingResend(true);
      final result = await httpService.request(
        url: ApiConstant.resendOtp,
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var data = ApiResponse.fromJsonModel(result.data, UserData.fromJson);
        if (data.isSuccess == true) {
          AppToast.success(data.message ?? "");
          if (data.data != null &&
              data.data?.verification != null &&
              data.data?.verification?.token != null &&
              data.data?.verification?.token != "") {
            token = data.data?.verification?.token;
            startTimer();
          }
        } else {
          AppToast.error(data.message ?? "");
        }
      }
    } finally {
      isLoadingResend(false);
    }
  }

  Future<void> sendVerificationCodeForgetPassword() async {
    try {
      Map<String, String> body = {"email": Get.arguments['email'] ?? ""};
      isLoadingResend(true);
      final result = await httpService.request(
        url: ApiConstant.forgotPassword,
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var data = ApiResponse.fromJsonModel(result.data, UserData.fromJson);
        if (data.isSuccess == true) {
          AppToast.success(data.message ?? "");
          if (data.data != null &&
              data.data?.verification != null &&
              data.data?.verification?.token != null &&
              data.data?.verification?.token != "") {
            token = data.data?.verification?.token;
            startTimer();
          }
        } else {
          AppToast.error(data.message ?? "");
        }
      }
    } finally {
      isLoadingResend(false);
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    _timer.cancel();
    super.dispose();
  }
}
