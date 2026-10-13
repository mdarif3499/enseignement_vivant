import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/widgers/custombutton/custombutton.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/language_screen_controller.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LanguageScreenController());

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
          ConstString.language.tr,
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
            children: [
              /// French Card
              Obx(() {
                final isFrench = controller.tempSelectedLangCode.value == 'fr';
                return _languageOptionCard(
                  title: ConstString.french.tr,
                  isSelected: isFrench,
                  onTap: () => controller.selectLanguage('fr'),
                );
              }),

              Gap(height: 12.h),

              /// English Card
              Obx(() {
                final isEnglish = controller.tempSelectedLangCode.value == 'en';
                return _languageOptionCard(
                  title: ConstString.english.tr,
                  isSelected: isEnglish,
                  onTap: () => controller.selectLanguage('en'),
                );
              }),

              const Spacer(),

              /// Save Changes Button
              CustomButton(
                text: ConstString.saveChanges.tr,
                backgroundColor: ConstColor.primaryTeal,
                onTap: controller.saveLanguage,
              ),

              Gap(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageOptionCard({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? ConstColor.primaryTeal : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF2E1A47) : const Color(0xFF48484A),
                fontFamily: 'SFPro',
              ),
            ),

            /// Radio Circle Indicator
            Container(
              width: 22.w,
              height: 22.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? ConstColor.primaryTeal : const Color(0xFFC7C7CC),
                  width: isSelected ? 6.5 : 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
