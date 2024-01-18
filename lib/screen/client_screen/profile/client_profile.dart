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
import '../../common/profile/help_and_support.dart';
import '../../common/setting/settings.dart';
import '../../widgets/constant.dart';
import '../../widgets/responsive.dart';
import '../dashboard/client_dashboard.dart';
import '../home/client_home.dart';
import '../notification/client_notification.dart';
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
              maxLines: 2,
            ),
            // subtitle: Text(
            //   AppLocalizations.of(context)!.iAmACustomer,
            //   style: kTextStyle.copyWith(color: kLightNeutralColor),
            //   maxLines: 1,
            // ),
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
                      AppLocalizations.of(context)!.myProfile,
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
                    onTap: () {
                      onDashboard();
                    },
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
                      AppLocalizations.of(context)!.dashboard,
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
                      onArtistCentre();
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
                      AppLocalizations.of(context)!.artistCentre,
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
                    onTap: () {
                      onHelpSupport();
                    },
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
      ),
    );
  }

  void onCart() {
    context.goNamed(CartRoute.name);
  }

  void onNotification() {
    DodResponsive.isDesktop(context) ? ClientHome.changeProfile(const ClientNotification()) : const ClientNotification().launch(context);
  }

  void onProfile() {
    DodResponsive.isDesktop(context) ? ClientHome.changeProfile(const ClientProfileDetails()) : context.goNamed(ProfileDetailRoute.name);
  }

  void onDashboard() {
    DodResponsive.isDesktop(context) ? ClientHome.changeProfile(const ClientDashBoard()) : const ClientDashBoard().launch(context);
  }

  void onArtistCentre() async {
    try {
      ProgressDialogUtils.showProgress(context);

      await PrefUtils().setRole('Artist');

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

  void onTransaction() {
    DodResponsive.isDesktop(context) ? ClientHome.changeProfile(const ClientTransaction()) : const ClientTransaction().launch(context);
  }

  void onSetting() {
    DodResponsive.isDesktop(context) ? ClientHome.changeProfile(const Settings()) : context.goNamed(SettingRoute.name);
  }

  void onHelpSupport() {
    DodResponsive.isDesktop(context) ? ClientHome.changeProfile(const HelpAndSupport()) : const HelpAndSupport().launch(context);
  }

  void onLogout() async {
    logout(context);
  }
}
