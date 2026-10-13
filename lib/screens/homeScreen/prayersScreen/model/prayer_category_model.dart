import 'package:enseignement_vivant/constant/app_api_end_point.dart';

class PrayerCategoryModel {
  final String id;
  final String title;
  final String subtitle;
  final String coverImage;
  final String categoryTag;
  final String prayerText;
  final String audioUrl;
  final String duration;
  final String status;

  String get imagePath => coverImage;

  PrayerCategoryModel({
    this.id = '',
    required this.title,
    required this.subtitle,
    required this.coverImage,
    this.categoryTag = 'PRAYER',
    this.prayerText = '',
    this.audioUrl = '',
    this.duration = '',
    this.status = '',
  });

  factory PrayerCategoryModel.fromJson(Map<String, dynamic> json) {
    String image = json['coverImage']?.toString() ?? json['image']?.toString() ?? '';
    if (image.isNotEmpty) {
      if (image.startsWith('http://') || image.startsWith('https://')) {
        // already full URL
      } else if (image.startsWith('/files/')) {
        image = "${AppApiEndPoint.instance.domain}$image";
      } else if (image.startsWith('/')) {
        image = "${AppApiEndPoint.instance.imageBaseUrl}$image";
      } else {
        image = "${AppApiEndPoint.instance.imageBaseUrl}/$image";
      }
    }

    String audio = json['audio']?.toString() ?? '';
    if (audio.isNotEmpty) {
      if (audio.startsWith('http://') || audio.startsWith('https://')) {
        // already full URL
      } else if (audio.startsWith('/files/')) {
        audio = "${AppApiEndPoint.instance.domain}$audio";
      } else if (audio.startsWith('/')) {
        audio = "${AppApiEndPoint.instance.imageBaseUrl}$audio";
      } else {
        audio = "${AppApiEndPoint.instance.imageBaseUrl}/$audio";
      }
    }

    final rawPrayer = json['prayer']?.toString() ?? '';

    return PrayerCategoryModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['description']?.toString() ?? json['subtitle']?.toString() ?? '',
      coverImage: image,
      categoryTag: 'PRAYER',
      prayerText: rawPrayer,
      audioUrl: audio,
      duration: json['duration']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}
