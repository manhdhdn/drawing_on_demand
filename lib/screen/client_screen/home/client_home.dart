// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:drawing_on_demand/app_routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../common/messgae/chat_list.dart';
import '../../widgets/constant.dart';
import '../job_post/client_job_post.dart';
import '../orders/client_orders.dart';
import '../profile/client_profile.dart';
import 'client_home_screen.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({Key? key}) : super(key: key);

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  int currentIndex = 0;

  static const List<String> _pageAddresses = <String>[
    AppRoutes.clientHome,
    AppRoutes.clientChat,
    AppRoutes.jobPost,
    AppRoutes.clientOrder,
    AppRoutes.clientProfile,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: getCurrentPage(
        isWeb ? window.location.pathname! : _pageAddresses[currentIndex],
      ),
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
            window.history.pushState(null, '', _pageAddresses[index]);

            setState(() {
              currentIndex = index;
            });
          },
          currentIndex: isWeb ? getCurrentIndex() : currentIndex,
        ),
      ),
    );
  }

  int getCurrentIndex() {
    return _pageAddresses.indexWhere(
      (address) => address.contains(window.location.pathname!),
    );
  }

  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      case AppRoutes.clientHome:
        return const ClientHomeScreen();
      case AppRoutes.clientChat:
        return const ChatScreen();
      case AppRoutes.jobPost:
        return const JobPost();
      case AppRoutes.clientOrder:
        return const ClientOrderList();
      case AppRoutes.clientProfile:
        return const ClientProfile();
      default:
        return const ClientHomeScreen();
    }
  }
}
