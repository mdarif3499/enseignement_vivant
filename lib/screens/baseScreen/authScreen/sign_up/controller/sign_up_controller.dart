import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/model/app_user_data.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/services/storage_services/get_storage_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> onCreateAccount() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      final userEmail = emailController.text.trim();
      final body = {
        "name": nameController.text.trim(),
        "email": userEmail,
        "password": passwordController.text.trim(),
      };

      final response = await ApiServices.instance.postServices(
        url: AppApiEndPoint.instance.userSignUp,
        body: body,
      );

      if (isClosed) return;

      if (response != null) {
        final statusCode = response['statusCode'];
        final suggestRoute = response['suggestRoute']?.toString();
        final message = response['message']?.toString() ?? '';
        final isSuccess = response['success'] == true &&
            (statusCode == null || statusCode == 200 || statusCode == 201);
        final isUnverified =
            suggestRoute != null || message.toLowerCase().contains('verify');

        if (isUnverified) {
          final targetEmail = response['email']?.toString() ?? userEmail;
          AppSnackBar.instance.success(message.isNotEmpty
              ? message
              : "Please check your email for verification code.");
          Get.toNamed(AppRoutes.forgotVerifyOtpScreen, arguments: {
            "email": targetEmail,
            "isForgotPassword": false,
          });
        } else if (isSuccess) {
          AppSnackBar.instance.success(
              message.isNotEmpty ? message : 'User created successfully');

          if (response['data'] != null) {
            final userData = AppUserModel.fromJson(response['data']);
            if (userData.name != null && userData.email != null) {
              await StorageServices.instance.saveUserProfile(
                name: userData.name!,
                email: userData.email!,
                image: userData.profileImage ?? '',
                city: '',
              );
            }
          }

          if (isClosed) return;

          Get.offAllNamed(AppRoutes.signInScreen);
        } else {
          AppSnackBar.instance
              .error(message.isNotEmpty ? message : "Registration failed.");
        }
      } else {
        AppSnackBar.instance.error("Registration failed. Please try again.");
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('SignUp error', e);
      AppSnackBar.instance.error("Something went wrong. Please try again.");
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  void onSignIn() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
