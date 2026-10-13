import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';
import 'profile_controller.dart';

class EditProfileController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController countryController;
  late TextEditingController phoneController;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: profileController.name.value);
    emailController = TextEditingController(text: profileController.email.value);
    countryController = TextEditingController(text: profileController.country.value);
    phoneController = TextEditingController(text: profileController.phone.value);
  }

  void saveProfile() {
    profileController.name.value = nameController.text.trim();
    profileController.email.value = emailController.text.trim();
    profileController.country.value = countryController.text.trim();
    profileController.phone.value = phoneController.text.trim();

    AppSnackBar.instance.success("Profile updated successfully!");
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    countryController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
