import 'package:offers/core/models/cities.dart';

class LocationData {
  int? id;
  String? name;
  String? address;
  String? lat;
  String? lng;
  String? phone;
  String? distance;
  Cities? city;

  LocationData({
    this.id,
    this.name,
    this.address,
    this.lat,
    this.lng,
    this.phone,
    this.distance,
    this.city,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    lat: json["lat"],
    lng: json["lng"],
    phone: json["phone"],
    distance: json["distance"],
    city: json["city"] != null ? Cities.fromJson(json["city"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "lat": lat,
    "lng": lng,
    "phone": phone,
    "distance": distance,
    "city": city?.toJson(),
  };
}
