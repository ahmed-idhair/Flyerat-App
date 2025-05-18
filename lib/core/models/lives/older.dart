import 'package:offers/core/models/lives/live.dart';

class Older {
  String? date;
  List<Live>? items;

  Older({this.date, this.items});

  factory Older.fromJson(Map<String, dynamic> json) => Older(
    date: json["date"],
    items:
        json["items"] != null
            ? List<Live>.from(json["items"].map((x) => Live.fromJson(x)))
            : [],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "items": List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}
