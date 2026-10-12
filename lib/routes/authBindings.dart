import 'package:get/get.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/sign_in/controller/sign_in_controller.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/sign_up/controller/sign_up_controller.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/forgotPasswordScreen/controller/forgotPasswordController.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/forgotVerifyOtpScreen/controller/forgotVerifyOtpController.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/resetPasswordScreen/controller/resetPasswordController.dart';
import 'package:enseignement_vivant/screens/homeScreen/prayersScreen/controller/prayers_controller.dart';
import 'package:enseignement_vivant/screens/homeScreen/mainScreen/controller/mainController.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => ForgotPasswordController());
    Get.lazyPut(() => ForgotVerifyOtpController());
    Get.lazyPut(() => ResetPasswordController());
    Get.lazyPut(() => PrayersController());
    Get.lazyPut(() => MainController());
  }
}
