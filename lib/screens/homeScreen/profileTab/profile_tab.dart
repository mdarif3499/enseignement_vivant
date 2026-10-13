import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/widgers/custom_text_Field/customtextfield.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/profile_controller.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: ConstColor.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          ConstString.profile.tr,
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
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Banner Card (Sara / sarahashem@gmail.com + Edit Pencil)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: ConstColor.primaryTeal,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: ConstColor.primaryTeal.withAlpha(50),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26.r,
                      backgroundColor: Colors.white24,
                      child: CircleAvatar(
                        radius: 24.r,
                        backgroundColor: const Color(0xFFE0F2F1),
                        child: Icon(Icons.person_rounded, color: ConstColor.primaryTeal, size: 28.sp),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sara",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'SFPro',
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "sarahashem@gmail.com",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white70,
                              fontFamily: 'SFPro',
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.editProfileScreen);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Gap(height: 24.h),

              /// Account Information Title
              Text(
                ConstString.accountInformation.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222222),
                  fontFamily: 'SFPro',
                ),
              ),

              Gap(height: 6.h),
              const Divider(color: Color(0xFFE5E7EB), thickness: 1),
              Gap(height: 16.h),

              /// Name Field (Read Only)
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      controller: TextEditingController(text: controller.name.value),
                      readOnly: true,
                    ),
                  ],
                ),
              ),

              Gap(height: 14.h),

              /// Email Field (Read Only)
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      controller: TextEditingController(text: controller.email.value),
                      readOnly: true,
                    ),
                  ],
                ),
              ),

              Gap(height: 14.h),

              /// Country Field (Read Only with Chevron)
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      controller: TextEditingController(text: controller.country.value),
                      readOnly: true,
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: const Color(0xFF8E8E93),
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
              ),

              Gap(height: 14.h),

              /// Phone Field (Read Only)
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      controller: TextEditingController(text: controller.phone.value),
                      readOnly: true,
                    ),
                  ],
                ),
              ),

              Gap(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }
}
