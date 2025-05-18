class Banner {
  int? id;
  String? image;
  String? type;
  int? partnerId;
  int? flyerId;
  String? startAt;
  String? endAt;
  String? url;

  Banner({
    this.id,
    this.image,
    this.type,
    this.partnerId,
    this.flyerId,
    this.startAt,
    this.endAt,
    this.url,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    id: json["id"],
    image: json["image"],
    type: json["type"],
    partnerId: json["partner_id"],
    flyerId: json["flyer_id"],
    startAt: json["start_at"],
    endAt: json["end_at"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "type": type,
    "partner_id": partnerId,
    "flyer_id": flyerId,
    "start_at": startAt,
    "end_at": endAt,
    "url": url,
  };
}
