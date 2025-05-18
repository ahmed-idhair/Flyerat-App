import 'available_competition.dart';
import 'banner.dart';
import 'category.dart';
import 'flyer.dart';

class HomeData {
  List<Banner>? banners;
  List<Category>? partnerCategories;
  List<Flyer>? starredFlyers;
  List<Flyer>? nearestFlyers;
  List<Flyer>? latestFlyers;
  AvailableCompetition? availableCompetition;

  HomeData({
    this.banners,
    this.partnerCategories,
    this.starredFlyers,
    this.nearestFlyers,
    this.latestFlyers,
    this.availableCompetition,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
    banners:
        json["banners"] != null
            ? List<Banner>.from(json["banners"].map((x) => Banner.fromJson(x)))
            : [],
    partnerCategories:
        json["partner_categories"] != null
            ? List<Category>.from(
              json["partner_categories"].map((x) => Category.fromJson(x)),
            )
            : [],
    starredFlyers:
        json["starred_flyers"] != null
            ? List<Flyer>.from(
              json["starred_flyers"].map((x) => Flyer.fromJson(x)),
            )
            : [],
    nearestFlyers:
        json["nearest_flyers"] != null
            ? List<Flyer>.from(
              json["nearest_flyers"].map((x) => Flyer.fromJson(x)),
            )
            : [],
    latestFlyers:
        json["latest_flyers"] != null
            ? List<Flyer>.from(
              json["latest_flyers"].map((x) => Flyer.fromJson(x)),
            )
            : [],
    availableCompetition:
        json["available_competition"] != null
            ? AvailableCompetition.fromJson(json["available_competition"])
            : null,
  );

  Map<String, dynamic> toJson() => {
    "banners": List<dynamic>.from(banners!.map((x) => x.toJson())),
    "partner_categories": List<dynamic>.from(
      partnerCategories!.map((x) => x.toJson()),
    ),
    "starred_flyers": List<dynamic>.from(starredFlyers!.map((x) => x.toJson())),
    "nearest_flyers": List<dynamic>.from(nearestFlyers!.map((x) => x.toJson())),
    "latest_flyers": List<dynamic>.from(latestFlyers!.map((x) => x.toJson())),
    "available_competition": availableCompetition?.toJson(),
  };
}
