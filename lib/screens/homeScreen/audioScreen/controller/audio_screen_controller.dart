import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import '../model/audio_item_model.dart';

class AudioScreenController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxBool isSearching = false.obs;
  final RxBool isLoading = false.obs;

  final RxString selectedCategory = ConstString.all.obs;

  final RxList<AudioItemModel> allAudioList = <AudioItemModel>[].obs;
  final RxList<AudioItemModel> filteredAudioList = <AudioItemModel>[].obs;

  final RxList<String> categories = <String>[
    ConstString.all,
    ConstString.prayer,
    ConstString.audio,
    ConstString.encouragement,
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAudioList();
  }

  Future<void> fetchAudioList() async {
    isLoading.value = true;
    try {
      final queryParams = <String, dynamic>{
        "status": "published",
      };

      if (selectedCategory.value != ConstString.all &&
          selectedCategory.value.trim().isNotEmpty) {
        queryParams["category"] = selectedCategory.value.trim();
      }

      final response = await ApiServices.instance.getServices(
        AppApiEndPoint.instance.audio,
        queryParameters: queryParams,
      );

      if (isClosed) return;

      if (response != null && response['data'] != null && response['data'] is List) {
        final List listData = response['data'];
        final audios = listData
            .map((item) => AudioItemModel.fromJson(item as Map<String, dynamic>))
            .toList();

        allAudioList.assignAll(audios);

        // Dynamically collect unique categories from items
        final catSet = <String>{ConstString.all, "Worship", "Prayer", "Encouragement"};
        for (var item in audios) {
          if (item.categoryTag.isNotEmpty) {
            catSet.add(item.categoryTag);
          }
        }
        categories.assignAll(catSet.toList());

        _applySearchFilter();
      } else {
        allAudioList.clear();
        filteredAudioList.clear();
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('Fetch Audio List Error', e);
      allAudioList.clear();
      filteredAudioList.clear();
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  void filterByCategory(String cat) {
    if (selectedCategory.value == cat) return;
    selectedCategory.value = cat;
    fetchAudioList();
  }

  void filterBySearch(String query) {
    _applySearchFilter();
  }

  void _applySearchFilter() {
    final query = searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      filteredAudioList.assignAll(allAudioList);
    } else {
      filteredAudioList.assignAll(
        allAudioList.where((item) {
          return item.title.toLowerCase().contains(query) ||
              item.subtitle.toLowerCase().contains(query) ||
              item.categoryTag.toLowerCase().contains(query) ||
              item.contentText.toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchController.clear();
      _applySearchFilter();
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
