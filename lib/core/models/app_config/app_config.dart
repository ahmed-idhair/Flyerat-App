class AppConfig {
  String? name;
  String? key;
  String? value;

  AppConfig({this.name, this.key, this.value});

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      name: json['name'],
      key: json['key'],
      value: json['value'],
    );
  }
}
