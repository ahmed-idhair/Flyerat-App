class SettingsObj {
  String? name;
  String? key;
  dynamic value;

  SettingsObj({this.name, this.key, this.value});

  factory SettingsObj.fromJson(Map<String, dynamic> json) =>
      SettingsObj(name: json["name"], key: json["key"], value: json["value"]);

  Map<String, dynamic> toJson() => {"name": name, "key": key, "value": value};
}
