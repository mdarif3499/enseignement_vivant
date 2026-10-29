import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/services/favorite/favorite_service.dart';

class EncouragementModel {
  final String id;
  final String title;
  final String subtitle;
  final String imagePath;
  final String categoryTag;
  final String contentText;
  final bool isFavorite;

  EncouragementModel({
    this.id = '',
    this.title = '',
    this.subtitle = '',
    this.imagePath = '',
    this.categoryTag = 'ENCOURAGEMENT',
    this.contentText = '',
    this.isFavorite = false,
  });

  factory EncouragementModel.fromJson(Map<String, dynamic> json) {
    String photo = json['photo']?.toString() ?? json['coverImage']?.toString() ?? json['image']?.toString() ?? '';
    if (photo.isNotEmpty) {
      if (photo.startsWith('http://') || photo.startsWith('https://')) {
        // already full URL
      } else if (photo.startsWith('/files/')) {
        photo = "${AppApiEndPoint.instance.domain}$photo";
      } else if (photo.startsWith('/')) {
        photo = "${AppApiEndPoint.instance.imageBaseUrl}$photo";
      } else {
        photo = "${AppApiEndPoint.instance.imageBaseUrl}/$photo";
      }
    }

    final msg = json['message']?.toString() ?? '';
    final authorText = json['author']?.toString() ?? '';
    final isFav = json['isFavorite'] == true || json['isFav'] == true;
    final modelId = json['_id']?.toString() ?? json['id']?.toString() ?? '';
    if (modelId.isNotEmpty) {
      FavoriteService.instance.seedFavorite(modelId, isFav);
    }

    return EncouragementModel(
      id: modelId,
      title: authorText.isNotEmpty ? authorText : 'Word of Encouragement',
      subtitle: authorText.isNotEmpty ? authorText : 'Encouragement',
      imagePath: photo,
      categoryTag: 'ENCOURAGEMENT',
      contentText: msg,
      isFavorite: isFav,
    );
  }
}
