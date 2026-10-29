import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/model/app_user_data.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/services/storage_services/get_storage_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';
import 'profile_controller.dart';

class EditProfileController extends GetxController {
  final ProfileController profileController = Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>()
      : Get.put(ProfileController());

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController countryController;
  late TextEditingController phoneController;

  final Rx<File?> selectedImageFile = Rx<File?>(null);
  final RxBool isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: profileController.name.value);
    emailController = TextEditingController(text: profileController.email.value);
    countryController = TextEditingController(text: profileController.country.value);
    phoneController = TextEditingController(text: profileController.phone.value);
  }

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        selectedImageFile.value = File(pickedFile.path);
      }
    } catch (e) {
      errorLog('Pick Image Error', e);
      AppSnackBar.instance.error("Failed to pick image");
    }
  }

  Future<void> saveProfile() async {
    final name = nameController.text.trim();
    final contact = phoneController.text.trim();
    final country = countryController.text.trim();

    isLoading.value = true;
    try {
      final Map<String, dynamic> formMap = {};

      if (name.isNotEmpty) formMap['name'] = name;
      if (contact.isNotEmpty) formMap['contact'] = contact;
      if (country.isNotEmpty) formMap['countryCode'] = country;

      if (selectedImageFile.value != null && selectedImageFile.value!.existsSync()) {
        formMap['image'] = await MultipartFile.fromFile(
          selectedImageFile.value!.path,
          filename: selectedImageFile.value!.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(formMap);

      final token = StorageServices.instance.getToken();
      final options = Options(
        headers: {
          if (token.isNotEmpty) "Authorization": "Bearer $token",
        },
      );

      final response = await ApiServices.instance.patchServices(
        url: AppApiEndPoint.instance.updateProfile,
        body: formData,
        options: options,
      );

      if (isClosed) return;

      if (response != null && (response['success'] == true || response['statusCode'] == 200)) {
        AppSnackBar.instance.success(
          response['message']?.toString() ?? "Profile updated successfully!",
        );

        if (response['data'] != null && response['data'] is Map<String, dynamic>) {
          final updatedUser = AppUserModel.fromJson(response['data'] as Map<String, dynamic>);
          profileController.name.value = (updatedUser.name != null && updatedUser.name!.isNotEmpty) ? updatedUser.name! : name;
          profileController.country.value = country;
          profileController.phone.value = contact;
          if (updatedUser.profileImage != null && updatedUser.profileImage!.isNotEmpty) {
            profileController.profileImage.value = updatedUser.profileImage!;
          }
        } else {
          profileController.name.value = name;
          profileController.country.value = country;
          profileController.phone.value = contact;
        }

        await StorageServices.instance.saveUserProfile(
          name: profileController.name.value,
          email: profileController.email.value,
          image: profileController.profileImage.value,
          city: '',
        );

        Get.back();
      } else if (response != null && response['message'] != null) {
        AppSnackBar.instance.error(response['message'].toString());
      } else {
        AppSnackBar.instance.error("Failed to update profile. Please try again.");
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('Update Profile API Error', e);
      AppSnackBar.instance.error("Something went wrong. Please try again.");
    } finally {
      if (!isClosed) isLoading.value = false;
    }
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
