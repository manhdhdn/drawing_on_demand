import 'package:auto_route/auto_route.dart';
import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/presentation/onboarding_one_screen/onboarding_one_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OnboardingOneScreen(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    super.dispose();
  }

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
            margin: getMargin(
              bottom: 5,
            ),
          ),
        ),
      ),
    );
  }
}
