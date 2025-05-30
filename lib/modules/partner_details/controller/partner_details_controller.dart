import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:offers/core/api/api_response.dart';
import 'package:offers/core/models/flyers/flyers.dart';
import 'package:offers/core/models/home/flyer.dart';
import 'package:offers/core/models/home/location_data.dart';
import 'package:offers/core/models/home/partner.dart';
import 'package:offers/modules/base_controller.dart';

import '../../../app/translations/lang_keys.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/http_service.dart';

class PartnerDetailsController extends BaseController {
  Partner? partner;
  var isLoading = false.obs;
  var partnerId = 0.obs;
  Rxn<LocationData> nearestLocation = Rxn<LocationData>();
  final searchController = TextEditingController();
  String searchQuery = '';

  final PagingController<int, Flyer> pagingController = PagingController(
    firstPageKey: 1,
  );

  final int _pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      partnerFlyers(pageKey);
    });
    if (Get.arguments != null && Get.arguments.containsKey('id')) {
      partnerId.value = Get.arguments['id'];
      if (partnerId.value > 0) {
        getPartnerProfile();
      } else {
        pagingController.error = LangKeys.anErrorFetchingData.tr;
      }
    } else {
      pagingController.error = LangKeys.anErrorFetchingData.tr;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    pagingController.dispose();
    super.dispose();
  }

  void clearSearch() {
    searchQuery = '';
    searchController.clear();
    pagingController.refresh();
  }

  void performSearch() {
    searchQuery = searchController.text.trim();
    pagingController.refresh();
  }

  Future<void> getPartnerProfile() async {
    try {
      isLoading(true);
      if (partnerId.value <= 0) {
        pagingController.error = LangKeys.anErrorFetchingData.tr;
        return;
      }
      final result = await httpService.request(
        url: "${ApiConstant.partner}/${partnerId.value}/profile",
        method: Method.GET,
      );
      if (result != null) {
        var response = ApiResponse.fromJsonModel(result.data, Partner.fromJson);
        if (response.isSuccess && response.data != null) {
          partner = response.data!;
          update(['updatePartner']);
        } else {
          pagingController.error = response.message;
        }
      } else {
        pagingController.error = LangKeys.anErrorFetchingData.tr;
      }
    } catch (error) {
      pagingController.error = error.toString();
    } finally {

      isLoading(false);
      update(['updatePartner']);
    }
  }

  Future<void> partnerFlyers(int pageKey) async {
    try {
      Map<String, dynamic> body = {
        'page': pageKey,
        'partner_id': partnerId.value,
      };
      if (searchQuery.isNotEmpty) {
        body['search'] = searchQuery;
      }
      final result = await httpService
          .request(
            url: ApiConstant.partnerFlyers,
            method: Method.GET,
            params: body,
          )
          .catchError((onError) => pagingController.error = onError);
      if (result != null) {
        var resp = ApiResponse.fromJsonModel(result.data, Flyers.fromJson);
        if (resp.isSuccess && resp.data != null) {
          nearestLocation.value = resp.data?.nearestLocation;
          final list = resp.data?.flyers ?? [];
          final isLastPage = list.length < _pageSize;
          if (isLastPage) {
            pagingController.appendLastPage(list);
          } else {
            final nextPageKey = pageKey + 1;
            pagingController.appendPage(list, nextPageKey);
          }
        } else {
          pagingController.error = resp.message;
        }
      } else {
        pagingController.error = LangKeys.anErrorFetchingData.tr;
      }
    } catch (error) {
      pagingController.error = error.toString();
    }
  }
}
