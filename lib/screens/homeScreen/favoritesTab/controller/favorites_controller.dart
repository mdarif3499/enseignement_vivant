import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/services/favorite/favorite_service.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import '../model/favorite_item_model.dart';

class FavoritesController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxBool isSearching = false.obs;
  final RxBool isLoading = false.obs;

  final RxString selectedCategory = ConstString.all.obs;

  final RxList<FavoriteItemModel> allFavorites = <FavoriteItemModel>[].obs;
  final RxList<FavoriteItemModel> filteredFavorites = <FavoriteItemModel>[].obs;

  final RxList<String> categories = <String>[
    ConstString.all,
    ConstString.prayer,
    ConstString.audio,
    ConstString.encouragement,
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    isLoading.value = true;
    try {
      final response = await ApiServices.instance.getServices(
        AppApiEndPoint.instance.favoriteEndpoint,
      );

      if (isClosed) return;

      if (response != null && response['data'] != null && response['data'] is List) {
        final List listData = response['data'];
        final items = listData
            .map((item) => FavoriteItemModel.fromJson(item as Map<String, dynamic>))
            .toList();

        allFavorites.assignAll(items);

        // Seed favorite IDs into FavoriteService
        for (var fav in items) {
          FavoriteService.instance.seedFavorite(fav.postId, true);
        }

        // Collect unique categories
        final catSet = <String>{ConstString.all, "Prayer", "Audio", "Encouragement", "Teaching", "Image", "Verse"};
        for (var fav in items) {
          if (fav.categoryTag.isNotEmpty) {
            catSet.add(fav.categoryTag);
          }
        }
        categories.assignAll(catSet.toList());

        _applyFilter();
      } else {
        allFavorites.clear();
        filteredFavorites.clear();
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('Fetch Favorites Error', e);
      allFavorites.clear();
      filteredFavorites.clear();
    } finally {
      if (!isClosed) isLoading.value = false;
    }
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
        final matchesCat = cat == ConstString.all || item.categoryTag.toLowerCase() == cat.toLowerCase();
        final matchesSearch = query.isEmpty ||
            item.title.toLowerCase().contains(query) ||
            item.subtitle.toLowerCase().contains(query);
        return matchesCat && matchesSearch;
      }).toList(),
    );
  }

  Future<void> removeFavorite(FavoriteItemModel item) async {
    allFavorites.removeWhere((element) => element.id == item.id || element.postId == item.postId);
    _applyFilter();

    await FavoriteService.instance.toggleFavorite(
      id: item.postId,
      postType: item.postType,
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
