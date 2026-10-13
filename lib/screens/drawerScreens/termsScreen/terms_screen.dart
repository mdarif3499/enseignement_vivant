import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/utils/gap.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
          ConstString.termsAndConditions.tr,
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
                "Welcome to Enseignement Vivant",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222222),
                  fontFamily: 'SFPro',
                ),
              ),
              Gap(height: 10.h),
              Text(
                "By downloading, accessing, or using the Enseignement Vivant mobile application, you agree to be bound by these Terms and Conditions. Please read them carefully before using our services.",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF555555),
                  fontFamily: 'SFPro',
                  height: 1.6,
                ),
              ),
              Gap(height: 16.h),
              Text(
                "1. Acceptance of Terms",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222222),
                  fontFamily: 'SFPro',
                ),
              ),
              Gap(height: 6.h),
              Text(
                "These terms constitute a legally binding agreement between you and Enseignement Vivant. If you do not agree to these terms, you must not use the application.",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF555555),
                  fontFamily: 'SFPro',
                  height: 1.6,
                ),
              ),
              Gap(height: 16.h),
              Text(
                "2. User Accounts and Responsibilities",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222222),
                  fontFamily: 'SFPro',
                ),
              ),
              Gap(height: 6.h),
              Text(
                "You are responsible for maintaining the confidentiality of your account credentials and for all activities conducted through your account.",
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
