import 'package:drawing_on_demand/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:drawing_on_demand/screen/widgets/constant.dart';
import 'package:is_first_run/is_first_run.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    bool firstRun = await IsFirstRun.isFirstRun();

    await Future.delayed(const Duration(seconds: 2)).then(
      (value) => Navigator.pushNamedAndRemoveUntil(context,
          firstRun ? AppRoutes.onBoard : AppRoutes.welcome, (route) => false),
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Container(
                    height: 180,
                    width: 180,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        'Version',
                        style: kTextStyle.copyWith(color: kWhite),
                      ),
                      Text(
                        '1.0.0',
                        style: kTextStyle.copyWith(
                            color: kWhite, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 630,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/bg.png'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
