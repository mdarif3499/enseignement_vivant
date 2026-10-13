import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/services/storage_services/get_storage_services.dart';
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';

class DeleteAccountController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final RxString otpCode = ''.obs;

  Future<void> confirmDeleteAccount() async {
    if (otpCode.value.length < 4) {
      AppSnackBar.instance.error("Please enter the verification code");
      return;
    }

    await StorageServices.instance.storageClear();
    AppSnackBar.instance.success("Account deleted successfully!");
    Get.offAllNamed(AppRoutes.signInScreen);
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
