class OnBoardings {
  int? id;
  String? title;
  String? description;
  String? image;
  int? order;

  OnBoardings({this.id, this.title, this.description, this.image, this.order});

  factory OnBoardings.fromJson(Map<String, dynamic> json) => OnBoardings(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    order: json["order"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
    "order": order,
  };
}
