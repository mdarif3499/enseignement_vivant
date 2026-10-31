import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/widgers/custom_text_Field/customtextfield.dart';
import 'package:enseignement_vivant/widgers/custombutton/custombutton.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

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
          ConstString.editProfile.tr,
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
              /// Profile Picture Picker Section
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: controller.pickImage,
                      child: Obx(() {
                        final pickedFile = controller.selectedImageFile.value;
                        final currentImgUrl = controller.profileController.profileImage.value;

                        return CircleAvatar(
                          radius: 45.r,
                          backgroundColor: ConstColor.primaryTeal.withAlpha(40),
                          backgroundImage: pickedFile != null
                              ? FileImage(pickedFile) as ImageProvider
                              : (currentImgUrl.isNotEmpty ? NetworkImage(currentImgUrl) : null),
                          child: (pickedFile == null && currentImgUrl.isEmpty)
                              ? Icon(Icons.person_rounded, color: ConstColor.primaryTeal, size: 48.sp)
                              : null,
                        );
                      }),
                    ),
                    Gap(height: 10.h),
                    GestureDetector(
                      onTap: controller.pickImage,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: ConstColor.primaryTeal,
                            size: 18.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            ConstString.changeProfilePicture.tr,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: ConstColor.primaryTeal,
                              fontFamily: 'SFPro',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Gap(height: 24.h),

              /// Editable Name Field
              Text(
                ConstString.name.tr,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B7280),
                  fontFamily: 'SFPro',
                ),
              ),
              Gap(height: 6.h),
              CustomTextField(
                controller: controller.nameController,
              ),

              Gap(height: 14.h),

              /// Editable Email Field (Read-Only as per standard auth)
              Text(
                ConstString.email.tr,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B7280),
                  fontFamily: 'SFPro',
                ),
              ),
              Gap(height: 6.h),
              CustomTextField(
                controller: controller.emailController,
                readOnly: true,
                keyboardType: TextInputType.emailAddress,
              ),

              Gap(height: 14.h),

              /// Editable Country Field
              Text(
                ConstString.country.tr,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B7280),
                  fontFamily: 'SFPro',
                ),
              ),
              Gap(height: 6.h),
              CustomTextField(
                controller: controller.countryController,
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF8E8E93),
                  size: 24.sp,
                ),
              ),

              Gap(height: 14.h),

              /// Editable Phone Field
              Text(
                ConstString.phone.tr,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B7280),
                  fontFamily: 'SFPro',
                ),
              ),
              Gap(height: 6.h),
              CustomTextField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
              ),

              Gap(height: 40.h),

              /// Save Changes Button
              Obx(
                () => CustomButton(
                  text: ConstString.saveChanges.tr,
                  backgroundColor: ConstColor.primaryTeal,
                  isLoading: controller.isLoading.value,
                  onTap: controller.isLoading.value ? null : controller.saveProfile,
                ),
              ),

              Gap(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
