/// Generic API response model for handling all API responses with consistent structure
class GlobalModel {
  final bool status;
  final int code;
  final String message;

  GlobalModel({
    required this.status,
    required this.code,
    required this.message,
  });

  /// Creates an ApiResponse from JSON, using the provided function to convert core
  factory GlobalModel.fromJson(Map<String, dynamic> json) {
    return GlobalModel(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  /// Converts ApiResponse to JSON, using the provided function to convert core
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
    };
  }

  /// Checks if the response is successful
  bool get isSuccess => status && code == 200;
}