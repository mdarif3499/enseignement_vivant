import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_assert_image.dart';
import '../model/verse_item_model.dart';

class VerseOfDayController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final RxList<VerseItemModel> verseItems = <VerseItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadVerseItems();
  }

  void loadVerseItems() {
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
      VerseItemModel(
        id: '4',
        verseText: "JE PUIS TOUT PAR CELUI QUI ME FORTIFIE.",
        verseReference: "PHILIPPIENS 4:13",
        imagePath: ImageString.tempItem4,
      ),
    ]);
  }

  void selectVerse(int index) {
    selectedIndex.value = index;
  }

  VerseItemModel get currentVerse => verseItems[selectedIndex.value];
}
