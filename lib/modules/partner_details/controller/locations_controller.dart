import 'package:get/get.dart';
import 'package:offers/core/models/home/location_data.dart';
import 'package:offers/modules/base_controller.dart';

import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../../core/models/home/partner.dart';

class LocationsController extends BaseController {
  final RxList<LocationData> locations = <LocationData>[].obs;
  final RxBool isLoading = false.obs;
  final Rxn<LocationData> selectedLocation = Rxn<LocationData>();
  String? partnerId;

  LocationsController({this.partnerId});

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    try {
      // Show loading indicator
      isLoading(true);
      // Map<String, dynamic> params = {"lat": 3.1, "lng": 3.1};
      final result = await httpService.request(
        url: "${ApiConstant.partner}/$partnerId/locations",
        method: Method.GET,
        // params: params,
      );
      if (result != null) {
        var resp = ApiResponse.fromJsonList(result.data, LocationData.fromJson);
        if (resp.isSuccess && resp.data != null) {
          locations.addAll(resp.data ?? []);
        }
      }
    } finally {
      // Hide loading indicator
      isLoading(false);
      update(['updateDetails']);
    }
  }

  void selectLocation(LocationData location) {
    selectedLocation.value = location;
    Get.back(result: location);
  }
}
