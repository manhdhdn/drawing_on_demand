import 'package:drawing_on_demand/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../screen/common/popUp/popup_1.dart';

class CommonFeatures {
  Future<void> logout(BuildContext context) async {
    try {
      // Sign out
      await FirebaseAuth.instance.signOut();

      // Clear pref data
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('account');
      prefs.remove('role');

      // Navigate to login
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.login, (route) => false);
    } catch (error) {
      Fluttertoast.showToast(msg: errorSomethingWentWrong);
    }
  }

  void showImportPicturePopUp(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const ImportImagePopUp(),
            );
          },
        );
      },
    );
  }

  void uploadImage() {}
}
