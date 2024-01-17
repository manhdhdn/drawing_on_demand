import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../client_screen/home/client_home.dart';
import '../../client_screen/profile/client_profile.dart';
import '../../widgets/constant.dart';
import '../../widgets/responsive.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({Key? key}) : super(key: key);

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
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
            DodResponsive.isDesktop(context) ? ClientHome.changeProfile(const ClientProfile()) : GoRouter.of(context).pop();
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
                  'Our History',
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Food First envisions a world in which all people have access to healthy, ecologically produced, and culturally appropriate food. After 40 years of analysis of the global food system, we know that making this vision a reality involves more than tech nical solutions—it requires political tran sformation. That’s why Food First supports activists, social movements, alliances, and coalitions working for systemic change. Our work—including action-oriented rese arch, publications, and projects—gives you the tools to understand the global food system, build your local food movement, and engage with the global movement for food sovereignty.',
                  style: kTextStyle.copyWith(color: kLightNeutralColor),
                ),
                const SizedBox(height: 15.0),
                Text(
                  'Our History',
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Food First envisions a world in which all people have access to healthy, ecologically produced, and culturally appropriate food. After 40 years of analysis of the global food system, we know that making this vision a reality involves more than tech nical solutions—it requires political tran sformation. That’s why Food First supports activists, social movements, alliances, and coalitions working for systemic change. Our work—including action-oriented rese arch, publications, and projects—gives you the tools to understand the global food system, build your local food movement, and engage with the global movement for food sovereignty.',
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
