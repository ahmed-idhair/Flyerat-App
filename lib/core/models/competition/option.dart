class Option {
  int? id;
  String? option;

  Option({this.id, this.option});

  factory Option.fromJson(Map<String, dynamic> json) =>
      Option(id: json["id"], option: json["option"]);

  Map<String, dynamic> toJson() => {"id": id, "option": option};
}
