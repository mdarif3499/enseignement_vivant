import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/services/storage_services/get_storage_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';
import 'package:enseignement_vivant/widgers/custom_text_Field/customtextfield.dart';

class DeleteAccountController extends GetxController {
  final TextEditingController passwordController = TextEditingController();
  final RxBool isObscure = true.obs;
  final RxBool isLoading = false.obs;

  void toggleObscure() => isObscure.value = !isObscure.value;

  void showPasswordDialog() {
    passwordController.clear();
    isObscure.value = true;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Confirm Account Deletion",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF222222),
                      fontFamily: 'SFPro',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.close_rounded, color: const Color(0xFF8E8E93), size: 22.sp),
                  ),
                ],
              ),
              Gap(height: 10.h),
              Text(
                "Please enter your password to confirm account deletion.",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF6B7280),
                  fontFamily: 'SFPro',
                  height: 1.4,
                ),
              ),
              Gap(height: 16.h),
              Obx(
                () => CustomTextField(
                  hintText: "Enter password",
                  controller: passwordController,
                  obscureText: isObscure.value,
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF8E8E93)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscure.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF8E8E93),
                    ),
                    onPressed: toggleObscure,
                  ),
                ),
              ),
              Gap(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF6B7280),
                          fontFamily: 'SFPro',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4D4D),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: isLoading.value ? null : performAccountDelete,
                        child: isLoading.value
                            ? SizedBox(
                                width: 18.w,
                                height: 18.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Delete",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'SFPro',
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Future<void> performAccountDelete() async {
    final password = passwordController.text.trim();
    if (password.isEmpty) {
      AppSnackBar.instance.error("Please enter your password");
      return;
    }

    isLoading.value = true;
    try {
      final token = StorageServices.instance.getToken();
      final body = {
        "password": password,
      };

      final options = Options(
        headers: {
          if (token.isNotEmpty) "Authorization": "Bearer $token",
        },
      );

      final response = await ApiServices.instance.deleteServices(
        url: AppApiEndPoint.instance.deleteAccount,
        body: body,
        options: options,
      );

      if (isClosed) return;

      if (response != null && (response['success'] == true || response['statusCode'] == 200)) {
        Get.back(); // close popup
        await StorageServices.instance.storageClear();
        AppSnackBar.instance.success(
          response['message']?.toString() ?? "Account deleted successfully!",
        );
        Get.offAllNamed(AppRoutes.signInScreen);
      } else if (response != null && response['message'] != null) {
        AppSnackBar.instance.error(response['message'].toString());
      } else {
        AppSnackBar.instance.error("Failed to delete account. Please try again.");
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('Delete Account API Error', e);
      AppSnackBar.instance.error("Something went wrong. Please try again.");
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }
}
