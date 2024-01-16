import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/common/common_features.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/artwork_api.dart';
import '../../../data/apis/rank_api.dart';
import '../../../data/models/artwork.dart';
import '../../../data/models/rank.dart';
import '../../widgets/chart.dart';
import '../../widgets/constant.dart';
import '../../widgets/data.dart';
import '../notification/seller_notification.dart';

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({Key? key}) : super(key: key);

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  late Future<Ranks?> ranks;
  late Future<Artworks?> artworks;

  @override
  void initState() {
    super.initState();

    ranks = getRanks();
    artworks = getArtworks();
  }

  DropdownButton<String> getPerformancePeriod() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in period) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(
          des,
          style: kTextStyle.copyWith(color: kSubTitleColor),
        ),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedPeriod,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) {
        setState(() {
          selectedPeriod = value!;
        });
      },
    );
  }

  DropdownButton<String> getStatisticsPeriod() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in staticsPeriod) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(
          des,
          style: kTextStyle.copyWith(color: kSubTitleColor),
        ),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedStaticsPeriod,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) {
        setState(() {
          selectedStaticsPeriod = value!;
        });
      },
    );
  }

  DropdownButton<String> getEarningPeriod() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in earningPeriod) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(
          des,
          style: kTextStyle.copyWith(color: kSubTitleColor),
        ),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedEarningPeriod,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) {
        setState(() {
          selectedEarningPeriod = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          backgroundColor: kDarkWhite,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: GestureDetector(
                onTap: () => {},
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                          jsonDecode(PrefUtils().getAccount())['Avatar']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              jsonDecode(PrefUtils().getAccount())['Name'],
              style: kTextStyle.copyWith(
                  color: kNeutralColor, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.imAArtist,
              style: kTextStyle.copyWith(color: kLightNeutralColor),
            ),
            trailing: GestureDetector(
              onTap: () => const SellerNotification().launch(context),
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
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Container(
            width: context.width(),
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
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
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: kBorderColorTextField),
                      boxShadow: const [
                        BoxShadow(
                          color: kDarkWhite,
                          blurRadius: 5.0,
                          spreadRadius: 2.0,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.performance,
                              style: kTextStyle.copyWith(
                                  color: kNeutralColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 30,
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  border: Border.all(color: kLightNeutralColor),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: getPerformancePeriod(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        const Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Summary(
                                title: '80 Orders',
                                subtitle: 'Order Completions',
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              flex: 1,
                              child: Summary2(
                                title1: '5.0/',
                                title2: '5.0',
                                subtitle: 'Positive Ratings',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        const Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Summary(
                                title: '100% On time',
                                subtitle: 'On-Time-Delivery',
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              flex: 1,
                              child: Summary(
                                title: 'Gigs 6 of 7',
                                subtitle: 'Total Gig',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: kBorderColorTextField),
                      boxShadow: const [
                        BoxShadow(
                          color: kDarkWhite,
                          blurRadius: 5.0,
                          spreadRadius: 2.0,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.statistics,
                              style: kTextStyle.copyWith(
                                  color: kNeutralColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 30,
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  border: Border.all(color: kLightNeutralColor),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: getStatisticsPeriod(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: RecordStatistics(
                                dataMap: dataMap,
                                colorList: colorList,
                              ),
                            ),
                            const Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  ChartLegend(
                                    iconColor: Color(0xFF69B22A),
                                    title: 'Impressions',
                                    value: '5.3K',
                                  ),
                                  ChartLegend(
                                    iconColor: Color(0xFF144BD6),
                                    title: 'Interaction',
                                    value: '3.5K',
                                  ),
                                  ChartLegend(
                                    iconColor: Color(0xFFFF3B30),
                                    title: 'Reached-Out',
                                    value: '2.3K',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: kBorderColorTextField),
                      boxShadow: const [
                        BoxShadow(
                          color: kDarkWhite,
                          blurRadius: 5.0,
                          spreadRadius: 2.0,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.earnings,
                              style: kTextStyle.copyWith(
                                  color: kNeutralColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 30,
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  border: Border.all(color: kLightNeutralColor),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: getEarningPeriod(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        const Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Summary(
                                title: '$currencySign${500.00}',
                                subtitle: 'Total Earnings',
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              flex: 1,
                              child: Summary(
                                title: '$currencySign${300.00}',
                                subtitle: 'Withdraw Earnings',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        const Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Summary(
                                title: '$currencySign${300.00}',
                                subtitle: 'Current Balance',
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              flex: 1,
                              child: Summary(
                                title: '$currencySign${300.00}',
                                subtitle: 'Active Orders',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      collapsedIconColor: kLightNeutralColor,
                      iconColor: kLightNeutralColor,
                      title: Text(
                        AppLocalizations.of(context)!.reachYourNextLevel,
                        style: kTextStyle.copyWith(
                            color: kNeutralColor, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        FutureBuilder(
                          future: ranks,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              int index = snapshot.data!.value
                                  .toList()
                                  .indexWhere((rank) =>
                                      rank.name == PrefUtils().getRank());

                              Column elements = Column(
                                children: [
                                  LevelSummary(
                                    title: snapshot.data!.value
                                        .elementAt(index)
                                        .name!,
                                    subTitle:
                                        '${AppLocalizations.of(context)!.feePerOrder} ${(snapshot.data!.value.elementAt(index).fee! * 100).toStringAsFixed(0)}%\n'
                                        'Connect: ${snapshot.data!.value.elementAt(index).connect!}',
                                    trailing1: NumberFormat.simpleCurrency(
                                            locale: 'vi_VN')
                                        .format(snapshot.data!.value
                                            .elementAt(index)
                                            .income),
                                    trailing2: NumberFormat.simpleCurrency(
                                            locale: 'vi_VN')
                                        .format(snapshot.data!.value
                                            .elementAt(index)
                                            .income),
                                  ),
                                ],
                              );

                              if (index < snapshot.data!.count! - 1) {
                                elements.children.addAll(
                                  [
                                    const SizedBox(height: 15.0),
                                    LevelSummary(
                                      title: snapshot.data!.value
                                          .elementAt(index + 1)
                                          .name!,
                                      subTitle:
                                          '${AppLocalizations.of(context)!.feePerOrder} ${(snapshot.data!.value.elementAt(index + 1).fee! * 100).toStringAsFixed(0)}%\n'
                                          'Connect: ${snapshot.data!.value.elementAt(index + 1).connect!}',
                                      trailing1: '0',
                                      trailing2: NumberFormat.simpleCurrency(
                                              locale: 'vi_VN')
                                          .format(snapshot.data!.value
                                              .elementAt(index + 1)
                                              .income),
                                    ),
                                  ],
                                );
                              }

                              return elements;
                            }

                            return const Center(
                              heightFactor: 2.0,
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.myArtworks,
                        style: kTextStyle.copyWith(
                            color: kNeutralColor, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          onViewAllArtwork();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.viewAll,
                          style: kTextStyle.copyWith(color: kLightNeutralColor),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  FutureBuilder(
                    future: artworks,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        int itemCount = snapshot.data!.count! < 10
                            ? snapshot.data!.count!
                            : 10;

                        return HorizontalList(
                          spacing: 10.0,
                          padding: const EdgeInsets.only(bottom: 10.0),
                          itemCount: itemCount,
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () {
                                onArtworkDetail(snapshot.data!.value
                                    .elementAt(index)
                                    .id
                                    .toString());
                              },
                              child: Container(
                                height: 205,
                                width: 156,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border:
                                      Border.all(color: kBorderColorTextField),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: kDarkWhite,
                                      blurRadius: 5.0,
                                      spreadRadius: 2.0,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 156,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(8.0),
                                              topLeft: Radius.circular(8.0),
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(snapshot
                                                  .data!.value
                                                  .elementAt(index)
                                                  .arts!
                                                  .first
                                                  .image!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.value
                                                .elementAt(index)
                                                .title!,
                                            style: kTextStyle.copyWith(
                                                color: kNeutralColor,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                IconlyBold.star,
                                                color: Colors.amber,
                                                size: 18.0,
                                              ),
                                              const SizedBox(width: 2.0),
                                              Text(
                                                getReviewPoint(snapshot
                                                    .data!.value
                                                    .elementAt(index)
                                                    .artworkReviews!),
                                                style: kTextStyle.copyWith(
                                                    color: kNeutralColor),
                                              ),
                                              const SizedBox(width: 2.0),
                                              Text(
                                                '(${snapshot.data!.value.elementAt(index).artworkReviews!.length} ${AppLocalizations.of(context)!.review})',
                                                style: kTextStyle.copyWith(
                                                    color: kLightNeutralColor),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5.0),
                                          RichText(
                                            text: TextSpan(
                                              text:
                                                  '${AppLocalizations.of(context)!.price}: ',
                                              style: kTextStyle.copyWith(
                                                  color: kLightNeutralColor),
                                              children: [
                                                TextSpan(
                                                  text: NumberFormat
                                                          .simpleCurrency(
                                                              locale: 'vi_VN')
                                                      .format(snapshot
                                                          .data!.value
                                                          .elementAt(index)
                                                          .price),
                                                  style: kTextStyle.copyWith(
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return const Center(
                        heightFactor: 2.0,
                        child: CircularProgressIndicator(
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
      ),
    );
  }

  Future<Ranks?> getRanks() async {
    try {
      return RankApi().gets(0, count: 'true', orderBy: 'income');
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get ranks failed');
    }

    return null;
  }

  Future<Artworks?> getArtworks() async {
    try {
      return ArtworkApi().gets(
        0,
        filter:
            'createdBy eq ${jsonDecode(PrefUtils().getAccount())['Id']} and status ne \'Proposed\' and status ne \'Deleted\'',
        count: 'true',
        orderBy: 'createdDate desc',
        expand: 'arts,artworkReviews',
      );
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get artworks failed');
    }

    return null;
  }

  void onViewAllArtwork() {
    context.goNamed(ArtworkRoute.name);
  }

  void onArtworkDetail(String id) {
    context.goNamed(
      '${ArtworkDetailRoute.name} out',
      pathParameters: {'artworkId': id},
    );
  }
}

class ChartLegend extends StatelessWidget {
  const ChartLegend({
    Key? key,
    required this.iconColor,
    required this.title,
    required this.value,
  }) : super(key: key);

  final Color iconColor;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.circle,
          size: 16.0,
          color: iconColor,
        ),
        const SizedBox(width: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: kTextStyle.copyWith(color: kSubTitleColor),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              value,
              style: kTextStyle.copyWith(
                  color: kNeutralColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
