import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import '../model/teaching_model.dart';

class TeachingsController extends GetxController {
  final RxList<TeachingModel> teachingsList = <TeachingModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTeachings();
  }

  Future<void> fetchTeachings() async {
    isLoading.value = true;
    try {
      final response = await ApiServices.instance.getServices(
        AppApiEndPoint.instance.teaching,
        queryParameters: {
          "status": "published",
        },
      );

      if (isClosed) return;

      if (response != null && response['data'] != null && response['data'] is List) {
        final List listData = response['data'];
        final items = listData
            .map((item) => TeachingModel.fromJson(item as Map<String, dynamic>))
            .toList();

        teachingsList.assignAll(items);
      } else {
        teachingsList.clear();
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('Fetch Teachings Error', e);
      teachingsList.clear();
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }
}
