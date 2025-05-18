class FlyerLiked {
  bool? isLiked;
  int? likesCount;

  FlyerLiked({
    this.isLiked,
    this.likesCount,
  });

  factory FlyerLiked.fromJson(Map<String, dynamic> json) => FlyerLiked(
    isLiked: json["is_liked"],
    likesCount: json["likes_count"],
  );

  Map<String, dynamic> toJson() => {
    "is_liked": isLiked,
    "likes_count": likesCount,
  };
}