import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/services/download/download_service.dart';
import 'package:enseignement_vivant/services/favorite/favorite_service.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'model/prayer_category_model.dart';

class PrayerDetailScreen extends StatefulWidget {
  const PrayerDetailScreen({super.key});

  @override
  State<PrayerDetailScreen> createState() => _PrayerDetailScreenState();
}

class _PrayerDetailScreenState extends State<PrayerDetailScreen> {
  late PrayerCategoryModel item;
  bool isFavorite = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is PrayerCategoryModel) {
      item = args;
      if (item.id.isNotEmpty) {
        fetchSinglePrayerDetails(item.id);
      }
    } else if (args is String && args.isNotEmpty) {
      item = PrayerCategoryModel(
        id: args,
        title: "Loading...",
        subtitle: "",
        coverImage: "",
      );
      fetchSinglePrayerDetails(args);
    } else if (args is Map && args['_id'] != null) {
      item = PrayerCategoryModel.fromJson(args as Map<String, dynamic>);
      if (item.id.isNotEmpty) {
        fetchSinglePrayerDetails(item.id);
      }
    } else {
      item = PrayerCategoryModel(
        title: "Morning Prayer",
        subtitle: "Place today in God's hands and rest in His faithfulness.",
        coverImage: "",
      );
    }
  }

  Future<void> fetchSinglePrayerDetails(String prayerId) async {
    if (prayerId.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiServices.instance.getServices(
        "${AppApiEndPoint.instance.prayer}/$prayerId",
      );

      if (mounted && response != null && response['data'] != null && response['data'] is Map<String, dynamic>) {
        final freshItem = PrayerCategoryModel.fromJson(response['data'] as Map<String, dynamic>);
        setState(() {
          item = freshItem;
        });
      }
    } catch (e) {
      errorLog("Fetch Single Prayer Details Error", e);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.primaryBackground,
      body: Stack(
        children: [
          /// Top Image Banner Header
          SizedBox(
            height: 250.h,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                /// Background Image
                item.imagePath.startsWith('http://') || item.imagePath.startsWith('https://')
                    ? Image.network(
                        item.imagePath,
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
                      )
                    : (item.imagePath.isNotEmpty
                        ? Image.asset(
                            item.imagePath,
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
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF1E1B3A), Color(0xFF0F0D24)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          )),

                /// Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withAlpha(120),
                        Colors.transparent,
                        Colors.black.withAlpha(80),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                /// Header Buttons (Back & Favorite)
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
                              color: Colors.black.withAlpha(40),
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
                              final isDownloaded = downloadService.isDownloaded(item.id);
                              final isDownloading = downloadService.isDownloading(item.id);

                              return GestureDetector(
                                onTap: () {
                                  if (!isDownloaded && !isDownloading) {
                                    downloadService.startDownload(
                                      id: item.id,
                                      title: item.title,
                                      subtitle: item.subtitle,
                                      categoryTag: item.categoryTag,
                                      imagePath: item.coverImage,
                                      downloadUrl: item.audioUrl.isNotEmpty ? item.audioUrl : item.coverImage,
                                      durationText: item.duration,
                                      mediaType: item.audioUrl.isNotEmpty ? 'AUDIO' : 'IMAGE',
                                    );
                                  }
                                },
                                child: Container(
                                  width: 38.w,
                                  height: 38.h,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(40),
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
                                              value: downloadService.downloadProgress[item.id],
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
                              final isFav = favoriteService.isFavorite(item.id);

                              return GestureDetector(
                                onTap: () {
                                  favoriteService.toggleFavorite(id: item.id, postType: "Prayer");
                                },
                                child: Container(
                                  width: 38.w,
                                  height: 38.h,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(40),
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
              ],
            ),
          ),

          /// Bottom Sheet Content (White body)
          Padding(
            padding: EdgeInsets.only(top: 220.h),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Category Pill Badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2F1),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                          item.categoryTag.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: ConstColor.primaryTeal,
                            fontFamily: 'SFPro',
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),

                      Gap(height: 10.h),

                      /// Title
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF222222),
                          fontFamily: 'SFPro',
                        ),
                      ),

                      Gap(height: 20.h),

                      /// Prayer Details Text Content
                      Text(
                        item.prayerText,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF555555),
                          fontFamily: 'SFPro',
                          height: 1.6,
                        ),
                      ),

                      Gap(height: 30.h),
                    ],
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
