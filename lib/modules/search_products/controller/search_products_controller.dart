import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:offers/app/widgets/common/app_bottom_sheet.dart';
import 'package:offers/core/models/home/category.dart';
import 'package:offers/core/models/products/products_data.dart';
import 'package:offers/modules/base_controller.dart';
import 'package:offers/modules/favorites_screen/controller/favorites_controller.dart';

import '../../../app/translations/lang_keys.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../../core/models/home/partner.dart';
import '../../../core/models/products/product.dart';

class SearchProductsController extends BaseController {
  // Title and arguments
  String? search;

  // Search query
  RxString searchQuery = ''.obs;
  final searchController = TextEditingController();

  // Pagination controller
  final PagingController<int, Product> pagingController = PagingController(
    firstPageKey: 1,
  );

  // Page size for pagination
  final int _pageSize = 10;

  @override
  void onInit() {
    super.onInit();

    // Get arguments
    if (Get.arguments != null) {
      if (Get.arguments['search'] != null) {
        search = Get.arguments['search'];
        searchController.text = search ?? "";
      }
    }
    pagingController.addPageRequestListener((pageKey) {
      _fetchProductsPage(pageKey);
    });
  }

  void clearSearch() {
    searchQuery.value = '';
    searchController.clear();
    pagingController.refresh();
  }

  void performSearch() {
    // searchQuery.value = searchController.text.trim();
    pagingController.refresh();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchProductsPage(int pageKey) async {
    try {
      // Prepare parameters
      Map<String, dynamic> params = {'page': pageKey};
      // Add search query if not empty
      if (searchController.text.isNotEmpty) {
        params['search'] = searchController.text;
      }
      final result = await httpService.request(
        url: ApiConstant.partnerProducts,
        method: Method.GET,
        params: params,
      );
      if (result == null) {
        // Handle the case where result is null (error was caught)
        if (!pagingController.error.toString().contains('Error')) {
          pagingController.error = LangKeys.notInternetConnection.tr;
        }
        return;
      }
      var response = ApiResponse.fromJsonModel<ProductsData>(
        result.data,
        ProductsData.fromJson,
      );
      if (response.isSuccess == true && response.data != null) {
        final newItems = response.data!.products;
        final pagination = response.data!.pagination;
        final isLastPage = pagination!.currentPage! >= pagination.lastPage!;
        if (isLastPage) {
          pagingController.appendLastPage(newItems!);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems!, nextPageKey);
        }
      } else {
        pagingController.error = response.message ?? 'Failed to load products';
      }
    } catch (e) {
      pagingController.error = e.toString();
    } finally {
      update(['updateList']);
    }
  }

  Future<void> toggleFavorite(Product product) async {
    try {
      // Get the current product index for updating UI
      final index =
          pagingController.itemList?.indexWhere((p) => p.id == product.id) ??
          -1;

      if (index != -1) {
        // Call API to update favorite status
        EasyLoading.show();
        final result = await httpService.request(
          url: "${ApiConstant.partnerProducts}/${product.id}/add-to-favorite",
          method: Method.POST,
        );
        if (result != null) {
          // Parse the response
          var response = ApiResponse.fromJsonSimple(result.data);
          // Check if response was successful
          if (response.isSuccess == true && response.data != null) {
            // Get the actual favorite status from the response
            bool isFavorite = response.data['is_favorite'] ?? false;
            // Update the product with the server's state (in case the optimistic update was incorrect)
            revertFavoriteChange(index, isFavorite);
            if (Get.isRegistered<FavoritesController>()) {
              Get.find<FavoritesController>().pagingController.refresh();
            }
          } else {
            showErrorBottomSheet(response.message ?? "");
          }
        }
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      // Handle error case and revert UI if necessary
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Helper method to revert favorite change in case of error
  void revertFavoriteChange(int index, bool isFavorite) {
    if (index != -1 && pagingController.itemList != null) {
      final product = pagingController.itemList![index];
      product.isFavorite = isFavorite;
      update(['updateList']);
    }
  }
}
