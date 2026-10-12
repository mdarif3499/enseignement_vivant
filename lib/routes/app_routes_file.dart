import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/routes/authBindings.dart';
import 'package:enseignement_vivant/routes/splashBinding.dart';
import 'package:enseignement_vivant/screens/baseScreen/splashScreen/splashScreen.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/sign_in/sign_in_screen.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/sign_up/sign_up_screen.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/forgotPasswordScreen/forgotPasswordScreen.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/forgotVerifyOtpScreen/forgotVerifyOtpScreen.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/resetPasswordScreen/resetPasswordScreen.dart';
import 'package:enseignement_vivant/screens/homeScreen/prayersScreen/prayers_screen.dart';
import 'package:enseignement_vivant/screens/homeScreen/prayersScreen/prayer_detail_screen.dart';
import 'package:enseignement_vivant/screens/homeScreen/encouragementsScreen/encouragements_screen.dart';
import 'package:enseignement_vivant/screens/homeScreen/encouragementsScreen/encouragement_detail_screen.dart';
import 'package:enseignement_vivant/screens/homeScreen/teachingsScreen/teachings_screen.dart';
import 'package:enseignement_vivant/screens/homeScreen/teachingsScreen/teaching_detail_screen.dart';
import 'package:enseignement_vivant/screens/homeScreen/imagesScreen/images_screen.dart';
import 'package:enseignement_vivant/screens/homeScreen/imagesScreen/image_detail_screen.dart';
import 'package:enseignement_vivant/screens/homeScreen/verseOfDayScreen/verse_of_day_screen.dart';
import 'package:enseignement_vivant/screens/homeScreen/mainScreen/mainScreen.dart';

List<GetPage> appRouteFile = <GetPage>[
  GetPage(name: AppRoutes.splashScreen, page: () => const SplashScreen(), binding: SplashBinding()),
  GetPage(name: AppRoutes.signInScreen, page: () => const SignInScreen(), binding: AuthBindings()),
  GetPage(name: AppRoutes.signUpScreen, page: () => const SignUpScreen(), binding: AuthBindings()),
  GetPage(name: AppRoutes.forgotPasswordScreen, page: () => const ForgotPasswordScreen(), binding: AuthBindings()),
  GetPage(name: AppRoutes.forgotVerifyOtpScreen, page: () => const ForgotVerifyOtpScreen(), binding: AuthBindings()),
  GetPage(name: AppRoutes.resetPasswordScreen, page: () => const ResetPasswordScreen(), binding: AuthBindings()),
  GetPage(name: AppRoutes.prayersScreen, page: () => const PrayersScreen(), binding: AuthBindings()),
  GetPage(name: AppRoutes.prayerDetailScreen, page: () => const PrayerDetailScreen(), binding: AuthBindings()),
  GetPage(name: AppRoutes.encouragementsScreen, page: () => const EncouragementsScreen(), binding: AuthBindings()),
  GetPage(name: AppRoutes.encouragementDetailScreen, page: () => const EncouragementDetailScreen(), binding: AuthBindings()),
  GetPage(name: AppRoutes.teachingsScreen, page: () => const TeachingsScreen(), binding: AuthBindings()),
  GetPage(name: AppRoutes.teachingDetailScreen, page: () => const TeachingDetailScreen(), binding: AuthBindings()),
  GetPage(name: AppRoutes.imagesScreen, page: () => const ImagesScreen(), binding: AuthBindings()),
  GetPage(name: AppRoutes.imageDetailScreen, page: () => const ImageDetailScreen(), binding: AuthBindings()),
  GetPage(name: AppRoutes.verseOfDayScreen, page: () => const VerseOfDayScreen(), binding: AuthBindings()),
  GetPage(name: AppRoutes.mainScreen, page: () => const MainScreen(), binding: AuthBindings()),
];
