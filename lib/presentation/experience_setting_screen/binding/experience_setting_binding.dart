import '../controller/experience_setting_controller.dart';
import 'package:get/get.dart';

/// A binding class for the ExperienceSettingScreen.
///
/// This class ensures that the ExperienceSettingController is created when the
/// ExperienceSettingScreen is first loaded.
class ExperienceSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExperienceSettingController());
  }
}
