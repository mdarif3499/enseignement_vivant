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
import 'controller/sign_in_controller.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());

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
                  ConstString.signIn.tr,
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
                  ConstString.greatToSeeYou.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: ConstColor.subtitleColor,
                    fontFamily: 'SFPro',
                  ),
                ),

                Gap(height: 24.h),

                /// Continue with Google Button
                CustomButton(
                  text: ConstString.continueWithGoogle.tr,
                  height: 50.h,
                  borderRadius: 28,
                  backgroundColor: Colors.white,
                  gradientColors: null,
                  textColor: const Color(0xFF2C2C2E),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  icon: Image.asset(
                    ConstIcons.googleIcon,
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                  ),
                  iconSize: 20,
                  onTap: controller.onGoogleSignIn,
                ),

                Gap(height: 12.h),

                /// Continue with Apple Button
                CustomButton(
                  text: ConstString.continueWithApple.tr,
                  height: 50.h,
                  borderRadius: 28,
                  backgroundColor: const Color(0xFF2C2C2E),
                  gradientColors: null,
                  textColor: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  icon: const Icon(
                    Icons.apple,
                    color: Colors.white,
                    size: 22,
                  ),
                  iconSize: 22,
                  onTap: controller.onAppleSignIn,
                ),

                Gap(height: 20.h),

                /// Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.black.withAlpha(20)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        ConstString.orSignUpManually.tr,
                        style: TextStyle(
                          color: const Color(0xFF8E8E93),
                          fontSize: 12.sp,
                          fontFamily: 'SFPro',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.black.withAlpha(20)),
                    ),
                  ],
                ),

                Gap(height: 20.h),

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
                  textInputAction: TextInputAction.next,
                  prefixIcon: Image.asset(
                    ConstIcons.emailIcon,
                    width: 20.sp,
                    height: 20.sp,
                    fit: BoxFit.contain,
                  ),
                ),

                Gap(height: 16.h),

                /// Password Label
                Text(
                  ConstString.password.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF48484A),
                    fontFamily: 'SFPro',
                  ),
                ),
                Gap(height: 6.h),

                /// Password Field
                Obx(
                  () => CustomTextField(
                    controller: controller.passwordController,
                    hintText: "•••••••••",
                    isPassWord: true,
                    borderRadius: 28,
                    fillColor: const Color(0xFFEFEFF4),
                    obscureText: controller.obscurePassword.value,
                    textInputAction: TextInputAction.done,
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

                Gap(height: 10.h),

                /// Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: controller.onForgotPassword,
                    child: Text(
                      ConstString.forgotPassword.tr,
                      style: TextStyle(
                        color: ConstColor.primaryTeal,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SFPro',
                      ),
                    ),
                  ),
                ),

                Gap(height: 24.h),

                /// Sign In Button
                Obx(
                  () => CustomButton(
                    text: ConstString.signIn.tr,
                    height: 50.h,
                    borderRadius: 28,
                    backgroundColor: ConstColor.primaryTeal,
                    gradientColors: null,
                    textColor: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    isLoading: controller.isLoading.value,
                    onTap: controller.isLoading.value ? null : controller.onSignIn,
                  ),
                ),

                Gap(height: 24.h),

                /// Bottom Link
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${ConstString.dontHaveAccount.tr} ",
                        style: TextStyle(
                          color: const Color(0xFF7A7A7A),
                          fontSize: 13.sp,
                          fontFamily: 'SFPro',
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.onCreateAccount,
                        child: Text(
                          ConstString.signUp.tr,
                          style: TextStyle(
                            color: ConstColor.primaryTeal,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SFPro',
                          ),
                        ),
                      ),
                    ],
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
