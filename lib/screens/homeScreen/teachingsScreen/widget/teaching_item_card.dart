import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/services/audio_service/audio_service_controller.dart';
import '../model/teaching_model.dart';

class TeachingItemCard extends StatelessWidget {
  final TeachingModel item;
  final VoidCallback? onTap;

  const TeachingItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final audioService = Get.find<AudioServiceController>();

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Obx(() {
        final isCurrentPlaying =
            audioService.currentPlayingId.value == item.id && audioService.isPlaying.value;

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isCurrentPlaying ? const Color(0xFFE6F6F4) : Colors.white,
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
                /// Item Thumbnail with Equalizer indicator if playing
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: item.imagePath.startsWith('http://') || item.imagePath.startsWith('https://')
                          ? Image.network(
                              item.imagePath,
                              width: 65.w,
                              height: 65.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 65.w,
                                height: 65.h,
                                color: const Color(0xFFE0F2F1),
                                child: Icon(Icons.school_rounded, color: ConstColor.primaryTeal, size: 28.sp),
                              ),
                            )
                          : (item.imagePath.isNotEmpty && !item.imagePath.startsWith('http')
                              ? Image.asset(
                                  item.imagePath,
                                  width: 65.w,
                                  height: 65.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 65.w,
                                    height: 65.h,
                                    color: const Color(0xFFE0F2F1),
                                    child: Icon(Icons.school_rounded, color: ConstColor.primaryTeal, size: 28.sp),
                                  ),
                                )
                              : Container(
                                  width: 65.w,
                                  height: 65.h,
                                  color: const Color(0xFFE0F2F1),
                                  child: Icon(Icons.school_rounded, color: ConstColor.primaryTeal, size: 28.sp),
                                )),
                    ),
                    if (isCurrentPlaying)
                      Container(
                        padding: EdgeInsets.all(3.r),
                        margin: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(160),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Icon(
                          Icons.bar_chart_rounded,
                          color: ConstColor.primaryTeal,
                          size: 14.sp,
                        ),
                      ),
                  ],
                ),

                SizedBox(width: 14.w),

                /// Title, Duration & Subtitle Column
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

                      /// Duration Row
                      Builder(builder: (context) {
                        final displayDuration = (isCurrentPlaying && audioService.duration.value.inSeconds > 0)
                            ? audioService.formatDuration(audioService.duration.value)
                            : item.durationText;

                        if (displayDuration.isEmpty) return const SizedBox.shrink();

                        return Row(
                          children: [
                            Container(
                              width: 4.w,
                              height: 4.h,
                              decoration: const BoxDecoration(
                                color: Color(0xFF8E8E93),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              displayDuration,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFF7A7A7A),
                                fontFamily: 'SFPro',
                              ),
                            ),
                          ],
                        );
                      }),

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

                /// Play/Pause Circular Action Button
                GestureDetector(
                  onTap: () {
                    audioService.playAudio(url: item.audioUrl, id: item.id);
                  },
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: isCurrentPlaying ? ConstColor.primaryTeal : const Color(0xFFE0F2F1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        isCurrentPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: isCurrentPlaying ? Colors.white : ConstColor.primaryTeal,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
