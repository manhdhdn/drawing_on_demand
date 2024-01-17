import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../client_screen/home/client_home.dart';
import '../../widgets/constant.dart';
import '../../widgets/responsive.dart';
import 'settings.dart';

class Policy extends StatefulWidget {
  const Policy({Key? key}) : super(key: key);

  @override
  State<Policy> createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
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
          AppLocalizations.of(context)!.privacyPolicy,
          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          height: context.height(),
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15.0),
                Text(
                  AppLocalizations.of(context)!.privacyPolicy,
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                Text(
                  AppLocalizations.of(context)!.explainPolicy,
                  style: kTextStyle.copyWith(color: kLightNeutralColor),
                ),
                const SizedBox(height: 20.0),
                Text(
                  AppLocalizations.of(context)!.collectData,
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                Text(
                  AppLocalizations.of(context)!.collectDataDetail,
                  style: kTextStyle.copyWith(color: kLightNeutralColor),
                ),
                const SizedBox(height: 20.0),
                Text(
                  AppLocalizations.of(context)!.useData,
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                Text(
                  AppLocalizations.of(context)!.useDataDetail,
                  style: kTextStyle.copyWith(color: kLightNeutralColor),
                ),
                const SizedBox(height: 20.0),
                Text(
                  AppLocalizations.of(context)!.discloseInformation,
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                Text(
                  AppLocalizations.of(context)!.discloseInformationDetail,
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
