import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/utils/pref_utils.dart';
import '../../widgets/constant.dart';
import '../../widgets/responsive.dart';
import '../profile/client_profile.dart';

class ClientHome extends StatelessWidget {
  final Widget child;

  const ClientHome({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveCt(
      mobile: Scaffold(
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
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            elevation: 0.0,
            selectedItemColor: kPrimaryColor,
            unselectedItemColor: kLightNeutralColor,
            backgroundColor: kWhite,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(IconlyBold.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyBold.chat),
                label: "Message",
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyBold.paperPlus),
                label: "Job Post",
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyBold.document),
                label: "Orders",
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyBold.profile),
                label: "Profile",
              ),
            ],
            onTap: (int index) {
              _onItemTapped(index, context);
            },
            currentIndex: _calculateSelectedIndex(context),
          ),
        ),
      ),
      desktop: Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 7,
              child: NavigationRail(
                selectedIndex: _calculateSelectedIndex(context),
                onDestinationSelected: (int index) {
                  _onItemTapped(index, context);
                },
                selectedIconTheme: const IconThemeData(color: kPrimaryColor),
                selectedLabelTextStyle: kTextStyle.copyWith(color: kPrimaryColor),
                unselectedIconTheme: const IconThemeData(color: kLightNeutralColor),
                unselectedLabelTextStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                backgroundColor: kWhite,
                elevation: 5.0,
                groupAlignment: -0.7,
                leading: GestureDetector(
                  onTap: () {
                    context.go('/');
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 85,
                        width: 110,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/drawing_on_demand.jpg'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      const Text(
                        'DRAWING\nON DEMAND',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                labelType: NavigationRailLabelType.selected,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(IconlyBold.home),
                    label: Text(
                      'Home',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(IconlyBold.chat),
                    label: Text(
                      'Message',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(IconlyBold.paperPlus),
                    label: Text(
                      'Job Post',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(IconlyBold.document),
                    label: Text(
                      'Orders',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(IconlyBold.profile),
                    label: Text(
                      'Profile',
                      textAlign: TextAlign.center,
                    ),
                    disabled: true,
                  ),
                ],
              ),
            ),
            const Expanded(
              flex: 1,
              child: SizedBox.shrink(),
            ),
            Expanded(
              flex: 60,
              child: child,
            ),
            const Expanded(
              flex: 1,
              child: SizedBox.shrink(),
            ),
            const Expanded(
              flex: 18,
              child: ClientProfile(),
            ).visible(ResponsiveCt.isDesktop(context) && PrefUtils().getAccount() != '{}'),
          ],
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    if (location.startsWith(MessageRoute.tag)) {
      return 1;
    }
    if (location.startsWith(JobRoute.tag)) {
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
        context.goNamed(JobRoute.name);
        break;
      case 3:
        context.goNamed(OrderRoute.name);
        break;
      case 4:
        context.goNamed(ProfileRoute.name);
    }
  }
}
