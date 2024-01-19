import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/rank_api.dart';
import '../../../data/apis/requirement_api.dart';
import '../../../data/models/requirement.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';

class BuyerRequestDetails extends StatefulWidget {
  final String? id;

  const BuyerRequestDetails({Key? key, this.id}) : super(key: key);

  @override
  State<BuyerRequestDetails> createState() => _BuyerRequestDetailsState();
}

class _BuyerRequestDetailsState extends State<BuyerRequestDetails> {
  late Future<Requirement?> requirement;

  bool canOffer = false;
  int maxConnect = 0;

  @override
  void initState() {
    super.initState();

    requirement = getRequirement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      appBar: AppBar(
        backgroundColor: kDarkWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: kNeutralColor),
        title: Text(
          AppLocalizations.of(context)!.details,
          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(color: kWhite),
        child: ButtonGlobalWithoutIcon(
          buttontext: AppLocalizations.of(context)!.sendOffer,
          buttonDecoration: kButtonDecoration.copyWith(
            color: canOffer ? kPrimaryColor : kLightNeutralColor,
          ),
          onPressed: () {
            canOffer ? onOffer() : null;
          },
          buttonTextColor: kWhite,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          width: context.width(),
          height: context.height(),
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: FutureBuilder(
            future: requirement,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: kWhite,
                          border: Border.all(color: kBorderColorTextField),
                          boxShadow: const [
                            BoxShadow(
                              color: kBorderColorTextField,
                              spreadRadius: 0.2,
                              blurRadius: 4.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                height: 44,
                                width: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(snapshot.data!.createdByNavigation!.avatar ?? defaultImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                snapshot.data!.createdByNavigation!.name!,
                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                DateFormat('dd-MM-yyyy').format(snapshot.data!.createdDate!),
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                              ),
                            ),
                            const Divider(
                              height: 0,
                              thickness: 1.0,
                              color: kBorderColorTextField,
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              snapshot.data!.title!,
                              style: kTextStyle.copyWith(
                                color: kNeutralColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              snapshot.data!.description!,
                              style: kTextStyle.copyWith(color: kSubTitleColor),
                            ),
                            const SizedBox(height: 20.0),
                            RichText(
                              text: TextSpan(
                                text: AppLocalizations.of(context)!.category,
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: snapshot.data!.category!.name,
                                    style: kTextStyle.copyWith(color: kNeutralColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                text: '${AppLocalizations.of(context)!.material}: ',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: snapshot.data!.material!.name,
                                    style: kTextStyle.copyWith(color: kNeutralColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                text: '${AppLocalizations.of(context)!.surface}: ',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: snapshot.data!.surface!.name,
                                    style: kTextStyle.copyWith(color: kNeutralColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.sizes!.isNotEmpty ? snapshot.data!.sizes!.length : 1,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5.0),
                                    RichText(
                                      text: TextSpan(
                                        text: '${AppLocalizations.of(context)!.pieces}: ',
                                        style: kTextStyle.copyWith(
                                          color: index == 0 ? kSubTitleColor : kWhite,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: snapshot.data!.pieces.toString(),
                                            style: kTextStyle.copyWith(
                                              color: index == 0 ? kNeutralColor : kWhite,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: snapshot.data!.sizes!.isNotEmpty ? ' (${snapshot.data!.sizes![index].width} cm x ${snapshot.data!.sizes![index].length} cm)' : null,
                                                style: kTextStyle.copyWith(
                                                  color: kNeutralColor,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                text: '${AppLocalizations.of(context)!.quantity}: ',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: snapshot.data!.quantity.toString(),
                                    style: kTextStyle.copyWith(color: kNeutralColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                text: '${AppLocalizations.of(context)!.budget}: ',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: NumberFormat.simpleCurrency(
                                      locale: 'vi-VN',
                                    ).format(snapshot.data!.budget),
                                    style: kTextStyle.copyWith(color: kNeutralColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                text: '${AppLocalizations.of(context)!.connectRequire}: ',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: calculateConnect(snapshot.data!.budget!),
                                    style: kTextStyle.copyWith(color: kNeutralColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0).visible(snapshot.data!.image != null),
                            Text(
                              AppLocalizations.of(context)!.attachFile,
                              style: kTextStyle.copyWith(
                                color: kSubTitleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ).visible(snapshot.data!.image != null),
                            const SizedBox(height: 8.0).visible(snapshot.data!.image != null),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxHeight: 359,
                                      maxWidth: 359,
                                    ),
                                    child: PhotoView(
                                      imageProvider: NetworkImage(
                                        snapshot.data!.image ?? defaultImage,
                                      ),
                                      tightMode: true,
                                    ),
                                  ),
                                ),
                              ],
                            ).visible(snapshot.data!.image != null),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<Requirement?> getRequirement() async {
    try {
      await RankApi().gets(0, orderBy: 'connect').then((ranks) {
        maxConnect = ranks.value.last.connect!;
      });

      return RequirementApi()
          .getOne(
        widget.id!,
        'createdByNavigation,category,surface,material,sizes,proposals',
      )
          .then((requirement) {
        setState(() {
          canOffer = !requirement.proposals!.any((proposal) => proposal.createdBy == Guid(jsonDecode(PrefUtils().getAccount())['Id']));
        });

        return requirement;
      });
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get requirement detail failed');
    }

    return null;
  }

  String calculateConnect(double budget) {
    int connect = budget ~/ 1000000;

    if (connect < 1) {
      connect = 1;
    }

    if (connect > maxConnect) {
      connect = maxConnect;
    }

    return connect.toString();
  }

  void onOffer() {
    context.goNamed(JobOfferRoute.name, pathParameters: {'jobId': widget.id!});
  }
}
