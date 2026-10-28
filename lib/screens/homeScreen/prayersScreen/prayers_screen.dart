import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/prayers_controller.dart';
import 'widget/prayer_category_item.dart';

class PrayersScreen extends StatelessWidget {
  const PrayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PrayersController());

    return Scaffold(
      backgroundColor: ConstColor.primaryBackground,
      body: Stack(
        children: [
          /// Top Image Header Banner
          SizedBox(
            height: 220.h,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                /// Dynamic Background Image (First Image from list or Gradient)
                Obx(() {
                  final firstImage = controller.allCategories.isNotEmpty
                      ? controller.allCategories.first.imagePath
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
                        /// Top Icons Row (Back arrow & Search Bar)
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
                                      onChanged: controller.filterCategories,
                                      style: TextStyle(fontSize: 13.sp, color: Colors.black87),
                                      decoration: InputDecoration(
                                        hintText: "Search prayers...",
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
                          ConstString.prayers.tr,
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
                          ConstString.prayersSubtitle.tr,
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
                  onRefresh: controller.fetchPrayers,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Section Header Title
                        Text(
                          ConstString.prayerCategories.tr,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF222222),
                            fontFamily: 'SFPro',
                          ),
                        ),

                        Gap(height: 16.h),

                        /// Prayer Categories List / Skeleton / Empty State
                        Obx(
                          () {
                            if (controller.isLoading.value) {
                              return _buildSkeletonLoading();
                            }

                            if (controller.filteredCategories.isEmpty) {
                              return _buildEmptyState(controller);
                            }

                            return ListView.builder(
                              itemCount: controller.filteredCategories.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = controller.filteredCategories[index];
                                return PrayerCategoryItem(
                                  item: item,
                                  onTap: () {
                                    Get.toNamed(AppRoutes.prayerDetailScreen, arguments: item);
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
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
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.h,
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
                          width: 140.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: 32.w,
                    height: 32.h,
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
  Widget _buildEmptyState(PrayersController controller) {
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
                Icons.auto_stories_outlined,
                size: 36.sp,
                color: ConstColor.primaryTeal,
              ),
            ),
            Gap(height: 16.h),
            Text(
              "No Prayers Available",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF222222),
                fontFamily: 'SFPro',
              ),
            ),
            Gap(height: 6.h),
            Text(
              "There are currently no prayers in this list. Please check back later.",
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
              onPressed: controller.fetchPrayers,
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
