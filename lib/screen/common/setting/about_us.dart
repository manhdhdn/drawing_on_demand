import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../client_screen/home/client_home.dart';
import '../../widgets/constant.dart';
import '../../widgets/responsive.dart';
import 'settings.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      appBar: AppBar(
        backgroundColor: kDarkWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: kNeutralColor),
        leading: IconButton(
          onPressed: () {
            DodResponsive.isDesktop(context) ? ClientHome.changeProfile(const Settings()) : GoRouter.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          AppLocalizations.of(context)!.aboutUs,
          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
          ),
          width: context.width(),
          height: context.height(),
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15.0),
                Text(
                  AppLocalizations.of(context)!.introApp,
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                Text(
                  '${AppLocalizations.of(context)!.introDesc1}\n${AppLocalizations.of(context)!.introDesc2}',
                  style: kTextStyle.copyWith(color: kLightNeutralColor),
                ),
                const SizedBox(height: 15.0),
                Text(
                  AppLocalizations.of(context)!.termOfService,
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                Text(
                  AppLocalizations.of(context)!.termDiscrip,
                  style: kTextStyle.copyWith(color: kLightNeutralColor),
                ),
                const SizedBox(height: 15.0),
                Text(
                  AppLocalizations.of(context)!.contact,
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                Text(
                  AppLocalizations.of(context)!.contacDetail,
                  style: kTextStyle.copyWith(color: kLightNeutralColor),
                ),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
