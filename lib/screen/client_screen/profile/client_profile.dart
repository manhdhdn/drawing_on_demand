import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/common/common_features.dart';
import '../../../core/utils/pref_utils.dart';
import '../../common/setting/settings.dart';
import '../../widgets/constant.dart';
import '../../widgets/responsive.dart';
import '../dashboard/client_dashboard.dart';
import '../favourite/client_favourite_list.dart';
import '../home/client_home.dart';
import '../invite/client_invite.dart';
import '../notification/client_notification.dart';
import '../report/client_report.dart';
import '../transaction/transaction.dart';
import 'client_profile_details.dart';

class ClientProfile extends StatefulWidget {
  const ClientProfile({Key? key}) : super(key: key);

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  @override
  Widget build(BuildContext context) {
    return Title(
      title: '$dod | Profile',
      color: kPrimaryColor,
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          backgroundColor: kDarkWhite,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: ListTile(
            contentPadding: const EdgeInsets.only(top: 10),
            leading: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: GestureDetector(
                // onTap: () => const ClientProfile().launch(context),
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: NetworkImage(jsonDecode(PrefUtils().getAccount())['Avatar']), fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            title: Text(
              jsonDecode(PrefUtils().getAccount())['Name'],
              style: kTextStyle.copyWith(
                color: kNeutralColor,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
            subtitle: Text(
              'I\'m a Customer',
              style: kTextStyle.copyWith(color: kLightNeutralColor),
              maxLines: 1,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    onCart();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: kPrimaryColor.withOpacity(0.2),
                      ),
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: kNeutralColor,
                    ),
                  ),
                ),
                const SizedBox(width: 9.0),
                GestureDetector(
                  onTap: () => const ClientNotification().launch(context),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: kPrimaryColor.withOpacity(0.2),
                      ),
                    ),
                    child: const Icon(
                      IconlyLight.notification,
                      color: kNeutralColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            height: context.height(),
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            width: context.width(),
            decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -3),
                    horizontalTitleGap: 10,
                    contentPadding: const EdgeInsets.only(bottom: 15),
                    leading: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE2EED8),
                      ),
                      child: const Icon(
                        IconlyBold.profile,
                        color: kPrimaryColor,
                      ),
                    ),
                    title: Text(
                      'My Profile',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: kTextStyle.copyWith(color: kNeutralColor),
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: kLightNeutralColor,
                    ),
                    onTap: () {
                      onProfile();
                    },
                  ),
                  ListTile(
                    onTap: () => const ClientDashBoard().launch(context),
                    visualDensity: const VisualDensity(vertical: -3),
                    horizontalTitleGap: 10,
                    contentPadding: const EdgeInsets.only(bottom: 15),
                    leading: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE3EDFF),
                      ),
                      child: const Icon(
                        IconlyBold.chart,
                        color: Color(0xFF144BD6),
                      ),
                    ),
                    title: Text(
                      'Dashboard',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: kTextStyle.copyWith(color: kNeutralColor),
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: kLightNeutralColor,
                    ),
                  ),
                  // Theme(
                  //   data: ThemeData(dividerColor: Colors.transparent),
                  //   child: ExpansionTile(
                  //     childrenPadding: EdgeInsets.zero,
                  //     tilePadding: const EdgeInsets.only(bottom: 10),
                  //     collapsedIconColor: kLightNeutralColor,
                  //     iconColor: kLightNeutralColor,
                  //     title: Text(
                  //       'Deposit',
                  //       style: kTextStyle.copyWith(color: kNeutralColor),
                  //     ),
                  //     leading: Container(
                  //       padding: const EdgeInsets.all(10.0),
                  //       decoration: const BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: Color(0xFFFFEFE0),
                  //       ),
                  //       child: const Icon(
                  //         IconlyBold.wallet,
                  //         color: Color(0xFFFF7A00),
                  //       ),
                  //     ),
                  //     trailing: const Icon(
                  //       FeatherIcons.chevronDown,
                  //       color: kLightNeutralColor,
                  //     ),
                  //     children: [
                  //       ListTile(
                  //         visualDensity: const VisualDensity(vertical: -3),
                  //         horizontalTitleGap: 10,
                  //         contentPadding: const EdgeInsets.only(left: 60),
                  //         title: Text(
                  //           'Add Deposit',
                  //           overflow: TextOverflow.ellipsis,
                  //           maxLines: 1,
                  //           style: kTextStyle.copyWith(color: kNeutralColor),
                  //         ),
                  //         trailing: const Icon(
                  //           FeatherIcons.chevronRight,
                  //           color: kLightNeutralColor,
                  //         ),
                  //         onTap: () => const AddDeposit().launch(context),
                  //       ),
                  //       ListTile(
                  //         onTap: () => const DepositHistory().launch(context),
                  //         visualDensity: const VisualDensity(vertical: -3),
                  //         horizontalTitleGap: 10,
                  //         contentPadding: const EdgeInsets.only(left: 60),
                  //         title: Text(
                  //           'Deposit History',
                  //           overflow: TextOverflow.ellipsis,
                  //           maxLines: 1,
                  //           style: kTextStyle.copyWith(color: kNeutralColor),
                  //         ),
                  //         trailing: const Icon(
                  //           FeatherIcons.chevronRight,
                  //           color: kLightNeutralColor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // ListTile(
                  //   onTap: () => const AddPaymentMethod().launch(context),
                  //   visualDensity: const VisualDensity(vertical: -3),
                  //   horizontalTitleGap: 10,
                  //   contentPadding: const EdgeInsets.only(bottom: 12),
                  //   leading: Container(
                  //     padding: const EdgeInsets.all(10.0),
                  //     decoration: const BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       color: Color(0xFFFFE5E3),
                  //     ),
                  //     child: const Icon(
                  //       IconlyBold.ticketStar,
                  //       color: Color(0xFFFF3B30),
                  //     ),
                  //   ),
                  //   title: Text(
                  //     'Add Payment method',
                  //     overflow: TextOverflow.ellipsis,
                  //     maxLines: 1,
                  //     style: kTextStyle.copyWith(color: kNeutralColor),
                  //   ),
                  //   trailing: const Icon(
                  //     FeatherIcons.chevronRight,
                  //     color: kLightNeutralColor,
                  //   ),
                  // ),
                  ListTile(
                    onTap: () => const ClientTransaction().launch(context),
                    visualDensity: const VisualDensity(vertical: -3),
                    horizontalTitleGap: 10,
                    contentPadding: const EdgeInsets.only(bottom: 12),
                    leading: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFE5E3),
                      ),
                      child: const Icon(
                        IconlyBold.ticketStar,
                        color: Color(0xFFFF3B30),
                      ),
                    ),
                    title: Text(
                      'Transaction',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: kTextStyle.copyWith(color: kNeutralColor),
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: kLightNeutralColor,
                    ),
                  ),
                  ListTile(
                    onTap: () => const ClientFavList().launch(context),
                    visualDensity: const VisualDensity(vertical: -3),
                    horizontalTitleGap: 10,
                    contentPadding: const EdgeInsets.only(bottom: 15),
                    leading: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE8E1FF),
                      ),
                      child: const Icon(
                        IconlyBold.heart,
                        color: Color(0xFF7E5BFF),
                      ),
                    ),
                    title: Text(
                      'Favorite',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: kTextStyle.copyWith(color: kNeutralColor),
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: kLightNeutralColor,
                    ),
                  ),
                  ListTile(
                    onTap: () => const ClientReport().launch(context),
                    visualDensity: const VisualDensity(vertical: -3),
                    horizontalTitleGap: 10,
                    contentPadding: const EdgeInsets.only(bottom: 15),
                    leading: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD0F1FF),
                      ),
                      child: const Icon(
                        Icons.draw,
                        color: Color(0xFF06AEF3),
                      ),
                    ),
                    title: Text(
                      'Artist Centre',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: kTextStyle.copyWith(color: kNeutralColor),
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: kLightNeutralColor,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      onSetting();
                    },
                    visualDensity: const VisualDensity(vertical: -3),
                    horizontalTitleGap: 10,
                    contentPadding: const EdgeInsets.only(bottom: 15),
                    leading: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFDDED),
                      ),
                      child: const Icon(
                        IconlyBold.setting,
                        color: Color(0xFFFF298C),
                      ),
                    ),
                    title: Text(
                      'Settings',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: kTextStyle.copyWith(color: kNeutralColor),
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: kLightNeutralColor,
                    ),
                  ),
                  ListTile(
                    onTap: () => const ClientInvite().launch(context),
                    visualDensity: const VisualDensity(vertical: -3),
                    horizontalTitleGap: 10,
                    contentPadding: const EdgeInsets.only(bottom: 15),
                    leading: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE2EED8),
                      ),
                      child: const Icon(
                        IconlyBold.addUser,
                        color: kPrimaryColor,
                      ),
                    ),
                    title: Text(
                      'Invite Friends',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: kTextStyle.copyWith(color: kNeutralColor),
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: kLightNeutralColor,
                    ),
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -3),
                    horizontalTitleGap: 10,
                    contentPadding: const EdgeInsets.only(bottom: 15),
                    leading: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE3EDFF),
                      ),
                      child: const Icon(
                        IconlyBold.danger,
                        color: Color(0xFF144BD6),
                      ),
                    ),
                    title: Text(
                      'Help & Support',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: kTextStyle.copyWith(color: kNeutralColor),
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: kLightNeutralColor,
                    ),
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -3),
                    horizontalTitleGap: 10,
                    contentPadding: const EdgeInsets.only(bottom: 15),
                    leading: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFEFE0),
                      ),
                      child: const Icon(
                        IconlyBold.logout,
                        color: Color(0xFFFF7A00),
                      ),
                    ),
                    title: Text(
                      'Log Out',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: kTextStyle.copyWith(color: kNeutralColor),
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: kLightNeutralColor,
                    ),
                    onTap: () {
                      onLogout();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onCart() {
    context.goNamed(CartRoute.name);
  }

  void onProfile() {
    DodResponsive.isDesktop(context) ? ClientHome.changeProfile(const ClientProfileDetails()) : context.goNamed(ProfileDetailRoute.name);
  }

  void onSetting() {
    DodResponsive.isDesktop(context) ? ClientHome.changeProfile(const Settings()) : context.goNamed(SettingRoute.name);
  }

  void onLogout() async {
    logout(context);
  }
}
