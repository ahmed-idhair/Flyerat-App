import '../date_at.dart';

class User {
  int? id;
  String? name;
  String? email;
  String? mobile;
  String? image;
  dynamic city;
  dynamic lat;
  dynamic lng;
  String? language;
  bool? notifications;
  bool? isVerified;
  bool? twoFactorAuth;
  String? timezone;
  String? status;
  dynamic totalPoints;
  DateAt? createdAt;
  DateAt? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.image,
    this.city,
    this.lat,
    this.lng,
    this.language,
    this.notifications,
    this.isVerified,
    this.twoFactorAuth,
    this.timezone,
    this.status,
    this.totalPoints,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    image: json["image"],
    city: json["city"],
    lat: json["lat"],
    lng: json["lng"],
    language: json["language"],
    notifications: json["notifications"],
    twoFactorAuth: json["two_factor_auth"],
    isVerified: json["is_verified"],
    timezone: json["timezone"],
    status: json["status"],
    totalPoints: json["total_points"],
    createdAt:
        json["created_at"] != null ? DateAt.fromJson(json["created_at"]) : null,
    updatedAt:
        json["updated_at"] != null ? DateAt.fromJson(json["updated_at"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile": mobile,
    "image": image,
    "city": city,
    "lat": lat,
    "lng": lng,
    "language": language,
    "notifications": notifications,
    "two_factor_auth": twoFactorAuth,
    "is_verified": isVerified,
    "timezone": timezone,
    "status": status,
    "total_points": totalPoints,
    "created_at": createdAt?.toJson(),
    "updated_at": updatedAt?.toJson(),
  };
}
