import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/services/storage_services/get_storage_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';

class FavoriteService extends GetxController {
  static FavoriteService get instance {
    if (!Get.isRegistered<FavoriteService>()) {
      Get.put(FavoriteService(), permanent: true);
    }
    return Get.find<FavoriteService>();
  }

  final GetStorage _box = GetStorage();
  static const String _favStorageKey = 'user_favorite_ids_v1';

  final RxSet<String> favoriteIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFavoriteIds();
  }

  void _loadFavoriteIds() {
    try {
      final List? list = _box.read(_favStorageKey);
      if (list != null) {
        favoriteIds.assignAll(list.cast<String>());
      }
    } catch (e) {
      errorLog('FavoriteService _loadFavoriteIds Error', e);
    }
  }

  bool isFavorite(String id) {
    if (id.isEmpty) return false;
    return favoriteIds.contains(id);
  }

  void seedFavorite(String id, bool isFav) {
    if (id.isEmpty) return;
    if (isFav) {
      if (!favoriteIds.contains(id)) {
        favoriteIds.add(id);
        _saveToStorage();
      }
    } else {
      if (favoriteIds.contains(id)) {
        favoriteIds.remove(id);
        _saveToStorage();
      }
    }
  }

  Future<bool> toggleFavorite({
    required String id,
    required String postType, // 'Prayer', 'Teaching', 'Encouragement', 'Audio', 'Image', 'Verse'
  }) async {
    if (id.isEmpty) return false;

    final bool currentlyFav = isFavorite(id);

    // Optimistically update UI
    if (currentlyFav) {
      favoriteIds.remove(id);
    } else {
      favoriteIds.add(id);
    }
    _saveToStorage();

    try {
      final body = {
        "post": id,
        "postType": postType,
      };

      final token = StorageServices.instance.getToken();
      final options = Options(
        headers: {
          if (token.isNotEmpty) "Authorization": "Bearer $token",
        },
      );

      final response = await ApiServices.instance.postServices(
        url: AppApiEndPoint.instance.favoriteEndpoint,
        body: body,
        options: options,
      );

      if (response != null && (response['success'] == true || response['statusCode'] == 200)) {
        final message = response['message']?.toString() ??
            (currentlyFav ? "Removed from favorites" : "Added to favorites");
        AppSnackBar.instance.success(message);
        return !currentlyFav;
      } else if (response != null && response['message'] != null) {
        AppSnackBar.instance.error(response['message'].toString());
        _revert(id, currentlyFav);
        return currentlyFav;
      } else {
        _revert(id, currentlyFav);
        return currentlyFav;
      }
    } catch (e) {
      errorLog('Toggle Favorite API Error for $id ($postType)', e);
      _revert(id, currentlyFav);
      AppSnackBar.instance.error("Something went wrong. Please try again.");
      return currentlyFav;
    }
  }

  void _revert(String id, bool previouslyFav) {
    if (previouslyFav) {
      favoriteIds.add(id);
    } else {
      favoriteIds.remove(id);
    }
    _saveToStorage();
  }

  void _saveToStorage() {
    try {
      _box.write(_favStorageKey, favoriteIds.toList());
      _box.save();
    } catch (e) {
      errorLog('FavoriteService _saveToStorage Error', e);
    }
  }
}
