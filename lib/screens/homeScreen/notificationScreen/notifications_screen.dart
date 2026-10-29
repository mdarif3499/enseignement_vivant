import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());

    return Scaffold(
      backgroundColor: ConstColor.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: ConstColor.titleColor, size: 30),
          onPressed: () => Get.back(),
        ),
        title: Text(
          ConstString.notifications.tr,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: ConstColor.titleColor,
            fontFamily: 'SFPro',
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () {
            if (controller.isLoading.value && controller.notifications.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: ConstColor.primaryTeal),
              );
            }

            if (controller.notifications.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 70.w,
                        height: 70.h,
                        decoration: BoxDecoration(
                          color: ConstColor.primaryTeal.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          size: 36.sp,
                          color: ConstColor.primaryTeal,
                        ),
                      ),
                      Gap(height: 16.h),
                      Text(
                        "No Notifications",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF222222),
                          fontFamily: 'SFPro',
                        ),
                      ),
                      Gap(height: 6.h),
                      Text(
                        "You currently have no new notifications.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF8E8E93),
                          fontFamily: 'SFPro',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              color: ConstColor.primaryTeal,
              onRefresh: controller.fetchNotifications,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                itemCount: controller.notifications.length,
                separatorBuilder: (context, index) => Divider(
                  color: const Color(0xFFE5E7EB),
                  thickness: 1,
                  height: 24.h,
                ),
                itemBuilder: (context, index) {
                  final item = controller.notifications[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Left Avatar Image or Icon
                        Container(
                          width: 48.r,
                          height: 48.r,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2F1),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: item.imagePath.isNotEmpty
                                ? Image.network(
                                    item.imagePath,
                                    fit: BoxFit.cover,
                                    width: 48.r,
                                    height: 48.r,
                                    errorBuilder: (context, error, stackTrace) => Icon(
                                      _getNotificationIcon(item.filePath),
                                      color: ConstColor.primaryTeal,
                                      size: 24.sp,
                                    ),
                                  )
                                : Icon(
                                    _getNotificationIcon(item.filePath),
                                    color: ConstColor.primaryTeal,
                                    size: 24.sp,
                                  ),
                          ),
                        ),

                        SizedBox(width: 14.w),

                        /// Content (Title + Time, Message)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF222222),
                                        fontFamily: 'SFPro',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    item.timeText,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: const Color(0xFF9CA3AF),
                                      fontFamily: 'SFPro',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                item.message,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xFF6B7280),
                                  fontFamily: 'SFPro',
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String filePath) {
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
}
