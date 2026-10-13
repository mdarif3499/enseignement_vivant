import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/core/localization/language_controller.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/routes/app_routes_file.dart';
import 'core/localization/app_translations.dart';
import 'core/localization/localization_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final savedLocale = await LocalizationService.getSavedLocale();
  Get.put(LanguageController(), permanent: true);

  runApp(MyApp(savedLocale: savedLocale));
}

class MyApp extends StatelessWidget {
  final Locale savedLocale;

  const MyApp({super.key, required this.savedLocale});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: savedLocale,
        fallbackLocale: LocalizationService.english,
        initialRoute: AppRoutes.splashScreen,
        getPages: appRouteFile,
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 400),
        theme: ThemeData(
          scaffoldBackgroundColor: ConstColor.primaryBackground,
          colorScheme: ColorScheme.fromSeed(
            seedColor: ConstColor.appColor,
            surface: ConstColor.primaryBackground,
          ),
        ),
      ),
    );
  }
}
