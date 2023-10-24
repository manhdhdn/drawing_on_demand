import 'package:drawing_on_demand/core/app_export.dart';import 'package:drawing_on_demand/presentation/profile_page/models/profile_model.dart';/// A controller class for the ProfilePage.
///
/// This class manages the state of the ProfilePage, including the
/// current profileModelObj
class ProfileController extends GetxController {ProfileController(this.profileModelObj);

Rx<ProfileModel> profileModelObj;

Rx<bool> opentowork = false.obs;

 }
