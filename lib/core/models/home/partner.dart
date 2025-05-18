import 'location_data.dart';

class Partner {
  int? id;
  String? name;
  String? email;
  String? image;
  List<LocationData>? locations;

  Partner({this.id, this.name, this.email, this.image, this.locations});

  factory Partner.fromJson(Map<String, dynamic> json) => Partner(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    image: json["image"],
    locations:
        json["locations"] != null
            ? List<LocationData>.from(
              json["locations"].map((x) => LocationData.fromJson(x)),
            )
            : [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "image": image,
    "locations": List<dynamic>.from(locations!.map((x) => x.toJson())),
  };
}
