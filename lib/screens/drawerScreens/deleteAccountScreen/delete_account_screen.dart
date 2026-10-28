import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/services/storage_services/get_storage_services.dart';
import 'package:enseignement_vivant/widgers/custombutton/custombutton.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/delete_account_controller.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DeleteAccountController());

    final userEmail = StorageServices.instance.getUserEmail().isNotEmpty
        ? StorageServices.instance.getUserEmail()
        : "";

    return Scaffold(
      backgroundColor: ConstColor.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: ConstColor.titleColor, size: 30),
          onPressed: () => Get.back(),
        ),
        title: Text(
          ConstString.accountDelete.tr,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: ConstColor.titleColor,
            fontFamily: 'SFPro',
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Description Paragraph 1
              Text(
                ConstString.deleteAccountDesc1.tr,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF555555),
                  fontFamily: 'SFPro',
                  height: 1.5,
                ),
              ),

              Gap(height: 14.h),

              /// Description Paragraph 2
              RichText(
                text: TextSpan(
                  text: "${ConstString.deleteAccountDesc2.tr} ",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF555555),
                    fontFamily: 'SFPro',
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: userEmail.isNotEmpty ? userEmail : "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF222222),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// Confirm Delete Button
              CustomButton(
                text: ConstString.accountDelete.tr,
                backgroundColor: const Color(0xFFFF4D4D),
                onTap: controller.showPasswordDialog,
              ),

              Gap(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
