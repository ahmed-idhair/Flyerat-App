class Cities {
  int? id;
  String? name;
  int? countryId;

  Cities({this.id, this.name, this.countryId});

  factory Cities.fromJson(Map<String, dynamic> json) =>
      Cities(id: json["id"], name: json["name"], countryId: json["country_id"]);

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country_id": countryId,
  };
}
