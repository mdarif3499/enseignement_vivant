import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/utils/gap.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          ConstString.privacyPolicy.tr,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: ConstColor.titleColor,
            fontFamily: 'SFPro',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Privacy Policy Notice",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222222),
                  fontFamily: 'SFPro',
                ),
              ),
              Gap(height: 10.h),
              Text(
                "At Enseignement Vivant, we respect your privacy and are committed to protecting your personal data. This privacy policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF555555),
                  fontFamily: 'SFPro',
                  height: 1.6,
                ),
              ),
              Gap(height: 16.h),
              Text(
                "1. Information We Collect",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222222),
                  fontFamily: 'SFPro',
                ),
              ),
              Gap(height: 6.h),
              Text(
                "We may collect personal information such as your name, email address, language preferences, and usage analytics to provide a tailored spiritual experience.",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF555555),
                  fontFamily: 'SFPro',
                  height: 1.6,
                ),
              ),
              Gap(height: 16.h),
              Text(
                "2. How We Use Your Information",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222222),
                  fontFamily: 'SFPro',
                ),
              ),
              Gap(height: 6.h),
              Text(
                "Your information is used strictly to deliver prayers, audio content, personalized notifications, and continuous improvements to our services.",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF555555),
                  fontFamily: 'SFPro',
                  height: 1.6,
                ),
              ),
              Gap(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
