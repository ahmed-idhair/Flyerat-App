import 'package:offers/core/models/date_at.dart';
import 'package:offers/core/models/home/category.dart';
import 'package:offers/core/models/home/media_data.dart';

import '../home/flyer.dart';
import '../home/partner.dart';

class Product {
  int? id;
  String? name;
  String? description;
  dynamic price;
  dynamic discount;
  dynamic newPrice;
  bool? hasDiscount;
  dynamic discountPercentage;
  String? startDate;
  String? endDate;
  List<MediaData>? media;
  DateAt? createdAt;
  DateAt? updatedAt;
  Partner? partner;
  Flyer? flyer;
  Category? category;
  Category? brand;
  bool? isFavorite;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.discount,
    this.newPrice,
    this.hasDiscount,
    this.discountPercentage,
    this.startDate,
    this.endDate,
    this.media,
    this.createdAt,
    this.updatedAt,
    this.partner,
    this.flyer,
    this.category,
    this.brand,
    this.isFavorite,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    discount: json["discount"],
    newPrice: json["new_price"],
    hasDiscount: json["has_discount"],
    discountPercentage: json["discount_percentage"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    media: json["media"] != null
        ? List<MediaData>.from(json["media"].map((x) => MediaData.fromJson(x)))
        : [],
    createdAt:
        json["created_at"] != null ? DateAt.fromJson(json["created_at"]) : null,
    updatedAt:
        json["updated_at"] != null ? DateAt.fromJson(json["updated_at"]) : null,
    partner: json["partner"] != null ? Partner.fromJson(json["partner"]) : null,
    flyer: json["flyer"] != null ? Flyer.fromJson(json["flyer"]) : null,
    category:
        json["category"] != null ? Category.fromJson(json["category"]) : null,
    brand: json["brand"] != null ? Category.fromJson(json["brand"]) : null,
    isFavorite: json["is_favorite"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "discount": discount,
    "new_price": newPrice,
    "has_discount": hasDiscount,
    "discount_percentage": discountPercentage,
    "start_date": startDate,
    "end_date": endDate,
    "media": List<dynamic>.from(media!.map((x) => x)),
    "created_at": createdAt?.toJson(),
    "updated_at": updatedAt?.toJson(),
    "partner": partner?.toJson(),
    "flyer": flyer?.toJson(),
    "category": category?.toJson(),
    "brand": brand?.toJson(),
    "is_favorite": isFavorite,
  };
}
