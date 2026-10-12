import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_assert_image.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import '../model/prayer_category_model.dart';

class PrayersController extends GetxController {
  final RxList<PrayerCategoryModel> prayerCategories = <PrayerCategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPrayerCategories();
  }

  void loadPrayerCategories() {
    prayerCategories.assignAll([
      PrayerCategoryModel(
        title: ConstString.morningPrayer.tr,
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem,
      ),
      PrayerCategoryModel(
        title: ConstString.anxietyPeace.tr,
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem,
      ),
      PrayerCategoryModel(
        title: ConstString.gratitude.tr,
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem,
      ),
      PrayerCategoryModel(
        title: ConstString.forgiveness.tr,
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem,
      ),
      PrayerCategoryModel(
        title: ConstString.strength.tr,
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem,
      ),
      PrayerCategoryModel(
        title: ConstString.griefLoss.tr,
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem,
      ),
      PrayerCategoryModel(
        title: ConstString.eveningPrayer.tr,
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem,
      ),
      PrayerCategoryModel(
        title: ConstString.faithTrust.tr,
        subtitle: ConstString.prayersSubtitle.tr,
        imagePath: ImageString.tempItem,
      ),
    ]);
  }
}
