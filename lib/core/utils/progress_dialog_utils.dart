import 'package:drawing_on_demand/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProgressDialogUtils {
  static bool isProgressShowing = false;

  static void showProgress(BuildContext context) {
    if (!isProgressShowing) {
      isProgressShowing = true;

      showDialog(
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
