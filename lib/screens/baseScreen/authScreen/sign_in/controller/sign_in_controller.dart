import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/model/app_user_data.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/services/storage_services/get_storage_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> onSignIn(String email, String password) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      final userEmail = email.trim();
      final body = {
        "email": userEmail,
        "password": password.trim(),
      };

      final response = await ApiServices.instance.postServices(
        url: AppApiEndPoint.instance.login,
        body: body,
      );

      if (isClosed) return;

      if (response != null) {
        final suggestRoute = response['suggestRoute']?.toString();
        final message = response['message']?.toString() ?? '';
        final isSuccess = response['success'] == true &&
            !(suggestRoute != null || message.toLowerCase().contains('verify'));
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
              message.isNotEmpty ? message : 'User logged in successfully.');

          if (response['data'] != null) {
            final data = response['data'];
            String? token;

            if (data is Map<String, dynamic>) {
              token =
                  data['accessToken']?.toString() ?? data['token']?.toString();

              if (data['role'] != null) {
                await StorageServices.instance
                    .setUserRole(data['role'].toString());
              }

              final userMap = data['user'] is Map<String, dynamic>
                  ? data['user'] as Map<String, dynamic>
                  : null;
              if (userMap != null) {
                final userData = AppUserModel.fromJson(userMap);
                await StorageServices.instance.saveUserProfile(
                  name: userData.name ?? '',
                  email: userData.email ?? userEmail,
                  image: userData.profileImage ?? '',
                  city: '',
                );
              } else {
                await StorageServices.instance.saveUserProfile(
                  name: '',
                  email: userEmail,
                  image: '',
                  city: '',
                );
              }
            } else if (data is String) {
              token = data;
              await StorageServices.instance.saveUserProfile(
                name: '',
                email: userEmail,
                image: '',
                city: '',
              );
            }

            if (token != null && token.isNotEmpty) {
              await StorageServices.instance.setToken(token);
            }
          }

          if (isClosed) return;

          Get.offAllNamed(AppRoutes.mainScreen);
        } else {
          AppSnackBar.instance
              .error(message.isNotEmpty ? message : "Login failed.");
        }
      } else {
        AppSnackBar.instance
            .error("Login failed. Please check your credentials.");
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('SignIn error', e);
      AppSnackBar.instance.error("Something went wrong. Please try again.");
    } finally {
      if (!isClosed) isLoading.value = false;
    }
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
}
