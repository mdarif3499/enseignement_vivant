import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/constant/app_assert_icons.dart';
import 'package:enseignement_vivant/screens/homeScreen/homeTab/homeTab.dart';
import 'package:enseignement_vivant/screens/homeScreen/favoritesTab/favorites_tab.dart';
import 'package:enseignement_vivant/screens/homeScreen/profileTab/profile_tab.dart';
import 'package:enseignement_vivant/screens/homeScreen/homeTab/widget/app_drawer.dart';
import 'controller/mainController.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());

    return Obx(() => Scaffold(
          backgroundColor: ConstColor.primaryBackground,
          drawer: const CustomDrawer(),
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              HomeTab(),
              FavoritesTab(),
              ProfileTab(),
            ],
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
              child: _buildBottomNavBar(controller),
            ),
          ),
        ));
  }

  Widget _buildBottomNavBar(MainController controller) {
    return Container(
      height: 68.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35.r),
        child: Row(
          children: [
            _navItem(
              controller: controller,
              index: 0,
              activeIconPath: ConstIcons.homeActive,
              inactiveIconPath: ConstIcons.homeInactive,
              label: ConstString.home.tr,
            ),
            _navItem(
              controller: controller,
              index: 1,
              activeIconPath: ConstIcons.favoriteActive,
              inactiveIconPath: ConstIcons.favoriteInactive,
              label: ConstString.favorite.tr,
            ),
            _navItem(
              controller: controller,
              index: 2,
              activeIconPath: ConstIcons.profileActive,
              inactiveIconPath: ConstIcons.profileInactive,
              label: ConstString.profile.tr,
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required MainController controller,
    required int index,
    required String activeIconPath,
    required String inactiveIconPath,
    required String label,
  }) {
    return Obx(() {
      final isActive = controller.currentIndex.value == index;

      return Expanded(
        child: GestureDetector(
          onTap: () => controller.changeTab(index),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Active Top Indicator Line
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 3.h,
                width: isActive ? 24.w : 0,
                decoration: BoxDecoration(
                  color: isActive ? ConstColor.primaryTeal : Colors.transparent,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              const Spacer(),

              /// Nav Icon
              Image.asset(
                isActive ? activeIconPath : inactiveIconPath,
                width: 22.w,
                height: 22.h,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 3.h),

              /// Nav Label
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontFamily: 'SFPro',
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive
                      ? ConstColor.primaryTeal
                      : const Color(0xFF8E8E93),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      );
    });
  }
}
