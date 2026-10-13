import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';

class HelpSupportController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void submitIssue() {
    if (titleController.text.trim().isEmpty) {
      AppSnackBar.instance.error("Please enter issue title");
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      AppSnackBar.instance.error("Please enter description");
      return;
    }

    AppSnackBar.instance.success("Issue submitted successfully!");
    titleController.clear();
    descriptionController.clear();
    Get.back();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
