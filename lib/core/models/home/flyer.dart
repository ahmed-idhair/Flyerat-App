import 'media_data.dart';
import 'partner.dart';

class Flyer {
  int? id;
  String? title;
  String? description;
  String? startDate;
  String? endDate;
  String? externalUrl;
  String? mediaType;
  String? videoCover;
  bool? starred;
  Partner? partner;
  List<MediaData>? media;
  bool? isLiked;
  int? likesCount;
  int? commentsCount;
  int? sharesCount;

  Flyer({
    this.id,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.externalUrl,
    this.mediaType,
    this.videoCover,
    this.starred,
    this.partner,
    this.media,
    this.isLiked,
    this.likesCount,
    this.commentsCount,
    this.sharesCount,
  });

  factory Flyer.fromJson(Map<String, dynamic> json) => Flyer(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    externalUrl: json["external_url"],
    mediaType: json["media_type"],
    videoCover: json["video_cover"],
    starred: json["starred"],
    partner: json["partner"] != null ? Partner.fromJson(json["partner"]) : null,
    media:
        json["media"] != null
            ? List<MediaData>.from(
              json["media"].map((x) => MediaData.fromJson(x)),
            )
            : [],
    isLiked: json["is_liked"],
    likesCount: json["likes_count"],
    commentsCount: json["comments_count"],
    sharesCount: json["shares_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "start_date": startDate,
    "end_date": endDate,
    "external_url": externalUrl,
    "media_type": mediaType,
    "video_cover": videoCover,
    "starred": starred,
    "partner": partner?.toJson(),
    "media": List<dynamic>.from(media!.map((x) => x.toJson())),
    "is_liked": isLiked,
    "likes_count": likesCount,
    "comments_count": commentsCount,
    "shares_count": sharesCount,
  };
}
