import 'package:drawing_on_demand/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProgressDialogUtils {
  static bool isProgressShowing = false;

  static Future<void> showProgress(BuildContext context) async {
    if (!isProgressShowing) {
      isProgressShowing = true;

      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: kPrimaryColor,
          ),
        ),
      );
    }
  }

  static void hideProgress(BuildContext context) {
    if (isProgressShowing) {
      isProgressShowing = false;

      context.pop();
    }
  }
}
