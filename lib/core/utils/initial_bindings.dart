import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/data/apiClient/api_account.dart';
import 'package:drawing_on_demand/data/apiClient/api_client.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Utils
    Get.put(PrefUtils());
    Get.put(ApiClient());

    //Api
    Get.put(ApiAccount());

    // Connectivity
    Connectivity connectivity = Connectivity();
    Get.put(NetworkInfo(connectivity));
  }
}
