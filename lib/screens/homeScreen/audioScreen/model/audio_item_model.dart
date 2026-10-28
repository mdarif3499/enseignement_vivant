import 'package:enseignement_vivant/constant/app_api_end_point.dart';

class AudioItemModel {
  final String id;
  final String title;
  final String categoryTag;
  final String durationText;
  final String subtitle;
  final String imagePath;
  final String audioUrl;
  final String contentText;

  AudioItemModel({
    required this.id,
    required this.title,
    required this.categoryTag,
    required this.durationText,
    required this.subtitle,
    required this.imagePath,
    required this.audioUrl,
    this.contentText = '''Heavenly Father, I come to You with open hands and a grateful heart. Today I surrender my plans, my worries, and my fears into Your care.

Lead me in Your wisdom. Quiet the noise within me, and let Your peace be the first thing I hear. Help me to trust that You are good, that You are near, and that You are working in every detail of my life.

Shape my words, guide my steps, and fill my heart with Your love so that I may be a light to others.

In Jesus' name, Amen.''',
  });

  factory AudioItemModel.fromJson(Map<String, dynamic> json) {
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

    return AudioItemModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      categoryTag: json['category']?.toString() ?? 'Prayer',
      durationText: json['duration']?.toString().trim() ?? '',
      subtitle: json['description']?.toString() ?? '',
      imagePath: image,
      audioUrl: audio,
      contentText: json['prayer']?.toString() ?? '',
    );
  }
}
