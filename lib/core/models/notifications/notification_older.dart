import 'package:offers/core/models/lives/live.dart';

import 'notifications_obj.dart';

class NotificationOlder {
  String? date;
  List<NotificationsObj>? items;

  NotificationOlder({this.date, this.items});

  factory NotificationOlder.fromJson(Map<String, dynamic> json) =>
      NotificationOlder(
        date: json["date"],
        items:
            json["items"] != null
                ? List<NotificationsObj>.from(
                  json["items"].map((x) => NotificationsObj.fromJson(x)),
                )
                : [],
      );

  Map<String, dynamic> toJson() => {
    "date": date,
    "items": List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}
