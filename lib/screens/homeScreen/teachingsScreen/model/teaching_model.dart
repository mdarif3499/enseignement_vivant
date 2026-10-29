import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/services/favorite/favorite_service.dart';

class TeachingModel {
  final String id;
  final String title;
  final String durationText;
  final String subtitle;
  final String imagePath;
  final String audioUrl;
  final String categoryTag;
  final String contentText;
  final bool isFavorite;

  TeachingModel({
    required this.id,
    required this.title,
    required this.durationText,
    required this.subtitle,
    required this.imagePath,
    required this.audioUrl,
    this.categoryTag = 'TEACHING',
    this.contentText = '',
    this.isFavorite = false,
  });

  factory TeachingModel.fromJson(Map<String, dynamic> json) {
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

    final isFav = json['isFavorite'] == true || json['isFav'] == true;
    final modelId = json['_id']?.toString() ?? json['id']?.toString() ?? '';
    if (modelId.isNotEmpty) {
      FavoriteService.instance.seedFavorite(modelId, isFav);
    }

    return TeachingModel(
      id: modelId,
      title: json['name']?.toString() ?? json['title']?.toString() ?? '',
      durationText: json['duration']?.toString().trim().isNotEmpty == true
          ? json['duration'].toString().trim()
          : '',
      subtitle: json['description']?.toString() ?? json['name']?.toString() ?? '',
      imagePath: image,
      audioUrl: audio,
      categoryTag: 'TEACHING',
      contentText: json['prayer']?.toString() ?? json['content']?.toString() ?? '',
      isFavorite: isFav,
    );
  }
}
