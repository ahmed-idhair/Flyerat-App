import 'option.dart';

class Question {
  int? id;
  String? question;
  List<Option>? options;
  int? selectedOptionId;

  Question({this.id, this.question, this.options, this.selectedOptionId});

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["id"],
    question: json["question"],
    options:
        json["options"] != null
            ? List<Option>.from(json["options"].map((x) => Option.fromJson(x)))
            : [],
    selectedOptionId: null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "options": List<dynamic>.from(options!.map((x) => x.toJson())),
  };
}
