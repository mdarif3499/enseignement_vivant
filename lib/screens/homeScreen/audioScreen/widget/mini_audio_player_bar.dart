import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/services/audio_service/audio_service_controller.dart';
import '../model/audio_item_model.dart';

class MiniAudioPlayerBar extends StatelessWidget {
  final AudioItemModel item;

  const MiniAudioPlayerBar({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final audioService = Get.find<AudioServiceController>();

    return Obx(() {
      if (audioService.currentPlayingId.value.isEmpty) {
        return const SizedBox.shrink();
      }

      final isPlaying = audioService.isPlaying.value;
      final totalSeconds = audioService.duration.value.inSeconds > 0
          ? audioService.duration.value.inSeconds
          : 1;
      final currentSeconds = audioService.position.value.inSeconds.clamp(0, totalSeconds);
      final double progress = (currentSeconds / totalSeconds).clamp(0.0, 1.0);

      return GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.audioDetailScreen, arguments: item);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: ConstColor.primaryTeal,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: ConstColor.primaryTeal.withAlpha(90),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              /// Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: item.imagePath.startsWith('http://') || item.imagePath.startsWith('https://')
                    ? Image.network(
                        item.imagePath,
                        width: 48.w,
                        height: 48.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 48.w,
                          height: 48.h,
                          color: const Color(0xFF0F6E65),
                          child: Icon(Icons.music_note_rounded, color: Colors.white, size: 24.sp),
                        ),
                      )
                    : (item.imagePath.isNotEmpty && !item.imagePath.startsWith('http')
                        ? Image.asset(
                            item.imagePath,
                            width: 48.w,
                            height: 48.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 48.w,
                              height: 48.h,
                              color: const Color(0xFF0F6E65),
                              child: Icon(Icons.music_note_rounded, color: Colors.white, size: 24.sp),
                            ),
                          )
                        : Container(
                            width: 48.w,
                            height: 48.h,
                            color: const Color(0xFF0F6E65),
                            child: Icon(Icons.music_note_rounded, color: Colors.white, size: 24.sp),
                          )),
              ),

              SizedBox(width: 12.w),

              /// Middle Title & Slider
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'SFPro',
                      ),
                    ),
                    SizedBox(height: 2.h),

                    /// Subtitle Category & Duration
                    Text(
                      "${item.categoryTag.isNotEmpty ? item.categoryTag : 'Audio'}${audioService.duration.value.inSeconds > 0 ? ' • ${audioService.formatDuration(audioService.duration.value)}' : (item.durationText.isNotEmpty ? ' • ${item.durationText}' : '')}",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white70,
                        fontFamily: 'SFPro',
                      ),
                    ),

                    SizedBox(height: 4.h),

                    /// White Progress Line & Time
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2.r),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              minHeight: 3.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          audioService.formatDuration(audioService.position.value),
                          style: TextStyle(fontSize: 9.sp, color: Colors.white70),
                        ),
                        Text(
                          audioService.formatDuration(audioService.duration.value),
                          style: TextStyle(fontSize: 9.sp, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 12.w),

              /// Play/Pause Circular Button
              GestureDetector(
                onTap: () {
                  audioService.playAudio(url: item.audioUrl, id: item.id);
                },
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F6E65),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
