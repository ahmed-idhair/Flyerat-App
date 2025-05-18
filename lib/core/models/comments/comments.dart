import '../pagination.dart';
import 'comment.dart';

class Comments {
  List<Comment>? comments;
  Pagination? pagination;

  Comments({this.comments, this.pagination});

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
    comments: List<Comment>.from(
      json["comments"].map((x) => Comment.fromJson(x)),
    ),
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}
