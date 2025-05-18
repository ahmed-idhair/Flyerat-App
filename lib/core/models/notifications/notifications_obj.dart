import 'package:offers/core/models/date_at.dart';

import '../home/partner.dart';

class NotificationsObj {
  String? id;
  String? title;
  String? content;
  dynamic readAt;
  bool? isRead;
  String? createdAt;
  String? createdAtFormatted;
  String? type;
  int? modelId;
  String? modelType;
  dynamic actionRoute;

  NotificationsObj({
    this.id,
    this.title,
    this.content,
    this.readAt,
    this.isRead,
    this.createdAt,
    this.createdAtFormatted,
    this.type,
    this.modelId,
    this.modelType,
    this.actionRoute,
  });

  factory NotificationsObj.fromJson(Map<String, dynamic> json) =>
      NotificationsObj(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        readAt: json["read_at"],
        isRead: json["is_read"],
        createdAt: json["created_at"],
        createdAtFormatted: json["created_at_formatted"],
        type: json["type"],
        modelId: json["model_id"],
        modelType: json["model_type"],
        actionRoute: json["action_route"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "read_at": readAt,
    "is_read": isRead,
    "created_at": createdAt,
    "created_at_formatted": createdAtFormatted,
    "type": type,
    "model_id": modelId,
    "model_type": modelType,
    "action_route": actionRoute,
  };
}
