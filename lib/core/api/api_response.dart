// api_response.dart
import 'dart:convert';

class ApiResponse<T> {
  final bool status;
  final int code;
  final String message;
  final T? data;

  ApiResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  /// تحويل من JSON إلى ApiResponse
  factory ApiResponse.fromJson(
      Map<String, dynamic> json, {
        T Function(dynamic)? fromJsonT,
      }) {
    // التحقق من وجود بيانات
    final hasData = json.containsKey('data') && json['data'] != null;

    // إنشاء كائن ApiResponse
    return ApiResponse<T>(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: hasData && fromJsonT != null ? fromJsonT(json['data']) : null,
    );
  }

  /// دوال مساعدة للتعامل مع أنواع شائعة

  /// للتعامل مع قائمة من النماذج
  static ApiResponse<List<E>> fromJsonList<E>(
      Map<String, dynamic> json,
      E Function(Map<String, dynamic>) fromJsonE,
      ) {
    return ApiResponse<List<E>>(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json.containsKey('data') && json['data'] != null
          ? (json['data'] as List).map((item) => fromJsonE(item)).toList()
          : null,
    );
  }

  /// للتعامل مع نموذج واحد
  static ApiResponse<E> fromJsonModel<E>(
      Map<String, dynamic> json,
      E Function(Map<String, dynamic>) fromJsonE,
      ) {
    return ApiResponse<E>(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json.containsKey('data') && json['data'] != null
          ? fromJsonE(json['data'])
          : null,
    );
  }

  /// للتعامل مع أنواع بسيطة (String, int, bool, double)
  static ApiResponse<T> fromJsonSimple<T>(Map<String, dynamic> json) {
    return ApiResponse<T>(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json.containsKey('data') ? json['data'] as T : null,
    );
  }
  /// التحقق من نجاح الاستجابة
  bool get isSuccess => status && code == 200;
}