import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/presentation/logout_popup_dialog/models/logout_popup_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A controller class for the LogoutPopupDialog.
///
/// This class manages the state of the LogoutPopupDialog, including the
/// current logoutPopupModelObj
class LogoutPopupController extends GetxController {
  Rx<LogoutPopupModel> logoutPopupModelObj = LogoutPopupModel().obs;

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      Get.offAllNamed(
        AppRoutes.homeContainerScreen,
      );
    } catch (e) {
      Get.snackbar("Logout Failed", e.toString());
    }
  }
}
