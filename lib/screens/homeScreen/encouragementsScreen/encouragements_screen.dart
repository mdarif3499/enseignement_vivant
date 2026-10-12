import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/encouragements_controller.dart';
import 'widget/encouragement_card.dart';

class EncouragementsScreen extends StatelessWidget {
  const EncouragementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EncouragementsController());

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
          ConstString.encouragements.tr,
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
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            children: [
              Obx(
                () => ListView.builder(
                  itemCount: controller.list.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = controller.list[index];
                    return EncouragementCard(
                      item: item,
                      onTap: () {
                        Get.toNamed(AppRoutes.encouragementDetailScreen, arguments: item);
                      },
                    );
                  },
                ),
              ),
              Gap(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
