import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_assert_image.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';
import '../model/encouragement_model.dart';

class EncouragementsController extends GetxController {
  final RxList<EncouragementModel> list = <EncouragementModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  void loadItems() {
    list.assignAll([
      EncouragementModel(
        title: ConstString.hope.tr,
        subtitle: ConstString.encouragementSubtitle.tr,
        imagePath: ImageString.tempItem1,
      ),
      EncouragementModel(
        title: ConstString.godIsGood.tr,
        subtitle: ConstString.encouragementSubtitle.tr,
        imagePath: ImageString.tempItem2,
      ),
      EncouragementModel(
        title: ConstString.faithOverFear.tr,
        subtitle: ConstString.encouragementSubtitle.tr,
        imagePath: ImageString.tempItem3,
      ),
    ]);
  }
}
