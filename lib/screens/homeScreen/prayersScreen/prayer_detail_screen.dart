import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
    item = Get.arguments is PrayerCategoryModel
        ? Get.arguments as PrayerCategoryModel
        : PrayerCategoryModel(
            title: "Morning Prayer",
            subtitle: "Place today in God's hands and rest in His faithfulness.",
            imagePath: "assets/temp/item.jpg",
          );
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
                Image.asset(
                  item.imagePath,
                  fit: BoxFit.cover,
                ),

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
                              color: Colors.black.withAlpha(40),
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
