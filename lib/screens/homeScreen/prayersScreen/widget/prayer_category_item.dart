import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/prayer_category_model.dart';

class PrayerCategoryItem extends StatelessWidget {
  final PrayerCategoryModel item;
  final VoidCallback? onTap;

  const PrayerCategoryItem({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(6),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              /// Item Image Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: item.imagePath.startsWith('http://') || item.imagePath.startsWith('https://')
                    ? Image.network(
                        item.imagePath,
                        width: 60.w,
                        height: 60.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60.w,
                          height: 60.h,
                          color: const Color(0xFFE0F2F1),
                          child: Icon(Icons.auto_stories_rounded, color: const Color(0xFF00897B), size: 28.sp),
                        ),
                      )
                    : (item.imagePath.isNotEmpty
                        ? Image.asset(
                            item.imagePath,
                            width: 60.w,
                            height: 60.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 60.w,
                              height: 60.h,
                              color: const Color(0xFFE0F2F1),
                              child: Icon(Icons.auto_stories_rounded, color: const Color(0xFF00897B), size: 28.sp),
                            ),
                          )
                        : Container(
                            width: 60.w,
                            height: 60.h,
                            color: const Color(0xFFE0F2F1),
                            child: Icon(Icons.auto_stories_rounded, color: const Color(0xFF00897B), size: 28.sp),
                          )),
              ),

              SizedBox(width: 14.w),

              /// Title & Subtitle Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF222222),
                        fontFamily: 'SFPro',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF7A7A7A),
                        fontFamily: 'SFPro',
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              /// Chevron Right Arrow
              Container(
                width: 32.w,
                height: 32.h,
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F6F6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: const Color(0xFF8E8E93),
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
