class Countries {
  int? id;
  String? name;
  String? code;
  String? phoneCode;
  String? currency;
  String? currencySymbol;
  String? image;

  Countries({
    this.id,
    this.name,
    this.code,
    this.phoneCode,
    this.currency,
    this.currencySymbol,
    this.image,
  });

  factory Countries.fromJson(Map<String, dynamic> json) => Countries(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    phoneCode: json["phone_code"],
    currency: json["currency"],
    currencySymbol: json["currency_symbol"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "phone_code": phoneCode,
    "currency": currency,
    "currency_symbol": currencySymbol,
    "image": image,
  };
}