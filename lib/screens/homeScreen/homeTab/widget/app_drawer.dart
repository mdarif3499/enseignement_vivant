import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/constant/app_assert_image.dart';
import 'package:enseignement_vivant/constant/app_assert_icons.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/utils/gap.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: 280.w,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25.r),
          bottomRight: Radius.circular(25.r),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Logo
              Center(
                child: Image.asset(
                  ImageString.logoImg,
                  width: 160.w,
                  height: 60.h,
                  fit: BoxFit.contain,
                ),
              ),

              Gap(height: 16.h),

              /// User Profile Card
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: ConstColor.primaryTeal,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: Colors.white24,
                      child: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: const Color(0xFFE0F2F1),
                        child: Icon(Icons.person_rounded, color: ConstColor.primaryTeal, size: 24.sp),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sara",
                            style: TextStyle(
                              fontSize: 15.sp,
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
                              fontSize: 11.sp,
                              color: Colors.white70,
                              fontFamily: 'SFPro',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ],
                ),
              ),

              Gap(height: 20.h),

              /// Drawer Items
              _drawerItem(
                iconPath: ConstIcons.downloadIcon,
                title: ConstString.downloads.tr,
                onTap: () {
                  Get.toNamed(AppRoutes.downloadsScreen);
                },
              ),
              _drawerItem(
                iconPath: ConstIcons.languageIcon,
                title: ConstString.language.tr,
                onTap: () {
                  Get.toNamed(AppRoutes.languageScreen);
                },
              ),
              _drawerItem(
                iconPath: ConstIcons.settingsIcon,
                title: ConstString.settings.tr,
                onTap: () {
                  Get.toNamed(AppRoutes.settingsScreen);
                },
              ),
              _drawerItem(
                iconPath: ConstIcons.termsIcon,
                title: ConstString.termsAndConditions.tr,
                onTap: () {
                  Get.toNamed(AppRoutes.termsScreen);
                },
              ),
              _drawerItem(
                iconPath: ConstIcons.privacyIcon,
                title: ConstString.privacyPolicy.tr,
                onTap: () {
                  Get.toNamed(AppRoutes.privacyPolicyScreen);
                },
              ),
              _drawerItem(
                iconPath: ConstIcons.helpSupportIcon,
                title: ConstString.helpAndSupport.tr,
                onTap: () {
                  Get.toNamed(AppRoutes.helpSupportScreen);
                },
              ),
              _drawerItem(
                iconPath: ConstIcons.deleteIcon,
                title: ConstString.accountDelete.tr,
                onTap: () {
                  Get.toNamed(AppRoutes.deleteAccountScreen);
                },
              ),
              _drawerItem(
                iconPath: ConstIcons.logoutIcon,
                title: ConstString.logout.tr,
                isLogout: true,
                onTap: () {
                  Get.offAllNamed(AppRoutes.signInScreen);
                },
              ),

              Gap(height: 20.h),

              /// Follow Us Section
              Text(
                ConstString.followUs.tr,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF8E8E93),
                  fontFamily: 'SFPro',
                ),
              ),

              Gap(height: 10.h),

              /// Social Icons Row
              Row(
                children: [
                  _socialIcon(ConstIcons.facebookIcon),
                  _socialIcon(ConstIcons.instagramIcon),
                  _socialIcon(ConstIcons.youtubeIcon),
                  _socialIcon(ConstIcons.tiktokIcon),
                ],
              ),

              Gap(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    final Color iconCircleBg = isLogout ? const Color(0xFFFFEBEE) : const Color(0xFFE6F6F4);
    final Color textColor = isLogout ? const Color(0xFFFF4D4D) : const Color(0xFF222222);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            children: [
              Container(
                width: 38.w,
                height: 38.h,
                decoration: BoxDecoration(
                  color: iconCircleBg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    iconPath,
                    width: 20.w,
                    height: 20.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: isLogout ? FontWeight.bold : FontWeight.w500,
                    color: textColor,
                    fontFamily: 'SFPro',
                  ),
                ),
              ),
              if (!isLogout)
                Icon(
                  Icons.chevron_right_rounded,
                  color: const Color(0xFF8E8E93),
                  size: 20.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialIcon(String iconPath) {
    return Container(
      width: 34.w,
      height: 34.h,
      margin: EdgeInsets.only(right: 8.w),
      child: Center(
        child: Image.asset(
          iconPath,
          width: 20.w,
          height: 20.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
