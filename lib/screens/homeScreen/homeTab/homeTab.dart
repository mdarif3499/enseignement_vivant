import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/constant/app_assert_image.dart';
import 'package:enseignement_vivant/constant/app_assert_icons.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'package:enseignement_vivant/screens/homeScreen/homeTab/widget/category_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late PageController _bannerController;
  int _currentBannerIndex = 0;
  Timer? _autoScrollTimer;

  final List<Map<String, String>> _bannerItems = [
    {
      "verse": "TA PAROLE EST UNE LAMPE\nÀ MES PIEDS, ET UNE LUMIÈRE\nSUR MON SENTIER.",
      "ref": "PSAUME 119:105",
    },
    {
      "verse": "CAR DIEU A TANT AIMÉ LE MONDE\nQU'IL A DONNÉ SON FILS UNIQUE.",
      "ref": "JEAN 3:16",
    },
    {
      "verse": "LE SEIGNEUR EST MON BERGER:\nJE NE MANQUERAI DE RIEN.",
      "ref": "PSAUME 23:1",
    },
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_bannerController.hasClients) {
        int nextPage = (_currentBannerIndex + 1) % _bannerItems.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Gap(height: 12.h),

            /// Header App Bar (Drawer Icon - Logo - Notification Bell)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Drawer Icon (Click opens custom drawer)
                Builder(
                  builder: (ctx) => GestureDetector(
                    onTap: () {
                      Scaffold.of(ctx).openDrawer();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Image.asset(
                        ConstIcons.drowerIcon,
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.menu_rounded,
                          size: 26.sp,
                          color: ConstColor.titleColor,
                        ),
                      ),
                    ),
                  ),
                ),

                /// Logo
                Image.asset(
                  ImageString.logoImg,
                  width: 200.w,
                  height: 119.h,
                  fit: BoxFit.contain,
                ),

                /// Notification Bell Button
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.notificationsScreen);
                  },
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(12),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        ConstIcons.notificationIcon,
                        width: 20.w,
                        height: 20.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Gap(height: 12.h),

            /// Auto-scrolling Banner Carousel Card
            Container(
              width: double.infinity,
              height: 180.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                image: const DecorationImage(
                  image: AssetImage(ImageString.homeCardImg),
                  fit: BoxFit.fill,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// PageView Carousel
                  PageView.builder(
                    controller: _bannerController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentBannerIndex = index;
                      });
                    },
                    itemCount: _bannerItems.length,
                    itemBuilder: (context, index) {
                      final item = _bannerItems[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item["verse"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SFPro',
                                height: 1.4,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Gap(height: 8.h),
                            Text(
                              item["ref"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10.sp,
                                fontFamily: 'SFPro',
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  /// Page Indicator Dots
                  Positioned(
                    bottom: 12.h,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(_bannerItems.length, (index) {
                        final isActive = _currentBannerIndex == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 3.w),
                          width: isActive ? 24.w : 6.w,
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white : Colors.white38,
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            Gap(height: 40.h),

            /// Grid Categories (3 columns x 2 rows)
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 14.h,
              childAspectRatio: 0.82,
              children: [
                CategoryCard(
                  iconPath: ConstIcons.prayerIcon,
                  title: ConstString.prayer.tr,
                  iconBgColor: const Color(0xFF34C759).withAlpha(25),
                  onTap: () => Get.toNamed(AppRoutes.prayersScreen),
                ),
                CategoryCard(
                  iconPath: ConstIcons.audioIcon,
                  title: ConstString.audio.tr,
                  iconBgColor: const Color(0xFFFFF9E7),
                  onTap: () => Get.toNamed(AppRoutes.audioScreen),
                ),
                CategoryCard(
                  iconPath: ConstIcons.encouragementIcon,
                  title: ConstString.encouragement.tr,
                  iconBgColor: const Color(0xFF34C759).withAlpha(25),
                  onTap: () => Get.toNamed(AppRoutes.encouragementsScreen),
                ),
                CategoryCard(
                  iconPath: ConstIcons.teachingIcon,
                  title: ConstString.teaching.tr,
                  iconBgColor: const Color(0xFFFFF9E7),
                  onTap: () => Get.toNamed(AppRoutes.teachingsScreen),
                ),
                CategoryCard(
                  iconPath: ConstIcons.imageIcon,
                  title: ConstString.image.tr,
                  iconBgColor: const Color(0xFF34C759).withAlpha(25),
                  onTap: () => Get.toNamed(AppRoutes.imagesScreen),
                ),
                CategoryCard(
                  iconPath: ConstIcons.verseOfDayIcon,
                  title: ConstString.verseOfTheDay.tr,
                  iconBgColor: const Color(0xFFFFF9E7),
                  onTap: () => Get.toNamed(AppRoutes.verseOfDayScreen),
                ),
              ],
            ),

            Gap(height: 20.h),
          ],
        ),
      ),
    );
  }
}
