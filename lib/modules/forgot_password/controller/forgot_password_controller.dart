import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/core/api/api_response.dart';
import 'package:offers/core/models/user/user_data.dart';

import '../../../app/translations/lang_keys.dart';
import '../../../app/widgets/feedback/app_toast.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/http_service.dart';
import '../../base_controller.dart';

class ForgotPasswordController extends BaseController {
  final emailController = TextEditingController();
  final RxBool isLoading = false.obs;

  @override
  void dispose() {
    emailController.dispose();
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
    forgotPassword();
  }

  Future<void> forgotPassword() async {
    try {
      Map<String, String> body = {"email": emailController.text.trim()};
      isLoading(true);
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
            Get.toNamed(
              AppRoutes.verificationCode,
              arguments: {
                "from": AppRoutes.forgotPassword,
                "email": emailController.text,
                "token": data.data?.verification?.token,
              },
            );
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
}
