import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:logger/logger.dart';
import 'package:offers/app/routes/app_routes.dart';
import 'package:offers/app/widgets/feedback/app_toast.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/services/storage_service.dart';
import '../../app/translations/lang_keys.dart';
import '../../app/widgets/common/app_bottom_sheet.dart';

/// Enum for HTTP methods
enum Method { POST, GET, PUT, DELETE, PATCH }

/// Base API URL
// const BASE_URL = "https://offers.omarakshaheen.com/api/v1/";
const BASE_URL = "https://flyerat.com/api/v1/";

class HttpService extends GetxService {
  late Dio _dio;
  final Logger _logger = Logger(
    printer: PrettyPrinter(colors: true, printEmojis: true, printTime: true),
  );

  Future<HttpService> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: BASE_URL,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    // ✅ Add Dio Logger only in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: false,
        ),
      );
    }

    return this;
  }

  /// 🟢 **Generate API Headers**
  ///
  /// This function generates API request headers, including:
  /// - `Content-Type` and `Accept`
  /// - `x-api-key` for authentication
  /// - `Accept-Language` based on user preference
  /// - `device-type` (Android/iOS)
  /// - `Authorization` token (if available)
  Map<String, String> _getHeaders({String? token}) {
    final storageService = Get.find<StorageService>();
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "X-API-KEY": "raodV7dGMCRT8g4oiDJXkQAt5J3DqXRNh2WcW2kqkHJPWM2249",
      "Accept-Language": storageService.getLanguageCode(),
      "device-type": Platform.isAndroid ? "android" : "ios",
    };
    final storedToken = storageService.getToken();
    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    } else if (storedToken != null && storedToken.isNotEmpty) {
      headers["Authorization"] = "Bearer $storedToken";
    }

    return headers;
  }

  /// 🟢 **Unified API Request Function**
  ///
  /// This function handles all types of API requests:
  /// - `GET`, `POST`, `PUT`, `DELETE`, `PATCH`
  /// - Supports sending `FormData` for file uploads
  /// - Uses `token` if provided, otherwise fetches from `StorageService`
  Future<Response?> request({
    required String url,
    required Method method,
    Map<String, dynamic>? params,
    bool isUploadImg = false,
    FormData? formData,
    String? token,
    String? contentType,
  }) async {
    try {
      // Set headers for each request
      _dio.options.headers = _getHeaders(token: token);
      final locationParams = _getLocationParams();
      Map<String, dynamic> queryParameters = {};

      queryParameters.addAll(locationParams);
      if (params != null) {
        if (method == Method.GET) {
          queryParameters.addAll(params);
        }
      }
      if (contentType == 'application/x-www-form-urlencoded') {
        _dio.options.contentType = Headers.formUrlEncodedContentType;
      }
      dynamic data = isUploadImg ? formData : params;

      // Log request details
      _logger.i(
        "📡 Request: ${method.name} $url\nHeaders: ${_dio.options.headers}",
      );

      Response response;
      switch (method) {
        case Method.GET:
          response = await _dio.get(url, queryParameters: queryParameters);
          break;
        case Method.POST:
          response = await _dio.post(
            url,
            queryParameters: queryParameters,
            data: data,
          );
          break;
        case Method.PUT:
          response = await _dio.put(
            url,
            data: data,
            queryParameters: queryParameters,
          );
          break;
        case Method.DELETE:
          response = await _dio.delete(url, queryParameters: queryParameters);
          break;
        case Method.PATCH:
          response = await _dio.patch(
            url,
            data: data,
            queryParameters: queryParameters,
          );
          break;
      }

      // Log API response
      _logger.i("✅ Response: ${response.statusCode} ${response.data}");
      return response;
    } on SocketException {
      _handleError(LangKeys.notInternetConnection.tr);
    } on FormatException {
      _handleError("❌ Bad response format");
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      _logger.e(e);
      _handleError("💥 Something went wrong");
    }
    return null;
  }

  Map<String, dynamic> _getLocationParams() {
    final storageService = Get.find<StorageService>();
    final locationParams = <String, dynamic>{};

    // Add location parameters if they exist
    if (storageService.getSelectedCity() != null &&
        storageService.getSelectedCity()?.id != null &&
        storageService.getSelectedCity()?.id != 0) {
      locationParams['country_id'] = storageService.getSelectedCountry()?.id;
    }
    if (storageService.getUserLocation() != null &&
        storageService.getUserLocation()?['latitude'] != null) {
      locationParams['lat'] = storageService.getUserLocation()?['latitude'];
    }

    if (storageService.getUserLocation() != null &&
        storageService.getUserLocation()?['longitude'] != null) {
      locationParams['lng'] = storageService.getUserLocation()?['longitude'];
    }
    return locationParams;
  }

  /// ❌ **Handles General API Errors**
  ///
  /// - Displays a snackbar with the error message.
  /// - Logs the error.
  void _handleError(String message) {
    _logger.e(message);
    // AppToast.error(message);
    showErrorBottomSheet(message);
    // UiErrorUtils.customSnackbar(title: LangKeys.error.tr, msg: message);
  }

  /// ❌ **Handles Dio-Specific Errors**
  ///
  /// - Categorizes errors based on DioException type.
  /// - Shows relevant error messages to the user.
  void _handleDioError(DioException e) {
    String? message;

    switch (e.type) {
      case DioExceptionType.cancel:
        message = "⚠ Request was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        message = "⏳ Connection timeout";
        break;
      case DioExceptionType.receiveTimeout:
        message = "📩 Receive timeout";
        break;
      case DioExceptionType.sendTimeout:
        message = "🚀 Send timeout";
        break;
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) {
          // If unauthorized, trigger logout process
          AppToast.error(e.response?.data['message']);
          Get.find<StorageService>().clearApp();
          Get.offAllNamed(AppRoutes.signIn);
          // showLogoutBottomSheet(e.response?.data['message']);
        } else {
          message = _handleHttpResponseError(
            e.response?.statusCode,
            e.response?.data,
          );
        }
        break;
      case DioExceptionType.unknown:
      default:
        message = LangKeys.notInternetConnection.tr;
        break;
    }
    if (message != null && message.isNotEmpty) {
      _handleError(message);
    } else {
      _handleError(LangKeys.notInternetConnection.tr);
    }
  }

  /// ❌ **Handles HTTP Response Errors**
  ///
  /// - Maps HTTP status codes to user-friendly messages.
  String _handleHttpResponseError(int? statusCode, dynamic error) {
    if (statusCode == null) return '🚨 Unknown error';

    switch (statusCode) {
      case 400:
      case 422:
        return _extractValidationErrors(error);
      case 409:
        return _extractValidationErrors(error);
      case 403:
        return _extractValidationErrors(error);
      case 401:
        return _extractValidationErrors(error);
      case 404:
        return _extractValidationErrors(error);
        // return "❌ Not Found";
      case 405:
        return "❌ Method Not Allowed";
      case 500:
        // Get.find<StorageService>().clearApp();
        // Get.offAllNamed(AppRoutes.signIn);
        return _extractValidationErrors(error);
      // return "🔥 Internal Server Error";
      default:
        return "⚠ Oops! Something went wrong";
    }
  }

  /// Extracts validation error messages from API response (422)
  String _extractValidationErrors(Map<String, dynamic> responseData) {
    if (responseData.containsKey("data")) {
      final errors = responseData["data"] as Map<String, dynamic>;
      List<String> errorMessages = [];

      errors.forEach((key, value) {
        if (value is List) {
          errorMessages.addAll(value.map((e) => "$e").toList());
        } else {
          errorMessages.add("$value");
        }
      });

      return errorMessages.join("\n");
    }
    return responseData["message"] ??
        "❌ Validation failed, please check your input";
  }
}
