import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:offers/core/models/cities.dart';
import 'package:offers/core/models/countries.dart';
import 'package:offers/modules/base_controller.dart';
import 'package:offers/core/api/api_constant.dart';
import 'package:offers/core/api/api_response.dart';
import 'package:offers/core/api/http_service.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/services/fcm_service.dart';
import '../../../app/widgets/feedback/app_toast.dart';
import '../../../core/models/user/user.dart';

class UserLocationController extends BaseController {
  // Observables for countries and cities
  final RxList<Countries> countries = <Countries>[].obs;
  final RxList<Cities> cities = <Cities>[].obs;
  final FCMService _fcmService = FCMService();

  // Selected country and city
  final Rxn<Countries> selectedCountry = Rxn<Countries>();
  final Rxn<Cities> selectedCity = Rxn<Cities>();

  // Loading states
  final RxBool isLoadingCountries = false.obs;
  final RxBool isLoadingCities = false.obs;
  final RxBool isLoadingLocation = false.obs;

  // User location
  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;
  final RxBool hasLocationPermission = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedLocation();
    fetchCountries();
  }

  void resetSelections() {
    // Reset only if explicitly changing location
    selectedCountry.value = null;
    selectedCity.value = null;
    cities.clear();
  }

  // Load any previously saved location data
  void loadSavedLocation() {
    // Load saved country
    final savedCountry = storage.getSelectedCountry();
    if (savedCountry != null) {
      selectedCountry.value = savedCountry;
      // If country is selected, load cities for that country
      fetchCities(savedCountry.id ?? 0);
      // Load saved city
      final savedCity = storage.getSelectedCity();
      if (savedCity != null) {
        selectedCity.value = savedCity;
      }
    }

    // Load saved coordinates
    final location = storage.getUserLocation();
    if (location != null) {
      latitude.value = location['latitude'] ?? 0.0;
      longitude.value = location['longitude'] ?? 0.0;
    }
  }

  // Fetch list of countries from API
  Future<void> fetchCountries() async {
    try {
      isLoadingCountries(true);

      final result = await httpService.request(
        url: ApiConstant.countries,
        method: Method.GET,
      );

      if (result != null) {
        var response = ApiResponse.fromJsonList<Countries>(
          result.data,
          Countries.fromJson,
        );

        if (response.isSuccess == true && response.data != null) {
          countries.assignAll(response.data!);
        } else {
          // Handle API error
          print('Error fetching countries: ${response.message}');
        }
      }
    } catch (e) {
      print('Error fetching countries: $e');
      // Fallback to some default countries in case of error
      // handleCountriesFetchError();
    } finally {
      isLoadingCountries(false);
    }
  }

  Future<void> updateLocation() async {
    try {
      EasyLoading.show();
      Map<String, dynamic> body = {"city_id": storage.getSelectedCity()?.id};
      if (storage.getUserLocation() != null) {
        body['lat'] = storage.getUserLocation()!['latitude'];
        body['lng'] = storage.getUserLocation()!['longitude'];
      }
      final result = await httpService.request(
        url: ApiConstant.location,
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var response = ApiResponse.fromJsonModel(result.data, User.fromJson);
        if (response.isSuccess && response.data != null) {
          storage.setUser(response.data!);
          // updateUser();
          await _fcmService.subscribeToCountry(
            storage.getSelectedCountry()!.id!,
          );
          await _fcmService.subscribeToCity(storage.getSelectedCity()!.id!);
          Get.offAllNamed(AppRoutes.home);
        } else {
          AppToast.error(response.message);
        }
      }
    } finally {
      EasyLoading.dismiss();
      // update(['updateUser']);
    }
  }

  // Fallback for when API fails to fetch countries
  void handleCountriesFetchError() {
    // Provide some default countries as a fallback
    // final fallbackCountries = [
    //   Country(id: 1, name: 'Jordan', code: 'JO', flag: '🇯🇴'),
    //   Country(id: 2, name: 'Egypt', code: 'EG', flag: '🇪🇬'),
    //   Country(id: 3, name: 'Saudi Arabia', code: 'SA', flag: '🇸🇦'),
    // ];
    // countries.assignAll(fallbackCountries);
  }

  // Fetch cities for selected country from API
  Future<void> fetchCities(int countryId) async {
    try {
      isLoadingCities(true);
      cities.clear();

      final result = await httpService.request(
        url: "${ApiConstant.cities}/$countryId",
        method: Method.GET,
      );

      if (result != null) {
        var response = ApiResponse.fromJsonList<Cities>(
          result.data,
          Cities.fromJson,
        );

        if (response.isSuccess == true && response.data != null) {
          cities.assignAll(response.data!);
        } else {
          // Handle API error
          print('Error fetching cities: ${response.message}');
        }
      }
    } catch (e) {
      print('Error fetching cities: $e');
      // Fallback to some default cities in case of error
      handleCitiesFetchError(countryId);
    } finally {
      isLoadingCities(false);
    }
  }

  // Fallback for when API fails to fetch cities
  void handleCitiesFetchError(int countryId) {
    // Provide some default cities as a fallback based on country
    // List<City> fallbackCities = [];
    //
    // if (countryId == 1) {
    //   // Jordan
    //   fallbackCities = [
    //     City(id: 1, name: 'Amman', countryId: 1),
    //     City(id: 2, name: 'Zarqa', countryId: 1),
    //     City(id: 3, name: 'Irbid', countryId: 1),
    //   ];
    // } else if (countryId == 2) {
    //   // Egypt
    //   fallbackCities = [
    //     City(id: 4, name: 'Cairo', countryId: 2),
    //     City(id: 5, name: 'Alexandria', countryId: 2),
    //   ];
    // } else if (countryId == 3) {
    //   // Saudi Arabia
    //   fallbackCities = [
    //     City(id: 6, name: 'Riyadh', countryId: 3),
    //     City(id: 7, name: 'Jeddah', countryId: 3),
    //   ];
    // }
    //
    // cities.assignAll(fallbackCities);
  }

  // Select a country
  void selectCountry(Countries country) {
    selectedCountry.value = country;
    selectedCity.value = null;
    storage.saveSelectedCountry(country);
    fetchCities(country.id ?? 0);
  }

  // Select a city
  void selectCity(Cities city) {
    selectedCity.value = city;
    storage.saveSelectedCity(city);
    Get.back(); // Close the city selection bottom sheet
  }

  // Request location permission and get current location
  Future<bool> requestAndGetLocation() async {
    isLoadingLocation(true);

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isLoadingLocation(false);
        return false;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          isLoadingLocation(false);
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        isLoadingLocation(false);
        return false;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition();
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      print('Log latitude ${position.latitude} ');
      print('Log longitude ${position.longitude} ');

      // Save to storage
      storage.saveUserLocation(position.latitude, position.longitude);

      hasLocationPermission(true);
      return true;
    } catch (e) {
      print('Error getting location: $e');
      return false;
    } finally {
      isLoadingLocation(false);
    }
  }

  // Check if location process is completed (either manually or automatically)
  bool isLocationComplete() {
    return selectedCountry.value != null && selectedCity.value != null;
  }

  // Complete the location selection process
  void completeLocationSelection() {
    if (isLocationComplete()) {
      Get.back(); // Close bottom sheet
      // Continue with app flow
    }
  }
}
