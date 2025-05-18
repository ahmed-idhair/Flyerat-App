import '../pagination.dart';
import '../products/product.dart';
import 'favorite.dart';

class FavoritesData {
  List<Favorite>? wishlist;
  Pagination? pagination;

  FavoritesData({this.wishlist, this.pagination});

  factory FavoritesData.fromJson(Map<String, dynamic> json) => FavoritesData(
    wishlist:
        json["wishlist"] != null
            ? List<Favorite>.from(
              json["wishlist"].map((x) => Favorite.fromJson(x)),
            )
            : [],
    pagination:
        json["pagination"] != null
            ? Pagination.fromJson(json["pagination"])
            : null,
  );

  Map<String, dynamic> toJson() => {
    "wishlist": List<dynamic>.from(wishlist!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}
