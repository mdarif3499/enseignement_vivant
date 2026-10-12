import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';

class AppSnackBar {
  AppSnackBar._privateConstructor();
  static final AppSnackBar _instance = AppSnackBar._privateConstructor();
  static AppSnackBar get instance => _instance;

  void error(String message) {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFFF4444).withAlpha(200),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  void success(String message) {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: ConstColor.appColor.withAlpha(200),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }
}
