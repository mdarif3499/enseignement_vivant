import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());

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
          ConstString.settings.tr,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: ConstColor.titleColor,
            fontFamily: 'SFPro',
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            children: [
              /// Change Password Row
              _settingsOptionTile(
                iconData: Icons.lock_outline_rounded,
                title: ConstString.changePassword.tr,
                onTap: () {
                  Get.toNamed(AppRoutes.changePasswordScreen);
                },
              ),

              Gap(height: 16.h),

              /// Notification Row
              _settingsOptionTile(
                iconData: Icons.notifications_none_rounded,
                title: ConstString.notification.tr,
                onTap: () {
                  Get.toNamed(AppRoutes.notificationSettingScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsOptionTile({
    required IconData iconData,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.h,
              decoration: const BoxDecoration(
                color: Color(0xFFE6F6F4),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  iconData,
                  color: ConstColor.primaryTeal,
                  size: 20.sp,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222222),
                  fontFamily: 'SFPro',
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: const Color(0xFF8E8E93),
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }
}
