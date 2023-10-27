import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/data/apiClient/api_account.dart';
import 'package:drawing_on_demand/data/apiClient/api_account_role.dart';
import 'package:drawing_on_demand/data/apiClient/api_client.dart';
import 'package:drawing_on_demand/data/apiClient/api_role.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Utils
    Get.put(PrefUtils());
    Get.put(ApiClient());

    //Api
    Get.put(ApiAccount());
    Get.put(ApiAccountRole());
    Get.put(ApiRole());

    // Connectivity
    Connectivity connectivity = Connectivity();
    Get.put(NetworkInfo(connectivity));
  }
}
