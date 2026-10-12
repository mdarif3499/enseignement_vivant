import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';

class ForgotVerifyOtpController extends GetxController {
  static const int otpLength = 6;
  static const int resendDurationInSeconds = 15;

  late final String email;

  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();

  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;

  final RxInt remainingSeconds = resendDurationInSeconds.obs;
  Timer? _resendTimer;

  bool get canResend => remainingSeconds.value <= 0;

  String get formattedTimer {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onInit() {
    super.onInit();
    email = (Get.arguments is String && (Get.arguments as String).isNotEmpty)
        ? Get.arguments as String
        : 'example.email@gmail.com';
    startResendTimer();
  }

  void startResendTimer() {
    remainingSeconds.value = resendDurationInSeconds;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value <= 0) {
        timer.cancel();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  String get otpCode => otpController.text.trim();

  Future<void> onVerifyCode() async {
    if (otpCode.length < otpLength) {
      AppSnackBar.instance.error('Please enter the full 6-digit code');
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1500));
    isLoading.value = false;

    Get.toNamed(AppRoutes.resetPasswordScreen, arguments: {
      "email": email,
      "otp": otpCode,
    });
  }

  Future<void> onResendCode() async {
    if (!canResend || isResending.value) return;

    isResending.value = true;
    await Future.delayed(const Duration(milliseconds: 1000));
    isResending.value = false;

    AppSnackBar.instance.success("OTP Resent!");
    otpController.clear();
    startResendTimer();
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    otpController.dispose();
    otpFocusNode.dispose();
    super.onClose();
  }
}
