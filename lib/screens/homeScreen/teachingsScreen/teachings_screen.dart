import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/teachings_controller.dart';
import 'widget/teaching_item_card.dart';

class TeachingsScreen extends StatelessWidget {
  const TeachingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeachingsController());

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
          ConstString.teachings.tr,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: ConstColor.titleColor,
            fontFamily: 'SFPro',
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: ConstColor.primaryTeal,
          onRefresh: controller.fetchTeachings,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              children: [
                Obx(
                  () {
                    if (controller.isLoading.value) {
                      return _buildSkeletonLoading();
                    }

                    if (controller.teachingsList.isEmpty) {
                      return _buildEmptyState(controller);
                    }

                    return ListView.builder(
                      itemCount: controller.teachingsList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = controller.teachingsList[index];
                        return TeachingItemCard(
                          item: item,
                          onTap: () {
                            Get.toNamed(AppRoutes.teachingDetailScreen, arguments: item);
                          },
                        );
                      },
                    );
                  },
                ),
                Gap(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Skeleton Loading Shimmer
  Widget _buildSkeletonLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(
          5,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 65.w,
                    height: 65.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: 120.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          width: 160.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Empty State View
  Widget _buildEmptyState(TeachingsController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: ConstColor.primaryTeal.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school_outlined,
                size: 36.sp,
                color: ConstColor.primaryTeal,
              ),
            ),
            Gap(height: 16.h),
            Text(
              "No Teachings Available",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF222222),
                fontFamily: 'SFPro',
              ),
            ),
            Gap(height: 6.h),
            Text(
              "There are currently no teaching entries available right now.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF8E8E93),
                fontFamily: 'SFPro',
                height: 1.4,
              ),
            ),
            Gap(height: 20.h),
            ElevatedButton.icon(
              onPressed: controller.fetchTeachings,
              icon: Icon(Icons.refresh_rounded, size: 18.sp, color: Colors.white),
              label: Text(
                "Refresh",
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ConstColor.primaryTeal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
