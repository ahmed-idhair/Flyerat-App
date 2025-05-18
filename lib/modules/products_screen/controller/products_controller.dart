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

class ProductsController extends BaseController {
  // Title and arguments
  late String title;
  final Rxn<Partner> partner = Rxn<Partner>();
  final Rxn<Category> category = Rxn<Category>();
  final Rxn<Category> brand = Rxn<Category>();

  // Loading states
  final RxBool isInitialLoading = true.obs;
  final RxBool isLoadingBrands = true.obs;

  // Data lists
  final RxList<Category> brands = <Category>[].obs;

  // Selected brand for filtering
  final RxInt selectedBrandId = 0.obs;

  // Search query
  RxString searchQuery = ''.obs;
  final searchController = TextEditingController();

  // Pagination controller
  final PagingController<int, Product> pagingController = PagingController(
    firstPageKey: 1,
  );
  RxBool isPaginationInitialized = false.obs;

  // Page size for pagination
  final int _pageSize = 10;

  @override
  void onInit() {
    super.onInit();

    // Get arguments
    if (Get.arguments != null) {
      if (Get.arguments['partner'] != null) {
        partner.value = Get.arguments['partner'];
      }
      if (Get.arguments['category'] != null) {
        category.value = Get.arguments['category'];
        title = category.value?.name ?? 'Products';
      }
      // else if (Get.arguments['department'] != null) {
      //   // brand.value = Get.arguments['department'];
      //   // title = brand.value?.name ?? 'Products';
      // }
      else {
        title = 'Products';
      }
    } else {
      title = 'Products';
    }
    fetchBrands();
    // Add listener for brand filter changes
    //     ever(selectedBrandId, (_) => pagingController.refresh());
    // // Initialize paging controller
    // pagingController.addPageRequestListener((pageKey) {
    //   _fetchProductsPage(pageKey);
    // });
  }

  void clearSearch() {
    searchQuery.value = '';
    searchController.clear();
    pagingController.refresh();
  }

  void performSearch() {
    searchQuery.value = searchController.text.trim();
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

      // Add partner_id if available
      if (partner.value?.id != null) {
        params['partner_id'] = partner.value!.id.toString();
      }
      //
      // Add category_id if available
      if (category.value?.id != null) {
        params['category_id'] = category.value!.id.toString();
      }
      // // Add brand_id if selected
      if (selectedBrandId.value > 0) {
        params['brand_id'] = selectedBrandId.value.toString();
      }

      // Add search query if not empty
      if (searchQuery.value.isNotEmpty) {
        params['search'] = searchQuery.value;
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
        print('Log newItems ${newItems?.length} ');
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

  Future<void> fetchBrands() async {
    try {
      isLoadingBrands(true);
      Map<String, dynamic> params = {};
      // Add partner_id if available
      if (partner.value?.id != null) {
        params['partner_id'] = partner.value!.id.toString();
      }
      final result = await httpService.request(
        url: "${ApiConstant.partnerBrands}/${category.value?.id}",
        method: Method.GET,
        params: params,
      );
      if (result != null) {
        var response = ApiResponse.fromJsonList<Category>(
          result.data,
          Category.fromJson,
        );
        if (response.isSuccess == true && response.data != null) {
          brands.value = response.data!;
          // Automatically select the first brand if available
          if (brands.isNotEmpty) {
            selectBrand(brands.first.id ?? 0);
          } else {
            // If no brands available, fetch products without brand filter
            selectBrand(0);
          }
        } else {
          // If API failed, fetch products without brand filter
          selectBrand(0);
        }
      } else {
        selectBrand(0);
      }
    } catch (e) {
      print('Error fetching brands: $e');
    } finally {
      isLoadingBrands(false);
      if (!isPaginationInitialized.value) {
        // Set up pagination listener
        pagingController.addPageRequestListener((pageKey) {
          _fetchProductsPage(pageKey);
        });

        // Set flag to prevent multiple initializations
        isPaginationInitialized.value = true;

        update(['updateList']);
      }
    }
  }

  void selectBrand(int brandId) {
    print('Log brandId $brandId');
    selectedBrandId.value = brandId;
    if (isPaginationInitialized.value) {
      pagingController.refresh();
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
