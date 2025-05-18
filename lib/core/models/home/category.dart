import 'partner.dart';

class Category {
  int? id;
  String? image;
  String? name;
  String? type;
  int? partnersCount;
  int? productsCount;
  List<Partner>? partners;

  Category({
    this.id,
    this.image,
    this.name,
    this.type,
    this.partnersCount,
    this.productsCount,
    this.partners,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"] ?? 0,
    image: json["image"],
    name: json["name"],
    type: json["type"],
    partnersCount: json["partners_count"] ?? 0,
    productsCount: json["products_count"] ?? 0,
    partners:
        json["partners"] != null
            ? List<Partner>.from(
              json["partners"].map((x) => Partner.fromJson(x)),
            )
            : [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "name": name,
    "type": type,
    "partners_count": partnersCount,
    "productsCount": productsCount,
    "partners": List<dynamic>.from(partners!.map((x) => x.toJson())),
  };
}
