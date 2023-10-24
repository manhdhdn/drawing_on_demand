import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/core/utils/progress_dialog_utils.dart';
import 'package:drawing_on_demand/presentation/login_screen/models/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// A controller class for the LoginScreen.
///
/// This class manages the state of the LoginScreen, including the
/// current loginModelObj
class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Rx<bool> isShowPassword = true.obs;

  Rx<LoginModel> loginModelObj = LoginModel().obs;

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
  }

  Future<void> login(String email, String password) async {
    try {
      ProgressDialogUtils.showProgressDialog();

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Get.offAllNamed(AppRoutes.homeContainerScreen);
    } catch (e) {
      Fluttertoast.showToast(msg: "Invalid email or password");
    } finally {
      ProgressDialogUtils.hideProgressDialog();
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      ProgressDialogUtils.showProgressDialog();

      await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      ProgressDialogUtils.hideProgressDialog();
    }
  }
}
