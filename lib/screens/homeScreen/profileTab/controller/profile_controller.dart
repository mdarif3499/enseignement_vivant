import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/model/app_user_data.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/services/storage_services/get_storage_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';

class ProfileController extends GetxController {
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString profileImage = ''.obs;
  final RxString country = 'France'.obs;
  final RxString phone = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStoredProfile();
    fetchProfileData();
  }

  void loadStoredProfile() {
    final storedName = StorageServices.instance.getUserName();
    final storedEmail = StorageServices.instance.getUserEmail();
    final storedImage = StorageServices.instance.getProfileImage();

    name.value = storedName.isNotEmpty ? storedName : 'User';
    email.value = storedEmail.isNotEmpty ? storedEmail : '';
    profileImage.value = storedImage;
  }

  Future<void> fetchProfileData() async {
    isLoading.value = true;
    try {
      final response = await ApiServices.instance.getServices(
        AppApiEndPoint.instance.updateProfile,
      );

      if (isClosed) return;

      if (response != null && response['data'] != null && response['data'] is Map<String, dynamic>) {
        final appUser = AppUserModel.fromJson(response['data'] as Map<String, dynamic>);

        name.value = (appUser.name != null && appUser.name!.isNotEmpty) ? appUser.name! : name.value;
        email.value = (appUser.email != null && appUser.email!.isNotEmpty) ? appUser.email! : email.value;
        profileImage.value = (appUser.profileImage != null && appUser.profileImage!.isNotEmpty) ? appUser.profileImage! : profileImage.value;

        await StorageServices.instance.saveUserProfile(
          name: name.value,
          email: email.value,
          image: profileImage.value,
          city: '',
        );
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('Fetch Profile Data Error', e);
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }
}
