import 'package:offers/core/models/lives/live.dart';
import 'package:offers/core/models/notifications/notifications_obj.dart';

import 'notification_older.dart';

class Notifications {
  List<NotificationsObj>? today;
  List<NotificationsObj>? yesterday;
  List<NotificationOlder>? older;

  Notifications({this.today, this.yesterday, this.older});

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    today:
        json["today"] != null
            ? List<NotificationsObj>.from(
              json["today"].map((x) => NotificationsObj.fromJson(x)),
            )
            : [],
    yesterday:
        json["yesterday"] != null
            ? List<NotificationsObj>.from(
              json["yesterday"].map((x) => NotificationsObj.fromJson(x)),
            )
            : [],
    older:
        json["older"] != null
            ? List<NotificationOlder>.from(
              json["older"].map((x) => NotificationOlder.fromJson(x)),
            )
            : [],
  );

  Map<String, dynamic> toJson() => {
    "today": List<dynamic>.from(today!.map((x) => x.toJson())),
    "yesterday": List<dynamic>.from(yesterday!.map((x) => x.toJson())),
    "older": List<dynamic>.from(older!.map((x) => x.toJson())),
  };
}
