import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ResponsiveCt extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  const ResponsiveCt({
    Key? key,
    required this.mobile,
    required this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) => context.width() < 650;

  static bool isTablet(BuildContext context) => context.width() < 1100 && context.width() >= 650;

  static bool isDesktop(BuildContext context) => context.width() >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 650) {
          return desktop;
        } else {
          return mobile;
        }
      },
    );
  }
}
