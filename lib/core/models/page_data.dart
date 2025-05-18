class PageData {
  int? id;
  String? title;
  String? content;
  String? key;
  String? type;

  PageData({this.id, this.title, this.content, this.key, this.type});

  factory PageData.fromJson(Map<String, dynamic> json) => PageData(
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
