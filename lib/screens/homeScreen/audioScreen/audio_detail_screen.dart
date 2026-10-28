import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/services/audio_service/audio_service_controller.dart';
import 'package:enseignement_vivant/services/download/download_service.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/audio_screen_controller.dart';
import 'model/audio_item_model.dart';
import 'widget/audio_list_card.dart';

class AudioDetailScreen extends StatefulWidget {
  const AudioDetailScreen({super.key});

  @override
  State<AudioDetailScreen> createState() => _AudioDetailScreenState();
}

class _AudioDetailScreenState extends State<AudioDetailScreen> {
  late AudioItemModel item;
  bool isFavorite = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is AudioItemModel) {
      item = args;
      if (item.id.isNotEmpty) {
        fetchSingleAudioDetails(item.id);
      }
    } else if (args is String && args.isNotEmpty) {
      item = AudioItemModel(
        id: args,
        title: "Loading...",
        categoryTag: "audio",
        durationText: "0:00",
        subtitle: "",
        imagePath: "",
        audioUrl: "",
      );
      fetchSingleAudioDetails(args);
    } else if (args is Map && args['_id'] != null) {
      item = AudioItemModel.fromJson(args as Map<String, dynamic>);
      if (item.id.isNotEmpty) {
        fetchSingleAudioDetails(item.id);
      }
    } else {
      item = AudioItemModel(
        id: '1',
        title: "Listen to this prayer",
        categoryTag: "prayer",
        durationText: "15:45",
        subtitle: "A powerful morning prayer to help you start the day with faith and...",
        imagePath: "",
        audioUrl: "",
      );
    }
  }

  Future<void> fetchSingleAudioDetails(String audioId) async {
    if (audioId.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiServices.instance.getServices(
        "${AppApiEndPoint.instance.audio}/$audioId",
      );

      if (mounted && response != null && response['data'] != null && response['data'] is Map<String, dynamic>) {
        final freshItem = AudioItemModel.fromJson(response['data'] as Map<String, dynamic>);
        setState(() {
          item = freshItem;
        });
      }
    } catch (e) {
      errorLog("Fetch Single Audio Details Error", e);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioService = Get.find<AudioServiceController>();
    final audioScreenController = Get.isRegistered<AudioScreenController>()
        ? Get.find<AudioScreenController>()
        : Get.put(AudioScreenController());

    return Scaffold(
      backgroundColor: ConstColor.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: ConstColor.titleColor, size: 30),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            final downloadService = DownloadService.instance;
            final isDownloaded = downloadService.isDownloaded(item.id);
            final isDownloading = downloadService.isDownloading(item.id);

            return IconButton(
              icon: isDownloading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ConstColor.primaryTeal,
                        value: downloadService.downloadProgress[item.id],
                      ),
                    )
                  : Icon(
                      isDownloaded ? Icons.download_done_rounded : Icons.file_download_outlined,
                      color: isDownloaded ? ConstColor.primaryTeal : ConstColor.titleColor,
                      size: 26.sp,
                    ),
              onPressed: () {
                if (!isDownloaded && !isDownloading) {
                  downloadService.startDownload(
                    id: item.id,
                    title: item.title,
                    subtitle: item.subtitle,
                    categoryTag: item.categoryTag.isNotEmpty ? item.categoryTag : 'Audio',
                    imagePath: item.imagePath,
                    downloadUrl: item.audioUrl,
                    durationText: item.durationText,
                    mediaType: 'AUDIO',
                  );
                }
              },
            );
          }),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Column(
            children: [
              /// Top Large Cover Thumbnail Card
              Container(
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: item.imagePath.startsWith('http://') || item.imagePath.startsWith('https://')
                      ? Image.network(
                          item.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: const Color(0xFFE0F2F1),
                            child: Icon(Icons.music_note_rounded, color: ConstColor.primaryTeal, size: 60.sp),
                          ),
                        )
                      : (item.imagePath.isNotEmpty
                          ? Image.asset(
                              item.imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: const Color(0xFFE0F2F1),
                                child: Icon(Icons.music_note_rounded, color: ConstColor.primaryTeal, size: 60.sp),
                              ),
                            )
                          : Container(
                              color: const Color(0xFFE0F2F1),
                              child: Icon(Icons.music_note_rounded, color: ConstColor.primaryTeal, size: 60.sp),
                            )),
                ),
              ),

              Gap(height: 20.h),

              /// Audio Title & Author
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: ConstColor.titleColor,
                  fontFamily: 'SFPro',
                ),
              ),
              Gap(height: 4.h),
              Text(
                item.categoryTag.isNotEmpty ? item.categoryTag : "Audio",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF8E8E93),
                  fontFamily: 'SFPro',
                ),
              ),

              Gap(height: 20.h),

              /// Interactive Seek Slider & Time Labels
              Obx(() {
                final isCurrent = audioService.currentPlayingId.value == item.id;
                final totalSec = (isCurrent && audioService.duration.value.inSeconds > 0)
                    ? audioService.duration.value.inSeconds.toDouble()
                    : 100.0;
                final currentSec = (isCurrent
                        ? audioService.position.value.inSeconds.toDouble()
                        : 0.0)
                    .clamp(0.0, totalSec);

                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3.h,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
                        activeTrackColor: ConstColor.primaryTeal,
                        inactiveTrackColor: const Color(0xFFE5E7EB),
                        thumbColor: ConstColor.primaryTeal,
                      ),
                      child: Slider(
                        value: currentSec,
                        min: 0.0,
                        max: totalSec,
                        onChanged: (val) {
                          if (isCurrent) {
                            audioService.seekAudio(Duration(seconds: val.toInt()));
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isCurrent
                                ? audioService.formatDuration(audioService.position.value)
                                : "0:00",
                            style: TextStyle(fontSize: 11.sp, color: const Color(0xFF8E8E93)),
                          ),
                          Text(
                            isCurrent
                                ? audioService.formatDuration(audioService.duration.value)
                                : item.durationText,
                            style: TextStyle(fontSize: 11.sp, color: const Color(0xFF8E8E93)),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),

              Gap(height: 16.h),

              /// Audio Player Control Buttons Row (-15s, Prev, Play/Pause, Next, +15s)
              Obx(() {
                final isCurrentPlaying =
                    audioService.currentPlayingId.value == item.id && audioService.isPlaying.value;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /// Rewind 15s
                    IconButton(
                      icon: Icon(Icons.replay_10_rounded, color: const Color(0xFF48484A), size: 24.sp),
                      onPressed: () {
                        final newPos = audioService.position.value - const Duration(seconds: 15);
                        audioService.seekAudio(newPos < Duration.zero ? Duration.zero : newPos);
                      },
                    ),

                    /// Skip Prev
                    IconButton(
                      icon: Icon(Icons.skip_previous_rounded, color: const Color(0xFF48484A), size: 28.sp),
                      onPressed: () {},
                    ),

                    /// Play/Pause Main Circular Button
                    GestureDetector(
                      onTap: () {
                        audioService.playAudio(url: item.audioUrl, id: item.id);
                      },
                      child: Container(
                        width: 56.w,
                        height: 56.h,
                        decoration: const BoxDecoration(
                          color: ConstColor.primaryTeal,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            isCurrentPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 32.sp,
                          ),
                        ),
                      ),
                    ),

                    /// Skip Next
                    IconButton(
                      icon: Icon(Icons.skip_next_rounded, color: const Color(0xFF48484A), size: 28.sp),
                      onPressed: () {},
                    ),

                    /// Forward 15s
                    IconButton(
                      icon: Icon(Icons.forward_10_rounded, color: const Color(0xFF48484A), size: 24.sp),
                      onPressed: () {
                        final newPos = audioService.position.value + const Duration(seconds: 15);
                        audioService.seekAudio(newPos);
                      },
                    ),
                  ],
                );
              }),

              Gap(height: 20.h),

              /// Actions Row Capsule (Favorite, Download, Share)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFF4),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      child: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorite ? Colors.redAccent : const Color(0xFF48484A),
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 32.w),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.file_download_outlined,
                        color: const Color(0xFF48484A),
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 32.w),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.share_outlined,
                        color: const Color(0xFF48484A),
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),

              Gap(height: 30.h),

              /// Related Prayers Section Header
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ConstString.relatedPrayers.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: ConstColor.titleColor,
                    fontFamily: 'SFPro',
                  ),
                ),
              ),

              Gap(height: 14.h),

              /// Related Prayers Audio List
              Obx(
                () => ListView.builder(
                  itemCount: audioScreenController.allAudioList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final relItem = audioScreenController.allAudioList[index];
                    return AudioListCard(
                      item: relItem,
                      onTap: () {
                        setState(() {
                          item = relItem;
                        });
                        if (relItem.id.isNotEmpty) {
                          fetchSingleAudioDetails(relItem.id);
                        }
                      },
                    );
                  },
                ),
              ),

              Gap(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
