import 'package:get/get.dart';
import 'package:enseignement_vivant/services/audio_service/audio_service_controller.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/sign_in/controller/sign_in_controller.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/sign_up/controller/sign_up_controller.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/forgotPasswordScreen/controller/forgotPasswordController.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/forgotVerifyOtpScreen/controller/forgotVerifyOtpController.dart';
import 'package:enseignement_vivant/screens/baseScreen/authScreen/resetPasswordScreen/controller/resetPasswordController.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AudioServiceController(), permanent: true);
  }
}

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
  }
}

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(() => SignUpController());
  }
}

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
  }
}

class ForgotVerifyOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotVerifyOtpController>(() => ForgotVerifyOtpController());
  }
}

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController());
  }
}
