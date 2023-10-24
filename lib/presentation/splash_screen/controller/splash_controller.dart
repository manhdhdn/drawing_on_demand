import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/presentation/splash_screen/models/splash_model.dart';
import 'package:is_first_run/is_first_run.dart';

/// A controller class for the SplashScreen.
///
/// This class manages the state of the SplashScreen, including the
/// current splashModelObj
class SplashController extends GetxController {
  Rx<SplashModel> splashModelObj = SplashModel().obs;

  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 2), () async {
      bool firstRun = await IsFirstRun.isFirstRun();

      if (firstRun) {
        Get.offNamed(AppRoutes.onboardingOneScreen);
      } else {
        Get.offNamed(AppRoutes.homeContainerScreen);
      }
    });
  }
}
