import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/widgers/custom_text_Field/customtextfield.dart';
import 'package:enseignement_vivant/widgers/custombutton/custombutton.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

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
          ConstString.changePassword.tr,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Current Password
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ConstString.currentPassword.tr,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF222222),
                        fontFamily: 'SFPro',
                      ),
                    ),
                    Gap(height: 6.h),
                    CustomTextField(
                      hintText: "••••••••••••",
                      controller: controller.currentPasswordController,
                      obscureText: controller.isCurrentObscure.value,
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF8E8E93)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isCurrentObscure.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF8E8E93),
                        ),
                        onPressed: controller.toggleCurrentObscure,
                      ),
                    ),
                  ],
                ),
              ),

              Gap(height: 16.h),

              /// New Password
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ConstString.newPassword.tr,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF222222),
                        fontFamily: 'SFPro',
                      ),
                    ),
                    Gap(height: 6.h),
                    CustomTextField(
                      hintText: "••••••••••••",
                      controller: controller.newPasswordController,
                      obscureText: controller.isNewObscure.value,
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF8E8E93)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isNewObscure.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF8E8E93),
                        ),
                        onPressed: controller.toggleNewObscure,
                      ),
                    ),
                  ],
                ),
              ),

              Gap(height: 16.h),

              /// Confirm New Password
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ConstString.confirmNewPassword.tr,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF222222),
                        fontFamily: 'SFPro',
                      ),
                    ),
                    Gap(height: 6.h),
                    CustomTextField(
                      hintText: "••••••••••••",
                      controller: controller.confirmPasswordController,
                      obscureText: controller.isConfirmObscure.value,
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF8E8E93)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmObscure.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF8E8E93),
                        ),
                        onPressed: controller.toggleConfirmObscure,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// Save Changes Button
              CustomButton(
                text: ConstString.saveChanges.tr,
                backgroundColor: ConstColor.primaryTeal,
                onTap: controller.changePassword,
              ),

              Gap(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
