import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/widgers/custombutton/custombutton.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/delete_account_controller.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DeleteAccountController());

    final defaultPinTheme = PinTheme(
      width: 62.w,
      height: 52.h,
      textStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: ConstColor.primaryTeal,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: ConstColor.primaryTeal, width: 1.5),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Colors.white,
        border: Border.all(color: ConstColor.primaryTeal, width: 1.5),
      ),
    );

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
          ConstString.accountDelete.tr,
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
              /// Description Paragraph 1
              Text(
                ConstString.deleteAccountDesc1.tr,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF555555),
                  fontFamily: 'SFPro',
                  height: 1.5,
                ),
              ),

              Gap(height: 14.h),

              /// Description Paragraph 2 with bold email
              RichText(
                text: TextSpan(
                  text: ConstString.deleteAccountDesc2.tr,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF555555),
                    fontFamily: 'SFPro',
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: "ha***12@gmail.com",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF222222),
                      ),
                    ),
                  ],
                ),
              ),

              Gap(height: 24.h),

              /// Verification Code Header
              Text(
                ConstString.enterVerificationCode.tr,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF222222),
                  fontFamily: 'SFPro',
                ),
              ),

              Gap(height: 12.h),

              /// Pinput OTP Field
              Center(
                child: Pinput(
                  length: 4,
                  controller: controller.otpController,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  onChanged: (val) {
                    controller.otpCode.value = val;
                  },
                ),
              ),

              const Spacer(),

              /// Save Changes / Confirm Delete Button
              CustomButton(
                text: ConstString.saveChanges.tr,
                backgroundColor: ConstColor.primaryTeal,
                onTap: controller.confirmDeleteAccount,
              ),

              Gap(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
