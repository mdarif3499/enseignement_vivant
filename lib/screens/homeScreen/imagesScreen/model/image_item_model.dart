import 'package:enseignement_vivant/constant/app_api_end_point.dart';

class ImageItemModel {
  final String id;
  final String title;
  final String categoryTag;
  final String imagePath;
  final String quoteText;

  ImageItemModel({
    required this.id,
    required this.title,
    required this.categoryTag,
    required this.imagePath,
    this.quoteText = '',
  });

  factory ImageItemModel.fromJson(Map<String, dynamic> json) {
    String img = json['image']?.toString() ?? json['coverImage']?.toString() ?? '';
    if (img.isNotEmpty) {
      if (img.startsWith('http://') || img.startsWith('https://')) {
        // already full URL
      } else if (img.startsWith('/files/')) {
        img = "${AppApiEndPoint.instance.domain}$img";
      } else if (img.startsWith('/')) {
        img = "${AppApiEndPoint.instance.imageBaseUrl}$img";
      } else {
        img = "${AppApiEndPoint.instance.imageBaseUrl}/$img";
      }
    }

    return ImageItemModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      categoryTag: json['category']?.toString() ?? 'Prayer',
      imagePath: img,
      quoteText: json['caption']?.toString() ?? json['title']?.toString() ?? '',
    );
  }
}
