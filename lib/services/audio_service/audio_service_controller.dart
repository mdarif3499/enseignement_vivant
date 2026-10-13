import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/utils/app_log.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';

class AudioServiceController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();

  final RxBool isPlaying = false.obs;
  final RxString currentPlayingId = ''.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final Rx<Duration> position = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();

    AudioPlayer.global.setAudioContext(AudioContext(
      android: const AudioContextAndroid(
        stayAwake: true,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.gain,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: const {
          AVAudioSessionOptions.mixWithOthers,
        },
      ),
    ));

    audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      duration.value = newDuration;
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      position.value = newPosition;
    });
  }

  Future<void> playAudio({required String url, required String id}) async {
    String formattedUrl = url.trim();
    if (formattedUrl.isNotEmpty && !formattedUrl.startsWith('http')) {
      if (formattedUrl.startsWith('/files/')) {
        formattedUrl = "${AppApiEndPoint.instance.domain}$formattedUrl";
      } else if (formattedUrl.startsWith('/')) {
        formattedUrl = "${AppApiEndPoint.instance.imageBaseUrl}$formattedUrl";
      } else {
        formattedUrl = "${AppApiEndPoint.instance.imageBaseUrl}/$formattedUrl";
      }
    }

    try {
      if (currentPlayingId.value == id && isPlaying.value) {
        await audioPlayer.pause();
      } else if (currentPlayingId.value == id && !isPlaying.value) {
        await audioPlayer.resume();
      } else {
        currentPlayingId.value = id;
        await audioPlayer.stop();
        if (formattedUrl.isNotEmpty) {
          appLog("Playing Audio URL: $formattedUrl");
          String? mimeType;
          if (formattedUrl.endsWith('.mp3')) {
            mimeType = 'audio/mpeg';
          } else if (formattedUrl.endsWith('.wav')) {
            mimeType = 'audio/wav';
          } else if (formattedUrl.endsWith('.m4a') || formattedUrl.endsWith('.aac')) {
            mimeType = 'audio/mp4';
          } else if (formattedUrl.endsWith('.ogg')) {
            mimeType = 'audio/ogg';
          }

          await audioPlayer.play(
            UrlSource(formattedUrl, mimeType: mimeType),
          );
        } else {
          AppSnackBar.instance.error("Audio URL not available");
        }
      }
    } catch (e) {
      errorLog('Audio Player Play Error', e);
      AppSnackBar.instance.error("Unable to play audio");
    }
  }

  Future<void> pauseAudio() async {
    await audioPlayer.pause();
  }

  Future<void> resumeAudio() async {
    await audioPlayer.resume();
  }

  Future<void> seekAudio(Duration pos) async {
    await audioPlayer.seek(pos);
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.onClose();
  }
}
