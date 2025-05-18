import '../pagination.dart';
import 'lives.dart';

class LivesData {
  Lives? lives;
  Pagination? pagination;

  LivesData({this.lives, this.pagination});

  factory LivesData.fromJson(Map<String, dynamic> json) => LivesData(
    lives: json["lives"] != null ? Lives.fromJson(json["lives"]) : null,
    pagination:
        json["pagination"] != null
            ? Pagination.fromJson(json["pagination"])
            : null,
  );

  Map<String, dynamic> toJson() => {
    "lives": lives?.toJson(),
    "pagination": pagination?.toJson(),
  };
}
