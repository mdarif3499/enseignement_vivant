import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/widgers/custom_text_Field/customtextfield.dart';
import 'package:enseignement_vivant/widgers/custombutton/custombutton.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/help_support_controller.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HelpSupportController());

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
          ConstString.helpAndSupport.tr,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: ConstColor.titleColor,
            fontFamily: 'SFPro',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ConstString.helpSubtitle.tr,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF6B7280),
                  fontFamily: 'SFPro',
                  height: 1.4,
                ),
              ),

              Gap(height: 20.h),

              /// Issue Title Field
              Text(
                "Title",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF222222),
                  fontFamily: 'SFPro',
                ),
              ),
              Gap(height: 6.h),
              CustomTextField(
                hintText: ConstString.issueTitle.tr,
                controller: controller.titleController,
              ),

              Gap(height: 16.h),

              /// Description Field
              Text(
                "Description",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF222222),
                  fontFamily: 'SFPro',
                ),
              ),
              Gap(height: 6.h),
              CustomTextField(
                hintText: ConstString.writeHere.tr,
                controller: controller.descriptionController,
                maxLines: 6,
                minLines: 5,
                contentPadding: EdgeInsets.all(16.r),
              ),

              Gap(height: 40.h),

              /// Submit Button
              CustomButton(
                text: ConstString.submit.tr,
                backgroundColor: ConstColor.primaryTeal,
                onTap: controller.submitIssue,
              ),

              Gap(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
