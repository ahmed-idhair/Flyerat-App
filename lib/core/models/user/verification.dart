class Verification {
  dynamic type;
  dynamic token;

  Verification({this.type, this.token});

  factory Verification.fromJson(Map<String, dynamic> json) =>
      Verification(type: json["type"], token: json["token"]);

  Map<String, dynamic> toJson() => {"type": type, "token": token};
}
