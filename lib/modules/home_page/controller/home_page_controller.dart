import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/core/models/home/banner.dart' as bn;
import 'package:offers/core/models/home/category.dart';
import 'package:offers/core/models/home/flyer.dart';
import 'package:offers/core/models/home/home_data.dart';
import 'package:offers/modules/base_controller.dart';

import '../../../app/widgets/feedback/app_toast.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../../core/models/home/available_competition.dart';
import '../../../core/models/home/partner.dart';

class HomePageController extends BaseController {
  final RxBool isLoading = false.obs;
  var homeData = HomeData().obs;
  final searchController = TextEditingController();

  var currentBannerIndex = 0.obs;
  var selectedCategoryId = 0.obs; // Default to 'All' (id = 0)

  @override
  void onInit() {
    super.onInit();

    getHome();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> getHome() async {
    try {
      isLoading(true);
      final result = await httpService.request(
        url: ApiConstant.home,
        method: Method.GET,
      );
      // Process response
      if (result != null) {
        var response = ApiResponse.fromJsonModel<HomeData>(
          result.data,
          HomeData.fromJson,
        );
        if (response.isSuccess && response.data != null) {
          homeData.value = response.data!;
          print('Log selectedCategoryId ${selectedCategoryId.value}');
          if (homeData.value.partnerCategories != null &&
              homeData.value.partnerCategories!.isEmpty) {
            selectedCategoryId(homeData.value.partnerCategories![0].id);
          }
          print('Log 11 selectedCategoryId ${selectedCategoryId.value}');
        } else {
          // Show error message
          AppToast.error(response.message);
        }
      }
    } finally {
      // Hide loading indicator and update UI
      isLoading(false);
      update(['selectQuestion']);
    }
  }

  void selectCategory(int id) {
    selectedCategoryId.value = id;
  }

  void changeBanner(int index) {
    currentBannerIndex.value = index;
  }

  List<bn.Banner> getBanners() {
    return homeData.value.banners ?? [];
  }

  List<Category> getPartnerCategories() {
    List<Category> categories = [];
    // categories.add(Category(id: 0, name: LangKeys.all.tr, partnersCount: 0));
    // Add categories from API
    if (homeData.value.partnerCategories != null) {
      categories.addAll(homeData.value.partnerCategories!);
      if (selectedCategoryId.value == 0) {
        selectedCategoryId(homeData.value.partnerCategories![0].id);
      }
    }

    return categories;
  }

  // Get partners for the selected category
  List<Partner> getPartnersForSelectedCategory() {
    // If no categories available, return empty list
    if (homeData.value.partnerCategories == null ||
        homeData.value.partnerCategories!.isEmpty) {
      return [];
    }

    // If selectedCategoryId is 0 (All), return all partners from all categories
    if (selectedCategoryId.value == 0) {
      List<Partner> allPartners = [];
      for (var category in homeData.value.partnerCategories!) {
        if (category.partners != null) {
          allPartners.addAll(category.partners!);
        }
      }
      return allPartners;
    }
    // Find selected category and return its partners
    final selectedCategory = homeData.value.partnerCategories!.firstWhere(
      (category) => category.id == selectedCategoryId.value,
      orElse: () => homeData.value.partnerCategories![0],
    );

    return selectedCategory.partners ?? [];
  }

  List<Flyer> getStarredFlyers() {
    return homeData.value.starredFlyers ?? [];
  }

  List<Flyer> getNearestFlyers() {
    return homeData.value.nearestFlyers ?? [];
  }

  List<Flyer> getLatestFlyers() {
    return homeData.value.latestFlyers ?? [];
  }

  AvailableCompetition? getAvailableCompetition() {
    return homeData.value.availableCompetition;
  }
}
