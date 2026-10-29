import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/services/favorite/favorite_service.dart';

class ImageItemModel {
  final String id;
  final String title;
  final String categoryTag;
  final String imagePath;
  final String quoteText;
  final bool isFavorite;

  ImageItemModel({
    required this.id,
    required this.title,
    required this.categoryTag,
    required this.imagePath,
    this.quoteText = '',
    this.isFavorite = false,
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

    final isFav = json['isFavorite'] == true || json['isFav'] == true;
    final modelId = json['_id']?.toString() ?? json['id']?.toString() ?? '';
    if (modelId.isNotEmpty) {
      FavoriteService.instance.seedFavorite(modelId, isFav);
    }

    return ImageItemModel(
      id: modelId,
      title: json['title']?.toString() ?? '',
      categoryTag: json['category']?.toString() ?? 'Prayer',
      imagePath: img,
      quoteText: json['caption']?.toString() ?? json['title']?.toString() ?? '',
      isFavorite: isFav,
    );
  }
}
