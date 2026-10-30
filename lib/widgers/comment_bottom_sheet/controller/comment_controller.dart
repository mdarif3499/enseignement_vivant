import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/services/storage_services/get_storage_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';
import '../model/comment_model.dart';

class CommentController extends GetxController {
  final TextEditingController commentInputController = TextEditingController();
  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final RxBool isLoading = false.obs;

  final Rx<CommentModel?> replyingToComment = Rx<CommentModel?>(null);
  final Rx<CommentModel?> editingComment = Rx<CommentModel?>(null);

  Future<void> fetchComments(String postId) async {
    if (postId.isEmpty) return;
    isLoading.value = true;
    try {
      final url = "${AppApiEndPoint.instance.commentEndpoint}/$postId";
      final response = await ApiServices.instance.getServices(url);

      if (kDebugMode) {
        debugPrint('================ GET COMMENTS RESPONSE ================');
        debugPrint('URL: $url');
        debugPrint('RESPONSE: $response');
        debugPrint('=======================================================');
      }

      if (isClosed) return;

      if (response != null && response['data'] != null) {
        List rawList = [];
        if (response['data'] is List) {
          rawList = response['data'] as List;
        } else if (response['data'] is Map<String, dynamic> && response['data']['data'] is List) {
          rawList = response['data']['data'] as List;
        }

        // Map existing comments to preserve expanded replies state across refreshes
        final Map<String, CommentModel> existingMap = {
          for (var c in comments) c.id: c
        };

        final items = rawList.map((e) {
          final newComment = CommentModel.fromJson(e as Map<String, dynamic>);
          final existing = existingMap[newComment.id];
          if (existing != null) {
            newComment.isRepliesExpanded.value = existing.isRepliesExpanded.value;
            if (existing.replies.isNotEmpty) {
              newComment.replies.assignAll(existing.replies);
            }
          }
          return newComment;
        }).toList();

        comments.assignAll(items);
      } else {
        comments.clear();
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('Fetch Comments API Error for $postId', e);
      comments.clear();
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  Future<void> fetchReplies(CommentModel comment) async {
    if (comment.id.isEmpty) return;
    comment.isLoadingReplies.value = true;
    try {
      final url = "${AppApiEndPoint.instance.commentEndpoint}/${comment.id}/reply";
      final response = await ApiServices.instance.getServices(url);

      if (kDebugMode) {
        debugPrint('================ GET REPLIES RESPONSE ================');
        debugPrint('URL: $url');
        debugPrint('RESPONSE: $response');
        debugPrint('======================================================');
      }

      if (isClosed) return;

      if (response != null && response['data'] != null) {
        List rawList = [];
        if (response['data'] is List) {
          rawList = response['data'] as List;
        } else if (response['data'] is Map<String, dynamic> && response['data']['data'] is List) {
          rawList = response['data']['data'] as List;
        }

        final items = rawList
            .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
            .toList();

        comment.replies.assignAll(items);
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('Fetch Replies API Error for comment ${comment.id}', e);
    } finally {
      comment.isLoadingReplies.value = false;
      comment.isRepliesExpanded.value = true;
    }
  }

  Future<void> postComment(String postId, String postType) async {
    final text = commentInputController.text.trim();
    if (text.isEmpty || postId.isEmpty) return;

    replyingToComment.value = null;
    editingComment.value = null;

    final userName = StorageServices.instance.getUserName().isNotEmpty
        ? StorageServices.instance.getUserName()
        : "User";
    final userImage = StorageServices.instance.getProfileImage();

    // Optimistically insert new comment
    final tempComment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: userName,
      userImage: userImage,
      text: text,
      timeAgo: 'Just now',
    );

    comments.insert(0, tempComment);
    commentInputController.clear();

    try {
      final body = {
        "content": text,
        "post": postId,
        "postType": postType,
      };

      final url = AppApiEndPoint.instance.commentEndpoint;
      final response = await ApiServices.instance.postServices(
        url: url,
        body: body,
      );

      if (kDebugMode) {
        debugPrint('================ POST COMMENT RESPONSE ================');
        debugPrint('URL: $url');
        debugPrint('BODY: $body');
        debugPrint('RESPONSE: $response');
        debugPrint('=======================================================');
      }

      fetchComments(postId);
    } catch (e) {
      errorLog('Post Comment API Error for $postId', e);
    }
  }

  Future<void> postReply(String commentId, String postId, String postType) async {
    final text = commentInputController.text.trim();
    if (text.isEmpty || commentId.isEmpty) return;

    CommentModel? parentComment = comments.firstWhereOrNull((c) => c.id == commentId);
    parentComment ??= replyingToComment.value;

    replyingToComment.value = null;
    editingComment.value = null;
    commentInputController.clear();

    final userName = StorageServices.instance.getUserName().isNotEmpty
        ? StorageServices.instance.getUserName()
        : "User";
    final userImage = StorageServices.instance.getProfileImage();

    final tempReply = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: userName,
      userImage: userImage,
      text: text,
      timeAgo: 'Just now',
    );

    if (parentComment != null) {
      parentComment.replies.add(tempReply);
      parentComment.isRepliesExpanded.value = true;
    }

    try {
      final body = {
        "content": text,
        "post": postId,
        "postType": postType,
      };

      final url = "${AppApiEndPoint.instance.commentEndpoint}/$commentId/reply";
      final response = await ApiServices.instance.postServices(
        url: url,
        body: body,
      );

      if (kDebugMode) {
        debugPrint('================ POST REPLY RESPONSE ================');
        debugPrint('URL: $url');
        debugPrint('BODY: $body');
        debugPrint('RESPONSE: $response');
        debugPrint('=====================================================');
      }

      if (parentComment != null) {
        await fetchReplies(parentComment);
      }
    } catch (e) {
      errorLog('Post Reply API Error for comment $commentId', e);
    }
  }

  void startEditing(CommentModel comment) {
    replyingToComment.value = null;
    editingComment.value = comment;
    commentInputController.text = comment.text;
  }

  void cancelEditing() {
    editingComment.value = null;
    commentInputController.clear();
  }

  Future<void> updateComment({required String postId, required String postType}) async {
    final commentToEdit = editingComment.value;
    final text = commentInputController.text.trim();
    if (commentToEdit == null || text.isEmpty) return;

    editingComment.value = null;
    commentInputController.clear();

    try {
      final body = {
        "content": text,
        "post": postId,
        "postType": postType,
      };

      final url = "${AppApiEndPoint.instance.commentEndpoint}/${commentToEdit.id}";
      final response = await ApiServices.instance.patchServices(
        url: url,
        body: body,
      );

      if (kDebugMode) {
        debugPrint('================ UPDATE COMMENT RESPONSE ================');
        debugPrint('URL: $url');
        debugPrint('BODY: $body');
        debugPrint('RESPONSE: $response');
        debugPrint('========================================================');
      }

      if (response != null && (response['success'] == true || response['statusCode'] == 200)) {
        AppSnackBar.instance.success(response['message']?.toString() ?? "Comment updated successfully");
      }
      fetchComments(postId);
    } catch (e) {
      errorLog('Update Comment API Error for ${commentToEdit.id}', e);
      fetchComments(postId);
    }
  }

  Future<void> deleteComment({required String commentId, required String postId, CommentModel? parentComment}) async {
    if (commentId.isEmpty) return;

    if (parentComment != null) {
      parentComment.replies.removeWhere((r) => r.id == commentId);
    } else {
      comments.removeWhere((c) => c.id == commentId);
    }

    try {
      final url = "${AppApiEndPoint.instance.commentEndpoint}/$commentId";
      final response = await ApiServices.instance.deleteServices(url: url);

      if (kDebugMode) {
        debugPrint('================ DELETE COMMENT RESPONSE ================');
        debugPrint('URL: $url');
        debugPrint('RESPONSE: $response');
        debugPrint('========================================================');
      }

      if (response != null && (response['success'] == true || response['statusCode'] == 200)) {
        AppSnackBar.instance.success(response['message']?.toString() ?? "Comment deleted successfully");
      }
      fetchComments(postId);
    } catch (e) {
      errorLog('Delete Comment API Error for $commentId', e);
      fetchComments(postId);
    }
  }

  @override
  void onClose() {
    commentInputController.dispose();
    super.onClose();
  }
}
