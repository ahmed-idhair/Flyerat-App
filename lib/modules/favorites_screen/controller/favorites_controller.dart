
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:offers/app/widgets/common/app_bottom_sheet.dart';
import 'package:offers/core/models/favorites/favorite.dart';
import 'package:offers/core/models/favorites/favorites_data.dart';
import 'package:offers/modules/base_controller.dart';

import '../../../app/translations/lang_keys.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../../core/models/products/product.dart';

class FavoritesController extends BaseController {
  final RxInt totalResult = 0.obs;

  // Pagination controller
  final PagingController<int, Favorite> pagingController = PagingController(
    firstPageKey: 1,
  );
  RxBool isPaginationInitialized = false.obs;

  // Page size for pagination
  final int _pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    if (storage.isAuth()) {
      pagingController.addPageRequestListener((pageKey) {
        _fetchWishList(pageKey);
      });
    }
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchWishList(int pageKey) async {
    try {
      // Prepare parameters
      Map<String, dynamic> params = {'page': pageKey};
      final result = await httpService.request(
        url: ApiConstant.wishList,
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
      var response = ApiResponse.fromJsonModel<FavoritesData>(
        result.data,
        FavoritesData.fromJson,
      );
      if (response.isSuccess == true && response.data != null) {
        final newItems = response.data!.wishlist;
        final pagination = response.data!.pagination;
        totalResult.value = pagination?.total ?? 0;
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
      print('Error fetching products: $e');
    } finally {
      update(['updateList']);
    }
  }

  Future<void> toggleFavorite(Product product) async {
    try {
      // Get the current product index for updating UI
      final index =
          pagingController.itemList?.indexWhere(
            (p) => p.product?.id == product.id,
          ) ??
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
      if (pagingController.itemList?.length == 1) {
        pagingController.refresh();
      } else {
        pagingController.itemList!.removeAt(index);
        update(['updateList']);
      }
    }
  }
}
