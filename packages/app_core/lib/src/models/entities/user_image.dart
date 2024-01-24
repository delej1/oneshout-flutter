class UserImage {
  UserImage({
    this.thumbnail = '',
    this.small = '',
    this.medium = '',
    this.large = '',
  });

  UserImage.fromJson(Map<String, dynamic> json)
      : thumbnail = json['thumbnail'] as String,
        small = json['small'] as String,
        medium = json['medium'] as String,
        large = json['large'] as String;

  String thumbnail;
  String small;
  String medium;
  String large;

  bool get valid =>
      thumbnail.isNotEmpty ||
      small.isNotEmpty ||
      medium.isNotEmpty ||
      large.isNotEmpty;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'thumbnail': thumbnail,
        'small': small,
        'medium': medium,
        'large': large,
      };
}
