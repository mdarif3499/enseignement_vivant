import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import '../model/image_item_model.dart';

class ImagesController extends GetxController {
  final RxString selectedCategory = ConstString.all.obs;
  final RxBool isLoading = false.obs;

  final RxList<ImageItemModel> allImages = <ImageItemModel>[].obs;
  final RxList<ImageItemModel> filteredImages = <ImageItemModel>[].obs;

  final RxList<String> categories = <String>[
    ConstString.all,
    ConstString.prayer,
    ConstString.audio,
    ConstString.encouragement,
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchImages();
  }

  Future<void> fetchImages() async {
    isLoading.value = true;
    try {
      final queryParams = <String, dynamic>{
        "status": "scheduled",
      };

      if (selectedCategory.value != ConstString.all &&
          selectedCategory.value.trim().isNotEmpty) {
        queryParams["category"] = selectedCategory.value.trim();
      }

      final response = await ApiServices.instance.getServices(
        AppApiEndPoint.instance.imageEndpoint,
        queryParameters: queryParams,
      );

      if (isClosed) return;

      if (response != null && response['data'] != null && response['data'] is List) {
        final List listData = response['data'];
        final items = listData
            .map((item) => ImageItemModel.fromJson(item as Map<String, dynamic>))
            .toList();

        allImages.assignAll(items);
        filteredImages.assignAll(items);

        // Dynamically collect unique categories from items
        final catSet = <String>{ConstString.all, "Prayer", "Audio", "Encouragement"};
        for (var item in items) {
          if (item.categoryTag.isNotEmpty) {
            catSet.add(item.categoryTag);
          }
        }
        categories.assignAll(catSet.toList());
      } else {
        allImages.clear();
        filteredImages.clear();
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('Fetch Images Error', e);
      allImages.clear();
      filteredImages.clear();
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  void filterByCategory(String cat) {
    if (selectedCategory.value == cat) return;
    selectedCategory.value = cat;
    fetchImages();
  }
}
