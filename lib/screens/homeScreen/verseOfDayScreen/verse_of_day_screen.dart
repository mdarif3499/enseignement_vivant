import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/verse_of_day_controller.dart';
import 'widget/verse_thumbnail_card.dart';

class VerseOfDayScreen extends StatefulWidget {
  const VerseOfDayScreen({super.key});

  @override
  State<VerseOfDayScreen> createState() => _VerseOfDayScreenState();
}

class _VerseOfDayScreenState extends State<VerseOfDayScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerseOfDayController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final currentVerse = controller.currentVerse;

        return Stack(
          fit: StackFit.expand,
          children: [
            /// Animated Fullscreen Background Image
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Image.asset(
                currentVerse.imagePath,
                key: ValueKey<String>(currentVerse.id),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

            /// Dark Overlay for text legibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withAlpha(140),
                    Colors.black.withAlpha(80),
                    Colors.black.withAlpha(180),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            /// Header Controls (Back, Download, Favorite)
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Back Button
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 38.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(50),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white,
                            size: 28.sp,
                          ),
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        /// Download Button
                        GestureDetector(
                          onTap: () {
                            // Download
                          },
                          child: Container(
                            width: 38.w,
                            height: 38.h,
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(50),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.file_download_outlined,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 10.w),

                        /// Favorite Button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                          child: Container(
                            width: 38.w,
                            height: 38.h,
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(50),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: isFavorite ? Colors.redAccent : Colors.white,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// Center Verse Content Overlay
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentVerse.categoryTag.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white70,
                        fontFamily: 'SFPro',
                        letterSpacing: 1.5,
                      ),
                    ),

                    Gap(height: 18.h),

                    Text(
                      currentVerse.verseText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'SFPro',
                        height: 1.4,
                      ),
                    ),

                    Gap(height: 12.h),

                    Text(
                      currentVerse.verseReference,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white70,
                        fontFamily: 'SFPro',
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Bottom Thumbnails Row
            Positioned(
              bottom: 30.h,
              left: 20.w,
              right: 20.w,
              child: SizedBox(
                height: 65.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.verseItems.length,
                    (index) {
                      final item = controller.verseItems[index];
                      final isSelected = controller.selectedIndex.value == index;

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: VerseThumbnailCard(
                          item: item,
                          isSelected: isSelected,
                          onTap: () => controller.selectVerse(index),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
