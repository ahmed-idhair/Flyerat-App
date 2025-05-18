class Pagination {
  int? total;
  int? perPage;
  int? currentPage;
  int? from;
  int? to;
  String? firstPageUrl;
  int? lastPage;
  String? lastPageUrl;
  dynamic nextPageUrl;
  dynamic prevPageUrl;

  Pagination({
    this.total,
    this.perPage,
    this.currentPage,
    this.from,
    this.to,
    this.firstPageUrl,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    from: json["from"],
    to: json["to"],
    firstPageUrl: json["first_page_url"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    nextPageUrl: json["next_page_url"],
    prevPageUrl: json["prev_page_url"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
    "from": from,
    "to": to,
    "first_page_url": firstPageUrl,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "next_page_url": nextPageUrl,
    "prev_page_url": prevPageUrl,
  };
}
