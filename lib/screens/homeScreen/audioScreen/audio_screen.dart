import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
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
                /// Dynamic Background Image (First Image from list or Gradient)
                Obx(() {
                  final firstImage = controller.allAudioList.isNotEmpty
                      ? controller.allAudioList.first.imagePath
                      : '';

                  if (firstImage.startsWith('http://') || firstImage.startsWith('https://')) {
                    return Image.network(
                      firstImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF1E1B3A), Color(0xFF0F0D24)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    );
                  } else if (firstImage.isNotEmpty) {
                    return Image.asset(
                      firstImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF1E1B3A), Color(0xFF0F0D24)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF1E1B3A),
                            Color(0xFF0F0D24),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    );
                  }
                }),

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
                child: RefreshIndicator(
                  color: ConstColor.primaryTeal,
                  onRefresh: controller.fetchAudioList,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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

                        Gap(height: 16.h),

                        /// Audio List / Skeleton / Empty State
                        Obx(
                          () {
                            if (controller.isLoading.value) {
                              return _buildSkeletonLoading();
                            }

                            if (controller.filteredAudioList.isEmpty) {
                              return _buildEmptyState(controller);
                            }

                            return ListView.builder(
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
                            );
                          },
                        ),

                        Gap(height: 80.h),
                      ],
                    ),
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

  /// Skeleton Loading Shimmer Widget
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

  /// Empty State View Widget
  Widget _buildEmptyState(AudioScreenController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
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
                Icons.music_note_outlined,
                size: 36.sp,
                color: ConstColor.primaryTeal,
              ),
            ),
            Gap(height: 16.h),
            Text(
              "No Audio Available",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF222222),
                fontFamily: 'SFPro',
              ),
            ),
            Gap(height: 6.h),
            Text(
              "There are currently no audio recordings in this category.",
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
              onPressed: controller.fetchAudioList,
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
