import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const String _keyLanguage = 'selected_language';

  final RxString selectedLanguage = 'fr'.obs; // Default: French

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
    final savedCode = prefs.getString(_keyLanguage) ?? 'fr';
    selectedLanguage.value = savedCode;

    final locale = savedCode == 'en' ? english : french;
    Get.updateLocale(locale);
  }

  /// Change and save language permanently to SharedPreferences
  Future<void> changeLanguage(String langCode) async {
    selectedLanguage.value = langCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, langCode);

    final locale = langCode == 'en' ? english : french;
    Get.updateLocale(locale);
  }

  bool get isFrench => selectedLanguage.value == 'fr';
  bool get isEnglish => selectedLanguage.value == 'en';
}
