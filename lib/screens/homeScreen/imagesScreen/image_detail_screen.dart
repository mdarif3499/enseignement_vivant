import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/services/download/download_service.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import 'model/image_item_model.dart';

class ImageDetailScreen extends StatefulWidget {
  const ImageDetailScreen({super.key});

  @override
  State<ImageDetailScreen> createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  late ImageItemModel item;
  bool isFavorite = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is ImageItemModel) {
      item = args;
      if (item.id.isNotEmpty) {
        fetchSingleImageDetails(item.id);
      }
    } else if (args is String && args.isNotEmpty) {
      item = ImageItemModel(
        id: args,
        title: "Loading...",
        categoryTag: "prayer",
        imagePath: "",
        quoteText: "",
      );
      fetchSingleImageDetails(args);
    } else if (args is Map && args['_id'] != null) {
      item = ImageItemModel.fromJson(args as Map<String, dynamic>);
      if (item.id.isNotEmpty) {
        fetchSingleImageDetails(item.id);
      }
    } else {
      item = ImageItemModel(
        id: '1',
        title: "Morning Mercy",
        categoryTag: "prayer",
        imagePath: "",
      );
    }
  }

  Future<void> fetchSingleImageDetails(String imageId) async {
    if (imageId.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiServices.instance.getServices(
        "${AppApiEndPoint.instance.imageEndpoint}/$imageId",
      );

      if (mounted && response != null && response['data'] != null && response['data'] is Map<String, dynamic>) {
        final freshItem = ImageItemModel.fromJson(response['data'] as Map<String, dynamic>);
        setState(() {
          item = freshItem;
        });
      }
    } catch (e) {
      errorLog("Fetch Single Image Details Error", e);
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
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// Fullscreen Image
          item.imagePath.startsWith('http://') || item.imagePath.startsWith('https://')
              ? Image.network(
                  item.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.black,
                    child: Center(
                      child: Icon(Icons.broken_image_outlined, color: Colors.white54, size: 50.sp),
                    ),
                  ),
                )
              : (item.imagePath.isNotEmpty && !item.imagePath.startsWith('http')
                  ? Image.asset(
                      item.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.black,
                        child: Center(
                          child: Icon(Icons.broken_image_outlined, color: Colors.white54, size: 50.sp),
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.black,
                      child: Center(
                        child: Icon(Icons.broken_image_outlined, color: Colors.white54, size: 50.sp),
                      ),
                    )),

          /// Dark Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withAlpha(140),
                  Colors.transparent,
                  Colors.black.withAlpha(200),
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
                        final isDownloaded = downloadService.isDownloaded(item.id);
                        final isDownloading = downloadService.isDownloading(item.id);

                        return GestureDetector(
                          onTap: () {
                            if (!isDownloaded && !isDownloading) {
                              downloadService.startDownload(
                                id: item.id,
                                title: item.title,
                                subtitle: item.quoteText,
                                categoryTag: item.categoryTag.isNotEmpty ? item.categoryTag : 'Image',
                                imagePath: item.imagePath,
                                downloadUrl: item.imagePath,
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
                                        value: downloadService.downloadProgress[item.id],
                                      ),
                                    )
                                  : Icon(
                                      isDownloaded ? Icons.download_done_rounded : Icons.file_download_outlined,
                                      color: isDownloaded ? Colors.tealAccent : Colors.white,
                                      size: 20.sp,
                                    ),
                            ),
                          ),
                        );
                      }),

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
                            color: Colors.black.withAlpha(60),
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

          /// Bottom Quote Text Overlay
          Positioned(
            bottom: 40.h,
            left: 24.w,
            right: 24.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.title.isNotEmpty)
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'SFPro',
                      shadows: [
                        Shadow(
                          color: Colors.black.withAlpha(180),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                if (item.quoteText.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Text(
                    item.quoteText,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                      fontFamily: 'SFPro',
                      height: 1.3,
                      shadows: [
                        Shadow(
                          color: Colors.black.withAlpha(180),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
