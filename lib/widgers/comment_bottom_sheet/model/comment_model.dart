import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';

class CommentModel {
  final String id;
  final String userName;
  final String userImage;
  final String text;
  final String timeAgo;
  final RxList<CommentModel> replies = <CommentModel>[].obs;
  final RxBool isRepliesExpanded = false.obs;
  final RxBool isLoadingReplies = false.obs;

  CommentModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.text,
    required this.timeAgo,
    List<CommentModel>? initialReplies,
  }) {
    if (initialReplies != null) {
      replies.assignAll(initialReplies);
    }
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    String uName = 'User';
    String uImg = '';

    if (json['user'] is Map<String, dynamic>) {
      final userMap = json['user'] as Map<String, dynamic>;
      uName = userMap['name']?.toString() ??
          userMap['userName']?.toString() ??
          userMap['title']?.toString() ??
          'User';
      uImg = userMap['profileImage']?.toString() ??
          userMap['image']?.toString() ??
          userMap['photo']?.toString() ??
          '';
    } else if (json['user'] != null) {
      uName = json['user'].toString();
    }

    if (uImg.isNotEmpty && !uImg.startsWith('http')) {
      if (uImg.startsWith('/files/')) {
        uImg = "${AppApiEndPoint.instance.domain}$uImg";
      } else if (uImg.startsWith('/')) {
        uImg = "${AppApiEndPoint.instance.imageBaseUrl}$uImg";
      } else {
        uImg = "${AppApiEndPoint.instance.imageBaseUrl}/$uImg";
      }
    }

    final commentMsg = json['comment']?.toString() ??
        json['message']?.toString() ??
        json['text']?.toString() ??
        json['content']?.toString() ??
        '';

    final rawCreated = json['createdAt']?.toString() ?? '';
    String formattedTime = 'Just now';
    if (rawCreated.isNotEmpty) {
      try {
        final dt = DateTime.parse(rawCreated).toLocal();
        final now = DateTime.now();
        final diff = now.difference(dt);

        if (diff.inMinutes < 1) {
          formattedTime = 'Just now';
        } else if (diff.inMinutes < 60) {
          formattedTime = '${diff.inMinutes}m ago';
        } else if (diff.inHours < 24) {
          formattedTime = '${diff.inHours}h ago';
        } else if (diff.inDays < 7) {
          formattedTime = '${diff.inDays}d ago';
        } else {
          formattedTime = '${dt.day}/${dt.month}/${dt.year}';
        }
      } catch (_) {
        formattedTime = rawCreated;
      }
    }

    List<CommentModel> parsedReplies = [];
    if (json['replies'] is List) {
      parsedReplies = (json['replies'] as List)
          .map((r) => CommentModel.fromJson(r as Map<String, dynamic>))
          .toList();
    }

    return CommentModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userName: uName,
      userImage: uImg,
      text: commentMsg,
      timeAgo: formattedTime,
      initialReplies: parsedReplies,
    );
  }
}
