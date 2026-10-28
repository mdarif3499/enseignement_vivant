import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/constant/app_assert_image.dart';
import 'package:enseignement_vivant/constant/app_assert_icons.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'package:enseignement_vivant/widgers/custom_text_Field/customtextfield.dart';
import 'package:enseignement_vivant/widgers/custombutton/custombutton.dart';
import 'controller/forgotPasswordController.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();

    return Scaffold(
      backgroundColor: ConstColor.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: ConstColor.titleColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap(height: 10.h),

                /// Logo
                Center(
                  child: Image.asset(
                    ImageString.logoImg,
                    width: 180.w,
                    height: 90.h,
                    fit: BoxFit.contain,
                  ),
                ),

                Gap(height: 16.h),

                /// Title
                Text(
                  ConstString.forgotPasswordTitle.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: ConstColor.titleColor,
                    fontFamily: 'SFPro',
                  ),
                ),

                Gap(height: 6.h),

                /// Subtitle
                Text(
                  ConstString.forgotPasswordSubtitle.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: ConstColor.subtitleColor,
                    fontFamily: 'SFPro',
                  ),
                ),

                Gap(height: 28.h),

                /// Email Label
                Text(
                  ConstString.email.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF48484A),
                    fontFamily: 'SFPro',
                  ),
                ),
                Gap(height: 6.h),

                /// Email Field
                CustomTextField(
                  controller: controller.emailController,
                  hintText: ConstString.emailAddress.tr,
                  isEmail: true,
                  borderRadius: 28,
                  fillColor: const Color(0xFFEFEFF4),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Image.asset(
                    ConstIcons.emailIcon,
                    width: 20.sp,
                    height: 20.sp,
                    fit: BoxFit.contain,
                  ),
                ),

                Gap(height: 28.h),

                /// Request OTP Button
                Obx(
                  () => CustomButton(
                    text: ConstString.requestOtp.tr,
                    height: 50.h,
                    borderRadius: 28,
                    backgroundColor: ConstColor.primaryTeal,
                    gradientColors: null,
                    textColor: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    isLoading: controller.isLoading.value,
                    onTap: controller.isLoading.value
                        ? null
                        : controller.onRequestOtp,
                  ),
                ),

                Gap(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
