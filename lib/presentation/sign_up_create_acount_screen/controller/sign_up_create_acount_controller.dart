import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/data/apiClient/api_account.dart';
import 'package:drawing_on_demand/data/models/account.dart';
import 'package:drawing_on_demand/presentation/sign_up_create_acount_screen/models/sign_up_create_acount_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// A controller class for the SignUpCreateAcountScreen.
///
/// This class manages the state of the SignUpCreateAcountScreen, including the
/// current signUpCreateAcountModelObj
class SignUpCreateAcountController extends GetxController {
  TextEditingController emailController = TextEditingController();

  Rx<SignUpCreateAcountModel> signUpCreateAcountModelObj =
      SignUpCreateAcountModel().obs;

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
  }

  Future<bool> isCreatedAccount() async {
    try {
      Set<Account> accounts = await Get.find<ApiAccount>()
          .filter("email", emailController.text.trim());

      if (accounts.isNotEmpty) {
        Fluttertoast.showToast(msg: "mgs_email_already_exists".tr);

        return true;
      } else {
        return false;
      }
    } catch (error, stackTrace) {
      Logger.log(
        error,
        stackTrace: stackTrace,
      );

      Fluttertoast.showToast(msg: "msg_something_went_wrong".tr);

      return true;
    }
  }
}
