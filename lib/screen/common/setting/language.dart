import 'package:drawing_on_demand/main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/constant.dart';

class Language extends StatefulWidget {
  final String selectedLanguage;
  final Future<dynamic> getCurrentLanguage;

  const Language({
    Key? key,
    required this.selectedLanguage,
    required this.getCurrentLanguage,
  }) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  String selectedLanguage = '';

  @override
  void initState() {
    selectedLanguage = widget.selectedLanguage;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, widget.getCurrentLanguage);
            }),
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
    );
  }

  void onChangeLanguage(String language) async {
    setState(() {
      selectedLanguage = language;
    });

    switch (language) {
      case 'English':
        MyApp.setLocale(context, const Locale('en'));
        break;

      case 'Vietnamese':
        MyApp.setLocale(context, const Locale('vi'));
        break;

      default:
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }
}
