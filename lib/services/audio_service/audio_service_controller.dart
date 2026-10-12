import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class AudioServiceController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();

  final RxBool isPlaying = false.obs;
  final RxString currentPlayingId = ''.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final Rx<Duration> position = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();

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
    if (currentPlayingId.value == id && isPlaying.value) {
      await audioPlayer.pause();
    } else if (currentPlayingId.value == id && !isPlaying.value) {
      await audioPlayer.resume();
    } else {
      currentPlayingId.value = id;
      await audioPlayer.stop();
      await audioPlayer.play(UrlSource(url));
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
