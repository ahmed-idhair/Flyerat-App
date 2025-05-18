class DateAt {
  String? defaultDate;
  String? human;

  DateAt({this.defaultDate, this.human});

  factory DateAt.fromJson(Map<String, dynamic> json) =>
      DateAt(defaultDate: json["default"], human: json["human"]);

  Map<String, dynamic> toJson() => {"default": defaultDate, "human": human};
}
