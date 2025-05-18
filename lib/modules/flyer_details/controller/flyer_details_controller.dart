import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/core/models/home/media_data.dart';
import 'package:offers/modules/base_controller.dart';

import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../../core/models/flyer_liked.dart';
import '../../../core/models/home/flyer.dart';

class FlyerDetailsController extends BaseController {
  final Rxn<Flyer> flyer = Rxn<Flyer>();
  final RxBool isLoading = false.obs;
  final RxList<MediaData> flyerImages = <MediaData>[].obs;
  final RxInt currentPage = 0.obs;
  RxString title = "".obs;
  int? partnerId;

  @override
  onInit() {
    super.onInit();
    // title = Get.arguments['title'];
    partnerId = Get.arguments['id'];
    getPartnerFlyer();
  }

  Future<void> getPartnerFlyer() async {
    try {
      // Show loading indicator
      isLoading(true);
      final result = await httpService.request(
        url: "${ApiConstant.partnerFlyers}/$partnerId",
        method: Method.GET,
      );
      if (result != null) {
        var resp = ApiResponse.fromJsonModel(result.data, Flyer.fromJson);
        if (resp.isSuccess && resp.data != null) {
          flyerImages.addAll(resp.data?.media ?? []);
          flyer.value = resp.data;
          title.value = resp.data?.partner?.name ?? "";
        }
      }
    } finally {
      // Hide loading indicator
      isLoading(false);
      update(['updateDetails']);
    }
  }

  Future<void> flyerLiked() async {
    try {
      // Show loading indicator
      // isLoading(true);
      EasyLoading.show();
      final result = await httpService.request(
        url: "${ApiConstant.partnerFlyers}/$partnerId/like",
        method: Method.POST,
      );
      if (result != null) {
        var resp = ApiResponse.fromJsonModel(result.data, FlyerLiked.fromJson);
        if (resp.isSuccess && resp.data != null) {
          flyer.value?.isLiked = resp.data?.isLiked;
          flyer.value?.likesCount = resp.data?.likesCount;
        }
      }
    } finally {
      // Hide loading indicator
      // isLoading(false);
      EasyLoading.dismiss();
      update(['updateDetails']);
    }
  }

  Future<void> flyerShare() async {
    try {
      // Show loading indicator
      // isLoading(true);
      // EasyLoading.show();
      final result = await httpService.request(
        url: "${ApiConstant.partnerFlyers}/$partnerId/share",
        method: Method.POST,
      );
      if (result != null) {
        var resp = ApiResponse.fromJsonModel(result.data, FlyerLiked.fromJson);
        if (resp.isSuccess) {
          flyer.value?.sharesCount = (flyer.value!.sharesCount! + 1);
          AppUtils.shareAppLink(flyer.value?.title ?? "");
        }
      }
    } finally {
      // Hide loading indicator
      // isLoading(false);
      // EasyLoading.dismiss();
      update(['updateDetails']);
    }
  }
}
