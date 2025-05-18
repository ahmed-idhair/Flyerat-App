import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/translations/lang_keys.dart';
import '../../../app/widgets/feedback/app_toast.dart';
import '../../../app/widgets/forms/app_phone_input.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../../core/models/user/user_data.dart';
import '../../base_controller.dart';

class SignUpController extends BaseController {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  var isAgreeTerms = false.obs;
  final phoneFocusNode = FocusNode();

  PhoneData? currentPhoneData;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Update current phone data when phone changes
  void onPhoneChanged(PhoneData phoneData) {
    currentPhoneData = phoneData;
  }

  Future<void> validate() async {
    if (fullNameController.text.isEmpty) {
      AppToast.error(LangKeys.enterFullName.tr);
      return;
    }

    // Validate phone
    if (phoneController.text.isEmpty) {
      AppToast.error(LangKeys.enterMobileNumber.tr);
      return;
    }
    // Ensure we have phone data
    // if (currentPhoneData == null) {
    //   AppToast.error("Phone data is missing");
    //   return;
    // }
    final validationResult = await AppPhoneInput.validateMobile(
      currentPhoneData!,
    );
    if (!validationResult.isValid) {
      AppToast.error(LangKeys.mobileNumberInvalid.tr);
      return;
    }

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

    if (confirmPasswordController.text.isEmpty) {
      AppToast.error(LangKeys.enterConfirmPassword.tr);
      return;
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      AppToast.error(LangKeys.passwordNotMatch.tr);
      return;
    }

    if (isAgreeTerms.isFalse) {
      AppToast.error(
        "${LangKeys.iHaveReadAndAgreeToThe.tr} ${LangKeys.termsOfService.tr}",
      );
      return;
    }
    register(validationResult.fullNumber);
    // Continue with form submission
    // submitForm(validationResult.fullNumber);
  }

  Future<void> register(String fullNumber) async {
    try {
      Map<String, dynamic> body = {
        "name": fullNameController.text,
        "email": emailController.text,
        "mobile": fullNumber,
        "password": passwordController.text.trim(),
        "password_confirmation": confirmPasswordController.text.trim(),
        "confirm_privacy": isAgreeTerms.isTrue ? 1 : 0,
      };
      isLoading(true);
      final result = await httpService.request(
        url: ApiConstant.register,
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var data = ApiResponse.fromJsonModel(result.data, UserData.fromJson);
        if (data.isSuccess == true) {
          // AppToast.success(data.message ?? "");
          if (data.data != null &&
              data.data?.verification != null &&
              data.data?.verification?.token != null &&
              data.data?.verification?.token != "") {
            Get.toNamed(
              AppRoutes.verificationCode,
              arguments: {
                "from": AppRoutes.signUp,
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

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }
}
