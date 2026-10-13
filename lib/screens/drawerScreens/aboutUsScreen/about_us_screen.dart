import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/utils/gap.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
          ConstString.aboutUs.tr,
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
                "About Enseignement Vivant",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222222),
                  fontFamily: 'SFPro',
                ),
              ),
              Gap(height: 10.h),
              Text(
                "Enseignement Vivant is a spiritual mobile application designed to bring daily prayers, audio teachings, inspiring encouragement messages, and scripture verses straight to your hands.",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF555555),
                  fontFamily: 'SFPro',
                  height: 1.6,
                ),
              ),
              Gap(height: 16.h),
              Text(
                "Our Mission",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222222),
                  fontFamily: 'SFPro',
                ),
              ),
              Gap(height: 6.h),
              Text(
                "To empower believers worldwide through accessible media, daily spiritual reflections, and multi-language support in French and English.",
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
