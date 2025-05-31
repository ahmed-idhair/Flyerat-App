class NotificationAction {
  int? id;
  int? replyId;
  int? modelId;
  String? type;
  String? modelType;

  NotificationAction({
    this.id,
    this.replyId,
    this.modelId,
    this.type,
    this.modelType,
  });

  factory NotificationAction.fromJson(Map<String, dynamic> json) =>
      NotificationAction(
        id: json["id"],
        replyId: json["reply_id"],
        modelId: json["model_id"],
        type: json["type"],
        modelType: json["model_type"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "reply_id": replyId,
    "model_id": modelId,
    "model_type": modelType,
  };
}
