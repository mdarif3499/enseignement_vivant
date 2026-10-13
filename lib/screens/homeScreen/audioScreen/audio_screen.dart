import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/constant/app_assert_image.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/audio_screen_controller.dart';
import 'widget/audio_list_card.dart';
import 'widget/mini_audio_player_bar.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioScreenController());

    return Scaffold(
      backgroundColor: ConstColor.primaryBackground,
      body: Stack(
        children: [
          /// Top Image Banner Header
          SizedBox(
            height: 220.h,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                /// Background Image
                Image.asset(
                  ImageString.tempBackground,
                  fit: BoxFit.cover,
                ),

                /// Dark Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withAlpha(160),
                        Colors.black.withAlpha(80),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                /// Header Controls & Title
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Top Controls Row
                        Obx(
                          () => Row(
                            children: [
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: Icon(
                                  Icons.chevron_left_rounded,
                                  color: Colors.white,
                                  size: 30.sp,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              if (controller.isSearching.value)
                                Expanded(
                                  child: Container(
                                    height: 38.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(230),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: TextField(
                                      controller: controller.searchController,
                                      autofocus: true,
                                      onChanged: controller.filterBySearch,
                                      style: TextStyle(fontSize: 13.sp, color: Colors.black87),
                                      decoration: InputDecoration(
                                        hintText: "Search audio...",
                                        hintStyle: TextStyle(fontSize: 13.sp, color: Colors.black45),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                const Spacer(),
                              GestureDetector(
                                onTap: controller.toggleSearch,
                                child: Icon(
                                  controller.isSearching.value ? Icons.close_rounded : Icons.search_rounded,
                                  color: Colors.white,
                                  size: 24.sp,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        /// Title
                        Text(
                          ConstString.audioTitle.tr,
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'SFPro',
                          ),
                        ),

                        Gap(height: 4.h),

                        /// Subtitle
                        Text(
                          ConstString.favoritesSubtitle.tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withAlpha(220),
                            fontFamily: 'SFPro',
                            height: 1.3,
                          ),
                        ),

                        Gap(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Bottom Sheet Content (White rounded body)
          Padding(
            padding: EdgeInsets.only(top: 200.h),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ConstColor.primaryBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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

                      Gap(height: 16.h),

                      /// Audio List
                      Obx(
                        () => ListView.builder(
                          itemCount: controller.filteredAudioList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = controller.filteredAudioList[index];
                            return AudioListCard(
                              item: item,
                              onTap: () {
                                Get.toNamed(AppRoutes.audioDetailScreen, arguments: item);
                              },
                            );
                          },
                        ),
                      ),

                      Gap(height: 80.h),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// Floating Mini Audio Player Bar
          Obx(() {
            if (controller.filteredAudioList.isEmpty) return const SizedBox.shrink();
            final currentItem = controller.filteredAudioList.first;
            return Positioned(
              bottom: 10.h,
              left: 0,
              right: 0,
              child: MiniAudioPlayerBar(item: currentItem),
            );
          }),
        ],
      ),
    );
  }
}
