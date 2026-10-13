import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_assert_image.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/screens/homeScreen/audioScreen/model/audio_item_model.dart';

class DownloadsController extends GetxController {
  final RxString selectedCategory = ConstString.all.obs;

  final RxList<AudioItemModel> allDownloads = <AudioItemModel>[].obs;
  final RxList<AudioItemModel> filteredDownloads = <AudioItemModel>[].obs;

  final List<String> categories = [
    ConstString.all,
    ConstString.prayer,
    ConstString.audio,
    ConstString.encouragement,
  ];

  static const String demoAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3';

  @override
  void onInit() {
    super.onInit();
    loadDownloads();
  }

  void loadDownloads() {
    final list = [
      AudioItemModel(
        id: '1',
        title: ConstString.listenToPrayer.tr,
        categoryTag: ConstString.prayer,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem,
        audioUrl: demoAudioUrl,
      ),
      AudioItemModel(
        id: '2',
        title: ConstString.listenToPrayer.tr,
        categoryTag: ConstString.audio,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem1,
        audioUrl: demoAudioUrl,
      ),
      AudioItemModel(
        id: '3',
        title: ConstString.listenToPrayer.tr,
        categoryTag: ConstString.encouragement,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem2,
        audioUrl: demoAudioUrl,
      ),
      AudioItemModel(
        id: '4',
        title: ConstString.listenToPrayer.tr,
        categoryTag: ConstString.prayer,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem3,
        audioUrl: demoAudioUrl,
      ),
      AudioItemModel(
        id: '5',
        title: ConstString.listenToPrayer.tr,
        categoryTag: ConstString.audio,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem4,
        audioUrl: demoAudioUrl,
      ),
      AudioItemModel(
        id: '6',
        title: ConstString.listenToPrayer.tr,
        categoryTag: ConstString.encouragement,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem5,
        audioUrl: demoAudioUrl,
      ),
    ];

    allDownloads.assignAll(list);
    _applyFilter();
  }

  void filterByCategory(String cat) {
    selectedCategory.value = cat;
    _applyFilter();
  }

  void _applyFilter() {
    final cat = selectedCategory.value;
    if (cat == ConstString.all) {
      filteredDownloads.assignAll(allDownloads);
    } else {
      filteredDownloads.assignAll(
        allDownloads.where((item) => item.categoryTag == cat).toList(),
      );
    }
  }
}
