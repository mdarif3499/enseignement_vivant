import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final RxBool isLoading = false.obs;

  Future<void> onRequestOtp() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1500));
    isLoading.value = false;

    final String email = emailController.text.trim().isNotEmpty
        ? emailController.text.trim()
        : 'example.email@gmail.com';

    Get.toNamed(AppRoutes.forgotVerifyOtpScreen, arguments: email);
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
