import 'package:get/get.dart';
import 'package:enseignement_vivant/routes/app_routes.dart';
import 'package:enseignement_vivant/services/storage_services/get_storage_services.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2200));

    final token = StorageServices.instance.getToken();
    if (token.isNotEmpty) {
      Get.offAllNamed(AppRoutes.mainScreen);
    } else {
      Get.offAllNamed(AppRoutes.signInScreen);
    }
  }
}
