import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> onSignIn() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1500));
    isLoading.value = false;

    Get.offAllNamed(AppRoutes.mainScreen);
  }

  void onForgotPassword() {
    Get.toNamed(AppRoutes.forgotPasswordScreen);
  }

  void onGoogleSignIn() {
    // Design mode
  }

  void onAppleSignIn() {
    // Design mode
  }

  void onCreateAccount() {
    Get.toNamed(AppRoutes.signUpScreen);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
