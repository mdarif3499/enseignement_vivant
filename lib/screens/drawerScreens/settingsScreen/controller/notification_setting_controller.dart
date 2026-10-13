import 'package:get/get.dart';

class NotificationSettingController extends GetxController {
  final RxBool generalNotification = true.obs;
  final RxBool sound = false.obs;

  void toggleGeneral(bool val) {
    generalNotification.value = val;
  }

  void toggleSound(bool val) {
    sound.value = val;
  }
}
