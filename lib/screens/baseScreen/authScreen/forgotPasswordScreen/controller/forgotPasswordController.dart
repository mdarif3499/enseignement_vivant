import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final RxBool isLoading = false.obs;

  Future<void> onRequestOtp() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      final email = emailController.text.trim();
      final body = {"email": email};

      final response = await ApiServices.instance.postServices(
        url: AppApiEndPoint.instance.authForgotPassword,
        body: body,
      );

      if (isClosed) return;

      if (response != null && response['success'] == true) {
        AppSnackBar.instance
            .success(response['message'] ?? "OTP sent to your email!");
        Get.toNamed(AppRoutes.forgotVerifyOtpScreen, arguments: {
          "email": email,
          "isForgotPassword": true,
        });
      } else if (response != null && response['message'] != null) {
        AppSnackBar.instance.error(response['message']);
      } else {
        AppSnackBar.instance.error("Failed to request OTP. Try again.");
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('Forgot Password Error', e);
      AppSnackBar.instance.error("Something went wrong. Please try again.");
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
