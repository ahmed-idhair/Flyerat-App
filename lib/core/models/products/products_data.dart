import '../pagination.dart';
import 'product.dart';

class ProductsData {
  List<Product>? products;
  Pagination? pagination;

  ProductsData({this.products, this.pagination});

  factory ProductsData.fromJson(Map<String, dynamic> json) => ProductsData(
    products:
        json["products"] != null
            ? List<Product>.from(
              json["products"].map((x) => Product.fromJson(x)),
            )
            : [],
    pagination:
        json["pagination"] != null
            ? Pagination.fromJson(json["pagination"])
            : null,
  );

  Map<String, dynamic> toJson() => {
    "products": List<dynamic>.from(products!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}
