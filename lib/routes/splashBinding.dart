import 'package:get/get.dart';
import 'package:enseignement_vivant/screens/baseScreen/splashScreen/controller/splashController.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
