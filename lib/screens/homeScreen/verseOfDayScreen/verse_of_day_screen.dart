import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/services/download/download_service.dart';
import 'package:enseignement_vivant/services/favorite/favorite_service.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/verse_of_day_controller.dart';
import 'widget/page_curl_widget.dart';
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
        if (controller.isLoading.value && controller.verseItems.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: ConstColor.primaryTeal),
          );
        }

        final currentVerse = controller.currentVerse;

        return Stack(
          fit: StackFit.expand,
          children: [
            /// Ultra-Realistic 3D Corner Page Curl & Flip Animation
            PageCurlWidget(
              pageKey: ValueKey<String>("bg_${currentVerse.id}_${currentVerse.imagePath}"),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: currentVerse.imagePath.startsWith('http://') || currentVerse.imagePath.startsWith('https://')
                    ? Image.network(
                        currentVerse.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFF1E1B3A),
                        ),
                      )
                    : (currentVerse.imagePath.isNotEmpty && !currentVerse.imagePath.startsWith('http')
                        ? Image.asset(
                            currentVerse.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFF1E1B3A),
                            ),
                          )
                        : Container(
                            color: const Color(0xFF1E1B3A),
                          )),
              ),
            ),

            /// Dark Overlay Gradient for text legibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withAlpha(150),
                    Colors.black.withAlpha(90),
                    Colors.black.withAlpha(190),
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
                          color: Colors.black.withAlpha(60),
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
                        Obx(() {
                          final downloadService = DownloadService.instance;
                          final isDownloaded = downloadService.isDownloaded(currentVerse.id);
                          final isDownloading = downloadService.isDownloading(currentVerse.id);

                          return GestureDetector(
                            onTap: () {
                              if (!isDownloaded && !isDownloading) {
                                downloadService.startDownload(
                                  id: currentVerse.id,
                                  title: currentVerse.verseReference,
                                  subtitle: currentVerse.verseText,
                                  categoryTag: 'VERSE OF THE DAY',
                                  imagePath: currentVerse.imagePath,
                                  downloadUrl: currentVerse.imagePath,
                                  durationText: '',
                                  mediaType: 'IMAGE',
                                );
                              }
                            },
                            child: Container(
                              width: 38.w,
                              height: 38.h,
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(60),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: isDownloading
                                    ? SizedBox(
                                        width: 18.w,
                                        height: 18.h,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                          value: downloadService.downloadProgress[currentVerse.id],
                                        ),
                                      )
                                    : Icon(
                                        isDownloaded ? Icons.download_done_rounded : Icons.file_download_outlined,
                                        color: isDownloaded ? ConstColor.primaryTeal : Colors.white,
                                        size: 20.sp,
                                      ),
                              ),
                            ),
                          );
                        }),

                        SizedBox(width: 10.w),

                        /// Favorite Button
                        Obx(() {
                          final favoriteService = FavoriteService.instance;
                          final isFav = favoriteService.isFavorite(currentVerse.id);

                          return GestureDetector(
                            onTap: () {
                              favoriteService.toggleFavorite(id: currentVerse.id, postType: "Verse");
                            },
                            child: Container(
                              width: 38.w,
                              height: 38.h,
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(60),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: isFav ? Colors.redAccent : Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// Premium Center Verse Content Overlay Animation (Slow Float + Fade)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 900),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(0.0, 0.08),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ));

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    key: ValueKey<String>("text_${currentVerse.id}_${controller.selectedIndex.value}"),
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
            ),

            /// Bottom Thumbnails Row (Horizontally Scrollable)
            Positioned(
              bottom: 25.h,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 75.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.verseItems.length,
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final item = controller.verseItems[index];
                    final isSelected = controller.selectedIndex.value == index;

                    return Center(
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
          ],
        );
      }),
    );
  }
}
