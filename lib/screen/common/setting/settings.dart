import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/constant.dart';
import 'about_us.dart';
import 'policy.dart';

class Settings extends StatefulWidget {
  static dynamic state;

  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();

  static void refresh() {
    state.refresh();
  }
}

class _SettingsState extends State<Settings> {
  bool isNotificationOn = false;
  String selectedLanguage = PrefUtils().getLanguage();

  @override
  void initState() {
    super.initState();

    Settings.state = this;
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: '${L10n.appName} | Settings',
      color: kPrimaryColor,
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          backgroundColor: kDarkWhite,
          elevation: 0,
          iconTheme: const IconThemeData(color: kNeutralColor),
          title: Text(
            AppLocalizations.of(context)!.setting,
            style: kTextStyle.copyWith(
                color: kNeutralColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
            ),
            width: context.width(),
            decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 30.0),
                ListTile(
                  visualDensity: const VisualDensity(vertical: -3),
                  horizontalTitleGap: 10,
                  contentPadding: const EdgeInsets.only(bottom: 15),
                  leading: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE7FFED),
                    ),
                    child: const Icon(
                      IconlyBold.notification,
                      color: kPrimaryColor,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.pushNotifications,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                  trailing: CupertinoSwitch(
                    value: isNotificationOn,
                    onChanged: (value) {
                      setState(() {
                        isNotificationOn = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  onTap: () {
                    onLanguage();
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
                      Icons.translate,
                      color: Color(0xFF144BD6),
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.language,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                  trailing: Text(
                    selectedLanguage == 'English'
                        ? AppLocalizations.of(context)!.english
                        : AppLocalizations.of(context)!.vietnamese,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kSubTitleColor),
                  ),
                ),
                ListTile(
                  onTap: () => const Policy().launch(context),
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
                      IconlyBold.danger,
                      color: Color(0xFFFF7A00),
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.privacyPolicy,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                ),
                ListTile(
                  onTap: () => const AboutUs().launch(context),
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
                      IconlyBold.shieldDone,
                      color: Color(0xFF7E5BFF),
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.termsOfService,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onLanguage() {
    context.goNamed(LanguageRoute.name);
  }

  refresh() {
    setState(() {
      selectedLanguage = PrefUtils().getLanguage();
    });
  }
}
