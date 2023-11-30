import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../common/messgae/chat_list.dart';
import '../../widgets/constant.dart';
import '../job_post/job_post.dart';
import '../orders/client_orders.dart';
import '../profile/client_profile.dart';
import 'client_home_screen.dart';

class ClientHome extends StatefulWidget {
  static const String tag = '/customer';

  const ClientHome({Key? key}) : super(key: key);

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  int currentIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ClientHomeScreen(),
    ChatScreen(),
    JobPost(),
    ClientOrderList(),
    ClientProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: _widgetOptions.elementAt(currentIndex),
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
            setState(() {
              currentIndex = index;
            });
          },
          currentIndex: currentIndex,
        ),
      ),
    );
  }
}
