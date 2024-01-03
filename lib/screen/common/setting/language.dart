import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../core/utils/pref_utils.dart';
import '../../../l10n/l10n.dart';
import '../../../main.dart';
import '../../widgets/constant.dart';
import 'settings.dart';

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  String selectedLanguage = PrefUtils().getLanguage();

  @override
  Widget build(BuildContext context) {
    return Title(
      title: '${L10n.appName} | Language',
      color: kPrimaryColor,
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          backgroundColor: kDarkWhite,
          elevation: 0,
          iconTheme: const IconThemeData(color: kNeutralColor),
          title: Text(
            AppLocalizations.of(context)!.language,
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
                ListView.builder(
                  itemCount: language.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (_, i) {
                    return ListTile(
                      onTap: () {
                        onChangeLanguage(language[i]);
                      },
                      visualDensity: const VisualDensity(vertical: -3),
                      horizontalTitleGap: 10,
                      contentPadding: const EdgeInsets.only(bottom: 15),
                      title: Text(
                        language[i] == 'English'
                            ? AppLocalizations.of(context)!.english
                            : AppLocalizations.of(context)!.vietnamese,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: kTextStyle.copyWith(color: kNeutralColor),
                      ),
                      trailing: Icon(
                        selectedLanguage == language[i] ? Icons.check : null,
                        color: kPrimaryColor,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onChangeLanguage(String language) async {
    setState(() {
      selectedLanguage = language;
    });

    await PrefUtils().setLanguage(language);

    // ignore: use_build_context_synchronously
    MyApp.refreshLocale(context);
    Settings.refresh();
  }
}
