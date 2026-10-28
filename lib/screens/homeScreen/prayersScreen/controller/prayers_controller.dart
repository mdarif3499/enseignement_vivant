import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/constant/app_assert_image.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import '../model/prayer_category_model.dart';

class PrayersController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxBool isSearching = false.obs;
  final RxBool isLoading = false.obs;

  final RxList<PrayerCategoryModel> allCategories = <PrayerCategoryModel>[].obs;
  final RxList<PrayerCategoryModel> filteredCategories = <PrayerCategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrayers();
  }

  Future<void> fetchPrayers() async {
    isLoading.value = true;
    try {
      final response = await ApiServices.instance.getServices(
        AppApiEndPoint.instance.prayer,
        queryParameters: {
          "status": "published",
        },
      );

      if (isClosed) return;

      if (response != null && response['data'] != null && response['data'] is List) {
        final List listData = response['data'];
        final prayers = listData
            .map((item) => PrayerCategoryModel.fromJson(item as Map<String, dynamic>))
            .toList();

        allCategories.assignAll(prayers);
        filteredCategories.assignAll(prayers);
      } else {
        allCategories.clear();
        filteredCategories.clear();
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('Fetch Prayers Error', e);
      allCategories.clear();
      filteredCategories.clear();
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  void loadFallbackCategories() {
    final list = [
      PrayerCategoryModel(
        title: ConstString.morningPrayer.tr,
        subtitle: ConstString.prayersSubtitle.tr,
        coverImage: ImageString.tempItem,
      ),
      PrayerCategoryModel(
        title: ConstString.anxietyPeace.tr,
        subtitle: ConstString.prayersSubtitle.tr,
        coverImage: ImageString.tempItem,
      ),
      PrayerCategoryModel(
        title: ConstString.gratitude.tr,
        subtitle: ConstString.prayersSubtitle.tr,
        coverImage: ImageString.tempItem,
      ),
      PrayerCategoryModel(
        title: ConstString.forgiveness.tr,
        subtitle: ConstString.prayersSubtitle.tr,
        coverImage: ImageString.tempItem,
      ),
      PrayerCategoryModel(
        title: ConstString.strength.tr,
        subtitle: ConstString.prayersSubtitle.tr,
        coverImage: ImageString.tempItem,
      ),
      PrayerCategoryModel(
        title: ConstString.griefLoss.tr,
        subtitle: ConstString.prayersSubtitle.tr,
        coverImage: ImageString.tempItem,
      ),
      PrayerCategoryModel(
        title: ConstString.eveningPrayer.tr,
        subtitle: ConstString.prayersSubtitle.tr,
        coverImage: ImageString.tempItem,
      ),
      PrayerCategoryModel(
        title: ConstString.faithTrust.tr,
        subtitle: ConstString.prayersSubtitle.tr,
        coverImage: ImageString.tempItem,
      ),
    ];

    allCategories.assignAll(list);
    filteredCategories.assignAll(list);
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchController.clear();
      filteredCategories.assignAll(allCategories);
    }
  }

  void filterCategories(String query) {
    if (query.trim().isEmpty) {
      filteredCategories.assignAll(allCategories);
    } else {
      final q = query.toLowerCase();
      filteredCategories.assignAll(
        allCategories.where((item) =>
          item.title.toLowerCase().contains(q) ||
          item.subtitle.toLowerCase().contains(q) ||
          item.prayerText.toLowerCase().contains(q)
        ).toList(),
      );
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
