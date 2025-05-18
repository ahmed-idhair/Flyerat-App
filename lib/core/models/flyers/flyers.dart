import 'package:offers/core/models/home/location_data.dart';

import '../home/flyer.dart';
import '../pagination.dart';

class Flyers {
  LocationData? nearestLocation;
  List<Flyer>? flyers;
  Pagination? pagination;

  Flyers({this.nearestLocation, this.flyers, this.pagination});

  factory Flyers.fromJson(Map<String, dynamic> json) => Flyers(
    nearestLocation:
        json["nearest_location"] != null
            ? LocationData.fromJson(json["nearest_location"])
            : null,
    flyers:
        json["flyers"] != null
            ? List<Flyer>.from(json["flyers"].map((x) => Flyer.fromJson(x)))
            : [],
    pagination:
        json["pagination"] != null
            ? Pagination.fromJson(json["pagination"])
            : null,
  );

  Map<String, dynamic> toJson() => {
    "nearest_location": nearestLocation?.toJson(),
    "flyers": List<dynamic>.from(flyers!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}
