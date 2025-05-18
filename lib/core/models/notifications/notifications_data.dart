import '../pagination.dart';
import 'notifications.dart';

class NotificationsData {
  Notifications? notifications;
  Pagination? pagination;

  NotificationsData({this.notifications, this.pagination});

  factory NotificationsData.fromJson(Map<String, dynamic> json) =>
      NotificationsData(
        notifications:
            json["notifications"] != null
                ? Notifications.fromJson(json["notifications"])
                : null,
        pagination:
            json["pagination"] != null
                ? Pagination.fromJson(json["pagination"])
                : null,
      );

  Map<String, dynamic> toJson() => {
    "notifications": notifications?.toJson(),
    "pagination": pagination?.toJson(),
  };
}
