class Pages {
  int? id;
  String? title;
  String? content;
  String? key;
  String? type;

  Pages({
    this.id,
    this.title,
    this.content,
    this.key,
    this.type,
  });

  factory Pages.fromJson(Map<String, dynamic> json) => Pages(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    key: json["key"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "key": key,
    "type": type,
  };
}
