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
import '../../../data/models/artwork.dart';
import '../../widgets/constant.dart';

class CreateService extends StatefulWidget {
  static dynamic state;

  const CreateService({Key? key}) : super(key: key);

  @override
  State<CreateService> createState() => _CreateServiceState();

  static void refresh() {
    state.refresh();
  }
}

class _CreateServiceState extends State<CreateService> {
  late Future<Artworks?> artworks;

  List<String> serviceList = [
    'All',
    'Available',
    'Paused',
    'Deleted',
  ];

  @override
  void initState() {
    super.initState();

    CreateService.state = this;
    artworks = getArtworks();
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
          AppLocalizations.of(context)!.artworks,
          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            onCreateArtwork();
          },
          backgroundColor: kPrimaryColor,
          child: const Icon(
            FeatherIcons.plus,
            color: kWhite,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
          width: context.width(),
          height: context.height(),
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: FutureBuilder(
            future: artworks,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15.0),
                      HorizontalList(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        itemCount: serviceList.length,
                        itemBuilder: (_, i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                onChangeTab(i);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: selectedArtworkCreateTab == serviceList[i] ? kPrimaryColor : kDarkWhite,
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                child: Text(
                                  serviceList[i] == 'All'
                                      ? AppLocalizations.of(context)!.all
                                      : serviceList[i] == 'Available'
                                          ? AppLocalizations.of(context)!.available
                                          : serviceList[i] == 'Paused'
                                              ? AppLocalizations.of(context)!.paused
                                              : AppLocalizations.of(context)!.deleted,
                                  style: kTextStyle.copyWith(
                                    color: selectedArtworkCreateTab == serviceList[i] ? kWhite : kNeutralColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15.0),
                      Column(
                        children: [
                          const SizedBox(height: 50.0),
                          Container(
                            height: 213,
                            width: 269,
                            decoration: const BoxDecoration(
                              image: DecorationImage(image: AssetImage('images/emptyservice.png'), fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            AppLocalizations.of(context)!.nothingJustYet,
                            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 24.0),
                          ),
                        ],
                      ).visible(snapshot.data!.value.isEmpty),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 0.8,
                        crossAxisCount: 2,
                        children: List.generate(
                          snapshot.data!.count!,
                          (index) => GestureDetector(
                            onTap: () {
                              onDetail(snapshot.data!.value.elementAt(index).id.toString());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
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
                                children: [
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        height: 105,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(8.0),
                                            topLeft: Radius.circular(8.0),
                                          ),
                                          image: DecorationImage(image: NetworkImage(snapshot.data!.value.elementAt(index).arts!.first.image!), fit: BoxFit.cover),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.value.elementAt(index).title!,
                                          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5.0),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              IconlyBold.star,
                                              color: Colors.amber,
                                              size: 18.0,
                                            ),
                                            const SizedBox(width: 2.0),
                                            Text(
                                              getReviewPoint(snapshot.data!.value.elementAt(index).artworkReviews!),
                                              style: kTextStyle.copyWith(color: kNeutralColor),
                                            ),
                                            const SizedBox(width: 2.0),
                                            Text(
                                              '(${snapshot.data!.value.elementAt(index).artworkReviews!.length} ${AppLocalizations.of(context)!.review})',
                                              style: kTextStyle.copyWith(color: kLightNeutralColor),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5.0),
                                        RichText(
                                          text: TextSpan(
                                            text: '${AppLocalizations.of(context)!.price}: ',
                                            style: kTextStyle.copyWith(color: kLightNeutralColor),
                                            children: [
                                              TextSpan(
                                                text: NumberFormat.simpleCurrency(locale: 'vi_VN').format(snapshot.data!.value.elementAt(index).price),
                                                style: kTextStyle.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        RichText(
                                          text: TextSpan(
                                            text: '${AppLocalizations.of(context)!.inStock}: ',
                                            style: kTextStyle.copyWith(color: kLightNeutralColor),
                                            children: [
                                              TextSpan(
                                                text: snapshot.data!.value[index].inStock.toString(),
                                                style: kTextStyle.copyWith(
                                                  color: kSubTitleColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5.0),
                                        RichText(
                                          text: TextSpan(
                                            text: '${AppLocalizations.of(context)!.status}: ',
                                            style: kTextStyle.copyWith(color: kLightNeutralColor),
                                            children: [
                                              TextSpan(
                                                text: snapshot.data!.value[index].status == 'Available'
                                                    ? AppLocalizations.of(context)!.available
                                                    : snapshot.data!.value[index].status == 'Paused'
                                                        ? AppLocalizations.of(context)!.paused
                                                        : snapshot.data!.value[index].status == 'Deleted'
                                                            ? AppLocalizations.of(context)!.deleted
                                                            : snapshot.data!.value[index].status,
                                                style: kTextStyle.copyWith(
                                                  color: kSubTitleColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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

  Future<Artworks?> getArtworks() async {
    try {
      String filter = 'createdBy eq ${jsonDecode(PrefUtils().getAccount())['Id']} and status ne \'Proposed\'';

      switch (selectedArtworkCreateTab) {
        case 'Available':
          filter += ' and status eq \'Available\'';
          break;
        case 'Paused':
          filter += ' and status eq \'Paused\'';
          break;
        case 'Deleted':
          filter += ' and status eq \'Deleted\'';
          break;
        default:
      }

      return ArtworkApi().gets(
        0,
        filter: filter,
        count: 'true',
        orderBy: 'createdDate desc',
        expand: 'arts,artworkReviews',
      );
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get artworks failed');
    }

    return null;
  }

  void onCreateArtwork() {
    context.goNamed(ArtworkCreateRoute.name);
  }

  void onDetail(String id) {
    context.goNamed('${ArtworkDetailRoute.name} in', pathParameters: {'artworkId': id});
  }

  void refresh() {
    setState(() {
      artworks = getArtworks();
    });
  }

  void onChangeTab(int i) {
    setState(() {
      selectedArtworkCreateTab = serviceList[i];
      artworks = getArtworks();
    });
  }
}
