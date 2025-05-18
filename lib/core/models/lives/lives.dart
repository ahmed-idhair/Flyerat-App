import 'package:offers/core/models/lives/live.dart';

import 'older.dart';

class Lives {
  List<Live>? today;
  List<Live>? yesterday;
  List<Older>? older;

  Lives({this.today, this.yesterday, this.older});

  factory Lives.fromJson(Map<String, dynamic> json) => Lives(
    today:
        json["today"] != null
            ? List<Live>.from(json["today"].map((x) => Live.fromJson(x)))
            : [],
    yesterday:
        json["yesterday"] != null
            ? List<Live>.from(json["yesterday"].map((x) => Live.fromJson(x)))
            : [],
    older:
        json["older"] != null
            ? List<Older>.from(json["older"].map((x) => Older.fromJson(x)))
            : [],
  );

  Map<String, dynamic> toJson() => {
    "today": List<dynamic>.from(today!.map((x) => x.toJson())),
    "yesterday": List<dynamic>.from(yesterday!.map((x) => x.toJson())),
    "older": List<dynamic>.from(older!.map((x) => x.toJson())),
  };
}
