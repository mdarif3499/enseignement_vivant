import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import '../model/favorite_item_model.dart';

class FavoriteItemCard extends StatelessWidget {
  final FavoriteItemModel item;
  final VoidCallback? onTap;
  final VoidCallback? onRemoveFavorite;

  const FavoriteItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onRemoveFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
              /// Item Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  item.imagePath,
                  width: 65.w,
                  height: 65.h,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: 14.w),

              /// Middle Details
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
                    SizedBox(height: 3.h),

                    /// Subtitle Row (Bibel • 15:45)
                    Row(
                      children: [
                        Text(
                          "Bibel",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF7A7A7A),
                            fontFamily: 'SFPro',
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Container(
                          width: 3.w,
                          height: 3.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFF8E8E93),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          item.durationText,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF7A7A7A),
                            fontFamily: 'SFPro',
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF8E8E93),
                        fontFamily: 'SFPro',
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10.w),

              /// Solid Heart Favorite Button
              GestureDetector(
                onTap: onRemoveFavorite,
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0F2F1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.favorite_rounded,
                      color: ConstColor.primaryTeal,
                      size: 18.sp,
                    ),
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
