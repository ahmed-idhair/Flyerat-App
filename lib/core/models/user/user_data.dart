import 'package:offers/core/models/user/user.dart';

import 'verification.dart';

class UserData {
  User? user;
  Verification? verification;
  String? token;

  UserData({this.user, this.verification, this.token});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    user: User.fromJson(json["user"]),
    verification: Verification.fromJson(json["verification"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "verification": verification?.toJson(),
    "token": token,
  };
}
