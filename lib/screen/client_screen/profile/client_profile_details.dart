import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/utils/pref_utils.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../widgets/responsive.dart';
import '../home/client_home.dart';
import 'client_edit_profile_details.dart';
import 'client_profile.dart';

class ClientProfileDetails extends StatefulWidget {
  const ClientProfileDetails({Key? key}) : super(key: key);

  @override
  State<ClientProfileDetails> createState() => _ClientProfileDetailsState();
}

class _ClientProfileDetailsState extends State<ClientProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return Title(
      title: '$dod | Profile details',
      color: kPrimaryColor,
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          backgroundColor: kDarkWhite,
          elevation: 0,
          iconTheme: const IconThemeData(color: kNeutralColor),
          leading: IconButton(
            onPressed: () {
              ResponsiveCt.isDesktop(context) ? ClientHome.changeProfile(const ClientProfile()) : context.pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            'My Profile',
            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(color: kWhite),
          child: ButtonGlobalWithIcon(
            buttontext: 'Edit Profile',
            buttonDecoration: kButtonDecoration.copyWith(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () {
              setState(() {
                const ClientEditProfile().launch(context);
              });
            },
            buttonTextColor: kWhite,
            buttonIcon: IconlyBold.edit,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Container(
            height: context.height(),
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              jsonDecode(PrefUtils().getAccount())['Avatar'] ?? defaultImage,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jsonDecode(PrefUtils().getAccount())['Name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                          Text(
                            jsonDecode(PrefUtils().getAccount())['Email'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kTextStyle.copyWith(color: kLightNeutralColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    'Client Information',
                    style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Phone Number',
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ':',
                              style: kTextStyle.copyWith(color: kSubTitleColor),
                            ),
                            const SizedBox(width: 10.0),
                            Flexible(
                              child: Text(
                                jsonDecode(PrefUtils().getAccount())['Phone'] ?? '',
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Gender',
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ':',
                              style: kTextStyle.copyWith(color: kSubTitleColor),
                            ),
                            const SizedBox(width: 10.0),
                            Flexible(
                              child: Text(
                                jsonDecode(PrefUtils().getAccount())['Gender'] ?? '',
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Address',
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ':',
                              style: kTextStyle.copyWith(color: kSubTitleColor),
                            ),
                            const SizedBox(width: 10.0),
                            Flexible(
                              child: Text(
                                jsonDecode(PrefUtils().getAccount())['Address'] ?? '',
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Bio',
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ':',
                              style: kTextStyle.copyWith(color: kSubTitleColor),
                            ),
                            const SizedBox(width: 10.0),
                            Flexible(
                              child: ReadMoreText(
                                jsonDecode(PrefUtils().getAccount())['Bio'] ?? '',
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                                trimLines: 4,
                                colorClickableText: kPrimaryColor,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: '..read more',
                                trimExpandedText: ' read less',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
