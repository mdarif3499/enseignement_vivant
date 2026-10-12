import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final Color iconBgColor;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.iconPath,
    required this.title,
     required this.iconBgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Rounded icon background
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 25.w,
                  height: 25.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 8.h),

            /// Title
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222222),
                  fontFamily: 'SFPro',
                  height: 1.15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
