class SupportReasons {
  int? id;
  String? reason;

  SupportReasons({this.id, this.reason});

  factory SupportReasons.fromJson(Map<String, dynamic> json) =>
      SupportReasons(id: json["id"], reason: json["reason"]);

  Map<String, dynamic> toJson() => {"id": id, "reason": reason};
}
