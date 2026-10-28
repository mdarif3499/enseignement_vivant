import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import 'package:enseignement_vivant/screens/homeScreen/audioScreen/model/audio_item_model.dart';
import 'package:enseignement_vivant/services/download/download_service.dart';

class DownloadsController extends GetxController {
  final DownloadService _downloadService = DownloadService.instance;

  final RxString selectedCategory = ConstString.all.obs;

  RxList<DownloadedMediaModel> get downloadedItems => _downloadService.downloadedItems;

  final RxList<AudioItemModel> filteredDownloads = <AudioItemModel>[].obs;

  final List<String> categories = [
    ConstString.all,
    ConstString.prayer,
    ConstString.audio,
    ConstString.encouragement,
    ConstString.teachings,
  ];

  @override
  void onInit() {
    super.onInit();
    _downloadService.loadDownloadedItems();
    ever(downloadedItems, (_) => _applyFilter());
    ever(selectedCategory, (_) => _applyFilter());
    _applyFilter();
  }

  void filterByCategory(String cat) {
    selectedCategory.value = cat;
    _applyFilter();
  }

  void _applyFilter() {
    final cat = selectedCategory.value;
    final convertedList = downloadedItems.map((item) {
      return AudioItemModel(
        id: item.id,
        title: item.title,
        categoryTag: item.categoryTag,
        durationText: item.durationText.isNotEmpty ? item.durationText : '0:00',
        subtitle: item.subtitle,
        imagePath: item.imagePath,
        audioUrl: item.localFilePath,
      );
    }).toList();

    if (cat == ConstString.all) {
      filteredDownloads.assignAll(convertedList);
    } else {
      filteredDownloads.assignAll(
        convertedList.where((item) => item.categoryTag.toLowerCase() == cat.toLowerCase()).toList(),
      );
    }
  }

  Future<void> onDeleteItem(String id) async {
    final item = downloadedItems.firstWhereOrNull((element) => element.id == id);
    if (item != null) {
      await _downloadService.deleteDownloadedItem(item);
    }
  }
}
