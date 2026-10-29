import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/constant/app_assert_image.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import '../model/verse_item_model.dart';

class VerseOfDayController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final RxList<VerseItemModel> verseItems = <VerseItemModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVersesAndImages();
  }

  Future<void> fetchVersesAndImages() async {
    isLoading.value = true;
    try {
      // 1. Fetch Scheduled Images API
      final imagesResponse = await ApiServices.instance.getServices(
        AppApiEndPoint.instance.imageEndpoint,
        queryParameters: {
          "status": "scheduled",
        },
      );

      // 2. Fetch Verse API
      final versesResponse = await ApiServices.instance.getServices(
        AppApiEndPoint.instance.verseEndpoint,
      );

      if (isClosed) return;

      List<Map<String, dynamic>> rawImages = [];
      if (imagesResponse != null && imagesResponse['data'] != null && imagesResponse['data'] is List) {
        rawImages = List<Map<String, dynamic>>.from(imagesResponse['data']);
      }

      List<Map<String, dynamic>> rawVerses = [];
      if (versesResponse != null && versesResponse['data'] != null && versesResponse['data'] is List) {
        rawVerses = List<Map<String, dynamic>>.from(versesResponse['data']);
      }

      final List<VerseItemModel> list = [];

      final int totalItems = rawImages.isNotEmpty
          ? rawImages.length
          : (rawVerses.isNotEmpty ? rawVerses.length : 0);

      if (totalItems > 0) {
        for (int i = 0; i < totalItems; i++) {
          // Extract Image for index i
          String imgPath = '';
          if (rawImages.isNotEmpty) {
            final imgObj = rawImages[i % rawImages.length];
            imgPath = imgObj['image']?.toString() ?? imgObj['coverImage']?.toString() ?? '';
            if (imgPath.isNotEmpty && !imgPath.startsWith('http')) {
              if (imgPath.startsWith('/files/')) {
                imgPath = "${AppApiEndPoint.instance.domain}$imgPath";
              } else if (imgPath.startsWith('/')) {
                imgPath = "${AppApiEndPoint.instance.imageBaseUrl}$imgPath";
              } else {
                imgPath = "${AppApiEndPoint.instance.imageBaseUrl}/$imgPath";
              }
            }
          }

          if (imgPath.isEmpty) {
            imgPath = ImageString.tempItem3;
          }

          // Extract Verse Content & Reference for index i
          String vContent = '';
          String vReference = '';
          String vCategory = 'VERSE OF THE DAY';
          String itemId = 'verse_item_$i';

          if (rawVerses.isNotEmpty) {
            final verseObj = rawVerses[i % rawVerses.length];
            vContent = verseObj['content']?.toString() ?? '';
            vReference = verseObj['reference']?.toString() ?? '';
            if (verseObj['_id'] != null) {
              itemId = "${verseObj['_id']}_$i";
            }
          }

          if (vContent.isEmpty) {
            vContent = "TA PAROLE EST UNE LAMPE À MES PIEDS, ET UNE LUMIÈRE SUR MON SENTIER.";
          }
          if (vReference.isEmpty) {
            vReference = "PSAUME 119:105";
          }

          list.add(
            VerseItemModel(
              id: itemId,
              categoryTag: vCategory,
              verseText: vContent,
              verseReference: vReference,
              imagePath: imgPath,
            ),
          );
        }
      }

      if (list.isNotEmpty) {
        verseItems.assignAll(list);
      } else {
        _loadFallbackVerseItems();
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('Fetch Verses And Images Error', e);
      _loadFallbackVerseItems();
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  void _loadFallbackVerseItems() {
    verseItems.assignAll([
      VerseItemModel(
        id: '1',
        verseText: "TA PAROLE EST UNE LAMPE\nÀ MES PIEDS, ET UNE LUMIÈRE\nSUR MON SENTIER.",
        verseReference: "PSAUME 119:105",
        imagePath: ImageString.tempItem3,
      ),
      VerseItemModel(
        id: '2',
        verseText: "CAR DIEU A TANT AIMÉ LE MONDE\nQU'IL A DONNÉ SON FILS UNIQUE.",
        verseReference: "JEAN 3:16",
        imagePath: ImageString.tempItem1,
      ),
      VerseItemModel(
        id: '3',
        verseText: "LE SEIGNEUR EST MON BERGER:\nJE NE MANQUERAI DE RIEN.",
        verseReference: "PSAUME 23:1",
        imagePath: ImageString.tempItem2,
      ),
    ]);
  }

  void selectVerse(int index) {
    if (index >= 0 && index < verseItems.length) {
      selectedIndex.value = index;
    }
  }

  VerseItemModel get currentVerse {
    if (verseItems.isEmpty) {
      return VerseItemModel(
        id: '0',
        verseText: "TA PAROLE EST UNE LAMPE À MES PIEDS",
        verseReference: "PSAUME 119:105",
        imagePath: ImageString.tempItem3,
      );
    }
    final idx = selectedIndex.value.clamp(0, verseItems.length - 1);
    return verseItems[idx];
  }
}
