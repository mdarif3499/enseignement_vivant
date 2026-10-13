import 'package:get/get.dart';

class ProfileController extends GetxController {
  final RxString name = 'Alex Simmerson'.obs;
  final RxString email = 'alex123@gmail.com'.obs;
  final RxString country = 'France'.obs;
  final RxString phone = '12345678910'.obs;
}
