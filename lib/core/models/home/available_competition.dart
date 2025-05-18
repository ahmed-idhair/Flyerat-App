class AvailableCompetition {
  int? id;
  String? title;
  String? description;
  int? allowedPoints;

  AvailableCompetition({
    this.id,
    this.title,
    this.description,
    this.allowedPoints,
  });

  factory AvailableCompetition.fromJson(Map<String, dynamic> json) =>
      AvailableCompetition(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        allowedPoints: json["allowed_points"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "allowed_points": allowedPoints,
  };
}
