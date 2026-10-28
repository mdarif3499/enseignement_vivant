import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/screens/homeScreen/audioScreen/widget/audio_list_card.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/downloads_controller.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DownloadsController());

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
          ConstString.downloads.tr,
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

              /// Downloads List
              Obx(
                () {
                  if (controller.filteredDownloads.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 80.h, horizontal: 20.w),
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
                                Icons.download_for_offline_outlined,
                                size: 36.sp,
                                color: ConstColor.primaryTeal,
                              ),
                            ),
                            Gap(height: 16.h),
                            Text(
                              "No downloaded files yet",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF222222),
                                fontFamily: 'SFPro',
                              ),
                            ),
                            Gap(height: 6.h),
                            Text(
                              "Downloaded media and songs will appear here for offline access.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF8E8E93),
                                fontFamily: 'SFPro',
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.filteredDownloads.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = controller.filteredDownloads[index];
                      return Dismissible(
                        key: Key(item.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.w),
                          margin: EdgeInsets.only(bottom: 12.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF4D4D),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                        onDismissed: (_) {
                          controller.onDeleteItem(item.id);
                        },
                        child: AudioListCard(
                          item: item,
                          onTap: () {
                            Get.toNamed(AppRoutes.audioDetailScreen, arguments: item);
                          },
                          onDelete: () {
                            _showDeleteConfirmation(context, controller, item.id, item.title);
                          },
                        ),
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
    );
  }

  void _showDeleteConfirmation(BuildContext context, DownloadsController controller, String id, String title) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(
          "Delete Download",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, fontFamily: 'SFPro'),
        ),
        content: Text(
          "Are you sure you want to remove '$title' from your downloads?",
          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF555555), fontFamily: 'SFPro'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(color: const Color(0xFF8E8E93), fontSize: 14.sp, fontFamily: 'SFPro'),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4D4D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            onPressed: () {
              Get.back();
              controller.onDeleteItem(id);
            },
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold, fontFamily: 'SFPro'),
            ),
          ),
        ],
      ),
    );
  }
}
