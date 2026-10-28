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
import 'package:enseignement_vivant/screens/homeScreen/audioScreen/audio_screen.dart';
import 'package:enseignement_vivant/screens/homeScreen/audioScreen/audio_detail_screen.dart';
import 'package:enseignement_vivant/screens/drawerScreens/downloadsScreen/downloads_screen.dart';
import 'package:enseignement_vivant/screens/drawerScreens/languageScreen/language_screen.dart';
import 'package:enseignement_vivant/screens/drawerScreens/settingsScreen/settings_screen.dart';
import 'package:enseignement_vivant/screens/drawerScreens/settingsScreen/notification_setting_screen.dart';
import 'package:enseignement_vivant/screens/drawerScreens/settingsScreen/change_password_screen.dart';
import 'package:enseignement_vivant/screens/drawerScreens/termsScreen/terms_screen.dart';
import 'package:enseignement_vivant/screens/drawerScreens/privacyPolicyScreen/privacy_policy_screen.dart';
import 'package:enseignement_vivant/screens/drawerScreens/helpSupportScreen/help_support_screen.dart';
import 'package:enseignement_vivant/screens/drawerScreens/aboutUsScreen/about_us_screen.dart';
import 'package:enseignement_vivant/screens/drawerScreens/deleteAccountScreen/delete_account_screen.dart';
import 'package:enseignement_vivant/screens/homeScreen/profileTab/edit_profile_screen.dart';
import 'package:enseignement_vivant/screens/homeScreen/notificationScreen/notifications_screen.dart';
import 'package:enseignement_vivant/screens/homeScreen/mainScreen/mainScreen.dart';

List<GetPage> appRouteFile = <GetPage>[
  GetPage(
      name: AppRoutes.splashScreen,
      page: () => const SplashScreen(),
      binding: SplashBinding()),
  GetPage(
      name: AppRoutes.signInScreen,
      page: () => const SignInScreen(),
      binding: SignInBinding()),
  GetPage(
      name: AppRoutes.signUpScreen,
      page: () => const SignUpScreen(),
      binding: SignUpBinding()),
  GetPage(
      name: AppRoutes.forgotPasswordScreen,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding()),
  GetPage(
      name: AppRoutes.forgotVerifyOtpScreen,
      page: () => const ForgotVerifyOtpScreen(),
      binding: ForgotVerifyOtpBinding()),
  GetPage(
      name: AppRoutes.resetPasswordScreen,
      page: () => const ResetPasswordScreen(),
      binding: ResetPasswordBinding()),
  GetPage(name: AppRoutes.prayersScreen, page: () => const PrayersScreen()),
  GetPage(
      name: AppRoutes.prayerDetailScreen,
      page: () => const PrayerDetailScreen()),
  GetPage(
      name: AppRoutes.encouragementsScreen,
      page: () => const EncouragementsScreen()),
  GetPage(
      name: AppRoutes.encouragementDetailScreen,
      page: () => const EncouragementDetailScreen()),
  GetPage(name: AppRoutes.teachingsScreen, page: () => const TeachingsScreen()),
  GetPage(
      name: AppRoutes.teachingDetailScreen,
      page: () => const TeachingDetailScreen()),
  GetPage(name: AppRoutes.imagesScreen, page: () => const ImagesScreen()),
  GetPage(
      name: AppRoutes.imageDetailScreen, page: () => const ImageDetailScreen()),
  GetPage(
      name: AppRoutes.verseOfDayScreen, page: () => const VerseOfDayScreen()),
  GetPage(name: AppRoutes.audioScreen, page: () => const AudioScreen()),
  GetPage(
      name: AppRoutes.audioDetailScreen, page: () => const AudioDetailScreen()),
  GetPage(name: AppRoutes.downloadsScreen, page: () => const DownloadsScreen()),
  GetPage(name: AppRoutes.languageScreen, page: () => const LanguageScreen()),
  GetPage(name: AppRoutes.settingsScreen, page: () => const SettingsScreen()),
  GetPage(
      name: AppRoutes.notificationSettingScreen,
      page: () => const NotificationSettingScreen()),
  GetPage(
      name: AppRoutes.changePasswordScreen,
      page: () => const ChangePasswordScreen()),
  GetPage(name: AppRoutes.termsScreen, page: () => const TermsScreen()),
  GetPage(
      name: AppRoutes.privacyPolicyScreen,
      page: () => const PrivacyPolicyScreen()),
  GetPage(
      name: AppRoutes.helpSupportScreen, page: () => const HelpSupportScreen()),
  GetPage(name: AppRoutes.aboutUsScreen, page: () => const AboutUsScreen()),
  GetPage(
      name: AppRoutes.deleteAccountScreen,
      page: () => const DeleteAccountScreen()),
  GetPage(
      name: AppRoutes.editProfileScreen, page: () => const EditProfileScreen()),
  GetPage(
      name: AppRoutes.notificationsScreen,
      page: () => const NotificationsScreen()),
  GetPage(name: AppRoutes.mainScreen, page: () => const MainScreen()),
];
