import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_routes/named_routes.dart';
import '../../widgets/constant.dart';

class SellerHome extends StatelessWidget {
  final Widget child;

  const SellerHome({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: child,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.0),
              topLeft: Radius.circular(15.0),
            ),
            boxShadow: [
              BoxShadow(
                  color: kDarkWhite,
                  blurRadius: 5.0,
                  spreadRadius: 3.0,
                  offset: Offset(0, -2))
            ]),
        child: BottomNavigationBar(
          elevation: 0.0,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: kLightNeutralColor,
          backgroundColor: kWhite,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(IconlyBold.home),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(IconlyBold.chat),
              label: AppLocalizations.of(context)!.message,
            ),
            BottomNavigationBarItem(
              icon: const Icon(IconlyBold.paperPlus),
              label: AppLocalizations.of(context)!.jobApply,
            ),
            BottomNavigationBarItem(
              icon: const Icon(IconlyBold.document),
              label: AppLocalizations.of(context)!.orders,
            ),
            BottomNavigationBarItem(
              icon: const Icon(IconlyBold.profile),
              label: AppLocalizations.of(context)!.profile,
            ),
          ],
          onTap: (int index) {
            _onItemTapped(index, context);
          },
          currentIndex: _calculateSelectedIndex(context),
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    if (location.startsWith(MessageRoute.tag)) {
      return 1;
    }
    if (location.startsWith(JobApplyRoute.tag)) {
      return 2;
    }
    if (location.startsWith(OrderRoute.tag)) {
      return 3;
    }
    if (location.startsWith(ProfileRoute.tag)) {
      return 4;
    }
    if (location.startsWith(HomeRoute.tag)) {
      return 0;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed(HomeRoute.name);
        break;
      case 1:
        context.goNamed(MessageRoute.name);
        break;
      case 2:
        context.goNamed(JobApplyRoute.name);
        break;
      case 3:
        context.goNamed(OrderRoute.name);
        break;
      case 4:
        context.goNamed(ProfileRoute.name);
    }
  }
}
