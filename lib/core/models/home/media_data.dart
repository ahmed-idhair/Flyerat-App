class MediaData {
  String? path;
  String? type;
  String? thumbnailPath;

  MediaData({this.path, this.type, this.thumbnailPath});

  factory MediaData.fromJson(Map<String, dynamic> json) => MediaData(
    path: json["path"],
    type: json["type"],
    thumbnailPath: json["thumbnailPath"],
  );

  Map<String, dynamic> toJson() => {
    "path": path,
    "type": type,
    "thumbnailPath": thumbnailPath,
  };
}
