import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';

import '../../../../../services/storage_services/get_storage_services.dart';

class ForgotVerifyOtpController extends GetxController {
  static const int otpLength = 6;
  static const int resendDurationInSeconds = 180; // 3 minutes timer

  late final String email;
  late final bool isForgotPassword;

  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();

  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;
  final RxBool isOtpComplete = false.obs;

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
    if (Get.arguments is Map) {
      email = Get.arguments['email']?.toString() ?? '';
      isForgotPassword = Get.arguments['isForgotPassword'] ?? true;
    } else if (Get.arguments is String &&
        (Get.arguments as String).isNotEmpty) {
      email = Get.arguments as String;
      isForgotPassword = true;
    } else {
      email = '';
      isForgotPassword = true;
    }

    otpController.addListener(_onOtpChanged);

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
    try {
      final body = {
        "email": email,
        "oneTimeCode": int.tryParse(otpCode) ?? otpCode,
      };

      final response = await ApiServices.instance.postServices(
        url: AppApiEndPoint.instance.authVerifyEmail,
        body: body,
      );

      if (isClosed) return;

      if (response != null && response['success'] == true) {
        AppSnackBar.instance
            .success(response['message'] ?? 'OTP verified successfully!');

        final resetToken =
            (response['data'] is String) ? response['data'].toString() : null;

        if (isClosed) return;

        if (isForgotPassword) {
          Get.toNamed(AppRoutes.resetPasswordScreen, arguments: {
            "email": email,
            "otp": otpCode,
            "token": resetToken ?? '',
          });
        } else {
          await StorageServices.instance.storageClear();
          Get.offAllNamed(AppRoutes.signInScreen);
        }
      } else if (response != null && response['message'] != null) {
        AppSnackBar.instance.error(response['message']);
      } else {
        AppSnackBar.instance
            .error("Verification failed. Please check your OTP code.");
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('OTP Verification Error', e);
      AppSnackBar.instance.error("Verification error. Please try again.");
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  Future<void> onResendCode() async {
    if (!canResend || isResending.value) return;

    isResending.value = true;
    try {
      final body = {
        "email": email,
      };

      final response = await ApiServices.instance.postServices(
        url: AppApiEndPoint.instance.userResendOtp,
        body: body,
      );

      if (isClosed) return;

      if (response != null &&
          (response['success'] == true || response['statusCode'] == 200)) {
        AppSnackBar.instance.success(response['message'] ?? "OTP Resent!");
        otpController.clear();
        startResendTimer();
      } else if (response != null && response['message'] != null) {
        AppSnackBar.instance.error(response['message']);
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('Resend OTP error', e);
      AppSnackBar.instance.error("Failed to resend code. Try again.");
    } finally {
      if (!isClosed) isResending.value = false;
    }
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    otpController.removeListener(_onOtpChanged);
    otpController.dispose();
    otpFocusNode.dispose();
    super.onClose();
  }

  void _onOtpChanged() {
    isOtpComplete.value = otpController.text.trim().length == otpLength;
  }
}
