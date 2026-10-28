import 'package:get/get.dart';
import 'package:enseignement_vivant/core/localization/language_controller.dart';

class LanguageScreenController extends GetxController {
  final LanguageController languageController = Get.find<LanguageController>();
  late RxString tempSelectedLangCode;

  @override
  void onInit() {
    super.onInit();
    tempSelectedLangCode = languageController.selectedLanguage.value.obs;
  }

  void selectLanguage(String code) {
    tempSelectedLangCode.value = code;
  }

  Future<void> saveLanguage() async {
    await languageController.changeLanguage(tempSelectedLangCode.value);
    Get.back();
  }
}
