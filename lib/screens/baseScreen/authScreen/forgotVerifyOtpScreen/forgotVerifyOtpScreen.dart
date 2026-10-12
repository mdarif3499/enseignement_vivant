import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/constant/app_assert_image.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'package:enseignement_vivant/widgers/custombutton/custombutton.dart';
import 'controller/forgotVerifyOtpController.dart';

class ForgotVerifyOtpScreen extends StatelessWidget {
  const ForgotVerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotVerifyOtpController());

    final defaultPinTheme = PinTheme(
      width: 46.w,
      height: 52.h,
      textStyle: TextStyle(
        color: const Color(0xFF222222),
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'SFPro',
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      textStyle: TextStyle(
        color: ConstColor.primaryTeal,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'SFPro',
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ConstColor.primaryTeal, width: 1.5),
      ),
    );

    return Scaffold(
      backgroundColor: ConstColor.primaryBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                ConstString.verification.tr,
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
                "${ConstString.enterCodeSentTo.tr} ${controller.email}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: ConstColor.subtitleColor,
                  fontFamily: 'SFPro',
                ),
              ),

              Gap(height: 24.h),

              /// Enter OTP Label
              Text(
                ConstString.enterOtp.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF48484A),
                  fontFamily: 'SFPro',
                ),
              ),

              Gap(height: 8.h),

              /// Pinput Code Fields
              Center(
                child: Pinput(
                  length: ForgotVerifyOtpController.otpLength,
                  controller: controller.otpController,
                  focusNode: controller.otpFocusNode,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: focusedPinTheme,
                  separatorBuilder: (index) => SizedBox(width: 8.w),
                  showCursor: true,
                  cursor: Container(
                    width: 2,
                    height: 20.h,
                    color: ConstColor.primaryTeal,
                  ),
                  keyboardType: TextInputType.number,
                  onCompleted: (_) => controller.otpFocusNode.unfocus(),
                ),
              ),

              Gap(height: 20.h),

              /// Resend timer
              Obx(
                () => Row(
                  children: [
                    Text(
                      controller.canResend
                          ? ""
                          : "${ConstString.resendCodeIn.tr} ",
                      style: TextStyle(
                        color: const Color(0xFF48484A),
                        fontSize: 13.sp,
                        fontFamily: 'SFPro',
                      ),
                    ),
                    if (controller.canResend)
                      GestureDetector(
                        onTap: controller.isResending.value
                            ? null
                            : controller.onResendCode,
                        child: Text(
                          ConstString.resendCode.tr,
                          style: TextStyle(
                            color: ConstColor.primaryTeal,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SFPro',
                          ),
                        ),
                      )
                    else
                      Text(
                        controller.formattedTimer,
                        style: TextStyle(
                          color: const Color(0xFF222222),
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          fontFamily: 'SFPro',
                        ),
                      ),
                  ],
                ),
              ),

              Gap(height: 28.h),

              /// Verify Button
              Obx(
                () => CustomButton(
                  text: ConstString.verify.tr,
                  height: 50.h,
                  borderRadius: 28,
                  backgroundColor: ConstColor.primaryTeal,
                  gradientColors: null,
                  textColor: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  isLoading: controller.isLoading.value,
                  onTap: controller.isLoading.value ? null : controller.onVerifyCode,
                ),
              ),

              Gap(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
