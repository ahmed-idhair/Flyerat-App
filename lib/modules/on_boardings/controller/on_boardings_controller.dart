import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/core/models/on_boardings.dart';

import '../../../app/widgets/feedback/app_toast.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../base_controller.dart';

class OnBoardingsController extends BaseController {
  // Observable variables
  var items = <OnBoardings>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt currentPage = 0.obs;

  // Page controller for onboarding slides
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    fetchOnboardingData();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // Fetch onboarding items from API
  Future<void> fetchOnboardingData() async {
    try {
      isLoading(true);
      final result = await httpService.request(
        url: ApiConstant.onBoarding,
        method: Method.GET,
      );
      if (result != null) {
        // Use the converter function to parse the list of onboarding items
        var response = ApiResponse.fromJsonList<OnBoardings>(
          result.data,
          OnBoardings.fromJson,
        );
        if (response.isSuccess && response.data != null) {
          print('Log asdasd');
          items.value = response.data!;
        } else {
          print('Log 454545');
          AppToast.error(response.message);
        }
      }
    } catch (e) {
      AppToast.error("Failed to load onboarding data");
    } finally {
      isLoading(false);
    }
  }

  // Navigate to next page
  void nextPage() {
    if (currentPage.value < items.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  // Skip to the end of onboarding
  void skipOnboarding() {
    completeOnboarding();
  }

  // Complete onboarding process
  void completeOnboarding() {
    storage.setIntro(true);
    Get.offAllNamed(AppRoutes.signIn);
  }

  // Handle page change from PageView
  void onPageChanged(int page) {
    currentPage.value = page;
  }
}
