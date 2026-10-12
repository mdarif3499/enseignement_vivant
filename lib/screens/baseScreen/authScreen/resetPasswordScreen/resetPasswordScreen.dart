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
import 'controller/resetPasswordController.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController());

    return Scaffold(
      backgroundColor: ConstColor.primaryBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap(height: 16.h),

                /// Logo
                Center(
                  child: Image.asset(
                    ImageString.logoImg,
                    width: 180.w,
                    height: 90.h,
                    fit: BoxFit.contain,
                  ),
                ),

                Gap(height: 12.h),

                /// Title
                Text(
                  ConstString.setNewPassword.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: ConstColor.titleColor,
                    fontFamily: 'SFPro',
                  ),
                ),

                Gap(height: 4.h),

                /// Subtitle
                Text(
                  ConstString.chooseNewPasswordDesc.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: ConstColor.subtitleColor,
                    fontFamily: 'SFPro',
                  ),
                ),

                Gap(height: 24.h),

                /// New Password Label
                Text(
                  ConstString.newPassword.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF48484A),
                    fontFamily: 'SFPro',
                  ),
                ),
                Gap(height: 6.h),

                /// New Password Field
                Obx(
                  () => CustomTextField(
                    controller: controller.passwordController,
                    hintText: "•••••••••",
                    isPassWord: true,
                    borderRadius: 28,
                    fillColor: const Color(0xFFEFEFF4),
                    obscureText: controller.obscurePassword.value,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Image.asset(
                      ConstIcons.passwordIcon,
                      width: 20.sp,
                      height: 20.sp,
                      fit: BoxFit.contain,
                    ),
                    suffixIcon: Icon(
                      controller.obscurePassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF8E8E93),
                      size: 20.sp,
                    ),
                    onSuffixTap: controller.togglePasswordVisibility,
                  ),
                ),

                Gap(height: 16.h),

                /// Confirm New Password Label
                Text(
                  ConstString.confirmNewPassword.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF48484A),
                    fontFamily: 'SFPro',
                  ),
                ),
                Gap(height: 6.h),

                /// Confirm New Password Field
                Obx(
                  () => CustomTextField(
                    controller: controller.confirmPasswordController,
                    hintText: "•••••••••",
                    isPassWord: true,
                    isPassWordSecondValidation: true,
                    isPassWordSecondValidationController: controller.passwordController,
                    borderRadius: 28,
                    fillColor: const Color(0xFFEFEFF4),
                    obscureText: controller.obscureConfirmPassword.value,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Image.asset(
                      ConstIcons.passwordIcon,
                      width: 20.sp,
                      height: 20.sp,
                      fit: BoxFit.contain,
                    ),
                    suffixIcon: Icon(
                      controller.obscureConfirmPassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF8E8E93),
                      size: 20.sp,
                    ),
                    onSuffixTap: controller.toggleConfirmPasswordVisibility,
                  ),
                ),

                Gap(height: 28.h),

                /// Continue Button
                Obx(
                  () => CustomButton(
                    text: ConstString.continueText.tr,
                    height: 50.h,
                    borderRadius: 28,
                    backgroundColor: ConstColor.primaryTeal,
                    gradientColors: null,
                    textColor: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    isLoading: controller.isLoading.value,
                    onTap: controller.isLoading.value ? null : controller.onResetPassword,
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
