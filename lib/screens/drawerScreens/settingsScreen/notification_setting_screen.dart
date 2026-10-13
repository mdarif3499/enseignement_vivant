import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/notification_setting_controller.dart';

class NotificationSettingScreen extends StatelessWidget {
  const NotificationSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationSettingController());

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
          ConstString.notificationSetting.tr,
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
              /// General Notification Row
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ConstString.generalNotification.tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF222222),
                          fontFamily: 'SFPro',
                        ),
                      ),
                      Switch(
                        value: controller.generalNotification.value,
                        activeColor: Colors.white,
                        activeTrackColor: ConstColor.primaryTeal,
                        inactiveTrackColor: const Color(0xFFE5E7EB),
                        onChanged: controller.toggleGeneral,
                      ),
                    ],
                  )),

              Gap(height: 12.h),

              /// Sound Row
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ConstString.sound.tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF222222),
                          fontFamily: 'SFPro',
                        ),
                      ),
                      Switch(
                        value: controller.sound.value,
                        activeColor: Colors.white,
                        activeTrackColor: ConstColor.primaryTeal,
                        inactiveTrackColor: const Color(0xFFE5E7EB),
                        onChanged: controller.toggleSound,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
