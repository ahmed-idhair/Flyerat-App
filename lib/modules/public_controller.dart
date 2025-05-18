import 'package:get/get.dart';

import 'base_controller.dart';

class PublicController extends BaseController {
  var notCount = 0.obs;
  var walletBalance = "0".obs;
  // var wallet = Wallet(amount: 0,currency: "").obs;

  // Future<void> changeFcmToken(String fcmToken) async {
  //   try {
  //     final result = await httpService.request(
  //         url: "${ApiConstant.changeFcmToken}?fcmToken=$fcmToken",
  //         method: Method.PUT);
  //     if (result != null) {
  //       if (result is d.Response) {
  //         var core = GlobalModel.fromJson(result.core);
  //         if (core.success == true) {
  //         } else {
  //           // UiErrorUtils.customSnackbar(
  //           //     title: LangKeys.error.tr, msg: core.errorMessage ?? "");
  //         }
  //       }
  //     }
  //   } finally {
  //     // EasyLoading.dismiss(animation: true);
  //   }
  // }

  // Future<void> changeLanguage() async {
  //   try {
  //     final result = await httpService.request(
  //         url: "${ApiConstant.changeLanguage}?lang=${storage.getLanguageCode() == "ar" ? 1 : 0}",
  //         method: Method.PUT);
  //     if (result != null) {
  //       if (result is d.Response) {
  //         var core = GlobalModel.fromJson(result.core);
  //         if (core.success == true) {
  //         } else {
  //           // UiErrorUtils.customSnackbar(
  //           //     title: LangKeys.error.tr, msg: core.errorMessage ?? "");
  //         }
  //       }
  //     }
  //   } finally {
  //     // EasyLoading.dismiss(animation: true);
  //   }
  // }
}
