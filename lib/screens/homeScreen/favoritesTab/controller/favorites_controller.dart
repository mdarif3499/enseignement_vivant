import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_assert_image.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import '../model/favorite_item_model.dart';

class FavoritesController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxBool isSearching = false.obs;

  final RxString selectedCategory = ConstString.all.obs;

  final RxList<FavoriteItemModel> allFavorites = <FavoriteItemModel>[].obs;
  final RxList<FavoriteItemModel> filteredFavorites = <FavoriteItemModel>[].obs;

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
    loadFavorites();
  }

  void loadFavorites() {
    final list = [
      FavoriteItemModel(
        id: '1',
        title: ConstString.listenToPrayer.tr,
        categoryTag: ConstString.prayer,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem,
        audioUrl: demoAudioUrl,
      ),
      FavoriteItemModel(
        id: '2',
        title: ConstString.listenToPrayer.tr,
        categoryTag: ConstString.audio,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem1,
        audioUrl: demoAudioUrl,
      ),
      FavoriteItemModel(
        id: '3',
        title: ConstString.listenToPrayer.tr,
        categoryTag: ConstString.encouragement,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem2,
        audioUrl: demoAudioUrl,
      ),
      FavoriteItemModel(
        id: '4',
        title: ConstString.listenToPrayer.tr,
        categoryTag: ConstString.prayer,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem3,
        audioUrl: demoAudioUrl,
      ),
      FavoriteItemModel(
        id: '5',
        title: ConstString.listenToPrayer.tr,
        categoryTag: ConstString.audio,
        durationText: '15:45',
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem4,
        audioUrl: demoAudioUrl,
      ),
    ];

    allFavorites.assignAll(list);
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

    filteredFavorites.assignAll(
      allFavorites.where((item) {
        final matchesCat = cat == ConstString.all || item.categoryTag == cat;
        final matchesSearch = query.isEmpty ||
            item.title.toLowerCase().contains(query) ||
            item.subtitle.toLowerCase().contains(query);
        return matchesCat && matchesSearch;
      }).toList(),
    );
  }

  void removeFavorite(String id) {
    allFavorites.removeWhere((item) => item.id == id);
    _applyFilter();
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
