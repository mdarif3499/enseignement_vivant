import 'package:get_storage/get_storage.dart';
import 'package:enseignement_vivant/constant/app_storage_key.dart';
import 'package:enseignement_vivant/utils/error_log.dart';

class StorageServices {
  StorageServices._privateConstructor();
  static final StorageServices _instance = StorageServices._privateConstructor();
  static StorageServices get instance => _instance;

  GetStorage box = GetStorage();

  Future<void> setToken(String value) async {
    try {
      await box.write(AppStorageKey.instance.token, value);
      await box.save();
    } catch (e) {
      errorLog("set token ", e);
    }
  }

  String getToken() {
    try {
      return box.read(AppStorageKey.instance.token) ?? "";
    } catch (e) {
      errorLog("get token", e);
      return "";
    }
  }

  Future<void> saveUserProfile({
    required String name,
    required String email,
    required String image,
    required String city,
  }) async {
    try {
      await box.write('userName', name);
      await box.write('userEmail', email);
      await box.write('profileImage', image);
      await box.write('userCity', city);
      await box.save();
    } catch (e) {
      errorLog("save user profile", e);
    }
  }

  String getUserName() => box.read('userName') ?? "";
  String getUserEmail() => box.read('userEmail') ?? "";
  String getProfileImage() => box.read('profileImage') ?? "";
  String getUserCity() => box.read('userCity') ?? "";

  Future<void> setUserRole(String value) async {
    try {
      await box.write(AppStorageKey.instance.userRole, value);
    } catch (e) {
      errorLog("set user role", e);
    }
  }

  String? getUserRole() {
    try {
      return box.read(AppStorageKey.instance.userRole);
    } catch (e) {
      errorLog("get user role", e);
      return "";
    }
  }

  Future<void> storageClear() async {
    try {
      await box.erase();
      await box.save();
      errorLog('Logout', 'Storage cleared successfully');
    } catch (e) {
      errorLog("logout", e);
    }
  }
}
