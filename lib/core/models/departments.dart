class Departments {
  int? id;
  String? image;
  String? name;
  String? type;
  int? productsCount;

  Departments({
    this.id,
    this.image,
    this.name,
    this.type,
    this.productsCount,
  });

  factory Departments.fromJson(Map<String, dynamic> json) => Departments(
    id: json["id"],
    image: json["image"],
    name: json["name"],
    type: json["type"],
    productsCount: json["products_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "name": name,
    "type": type,
    "products_count": productsCount,
  };
}