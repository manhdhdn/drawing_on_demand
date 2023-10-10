import '../controller/add_new_education_controller.dart';
import 'package:get/get.dart';

/// A binding class for the AddNewEducationScreen.
///
/// This class ensures that the AddNewEducationController is created when the
/// AddNewEducationScreen is first loaded.
class AddNewEducationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddNewEducationController());
  }
}
