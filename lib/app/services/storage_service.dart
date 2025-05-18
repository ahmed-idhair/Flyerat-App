import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:offers/core/models/cities.dart';
import 'package:offers/core/models/countries.dart';
import '../../core/models/user/user.dart';

class StorageService extends GetxService {
  String? languageCode;
  String? countryCode;
  String? deviceId;
  String? version;
  String? timezone = "Asia/Amman";
  String? appVersion = "1.0";

  // Storage keys
  static const String USER_KEY = "user_jordan_offers";
  static const String TOKEN_KEY = "token_jordan_offers";
  static const String INTRO_KEY = "is_intro_jordan_offers";
  static const String LANG_FIRST_KEY = "is_lang_first_jordan_offers";
  static const String LOCATION_KEY = "user_location_jordan_offers";
  static const String SELECTED_COUNTRY_KEY = "selected_country_jordan_offers";
  static const String SELECTED_CITY_KEY = "selected_city_jordan_offers";
  static const String LANGUAGE_CODE_KEY = "languageCode";

  Future<StorageService> init() async {
    await GetStorage.init();
    languageCode = GetStorage().read(LANGUAGE_CODE_KEY);
    countryCode = GetStorage().read('countryCode');
    if (languageCode == null || languageCode == "") {
      languageCode = Get.deviceLocale!.languageCode;
      countryCode = Get.deviceLocale!.countryCode;
    }
    return this;
  }

  User? getUser() {
    if (GetStorage().read(USER_KEY) != null) {
      return User.fromJson(GetStorage().read(USER_KEY));
    }
    return null;
  }

  String getLanguageCode() {
    if (GetStorage().read(LANGUAGE_CODE_KEY) != null) {
      return GetStorage().read(LANGUAGE_CODE_KEY);
    }
    return "en";
  }

  String? getToken() {
    if (GetStorage().read(TOKEN_KEY) != null) {
      return GetStorage().read(TOKEN_KEY);
    }
    return null;
  }

  void setUserToken(String value) {
    GetStorage().write(TOKEN_KEY, value);
  }

  bool isAuth() {
    if (GetStorage().read(TOKEN_KEY) != null &&
        GetStorage().read(USER_KEY) != null) {
      return true;
    }
    return false;
  }

  void clearApp() {
    GetStorage().remove(USER_KEY);
    GetStorage().remove(TOKEN_KEY);
  }

  void write(String key, dynamic value) {
    GetStorage().write(key, value);
  }

  bool isIntro() {
    if (GetStorage().read(INTRO_KEY) != null) {
      return GetStorage().read(INTRO_KEY);
    } else {
      return false;
    }
  }

  bool isLangFirst() {
    if (GetStorage().read(LANG_FIRST_KEY) != null) {
      return GetStorage().read(LANG_FIRST_KEY);
    } else {
      return false;
    }
  }

  void setIntro(bool isIntro) {
    GetStorage().write(INTRO_KEY, isIntro);
  }

  void setLangFirst(bool isLang) {
    GetStorage().write(LANG_FIRST_KEY, isLang);
  }

  void setUser(User value) {
    GetStorage().write(
      USER_KEY,
      User(
        id: value.id,
        email: value.email,
        image: value.image,
        isVerified: value.isVerified,
        language: value.language,
        notifications: value.notifications,
        mobile: value.mobile,
        name: value.name,
        status: value.status,
        twoFactorAuth: value.twoFactorAuth,
      ).toJson(),
    );
  }

  // Location methods
  bool hasLocationData() {
    return GetStorage().read(SELECTED_COUNTRY_KEY) != null &&
        GetStorage().read(SELECTED_CITY_KEY) != null;
  }

  // Save user location (lat/lng)
  void saveUserLocation(double latitude, double longitude) {
    final location = {'latitude': latitude, 'longitude': longitude};
    GetStorage().write(LOCATION_KEY, location);
  }

  // Get user location
  Map<String, double>? getUserLocation() {
    final data = GetStorage().read(LOCATION_KEY);
    if (data != null) {
      return {'latitude': data['latitude'], 'longitude': data['longitude']};
    }
    return null;
  }

  // Save selected country
  void saveSelectedCountry(Countries country) {
    GetStorage().write(SELECTED_COUNTRY_KEY, country.toJson());
  }

  // Get selected country
  Countries? getSelectedCountry() {
    final data = GetStorage().read(SELECTED_COUNTRY_KEY);
    if (data != null) {
      return Countries.fromJson(data);
    }
    return null;
  }

  // Save selected city
  void saveSelectedCity(Cities city) {
    GetStorage().write(SELECTED_CITY_KEY, city.toJson());
  }

  // Get selected city
  Cities? getSelectedCity() {
    final data = GetStorage().read(SELECTED_CITY_KEY);
    if (data != null) {
      return Cities.fromJson(data);
    }
    return null;
  }
}
