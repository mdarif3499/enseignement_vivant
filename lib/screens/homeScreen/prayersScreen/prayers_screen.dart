import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/constant/app_assert_image.dart';
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
              fit: StackTrace.expand,
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
                        /// Top Icons Row (Back arrow & Search)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Icon(
                                Icons.chevron_left_rounded,
                                color: Colors.white,
                                size: 30.sp,
                              ),
                            ),
                            Icon(
                              Icons.search_rounded,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ],
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
                child: SingleChildScrollView(
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

                      /// Prayer Categories List
                      Obx(
                        () => ListView.builder(
                          itemCount: controller.prayerCategories.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = controller.prayerCategories[index];
                            return PrayerCategoryItem(
                              item: item,
                              onTap: () {
                                // Navigate to specific detail
                              },
                            );
                          },
                        ),
                      ),
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
