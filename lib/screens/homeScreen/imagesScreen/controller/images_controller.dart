import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_assert_image.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import '../model/image_item_model.dart';

class ImagesController extends GetxController {
  final RxString selectedCategory = ConstString.all.obs;

  final RxList<ImageItemModel> allImages = <ImageItemModel>[].obs;
  final RxList<ImageItemModel> filteredImages = <ImageItemModel>[].obs;

  final List<String> categories = [
    ConstString.all,
    ConstString.prayer,
    ConstString.audio,
    ConstString.encouragement,
  ];

  @override
  void onInit() {
    super.onInit();
    loadImages();
  }

  void loadImages() {
    final list = [
      ImageItemModel(
        id: '1',
        title: ConstString.morningMercy.tr,
        categoryTag: ConstString.prayer,
        imagePath: ImageString.tempItem4,
      ),
      ImageItemModel(
        id: '2',
        title: ConstString.morningMercy.tr,
        categoryTag: ConstString.audio,
        imagePath: ImageString.tempItem5,
      ),
      ImageItemModel(
        id: '3',
        title: ConstString.morningMercy.tr,
        categoryTag: ConstString.encouragement,
        imagePath: ImageString.tempItem6,
      ),
      ImageItemModel(
        id: '4',
        title: ConstString.morningMercy.tr,
        categoryTag: ConstString.prayer,
        imagePath: ImageString.tempItem7,
      ),
      ImageItemModel(
        id: '5',
        title: ConstString.morningMercy.tr,
        categoryTag: ConstString.audio,
        imagePath: ImageString.tempItem1,
      ),
      ImageItemModel(
        id: '6',
        title: ConstString.morningMercy.tr,
        categoryTag: ConstString.encouragement,
        imagePath: ImageString.tempItem2,
      ),
    ];

    allImages.assignAll(list);
    filteredImages.assignAll(list);
  }

  void filterByCategory(String cat) {
    selectedCategory.value = cat;
    if (cat == ConstString.all) {
      filteredImages.assignAll(allImages);
    } else {
      filteredImages.assignAll(
        allImages.where((item) => item.categoryTag == cat).toList(),
      );
    }
  }
}
