import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
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
import '../../../data/apis/account_role_api.dart';
import '../../../data/apis/artwork_api.dart';
import '../../../data/models/account.dart';
import '../../../data/models/artwork.dart';
import '../../widgets/constant.dart';
import '../../widgets/responsive.dart';
import '../notification/client_notification.dart';
import '../search/search.dart';
import 'client_all_categories.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({Key? key}) : super(key: key);

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  late Future<Artworks?> popularArtworks;
  late Future<Accounts?> topArtists;
  late Future<Artworks?> newArtworks;

  int poppularArtworkTop = 10;
  int newArtworkTop = 10;
  int artistTop = 10;

  @override
  void initState() {
    super.initState();

    popularArtworks = getPopularArtworks();
    topArtists = getTopArtists();
    newArtworks = getNewArtworks();

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: '$dod | Home',
      color: kPrimaryColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kDarkWhite,
          appBar: AppBar(
            backgroundColor: kDarkWhite,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Container(
              margin: const EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: ListTile(
                horizontalTitleGap: 0,
                visualDensity: const VisualDensity(vertical: -2),
                leading: const Icon(
                  FeatherIcons.search,
                  color: kNeutralColor,
                ),
                title: Text(
                  AppLocalizations.of(context)!.search,
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(),
                  );
                },
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        onCart();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: kPrimaryColor.withOpacity(0.2),
                          ),
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: kNeutralColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 9.0),
                    GestureDetector(
                      onTap: () => const ClientNotification().launch(context),
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
                  ],
                ),
              ).visible(!DodResponsive.isDesktop(context)),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              height: context.height(),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25.0),
                    HorizontalList(
                      physics: const BouncingScrollPhysics(),
                      spacing: 10.0,
                      itemCount: PrefUtils().getAccount() != '{}' ? 3 : 4,
                      itemBuilder: (_, i) {
                        return Container(
                          height: 140,
                          width: 304,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: const DecorationImage(image: AssetImage('images/banner.png'), fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 25.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        children: [
                          Text(
                            'Categories',
                            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => const ClientAllCategories().launch(context),
                            child: Text(
                              AppLocalizations.of(context)!.viewAll,
                              style: kTextStyle.copyWith(color: kLightNeutralColor),
                            ),
                          ),
                        ],
                      ),
                    ).visible(false),
                    HorizontalList(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 15.0, right: 15.0),
                      spacing: 10.0,
                      itemCount: catName.length,
                      itemBuilder: (_, i) {
                        return Container(
                          padding: const EdgeInsets.only(left: 5.0, right: 10.0, top: 5.0, bottom: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: kWhite,
                            boxShadow: const [
                              BoxShadow(
                                color: kBorderColorTextField,
                                blurRadius: 7.0,
                                spreadRadius: 1.0,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 39,
                                width: 39,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: AssetImage(catIcon[i]), fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    catName[i],
                                    style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    'Related all categories',
                                    style: kTextStyle.copyWith(color: kLightNeutralColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ).visible(false),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.popularArtwork,
                            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              onPopularArtwork();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.viewAll,
                              style: kTextStyle.copyWith(color: kLightNeutralColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: popularArtworks,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return HorizontalList(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(top: 20, bottom: 20, left: 15.0, right: 15.0),
                            spacing: 10.0,
                            itemCount: poppularArtworkTop,
                            itemBuilder: (_, i) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    onArtworkDetail(snapshot.data!.value.elementAt(i).id!.toString());
                                  },
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: kWhite,
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
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Stack(
                                          alignment: Alignment.topLeft,
                                          children: [
                                            Container(
                                              height: 120,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                  bottomLeft: Radius.circular(8.0),
                                                  topLeft: Radius.circular(8.0),
                                                ),
                                                image: DecorationImage(image: NetworkImage(snapshot.data!.value.elementAt(i).arts!.first.image!), fit: BoxFit.cover),
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // GestureDetector(
                                                //   onTap: () {
                                                //     setState(() {
                                                //       isFavorite = !isFavorite;
                                                //     });
                                                //   },
                                                //   child: Padding(
                                                //     padding:
                                                //         const EdgeInsets.only(
                                                //             top: 5.0,
                                                //             left: 5.0),
                                                //     child: Container(
                                                //       height: 25,
                                                //       width: 25,
                                                //       decoration:
                                                //           const BoxDecoration(
                                                //         color: Colors.white,
                                                //         shape: BoxShape.circle,
                                                //         boxShadow: [
                                                //           BoxShadow(
                                                //             color:
                                                //                 Colors.black12,
                                                //             blurRadius: 10.0,
                                                //             spreadRadius: 1.0,
                                                //             offset:
                                                //                 Offset(0, 2),
                                                //           ),
                                                //         ],
                                                //       ),
                                                //       child: isFavorite
                                                //           ? const Center(
                                                //               child: Icon(
                                                //                 Icons.favorite,
                                                //                 color:
                                                //                     Colors.red,
                                                //                 size: 16.0,
                                                //               ),
                                                //             )
                                                //           : const Center(
                                                //               child: Icon(
                                                //                 Icons
                                                //                     .favorite_border,
                                                //                 color:
                                                //                     kNeutralColor,
                                                //                 size: 16.0,
                                                //               ),
                                                //             ),
                                                //     ),
                                                //   ),
                                                // ),
                                                GestureDetector(
                                                  onTap: () {
                                                    onAddToCart(snapshot.data!.value.elementAt(i));
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                                                    child: Container(
                                                      height: 25,
                                                      width: 25,
                                                      decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black12,
                                                            blurRadius: 10.0,
                                                            spreadRadius: 1.0,
                                                            offset: Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.add_shopping_cart_outlined,
                                                          color: kNeutralColor,
                                                          size: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: SizedBox(
                                                  width: 190,
                                                  child: Text(
                                                    snapshot.data!.value.elementAt(i).title!,
                                                    style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
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
                                                    getReviewPoint(snapshot.data!.value.elementAt(i).artworkReviews!),
                                                    style: kTextStyle.copyWith(color: kNeutralColor),
                                                  ),
                                                  const SizedBox(width: 2.0),
                                                  Text(
                                                    '(${snapshot.data!.value.elementAt(i).artworkReviews!.length})',
                                                    style: kTextStyle.copyWith(color: kLightNeutralColor),
                                                  ),
                                                  const SizedBox(width: 40),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: AppLocalizations.of(context)!.price,
                                                      style: kTextStyle.copyWith(color: kLightNeutralColor),
                                                      children: [
                                                        TextSpan(
                                                          text: NumberFormat.simpleCurrency(
                                                            locale: 'vi_VN',
                                                          ).format(
                                                            snapshot.data!.value.elementAt(i).price!,
                                                          ),
                                                          style: kTextStyle.copyWith(
                                                            color: kPrimaryColor,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5.0),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 32,
                                                    width: 32,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(image: NetworkImage(snapshot.data!.value.elementAt(i).createdByNavigation!.avatar!), fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5.0),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        snapshot.data!.value.elementAt(i).createdByNavigation!.name!,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                                      ),
                                                      Text(
                                                        '${AppLocalizations.of(context)!.artistRank} - ${snapshot.data!.value.elementAt(i).createdByNavigation!.rank!.name!}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        return const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.topArtist,
                            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              onTopArtists();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.viewAll,
                              style: kTextStyle.copyWith(color: kLightNeutralColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: topArtists,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return HorizontalList(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(top: 20, bottom: 20, left: 15.0, right: 15.0),
                            spacing: 10.0,
                            itemCount: artistTop,
                            itemBuilder: (_, i) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    onArtistDetail(snapshot.data!.value.elementAt(i).id!.toString());
                                  },
                                  child: Container(
                                    height: 220,
                                    width: 156,
                                    decoration: BoxDecoration(
                                      color: kWhite,
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
                                        Container(
                                          height: 135,
                                          width: 156,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(8.0),
                                              topLeft: Radius.circular(8.0),
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(snapshot.data!.value.elementAt(i).avatar ?? defaultImage),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data!.value.elementAt(i).name!,
                                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 6.0),
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
                                                    getAccountReviewPoint(snapshot.data!.value.elementAt(i).accountReviewAccounts!),
                                                    style: kTextStyle.copyWith(color: kNeutralColor),
                                                  ),
                                                  const SizedBox(width: 2.0),
                                                  Text(
                                                    '(${snapshot.data!.value.elementAt(i).accountReviewAccounts!.length} ${AppLocalizations.of(context)!.review})',
                                                    style: kTextStyle.copyWith(color: kLightNeutralColor),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6.0),
                                              RichText(
                                                text: TextSpan(
                                                  text: '${AppLocalizations.of(context)!.artistRank} - ',
                                                  style: kTextStyle.copyWith(color: kNeutralColor),
                                                  children: [
                                                    TextSpan(
                                                      text: snapshot.data!.value.elementAt(i).rank!.name!,
                                                      style: kTextStyle.copyWith(color: kLightNeutralColor),
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
                                ),
                              );
                            },
                          );
                        }

                        return const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.newArtwork,
                            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              onNewArtworks();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.viewAll,
                              style: kTextStyle.copyWith(color: kLightNeutralColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: newArtworks,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return HorizontalList(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(top: 20, bottom: 20, left: 15.0, right: 15.0),
                            spacing: 10.0,
                            itemCount: newArtworkTop,
                            itemBuilder: (_, i) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    onArtworkDetail(snapshot.data!.value.elementAt(i).id!.toString());
                                  },
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: kWhite,
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
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Stack(
                                          alignment: Alignment.topLeft,
                                          children: [
                                            Container(
                                              height: 120,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                  bottomLeft: Radius.circular(8.0),
                                                  topLeft: Radius.circular(8.0),
                                                ),
                                                image: DecorationImage(image: NetworkImage(snapshot.data!.value.elementAt(i).arts!.first.image!), fit: BoxFit.cover),
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      isFavorite = !isFavorite;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                                                    child: Container(
                                                      height: 25,
                                                      width: 25,
                                                      decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black12,
                                                            blurRadius: 10.0,
                                                            spreadRadius: 1.0,
                                                            offset: Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: isFavorite
                                                          ? const Center(
                                                              child: Icon(
                                                                Icons.favorite,
                                                                color: Colors.red,
                                                                size: 16.0,
                                                              ),
                                                            )
                                                          : const Center(
                                                              child: Icon(
                                                                Icons.favorite_border,
                                                                color: kNeutralColor,
                                                                size: 16.0,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    onAddToCart(snapshot.data!.value.elementAt(i));
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                                                    child: Container(
                                                      height: 25,
                                                      width: 25,
                                                      decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black12,
                                                            blurRadius: 10.0,
                                                            spreadRadius: 1.0,
                                                            offset: Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.add_shopping_cart_outlined,
                                                          color: kNeutralColor,
                                                          size: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: SizedBox(
                                                  width: 190,
                                                  child: Text(
                                                    snapshot.data!.value.elementAt(i).title!,
                                                    style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
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
                                                    getReviewPoint(snapshot.data!.value.elementAt(i).artworkReviews!),
                                                    style: kTextStyle.copyWith(color: kNeutralColor),
                                                  ),
                                                  const SizedBox(width: 2.0),
                                                  Text(
                                                    '(${snapshot.data!.value.elementAt(i).artworkReviews!.length})',
                                                    style: kTextStyle.copyWith(color: kLightNeutralColor),
                                                  ),
                                                  const SizedBox(width: 40),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: AppLocalizations.of(context)!.price,
                                                      style: kTextStyle.copyWith(color: kLightNeutralColor),
                                                      children: [
                                                        TextSpan(
                                                          text: NumberFormat.simpleCurrency(locale: 'vi_VN').format(snapshot.data!.value.elementAt(i).price!),
                                                          style: kTextStyle.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 5.0),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 32,
                                                    width: 32,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(image: NetworkImage(snapshot.data!.value.elementAt(i).createdByNavigation!.avatar!), fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5.0),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        snapshot.data!.value.elementAt(i).createdByNavigation!.name!,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                                      ),
                                                      Text(
                                                        '${AppLocalizations.of(context)!.artistRank} - ${snapshot.data!.value.elementAt(i).createdByNavigation!.rank!.name!}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        return const Center(
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
      ),
    );
  }

  void init() async {
    if (PrefUtils().getToken() == '{}') {
      await FirebaseAuth.instance.signInAnonymously();

      // Save token
      var token = await FirebaseAuth.instance.currentUser!.getIdToken();
      await PrefUtils().setToken(token!);

      setState(() {
        popularArtworks = getPopularArtworks();
        topArtists = getTopArtists();
        newArtworks = getNewArtworks();
      });
    }
  }

  Future<Artworks?> getPopularArtworks() async {
    try {
      return ArtworkApi()
          .gets(
        0,
        top: poppularArtworkTop,
        filter: 'status eq \'Available\'',
        count: 'true',
        expand: 'artworkReviews,arts,createdByNavigation(expand=rank)',
      )
          .then((artworks) {
        if (poppularArtworkTop > artworks.count!) {
          poppularArtworkTop = artworks.count!;
        }

        return artworks;
      });
    } catch (error) {
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.getPopularArtworkFailed);
    }

    return null;
  }

  Future<Accounts?> getTopArtists() async {
    try {
      var accountRoles = await AccountRoleApi()
          .gets(
        0,
        top: artistTop,
        filter: "role/name eq 'Artist' and status eq 'Active' and account/status eq 'Active' and accountId ne ${jsonDecode(PrefUtils().getAccount())['Id']}",
        count: 'true',
        expand: 'account(expand=rank, accountReviewAccounts), role',
      )
          .then((artists) {
        if (artistTop > artists.count!) {
          artistTop = artists.count!;
        }

        return artists;
      });

      List<Account> accounts = List<Account>.from(accountRoles.value.map((ar) => ar.account!));

      return Accounts(value: accounts);
    } catch (error) {
      Fluttertoast.showToast(
          // ignore: use_build_context_synchronously
          msg: AppLocalizations.of(context)!.getTopArtistFailed);
    }

    return null;
  }

  Future<Artworks?> getNewArtworks() async {
    try {
      return ArtworkApi()
          .gets(
        0,
        top: newArtworkTop,
        filter: 'status eq \'Available\'',
        count: 'true',
        expand: 'artworkreviews,arts,createdbynavigation(expand=rank)',
        orderBy: 'createdDate desc',
      )
          .then((artworks) {
        if (newArtworkTop > artworks.count!) {
          newArtworkTop = artworks.count!;
        }

        return artworks;
      });
    } catch (error) {
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.getNewArtworkFaild);
    }

    return null;
  }

  void onArtworkDetail(String id) {
    context.goNamed(
      '${ArtworkDetailRoute.name} out',
      pathParameters: {'artworkId': id},
    );
  }

  void onCart() {
    context.goNamed(CartRoute.name);
  }

  void onPopularArtwork() {
    context.goNamed(ArtworkRoute.name, queryParameters: {'tab': 'Popular'});
  }

  void onNewArtworks() {
    context.goNamed(ArtworkRoute.name, queryParameters: {'tab': 'New'});
  }

  void onTopArtists() {
    context.goNamed(ArtistRoute.name);
  }

  void onProfile() {
    context.goNamed(ProfileRoute.name);
  }

  void onArtistDetail(String id) {
    context.goNamed(
      '${ArtistProfileDetailRoute.name} out',
      pathParameters: {'id': id},
    );
  }
}
