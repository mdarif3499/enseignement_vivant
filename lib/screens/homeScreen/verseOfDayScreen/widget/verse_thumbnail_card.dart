import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import '../model/verse_item_model.dart';

class VerseThumbnailCard extends StatelessWidget {
  final VerseItemModel item;
  final bool isSelected;
  final VoidCallback onTap;

  const VerseThumbnailCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: isSelected ? 72.w : 60.w,
        height: isSelected ? 72.h : 60.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isSelected ? ConstColor.primaryTeal : Colors.white30,
            width: isSelected ? 3.0 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? ConstColor.primaryTeal.withAlpha(120)
                  : Colors.black.withAlpha(30),
              blurRadius: isSelected ? 12 : 6,
              spreadRadius: isSelected ? 2 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: item.imagePath.startsWith('http://') || item.imagePath.startsWith('https://')
              ? Image.network(
                  item.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[800],
                    child: const Icon(Icons.image_not_supported_outlined, color: Colors.white54),
                  ),
                )
              : (item.imagePath.isNotEmpty && !item.imagePath.startsWith('http')
                  ? Image.asset(
                      item.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.image_not_supported_outlined, color: Colors.white54),
                      ),
                    )
                  : Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.image_not_supported_outlined, color: Colors.white54),
                    )),
        ),
      ),
    );
  }
}
