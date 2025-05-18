import 'package:offers/core/models/date_at.dart';

import 'question.dart';

class Competition {
  int? id;
  String? title;
  String? description;
  String? startDate;
  String? endDate;
  int? allowedPoints;
  String? status;
  List<Question>? questions;
  bool? isActive;
  DateAt? createdAt;

  Competition({
    this.id,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.allowedPoints,
    this.status,
    this.questions,
    this.isActive,
    this.createdAt,
  });

  factory Competition.fromJson(Map<String, dynamic> json) => Competition(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    allowedPoints: json["allowed_points"],
    status: json["status"],
    questions:
        json["questions"] != null
            ? List<Question>.from(
              json["questions"].map((x) => Question.fromJson(x)),
            )
            : [],
    isActive: json["is_active"],
    createdAt:
        json["created_at"] != null ? DateAt.fromJson(json["created_at"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "start_date": startDate,
    "end_date": endDate,
    "allowed_points": allowedPoints,
    "status": status,
    "questions": List<dynamic>.from(questions!.map((x) => x.toJson())),
    "is_active": isActive,
    "created_at": createdAt?.toJson(),
  };
}
