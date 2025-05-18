import 'package:offers/core/models/date_at.dart';

import '../home/partner.dart';

class Live {
  int? id;
  String? title;
  String? url;
  Partner? partner;
  DateAt? createdAt;

  Live({this.id, this.title, this.url, this.partner, this.createdAt});

  factory Live.fromJson(Map<String, dynamic> json) => Live(
    id: json["id"],
    title: json["title"],
    url: json["url"],
    partner: json["partner"] != null ? Partner.fromJson(json["partner"]) : null,
    createdAt:
        json["created_at"] != null ? DateAt.fromJson(json["created_at"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "url": url,
    "partner": partner?.toJson(),
    "created_at": createdAt?.toJson(),
  };
}
