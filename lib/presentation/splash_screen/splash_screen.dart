import 'controller/splash_controller.dart';
import 'package:drawing_on_demand/core/app_export.dart';
import 'package:flutter/material.dart';

class SplashScreen extends GetWidget<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.primary,
        body: SizedBox(
          width: double.maxFinite,
          child: CustomImageView(
            svgPath: ImageConstant.imgGroup162797,
            height: getVerticalSize(153),
            width: getHorizontalSize(102),
            alignment: Alignment.center,
            margin: getMargin(bottom: 5),
          ),
        ),
      ),
    );
  }
}
