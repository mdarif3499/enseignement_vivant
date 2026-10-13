import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/services/storage_services/get_storage_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';

class ResetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxBool isLoading = false.obs;

  late String email;
  late String otp;
  late String token;

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic>? args = Get.arguments;
    email = args?['email'] ?? '';
    otp = args?['otp'] ?? '';
    token = args?['token'] ?? StorageServices.instance.getToken();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  Future<void> onResetPassword(
    String password,
    String confirmPassword,
  ) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final newPassword = password.trim();
    final confirmedPassword = confirmPassword.trim();

    if (newPassword != confirmedPassword) {
      AppSnackBar.instance.error("Passwords do not match");
      return;
    }

    isLoading.value = true;
    try {
      final resetToken =
          token.isNotEmpty ? token : StorageServices.instance.getToken();

      final body = {
        "newPassword": newPassword,
        "confirmPassword": confirmedPassword,
      };

      final options = Options(
        headers: {
          if (resetToken.isNotEmpty) "Authorization": resetToken,
        },
      );

      final response = await ApiServices.instance.postServices(
        url: AppApiEndPoint.instance.authResetPassword,
        body: body,
        options: options,
      );

      if (isClosed) return;

      if (response != null && response['success'] == true) {
        await StorageServices.instance.storageClear();
        AppSnackBar.instance.success(response['message'] ??
            'Your password has been successfully reset.');
        Get.offAllNamed(AppRoutes.signInScreen);
      } else if (response != null && response['message'] != null) {
        AppSnackBar.instance.error(response['message']);
      } else {
        AppSnackBar.instance.error("Password reset failed. Please try again.");
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('Reset Password Error', e);
      AppSnackBar.instance.error("Something went wrong. Please try again.");
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }
}
