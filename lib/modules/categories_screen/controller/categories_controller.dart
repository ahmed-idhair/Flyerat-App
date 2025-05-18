import 'package:get/get.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/modules/base_controller.dart';

import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../../core/models/home/category.dart';
import '../../../core/models/home/partner.dart';

class CategoriesController extends BaseController {
  Partner? partner;
  bool? isHome;

  // Loading states
  final RxBool isLoadingDepartments = false.obs;
  final RxBool isLoadingCategories = false.obs;

  // Data lists
  final RxList<Category> departments = <Category>[].obs;
  final RxList<Category> categories = <Category>[].obs;

  // Selected department for filtering
  final RxInt selectedDepartmentId = 0.obs;

  // Search query
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      partner = Get.arguments['partner'];
      isHome = Get.arguments['isHome'];
    }
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    try {
      isLoadingDepartments(true);
      Map<String, dynamic> params = {};
      if (partner != null && partner?.id != null) {
        params["partner_id"] = partner?.id;
      }
      final result = await httpService.request(
        url: ApiConstant.partnerDepartments,
        method: Method.GET,
        params: params,
      );
      if (result != null) {
        var response = ApiResponse.fromJsonList<Category>(
          result.data,
          Category.fromJson,
        );
        if (response.isSuccess == true && response.data != null) {
          departments.clear();
          departments.addAll(response.data!);
          if (departments.isNotEmpty) {
            selectDepartment(departments.first.id ?? 0);
          }
        }
      }
    } catch (e) {
      print('Error fetching departments: $e');
    } finally {
      isLoadingDepartments(false);
    }
  }

  Future<void> fetchCategories() async {
    try {
      isLoadingCategories(true);

      final Map<String, dynamic> params = {};
      // Add partner ID if available
      if (partner != null && partner?.id != null) {
        params['partner_id'] = partner?.id;
      }
      //
      // // Add department ID if selected
      // if (selectedDepartmentId.value > 0) {
      //   params['department_id'] = selectedDepartmentId.value.toString();
      // }

      // Add search query if not empty
      if (searchQuery.value.isNotEmpty) {
        params['search'] = searchQuery.value;
      }
      final result = await httpService.request(
        url: "${ApiConstant.partnerCategories}/${selectedDepartmentId.value}",
        method: Method.GET,
        params: params,
      );
      if (result != null) {
        var response = ApiResponse.fromJsonList<Category>(
          result.data,
          Category.fromJson,
        );
        if (response.status == true && response.data != null) {
          categories.value = response.data!;
        }
      }
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      isLoadingCategories(false);
    }
  }

  void selectDepartment(int departmentId) {
    selectedDepartmentId.value = departmentId;
    fetchCategories();
  }

  void navigateToCategory(Category category) {
    print('Log category ${category.id}');
    print('Log selectedDepartmentId.value ${selectedDepartmentId.value}');
    Get.toNamed(
      AppRoutes.productsScreen,
      arguments: {
        "department": departments.firstWhere(
          (element) => element.id == selectedDepartmentId.value,
        ),
        'category': category,
        'partner': partner,
      },
    );
  }
}
