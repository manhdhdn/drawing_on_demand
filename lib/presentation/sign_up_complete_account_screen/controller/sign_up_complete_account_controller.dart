import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/data/apiClient/api_account.dart';
import 'package:drawing_on_demand/data/models/account.dart';
import 'package:drawing_on_demand/presentation/sign_up_complete_account_screen/models/sign_up_complete_account_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// A controller class for the SignUpCompleteAccountScreen.
///
/// This class manages the state of the SignUpCompleteAccountScreen, including the
/// current signUpCompleteAccountModelObj
class SignUpCompleteAccountController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Rx<SignUpCompleteAccountModel> signUpCompleteAccountModelObj =
      SignUpCompleteAccountModel().obs;

  Rx<bool> isShowPassword = true.obs;
  Rx<String> gender = "Male".obs;

  Account accountRep = Account();

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }

  /// Calls the https://nodedemo.dhiwise.co/device/auth/register API with the specified request data.
  ///
  /// The [Map] parameter represents request body
  Future<void> callRegisterDeviceAuth(Account account) async {
    try {
      accountRep = await Get.find<ApiAccount>().postOne(account);
      await register(Get.arguments, passwordController.text.trim());
      _handleRegisterDeviceAuthSuccess();

      Get.offAllNamed(AppRoutes.jobTypeScreen);
    } on NoInternetException catch (e) {
      Get.rawSnackbar(message: e.toString());
    } catch (error, stackTrace) {
      Logger.log(
        error,
        stackTrace: stackTrace,
      );

      Fluttertoast.showToast(msg: "msg_something_went_wrong".tr);
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  /// handles the success response for the API
  void _handleRegisterDeviceAuthSuccess() {
    Get.find<PrefUtils>().setAccount(accountRep);
  }
}
