import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/utils/pref_utils.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../widgets/responsive.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Title(
      title: '$dod | Welcome',
      color: kPrimaryColor,
      child: SafeArea(
        child: DodResponsive(
          mobile: Scaffold(
            backgroundColor: kWhite,
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: kDarkWhite,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
              ),
              toolbarHeight: 250,
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 125,
                      width: 160,
                      decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage('images/logo2.png'), fit: BoxFit.cover),
                      ),
                    )
                  ],
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.joinAs,
                      style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Card(
                    elevation: 1.0,
                    shadowColor: kDarkWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: const [
                          BoxShadow(
                            color: kBorderColorTextField,
                            spreadRadius: 1.0,
                            blurRadius: 1.0,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: CheckboxListTile(
                        visualDensity: const VisualDensity(vertical: -2),
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          AppLocalizations.of(context)!.customer,
                          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!.lookingForHelp,
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        secondary: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xFFCCF2E3),
                            borderRadius: BorderRadius.circular(3.0),
                            image: const DecorationImage(image: AssetImage('images/profile1.png'), fit: BoxFit.cover),
                          ),
                        ),
                        autofocus: false,
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                        selected: !isArtist,
                        value: !isArtist,
                        onChanged: (value) {
                          setState(() {
                            isArtist = false;
                          });

                          PrefUtils().setRole('Customer');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Card(
                    elevation: 1.0,
                    shadowColor: kDarkWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: const [
                          BoxShadow(
                            color: kBorderColorTextField,
                            spreadRadius: 1.0,
                            blurRadius: 1.0,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: CheckboxListTile(
                        visualDensity: const VisualDensity(vertical: -2),
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          AppLocalizations.of(context)!.artist,
                          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!.lookingForWork,
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        secondary: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xFFCCF2E3),
                            borderRadius: BorderRadius.circular(3.0),
                            image: const DecorationImage(image: AssetImage('images/profile2.png'), fit: BoxFit.cover),
                          ),
                        ),
                        autofocus: false,
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                        selected: isArtist,
                        value: isArtist,
                        onChanged: (value) {
                          setState(() {
                            isArtist = true;
                          });

                          PrefUtils().setRole('Artist');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  ButtonGlobalWithoutIcon(
                    buttontext: AppLocalizations.of(context)!.createAnAccount,
                    buttonDecoration: kButtonDecoration.copyWith(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onPressed: () {
                      onCreateAccount();
                    },
                    buttonTextColor: kWhite,
                  ),
                  const SizedBox(height: 15.0),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        onLogin();
                      },
                      child: RichText(
                        text: TextSpan(
                          text: AppLocalizations.of(context)!.alreadyHaveAccount,
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!.logIn,
                              style: kTextStyle.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          desktop: Scaffold(
            backgroundColor: kWhite,
            body: Row(
              children: [
                const Expanded(
                  flex: 4,
                  child: SizedBox.shrink(),
                ),
                Expanded(
                  flex: 3,
                  child: Material(
                    elevation: 5.0,
                    child: Scaffold(
                      backgroundColor: kWhite,
                      appBar: AppBar(
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        backgroundColor: kDarkWhite,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0),
                          ),
                        ),
                        toolbarHeight: 250,
                        flexibleSpace: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 125,
                                width: 160,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(image: AssetImage('images/logo2.png'), fit: BoxFit.cover),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                AppLocalizations.of(context)!.joinAs,
                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Card(
                              elevation: 1.0,
                              shadowColor: kDarkWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.only(left: 10.0),
                                decoration: BoxDecoration(
                                  color: kWhite,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: kBorderColorTextField,
                                      spreadRadius: 1.0,
                                      blurRadius: 1.0,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: CheckboxListTile(
                                  visualDensity: const VisualDensity(vertical: -2),
                                  checkboxShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    AppLocalizations.of(context)!.customer,
                                    style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    AppLocalizations.of(context)!.lookingForHelp,
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  secondary: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFCCF2E3),
                                      borderRadius: BorderRadius.circular(3.0),
                                      image: const DecorationImage(image: AssetImage('images/profile1.png'), fit: BoxFit.cover),
                                    ),
                                  ),
                                  autofocus: false,
                                  activeColor: Colors.green,
                                  checkColor: Colors.white,
                                  selected: !isArtist,
                                  value: !isArtist,
                                  onChanged: (value) {
                                    setState(() {
                                      isArtist = false;
                                    });

                                    PrefUtils().setRole('Customer');
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Card(
                              elevation: 1.0,
                              shadowColor: kDarkWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.only(left: 10.0),
                                decoration: BoxDecoration(
                                  color: kWhite,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: kBorderColorTextField,
                                      spreadRadius: 1.0,
                                      blurRadius: 1.0,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: CheckboxListTile(
                                  visualDensity: const VisualDensity(vertical: -2),
                                  checkboxShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    AppLocalizations.of(context)!.artist,
                                    style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    AppLocalizations.of(context)!.lookingForWork,
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  secondary: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFCCF2E3),
                                      borderRadius: BorderRadius.circular(3.0),
                                      image: const DecorationImage(image: AssetImage('images/profile2.png'), fit: BoxFit.cover),
                                    ),
                                  ),
                                  autofocus: false,
                                  activeColor: Colors.green,
                                  checkColor: Colors.white,
                                  selected: isArtist,
                                  value: isArtist,
                                  onChanged: (value) {
                                    setState(() {
                                      isArtist = true;
                                    });

                                    PrefUtils().setRole('Artist');
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            ButtonGlobalWithoutIcon(
                              buttontext: AppLocalizations.of(context)!.createAnAccount,
                              buttonDecoration: kButtonDecoration.copyWith(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                onCreateAccount();
                              },
                              buttonTextColor: kWhite,
                            ),
                            const SizedBox(height: 15.0),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  onLogin();
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: AppLocalizations.of(context)!.alreadyHaveAnOffer,
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                    children: [
                                      TextSpan(
                                        text: AppLocalizations.of(context)!.logIn,
                                        style: kTextStyle.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 4,
                  child: SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onLogin() {
    context.goNamed(LoginRoute.name);
  }

  void onCreateAccount() {
    context.goNamed(RegisterRoute.name);
  }
}
