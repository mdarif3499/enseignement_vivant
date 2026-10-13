import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';

class ChangePasswordController extends GetxController {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final RxBool isCurrentObscure = true.obs;
  final RxBool isNewObscure = true.obs;
  final RxBool isConfirmObscure = true.obs;

  void toggleCurrentObscure() => isCurrentObscure.value = !isCurrentObscure.value;
  void toggleNewObscure() => isNewObscure.value = !isNewObscure.value;
  void toggleConfirmObscure() => isConfirmObscure.value = !isConfirmObscure.value;

  void changePassword() {
    if (currentPasswordController.text.trim().isEmpty) {
      AppSnackBar.instance.error("Please enter current password");
      return;
    }
    if (newPasswordController.text.trim().isEmpty) {
      AppSnackBar.instance.error("Please enter new password");
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      AppSnackBar.instance.error("Passwords do not match");
      return;
    }

    AppSnackBar.instance.success("Password changed successfully!");
    Get.back();
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
