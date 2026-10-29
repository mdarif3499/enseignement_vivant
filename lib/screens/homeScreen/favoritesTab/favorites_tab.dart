import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/constant/app_assert_image.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/favorites_controller.dart';
import 'widget/favorite_item_card.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoritesController());

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
                        /// Top Search Icon / Input Row
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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
                                        hintText: "Search favorites...",
                                        hintStyle: TextStyle(fontSize: 13.sp, color: Colors.black45),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(width: 10.w),
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
                          ConstString.favoritesTitle.tr,
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
                  onRefresh: controller.fetchFavorites,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
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

                        /// Favorites List
                        Obx(
                          () {
                            if (controller.isLoading.value && controller.allFavorites.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 60.h),
                                child: const Center(
                                  child: CircularProgressIndicator(color: ConstColor.primaryTeal),
                                ),
                              );
                            }

                            if (controller.filteredFavorites.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 20.w),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 60.w,
                                        height: 60.h,
                                        decoration: BoxDecoration(
                                          color: ConstColor.primaryTeal.withAlpha(20),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.favorite_border_rounded,
                                          size: 32.sp,
                                          color: ConstColor.primaryTeal,
                                        ),
                                      ),
                                      Gap(height: 12.h),
                                      Text(
                                        "No favorites saved yet",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF222222),
                                          fontFamily: 'SFPro',
                                        ),
                                      ),
                                      Gap(height: 4.h),
                                      Text(
                                        "Tap the heart icon on any item to add it to your favorites.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: const Color(0xFF8E8E93),
                                          fontFamily: 'SFPro',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              itemCount: controller.filteredFavorites.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = controller.filteredFavorites[index];
                                return FavoriteItemCard(
                                  item: item,
                                  onTap: () {
                                    final type = item.postType.toLowerCase();
                                    if (type.contains('audio')) {
                                      Get.toNamed(AppRoutes.audioDetailScreen, arguments: item.postId);
                                    } else if (type.contains('prayer')) {
                                      Get.toNamed(AppRoutes.prayerDetailScreen, arguments: item.postId);
                                    } else if (type.contains('teaching')) {
                                      Get.toNamed(AppRoutes.teachingDetailScreen, arguments: item.postId);
                                    } else if (type.contains('encouragement')) {
                                      Get.toNamed(AppRoutes.encouragementDetailScreen, arguments: item.postId);
                                    } else if (type.contains('image')) {
                                      Get.toNamed(AppRoutes.imageDetailScreen, arguments: item.postId);
                                    } else if (type.contains('verse')) {
                                      Get.toNamed(AppRoutes.verseOfDayScreen);
                                    } else {
                                      Get.toNamed(AppRoutes.audioDetailScreen, arguments: item.postId);
                                    }
                                  },
                                  onRemoveFavorite: () {
                                    controller.removeFavorite(item);
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
        ],
      ),
    );
  }
}
