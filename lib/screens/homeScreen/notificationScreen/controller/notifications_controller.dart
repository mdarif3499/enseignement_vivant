import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String filePath;
  final String imagePath;
  final bool isRead;
  final String timeText;
  final String createdAt;

  String get titleKey => title;
  String get subtitleKey => message;
  String get time => timeText;
  IconData get icon => _getNotificationIcon(filePath);
  Color get iconBgColor => const Color(0xFFE0F2F1);
  Color get iconColor => ConstColor.primaryTeal;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.filePath,
    required this.imagePath,
    required this.isRead,
    required this.timeText,
    required this.createdAt,
  });

  static IconData _getNotificationIcon(String filePath) {
    final path = filePath.toLowerCase();
    if (path.contains('prayer')) {
      return Icons.auto_stories_rounded;
    } else if (path.contains('audio')) {
      return Icons.audiotrack_rounded;
    } else if (path.contains('teaching')) {
      return Icons.school_rounded;
    } else if (path.contains('encouragement')) {
      return Icons.favorite_rounded;
    } else if (path.contains('image')) {
      return Icons.image_rounded;
    }
    return Icons.notifications_rounded;
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    String img = json['image']?.toString() ?? json['coverImage']?.toString() ?? '';
    if (img.isNotEmpty && !img.startsWith('http')) {
      if (img.startsWith('/files/')) {
        img = "${AppApiEndPoint.instance.domain}$img";
      } else if (img.startsWith('/')) {
        img = "${AppApiEndPoint.instance.imageBaseUrl}$img";
      } else {
        img = "${AppApiEndPoint.instance.imageBaseUrl}/$img";
      }
    }

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
          final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
          final period = dt.hour >= 12 ? 'PM' : 'AM';
          final minute = dt.minute.toString().padLeft(2, '0');
          formattedTime = '${dt.day}/${dt.month}/${dt.year} $hour:$minute $period';
        }
      } catch (_) {
        formattedTime = rawCreated;
      }
    }

    return NotificationModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Notification',
      message: json['message']?.toString() ?? json['content']?.toString() ?? '',
      filePath: json['filePath']?.toString() ?? '',
      imagePath: img,
      isRead: json['isRead'] == true,
      timeText: formattedTime,
      createdAt: rawCreated,
    );
  }
}

class NotificationsController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final response = await ApiServices.instance.getServices(
        AppApiEndPoint.instance.notificationEndpoint,
      );

      if (isClosed) return;

      if (response != null && response['data'] != null) {
        List rawList = [];

        if (response['data'] is Map<String, dynamic>) {
          final dataMap = response['data'] as Map<String, dynamic>;
          unreadCount.value = (dataMap['unreadCount'] as int?) ?? 0;
          if (dataMap['data'] is List) {
            rawList = dataMap['data'] as List;
          }
        } else if (response['data'] is List) {
          rawList = response['data'] as List;
        }

        final items = rawList
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList();

        notifications.assignAll(items);
      } else {
        notifications.clear();
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('Fetch Notifications Error', e);
      notifications.clear();
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }
}
