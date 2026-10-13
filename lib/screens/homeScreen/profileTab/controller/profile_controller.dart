import 'package:get/get.dart';
import 'package:enseignement_vivant/services/storage_services/get_storage_services.dart';

class ProfileController extends GetxController {
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString country = 'France'.obs;
  final RxString phone = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void loadProfile() {
    final storedName = StorageServices.instance.getUserName();
    final storedEmail = StorageServices.instance.getUserEmail();

    name.value = storedName.isNotEmpty ? storedName : 'User';
    email.value = storedEmail.isNotEmpty ? storedEmail : '';
  }
}
