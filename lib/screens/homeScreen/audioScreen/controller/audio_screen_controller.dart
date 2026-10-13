import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_assert_image.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import '../model/audio_item_model.dart';

class AudioScreenController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxBool isSearching = false.obs;

  final RxString selectedCategory = ConstString.all.obs;

  final RxList<AudioItemModel> allAudioList = <AudioItemModel>[].obs;
  final RxList<AudioItemModel> filteredAudioList = <AudioItemModel>[].obs;

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
    loadAudioItems();
  }

  void loadAudioItems() {
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
    ];

    allAudioList.assignAll(list);
    _applyFilter();
  }

  void filterByCategory(String cat) {
    selectedCategory.value = cat;
    _applyFilter();
  }

  void filterBySearch(String query) {
    _applyFilter();
  }

  void _applyFilter() {
    final query = searchController.text.trim().toLowerCase();
    final cat = selectedCategory.value;

    filteredAudioList.assignAll(
      allAudioList.where((item) {
        final matchesCat = cat == ConstString.all || item.categoryTag == cat;
        final matchesSearch = query.isEmpty ||
            item.title.toLowerCase().contains(query) ||
            item.subtitle.toLowerCase().contains(query);
        return matchesCat && matchesSearch;
      }).toList(),
    );
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchController.clear();
      _applyFilter();
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
