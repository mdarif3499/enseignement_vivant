import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const String _keyLanguage = 'selected_language';

  final RxString selectedLanguage = 'en'.obs;

  static const Locale english = Locale('en', 'US');
  static const Locale french = Locale('fr', 'FR');

  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
  }

  /// Load language from SharedPreferences
  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_keyLanguage) ?? 'en';
    final languageCode = savedCode == 'fr' ? 'fr' : 'en';
    selectedLanguage.value = languageCode;

    Get.updateLocale(languageCode == 'fr' ? french : english);
  }

  /// Change and save language permanently to SharedPreferences
  Future<void> changeLanguage(String langCode) async {
    final languageCode = langCode == 'fr' ? 'fr' : 'en';
    selectedLanguage.value = languageCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, languageCode);

    Get.updateLocale(languageCode == 'fr' ? french : english);
  }

  bool get isFrench => selectedLanguage.value == 'fr';
  bool get isEnglish => selectedLanguage.value == 'en';
}
