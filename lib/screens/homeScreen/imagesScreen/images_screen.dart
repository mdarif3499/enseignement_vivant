import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Filter Chips Row
              SizedBox(
                height: 38.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  separatorBuilder: (context, index) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    final catKey = controller.categories[index];
                    return Obx(() {
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
                    });
                  },
                ),
              ),

              Gap(height: 20.h),

              /// Images Grid (2 columns)
              Obx(
                () => GridView.builder(
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
