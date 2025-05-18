import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart'
    as intl_phone;
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/feedback/app_toast.dart';
import 'package:offers/core/models/user/user.dart';
import 'package:offers/modules/base_controller.dart';
import 'package:offers/modules/profile/controller/profile_controller.dart';
import 'package:offers/modules/settings_page/controller/settings_page_controller.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../../app/widgets/forms/app_phone_input.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';

class EditProfileController extends BaseController {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();

  final emailController = TextEditingController();
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isAgreeTerms = false.obs;
  final phoneFocusNode = FocusNode();

  // final RxString phoneCode = '962'.obs;
  // final RxString countryCode = 'JO'.obs;
  // final RxString flag = '🇯🇴'.obs;
  String? fullMobile;

  User? user;

  @override
  void onInit() {
    super.onInit();
    user = storage.getUser();
    fullNameController.text = user?.name ?? "";
    emailController.text = user?.email ?? "";
    parsePhoneNumber(user?.mobile);
  }

  Future<void> parsePhoneNumber(String? mobile) async {
    intl_phone.PhoneNumber phoneNumber = await intl_phone
        .PhoneNumber.getRegionInfoFromPhoneNumber(mobile ?? "");
    if (phoneNumber.phoneNumber != null) {
      phoneController.text = phoneNumber.phoneNumber!.replaceAll(
        "+${phoneNumber.dialCode}",
        "",
      );

      print('Log dialCode ${phoneNumber.dialCode}');
      print('Log isoCode ${phoneNumber.isoCode}');
      currentPhoneData = PhoneData(
        phoneNumber: phoneController.text,
        phoneCode: phoneNumber.dialCode ?? "962",
        countryCode: phoneNumber.isoCode ?? "JO",
        flag: currentPhoneData?.flag ?? "",
      );
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  PhoneData? currentPhoneData;

  // Update current phone data when phone changes
  void onPhoneChanged(PhoneData phoneData) {
    currentPhoneData = phoneData;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> validation() async {
    if (fullNameController.text.isEmpty) {
      AppToast.error(LangKeys.enterFullName.tr);
      return;
    }
    if (phoneController.text.isEmpty) {
      AppToast.error(LangKeys.enterMobileNumber.tr);
      return;
    }

    // تحديث رقم الهاتف في currentPhoneData إذا تم تغييره في حقل الإدخال

    final validationResult = await AppPhoneInput.validateMobile(
      currentPhoneData!,
    );
    if (!validationResult.isValid) {
      AppToast.error(LangKeys.mobileNumberInvalid.tr);
      return;
    }
    updateProfile(validationResult.fullNumber);
  }

  Future<void> updateProfile(String fullMobile) async {
    try {
      Map<String, dynamic> body = {
        "name": fullNameController.text,
        "email": emailController.text.trim(),
        "mobile": fullMobile,
        "city_id": 1,
        "timezone": "UTC",
      };
      isLoading(true);

      final result = await httpService.request(
        url: ApiConstant.updateProfile,
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var data = ApiResponse.fromJsonModel(result.data, User.fromJson);
        if (data.isSuccess == true) {
          storage.setUser(data.data!);
          Get.find<ProfileController>().updateUser();
          Get.find<SettingsPageController>().updateUser();
          Get.back();
          AppToast.success(data.message ?? "");
        } else {
          AppToast.error(data.message ?? "");
        }
      }
    } finally {
      isLoading(false);
    }
  }
}
