import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_controller.dart';

class LocalizationService {
  static const String _keyLanguage = 'selected_language';

  static const Locale english = Locale('en', 'US');
  static const Locale french = Locale('fr', 'FR');
  static const List<Locale> supportedLocales = [english, french];

  /// Reads initial saved locale from SharedPreferences at main()
  static Future<Locale> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_keyLanguage) ?? 'en';
    return savedCode == 'fr' ? french : english;
  }

  /// Change language permanently using LanguageController / SharedPreferences
  static Future<void> changeLanguage(String languageCode) async {
    if (Get.isRegistered<LanguageController>()) {
      await Get.find<LanguageController>().changeLanguage(languageCode);
    } else {
      final controller = Get.put(LanguageController(), permanent: true);
      await controller.changeLanguage(languageCode);
    }
  }

  static String currentLanguageCode() {
    if (Get.isRegistered<LanguageController>()) {
      return Get.find<LanguageController>().selectedLanguage.value;
    }
    return 'en';
  }

  static bool isFrench() => currentLanguageCode() == 'fr';
}
