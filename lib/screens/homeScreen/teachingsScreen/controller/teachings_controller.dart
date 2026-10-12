import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_assert_image.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import '../model/teaching_model.dart';

class TeachingsController extends GetxController {
  final RxList<TeachingModel> teachingsList = <TeachingModel>[].obs;
  static const String demoAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3';

  @override
  void onInit() {
    super.onInit();
    loadTeachings();
  }

  void loadTeachings() {
    teachingsList.assignAll([
      TeachingModel(
        id: '1',
        title: ConstString.listenToPrayer.tr,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem,
        audioUrl: demoAudioUrl,
      ),
      TeachingModel(
        id: '2',
        title: ConstString.listenToPrayer.tr,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem1,
        audioUrl: demoAudioUrl,
      ),
      TeachingModel(
        id: '3',
        title: ConstString.listenToPrayer.tr,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem2,
        audioUrl: demoAudioUrl,
      ),
      TeachingModel(
        id: '4',
        title: ConstString.listenToPrayer.tr,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem3,
        audioUrl: demoAudioUrl,
      ),
      TeachingModel(
        id: '5',
        title: ConstString.listenToPrayer.tr,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem1,
        audioUrl: demoAudioUrl,
      ),
      TeachingModel(
        id: '6',
        title: ConstString.listenToPrayer.tr,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem2,
        audioUrl: demoAudioUrl,
      ),
      TeachingModel(
        id: '7',
        title: ConstString.listenToPrayer.tr,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem3,
        audioUrl: demoAudioUrl,
      ),
    ]);
  }
}
