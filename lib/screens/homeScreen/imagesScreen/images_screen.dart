import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/images_controller.dart';
import 'widget/image_grid_card.dart';

class ImagesScreen extends StatelessWidget {
  const ImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ImagesController());

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
          ConstString.images.tr,
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
          onRefresh: controller.fetchImages,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Filter Chips Row
                Obx(
                  () => SizedBox(
                    height: 38.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.categories.length,
                      separatorBuilder: (context, index) => SizedBox(width: 8.w),
                      itemBuilder: (context, index) {
                        final catKey = controller.categories[index];
                        final isSelected = controller.selectedCategory.value == catKey;
                        return GestureDetector(
                          onTap: () => controller.filterByCategory(catKey),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: isSelected ? ConstColor.primaryTeal : const Color(0xFFEFEFF4),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Center(
                              child: Text(
                                catKey.tr,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? Colors.white : const Color(0xFF7A7A7A),
                                  fontFamily: 'SFPro',
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                Gap(height: 20.h),

                /// Images Grid / Skeleton / Empty State
                Obx(
                  () {
                    if (controller.isLoading.value) {
                      return _buildSkeletonLoading();
                    }

                    if (controller.filteredImages.isEmpty) {
                      return _buildEmptyState(controller);
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.filteredImages.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 14.h,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        final item = controller.filteredImages[index];
                        return ImageGridCard(
                          item: item,
                          onTap: () {
                            Get.toNamed(AppRoutes.imageDetailScreen, arguments: item);
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

  /// Skeleton Grid Loading Shimmer
  Widget _buildSkeletonLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 14.h,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
          );
        },
      ),
    );
  }

  /// Empty State View Widget
  Widget _buildEmptyState(ImagesController controller) {
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
                Icons.image_outlined,
                size: 36.sp,
                color: ConstColor.primaryTeal,
              ),
            ),
            Gap(height: 16.h),
            Text(
              "No Images Available",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF222222),
                fontFamily: 'SFPro',
              ),
            ),
            Gap(height: 6.h),
            Text(
              "There are currently no image entries available in this section.",
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
              onPressed: controller.fetchImages,
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
