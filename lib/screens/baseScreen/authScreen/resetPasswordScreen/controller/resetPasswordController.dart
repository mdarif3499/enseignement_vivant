import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';

class ResetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxBool isLoading = false.obs;

  late String email;
  late String otp;

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic>? args = Get.arguments;
    email = args?['email'] ?? '';
    otp = args?['otp'] ?? '';
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  Future<void> onResetPassword() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1500));
    isLoading.value = false;

    Get.offAllNamed(AppRoutes.signInScreen);
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
