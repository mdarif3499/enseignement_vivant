import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/services/storage_services/get_storage_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';

class ChangePasswordController extends GetxController {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final RxBool isCurrentObscure = true.obs;
  final RxBool isNewObscure = true.obs;
  final RxBool isConfirmObscure = true.obs;
  final RxBool isLoading = false.obs;

  void toggleCurrentObscure() => isCurrentObscure.value = !isCurrentObscure.value;
  void toggleNewObscure() => isNewObscure.value = !isNewObscure.value;
  void toggleConfirmObscure() => isConfirmObscure.value = !isConfirmObscure.value;

  Future<void> changePassword() async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty) {
      AppSnackBar.instance.error("Please enter current password");
      return;
    }
    if (newPassword.isEmpty) {
      AppSnackBar.instance.error("Please enter new password");
      return;
    }
    if (newPassword.length < 6) {
      AppSnackBar.instance.error("Password must be at least 6 characters");
      return;
    }
    if (newPassword != confirmPassword) {
      AppSnackBar.instance.error("New password and confirm password do not match");
      return;
    }

    isLoading.value = true;
    try {
      final body = {
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
        "currentPassword": currentPassword,
      };

      final token = StorageServices.instance.getToken();
      final options = Options(
        headers: {
          if (token.isNotEmpty) "Authorization": "Bearer $token",
        },
      );

      final response = await ApiServices.instance.postServices(
        url: AppApiEndPoint.instance.changePassword,
        body: body,
        options: options,
      );

      if (isClosed) return;

      if (response != null && (response['success'] == true || response['statusCode'] == 200)) {
        AppSnackBar.instance.success(
          response['message']?.toString() ?? "Password changed successfully!",
        );
        Get.back();
      } else if (response != null && response['message'] != null) {
        AppSnackBar.instance.error(response['message'].toString());
      } else {
        AppSnackBar.instance.error("Failed to change password. Please try again.");
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('Change Password API Error', e);
      AppSnackBar.instance.error("Something went wrong. Please try again.");
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
