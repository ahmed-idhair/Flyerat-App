import 'package:offers/core/models/date_at.dart';

import '../products/product.dart';

class Favorite {
  int? id;
  Product? product;
  DateAt? createdAt;

  Favorite({this.id, this.product, this.createdAt});

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
    id: json["id"],
    product: json["product"] != null ? Product.fromJson(json["product"]) : null,
    createdAt:
        json["created_at"] != null ? DateAt.fromJson(json["created_at"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product": product?.toJson(),
    "created_at": createdAt?.toJson(),
  };
}
