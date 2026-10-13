import 'package:get/get.dart';
import 'package:enseignement_vivant/services/audio_service/audio_service_controller.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/sign_in/controller/sign_in_controller.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/sign_up/controller/sign_up_controller.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/forgotPasswordScreen/controller/forgotPasswordController.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/forgotVerifyOtpScreen/controller/forgotVerifyOtpController.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/resetPasswordScreen/controller/resetPasswordController.dart';
import 'package:enseignement_vivant/screens/homeScreen/prayersScreen/controller/prayers_controller.dart';
import 'package:enseignement_vivant/screens/homeScreen/encouragementsScreen/controller/encouragements_controller.dart';
import 'package:enseignement_vivant/screens/homeScreen/teachingsScreen/controller/teachings_controller.dart';
import 'package:enseignement_vivant/screens/homeScreen/imagesScreen/controller/images_controller.dart';
import 'package:enseignement_vivant/screens/homeScreen/verseOfDayScreen/controller/verse_of_day_controller.dart';
import 'package:enseignement_vivant/screens/homeScreen/favoritesTab/controller/favorites_controller.dart';
import 'package:enseignement_vivant/screens/homeScreen/audioScreen/controller/audio_screen_controller.dart';
import 'package:enseignement_vivant/screens/drawerScreens/downloadsScreen/controller/downloads_controller.dart';
import 'package:enseignement_vivant/screens/drawerScreens/languageScreen/controller/language_screen_controller.dart';
import 'package:enseignement_vivant/screens/drawerScreens/settingsScreen/controller/settings_controller.dart';
import 'package:enseignement_vivant/screens/drawerScreens/settingsScreen/controller/notification_setting_controller.dart';
import 'package:enseignement_vivant/screens/drawerScreens/settingsScreen/controller/change_password_controller.dart';
import 'package:enseignement_vivant/screens/drawerScreens/helpSupportScreen/controller/help_support_controller.dart';
import 'package:enseignement_vivant/screens/drawerScreens/deleteAccountScreen/controller/delete_account_controller.dart';
import 'package:enseignement_vivant/screens/homeScreen/profileTab/controller/profile_controller.dart';
import 'package:enseignement_vivant/screens/homeScreen/profileTab/controller/edit_profile_controller.dart';
import 'package:enseignement_vivant/screens/homeScreen/notificationScreen/controller/notifications_controller.dart';
import 'package:enseignement_vivant/screens/homeScreen/mainScreen/controller/mainController.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AudioServiceController(), permanent: true);
    Get.lazyPut(() => SignInController());
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => ForgotPasswordController());
    Get.lazyPut(() => ForgotVerifyOtpController());
    Get.lazyPut(() => ResetPasswordController());
    Get.lazyPut(() => PrayersController());
    Get.lazyPut(() => EncouragementsController());
    Get.lazyPut(() => TeachingsController());
    Get.lazyPut(() => ImagesController());
    Get.lazyPut(() => VerseOfDayController());
    Get.lazyPut(() => FavoritesController());
    Get.lazyPut(() => AudioScreenController());
    Get.lazyPut(() => DownloadsController());
    Get.lazyPut(() => LanguageScreenController());
    Get.lazyPut(() => SettingsController());
    Get.lazyPut(() => NotificationSettingController());
    Get.lazyPut(() => ChangePasswordController());
    Get.lazyPut(() => HelpSupportController());
    Get.lazyPut(() => DeleteAccountController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => EditProfileController());
    Get.lazyPut(() => NotificationsController());
    Get.lazyPut(() => MainController());
  }
}
