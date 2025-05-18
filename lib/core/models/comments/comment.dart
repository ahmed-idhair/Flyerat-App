import '../date_at.dart';
import '../user/user.dart';

class Comment {
  int? id;
  String? comment;
  List<Comment>? replies;
  DateAt? createdAt;
  User? user;

  Comment({this.id, this.comment, this.replies, this.createdAt, this.user});

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    comment: json["comment"],
    replies:
        json["replies"] != null
            ? List<Comment>.from(
              json["replies"].map((x) => Comment.fromJson(x)),
            )
            : [],
    createdAt:
        json["created_at"] != null ? DateAt.fromJson(json["created_at"]) : null,
    user: json["user"] != null ? User.fromJson(json["user"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "comment": comment,
    "replies": List<dynamic>.from(replies!.map((x) => x.toJson())),
    "created_at": createdAt?.toJson(),
    "user": user?.toJson(),
  };
}
