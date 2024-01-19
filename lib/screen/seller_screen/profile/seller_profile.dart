import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/common/common_features.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../main.dart';
import '../../client_screen/home/client_home.dart';
import '../../common/setting/settings.dart';
import '../../widgets/constant.dart';
import '../../widgets/responsive.dart';
// import '../notification/seller_notification.dart';
import '../withdraw_money/seller_withdraw_history.dart';
import '../withdraw_money/seller_withdraw_money.dart';

class SellerProfile extends StatefulWidget {
  const SellerProfile({Key? key}) : super(key: key);

  @override
  State<SellerProfile> createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      appBar: AppBar(
        backgroundColor: kDarkWhite,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: ListTile(
          contentPadding: const EdgeInsets.only(top: 10.0),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: GestureDetector(
              onTap: () => {},
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(jsonDecode(PrefUtils().getAccount())['Avatar']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            jsonDecode(PrefUtils().getAccount())['Name'],
            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
          ),
          subtitle: RichText(
            text: TextSpan(
              text: AppLocalizations.of(context)!.availableConnect,
              style: kTextStyle.copyWith(color: kLightNeutralColor),
              children: [
                TextSpan(
                  text: jsonDecode(PrefUtils().getAccount())['AvailableConnect'].toString(),
                  style: kTextStyle.copyWith(color: kNeutralColor),
                ),
              ],
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              onNotification();
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
                IconlyLight.notification,
                color: kNeutralColor,
              ),
            ),
          ),
        ),
        centerTitle: true,
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
                  onTap: () {
                    onProfile();
                  },
                  visualDensity: const VisualDensity(vertical: -3),
                  horizontalTitleGap: 10,
                  contentPadding: const EdgeInsets.only(bottom: 10),
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
                    AppLocalizations.of(context)!.myProfile,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                  trailing: const Icon(
                    FeatherIcons.chevronRight,
                    color: kLightNeutralColor,
                  ),
                ),
                Theme(
                  data: ThemeData(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.zero,
                    tilePadding: const EdgeInsets.only(bottom: 10),
                    collapsedIconColor: kLightNeutralColor,
                    iconColor: kLightNeutralColor,
                    title: Text(
                      AppLocalizations.of(context)!.withdraw,
                      style: kTextStyle.copyWith(color: kNeutralColor),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFEFE0),
                      ),
                      child: const Icon(
                        IconlyBold.wallet,
                        color: Color(0xFFFF7A00),
                      ),
                    ),
                    // trailing: const Icon(
                    //   FeatherIcons.chevronDown,
                    //   color: kLightNeutralColor,
                    // ),
                    children: [
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -3),
                        horizontalTitleGap: 10,
                        contentPadding: const EdgeInsets.only(left: 60),
                        title: Text(
                          AppLocalizations.of(context)!.withdrawAmount,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: kTextStyle.copyWith(color: kNeutralColor),
                        ),
                        trailing: const Icon(
                          FeatherIcons.chevronRight,
                          color: kLightNeutralColor,
                        ),
                        onTap: () => const SellerWithdrawMoney().launch(context),
                      ),
                      ListTile(
                        onTap: () => const SellerWithDrawHistory().launch(context),
                        visualDensity: const VisualDensity(vertical: -3),
                        horizontalTitleGap: 10,
                        contentPadding: const EdgeInsets.only(left: 60),
                        title: Text(
                          AppLocalizations.of(context)!.withdrawalHistory,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: kTextStyle.copyWith(color: kNeutralColor),
                        ),
                        trailing: const Icon(
                          FeatherIcons.chevronRight,
                          color: kLightNeutralColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // ListTile(
                //   onTap: () => const SellerFavList().launch(context),
                //   visualDensity: const VisualDensity(vertical: -3),
                //   horizontalTitleGap: 10,
                //   contentPadding: const EdgeInsets.only(bottom: 15),
                //   leading: Container(
                //     padding: const EdgeInsets.all(10.0),
                //     decoration: const BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: Color(0xFFFFE5E3),
                //     ),
                //     child: const Icon(
                //       IconlyBold.heart,
                //       color: Color(0xFFFF3B30),
                //     ),
                //   ),
                //   title: Text(
                //     'Favourite',
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
                  onTap: () {
                    onChangeToCustomer();
                  },
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
                    AppLocalizations.of(context)!.customerCentre,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                  trailing: const Icon(
                    FeatherIcons.chevronRight,
                    color: kLightNeutralColor,
                  ),
                ),
                // ListTile(
                //   onTap: () => const Invite().launch(context),
                //   visualDensity: const VisualDensity(vertical: -3),
                //   horizontalTitleGap: 10,
                //   contentPadding: const EdgeInsets.only(bottom: 15),
                //   leading: Container(
                //     padding: const EdgeInsets.all(10.0),
                //     decoration: const BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: Color(0xFFE2EED8),
                //     ),
                //     child: const Icon(
                //       IconlyBold.addUser,
                //       color: kPrimaryColor,
                //     ),
                //   ),
                //   title: Text(
                //     'Invite Friends',
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
                  onTap: () => onSetting(),
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
                    AppLocalizations.of(context)!.settings,
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
                    AppLocalizations.of(context)!.helpSupport,
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
                    AppLocalizations.of(context)!.logout,
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
    );
  }

  void onNotification() {
    // DodResponsive.isDesktop(context) ? ClientHome.changeProfile(const ClientNotification()) : const ClientNotification().launch(context);
    DodResponsive.isDesktop(context) ? ClientHome.changeProfile(const Settings()) : context.goNamed(SettingRoute.name);
  }

  void onProfile() {
    context.goNamed(ArtistProfileDetailRoute.name, pathParameters: {
      'id': jsonDecode(PrefUtils().getAccount())['Id'].toString(),
    });
  }

  void onChangeToCustomer() async {
    try {
      ProgressDialogUtils.showProgress(context);

      await PrefUtils().setRole('Customer');

      Future.delayed(const Duration(seconds: 1), () {
        // ignore: use_build_context_synchronously
        ProgressDialogUtils.hideProgress(context);
        MyApp.refreshRoutes(context);
      });
    } catch (error) {
      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);
    }
  }

  void onSetting() {
    context.goNamed(SettingRoute.name);
  }

  void onLogout() {
    logout(context);
  }
}
