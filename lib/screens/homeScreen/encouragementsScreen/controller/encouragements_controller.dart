import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/screens/homeScreen/encouragementsScreen/model/encouragement_model.dart';
import 'package:enseignement_vivant/services/api/api_services.dart';
import 'package:enseignement_vivant/utils/error_log.dart';

class EncouragementsController extends GetxController {
  final RxList<EncouragementModel> list = <EncouragementModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEncouragements();
  }

  Future<void> fetchEncouragements() async {
    isLoading.value = true;
    try {
      final response = await ApiServices.instance.getServices(
        AppApiEndPoint.instance.encouragement,
        queryParameters: {
          "status": "published",
        },
      );

      if (isClosed) return;

      if (response != null && response['data'] != null && response['data'] is List) {
        final List listData = response['data'];
        final items = listData
            .map((item) => EncouragementModel.fromJson(item as Map<String, dynamic>))
            .toList();

        list.assignAll(items);
      } else {
        list.clear();
      }
    } catch (e) {
      if (isClosed) return;
      errorLog('Fetch Encouragements Error', e);
      list.clear();
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }
}
