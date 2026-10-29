import 'package:enseignement_vivant/constant/app_api_end_point.dart';

class FavoriteItemModel {
  final String id;
  final String postId;
  final String postType;
  final String title;
  final String categoryTag;
  final String durationText;
  final String subtitle;
  final String imagePath;
  final String audioUrl;
  final String contentText;

  FavoriteItemModel({
    required this.id,
    required this.postId,
    required this.postType,
    required this.title,
    required this.categoryTag,
    required this.durationText,
    required this.subtitle,
    required this.imagePath,
    required this.audioUrl,
    this.contentText = '',
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    final favId = json['_id']?.toString() ?? '';
    final type = json['postType']?.toString() ?? 'Prayer';
    final postObj = json['post'] is Map<String, dynamic>
        ? json['post'] as Map<String, dynamic>
        : <String, dynamic>{};

    final actualPostId = postObj['_id']?.toString() ?? postObj['id']?.toString() ?? favId;

    // Resolve Image URL
    String img = postObj['coverImage']?.toString() ?? postObj['image']?.toString() ?? postObj['photo']?.toString() ?? '';
    if (img.isNotEmpty && !img.startsWith('http')) {
      if (img.startsWith('/files/')) {
        img = "${AppApiEndPoint.instance.domain}$img";
      } else if (img.startsWith('/')) {
        img = "${AppApiEndPoint.instance.imageBaseUrl}$img";
      } else {
        img = "${AppApiEndPoint.instance.imageBaseUrl}/$img";
      }
    }

    // Resolve Audio URL
    String audio = postObj['audio']?.toString() ?? '';
    if (audio.isNotEmpty && !audio.startsWith('http')) {
      if (audio.startsWith('/files/')) {
        audio = "${AppApiEndPoint.instance.domain}$audio";
      } else if (audio.startsWith('/')) {
        audio = "${AppApiEndPoint.instance.imageBaseUrl}$audio";
      } else {
        audio = "${AppApiEndPoint.instance.imageBaseUrl}/$audio";
      }
    }

    final rawTitle = postObj['title']?.toString() ?? postObj['name']?.toString() ?? postObj['author']?.toString() ?? 'Favorite';
    final rawSubtitle = postObj['description']?.toString() ?? postObj['caption']?.toString() ?? postObj['message']?.toString() ?? postObj['content']?.toString() ?? '';
    final rawDuration = postObj['duration']?.toString().trim() ?? '';
    final rawContent = postObj['prayer']?.toString() ?? postObj['content']?.toString() ?? postObj['message']?.toString() ?? '';

    return FavoriteItemModel(
      id: favId,
      postId: actualPostId,
      postType: type,
      title: rawTitle,
      categoryTag: type,
      durationText: rawDuration,
      subtitle: rawSubtitle,
      imagePath: img,
      audioUrl: audio,
      contentText: rawContent,
    );
  }
}
