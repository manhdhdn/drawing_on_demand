import 'package:drawing_on_demand/core/app_export.dart';import 'package:drawing_on_demand/presentation/privacy_screen/models/privacy_model.dart';/// A controller class for the PrivacyScreen.
///
/// This class manages the state of the PrivacyScreen, including the
/// current privacyModelObj
class PrivacyController extends GetxController {Rx<PrivacyModel> privacyModelObj = PrivacyModel().obs;

 }
