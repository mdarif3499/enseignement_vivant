import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'model/image_item_model.dart';

class ImageDetailScreen extends StatefulWidget {
  const ImageDetailScreen({super.key});

  @override
  State<ImageDetailScreen> createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  late ImageItemModel item;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    item = Get.arguments is ImageItemModel
        ? Get.arguments as ImageItemModel
        : ImageItemModel(
            id: '1',
            title: "Morning Mercy",
            categoryTag: "prayer",
            imagePath: "assets/temp/item_7.jpg",
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// Fullscreen Image
          Image.asset(
            item.imagePath,
            fit: BoxFit.cover,
          ),

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
                      GestureDetector(
                        onTap: () {
                          // Handle download
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
            child: Text(
              ConstString.theLordIsNear.tr,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
          ),
        ],
      ),
    );
  }
}
