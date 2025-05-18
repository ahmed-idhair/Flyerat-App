class FeedbackReasons {
  int? id;
  String? question;

  FeedbackReasons({this.id, this.question});

  factory FeedbackReasons.fromJson(Map<String, dynamic> json) =>
      FeedbackReasons(id: json["id"], question: json["question"]);

  Map<String, dynamic> toJson() => {"id": id, "question": question};
}
