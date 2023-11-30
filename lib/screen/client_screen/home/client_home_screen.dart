import 'dart:convert';

import 'package:decimal/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../data/apis/account_api.dart';
import '../../../data/apis/artwork_api.dart';
import '../../../data/models/account.dart';
import '../../../data/models/artwork.dart';
import '../../widgets/constant.dart';
import '../notification/client_notification.dart';
import '../service_details/client_service_details.dart';
import '../search/search.dart';
import 'client_all_categories.dart';
import 'popular_services.dart';
import 'recently_view.dart';
import 'top_seller.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({Key? key}) : super(key: key);

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  late Future<dynamic> account;
  late Future<Artworks?> popularArtworks;
  late Future<Accounts?> topArtists;
  late Future<Artworks?> newArtworks;

  int top = 10;

  @override
  void initState() {
    super.initState();

    account = getData();
    popularArtworks = getPoppularArtworks();
    topArtists = getTopArtists();
    newArtworks = getNewArtworks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: account,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: kDarkWhite,
              appBar: AppBar(
                backgroundColor: kDarkWhite,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: ListTile(
                  contentPadding: const EdgeInsets.only(top: 10),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: GestureDetector(
                      // onTap: () => const ClientProfile().launch(context),
                      child: Container(
                        height: 44,
                        width: 44,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('images/profile3.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    snapshot.data!.name!,
                    style: kTextStyle.copyWith(
                        color: kNeutralColor, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'I’m a Client',
                    style: kTextStyle.copyWith(color: kLightNeutralColor),
                  ),
                  trailing: GestureDetector(
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
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: 15.0),
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
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: kDarkWhite,
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
                                'Search services...',
                                style:
                                    kTextStyle.copyWith(color: kSubTitleColor),
                              ),
                              onTap: () {
                                showSearch(
                                  context: context,
                                  delegate: CustomSearchDelegate(),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        HorizontalList(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(left: 15),
                          spacing: 10.0,
                          itemCount: 3,
                          itemBuilder: (_, i) {
                            return Container(
                              height: 140,
                              width: 304,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: const DecorationImage(
                                    image: AssetImage('images/banner.png'),
                                    fit: BoxFit.cover),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 25.0),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Row(
                            children: [
                              Text(
                                'Categories',
                                style: kTextStyle.copyWith(
                                    color: kNeutralColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () =>
                                    const ClientAllCategories().launch(context),
                                child: Text(
                                  'View All',
                                  style: kTextStyle.copyWith(
                                      color: kLightNeutralColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        HorizontalList(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 20, left: 15.0, right: 15.0),
                          spacing: 10.0,
                          itemCount: catName.length,
                          itemBuilder: (_, i) {
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 5.0,
                                  right: 10.0,
                                  top: 5.0,
                                  bottom: 5.0),
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
                                      image: DecorationImage(
                                          image: AssetImage(catIcon[i]),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        catName[i],
                                        style: kTextStyle.copyWith(
                                            color: kNeutralColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        'Related all categories',
                                        style: kTextStyle.copyWith(
                                            color: kLightNeutralColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 10),
                          child: Row(
                            children: [
                              Text(
                                'Popular Artworks',
                                style: kTextStyle.copyWith(
                                    color: kNeutralColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () =>
                                    const PopularServices().launch(context),
                                child: Text(
                                  'View All',
                                  style: kTextStyle.copyWith(
                                      color: kLightNeutralColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder(
                          future: popularArtworks,
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              return HorizontalList(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 20,
                                    left: 15.0,
                                    right: 15.0),
                                spacing: 10.0,
                                itemCount: snapshot.data!.value.length,
                                itemBuilder: (_, i) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: GestureDetector(
                                      onTap: () => const ClientServiceDetails()
                                          .launch(context),
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: kWhite,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                              color: kBorderColorTextField),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Stack(
                                              alignment: Alignment.topLeft,
                                              children: [
                                                Container(
                                                  height: 120,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(8.0),
                                                      topLeft:
                                                          Radius.circular(8.0),
                                                    ),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            snapshot.data!.value
                                                                .elementAt(i)
                                                                .arts!
                                                                .first
                                                                .image!),
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      isFavorite = !isFavorite;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Container(
                                                      height: 25,
                                                      width: 25,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            blurRadius: 10.0,
                                                            spreadRadius: 1.0,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: isFavorite
                                                          ? const Center(
                                                              child: Icon(
                                                                Icons.favorite,
                                                                color:
                                                                    Colors.red,
                                                                size: 16.0,
                                                              ),
                                                            )
                                                          : const Center(
                                                              child: Icon(
                                                                Icons
                                                                    .favorite_border,
                                                                color:
                                                                    kNeutralColor,
                                                                size: 16.0,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flexible(
                                                    child: SizedBox(
                                                      width: 190,
                                                      child: Text(
                                                        snapshot.data!.value
                                                            .elementAt(i)
                                                            .title!,
                                                        style:
                                                            kTextStyle.copyWith(
                                                                color:
                                                                    kNeutralColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
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
                                                      const SizedBox(
                                                          width: 2.0),
                                                      Text(
                                                        '5.0',
                                                        style: kTextStyle.copyWith(
                                                            color:
                                                                kNeutralColor),
                                                      ),
                                                      const SizedBox(
                                                          width: 2.0),
                                                      Text(
                                                        '(2)',
                                                        style: kTextStyle.copyWith(
                                                            color:
                                                                kLightNeutralColor),
                                                      ),
                                                      const SizedBox(width: 40),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: 'Price: ',
                                                          style: kTextStyle
                                                              .copyWith(
                                                                  color:
                                                                      kLightNeutralColor),
                                                          children: [
                                                            TextSpan(
                                                              text: NumberFormat
                                                                      .decimalPattern(
                                                                          'vi_VN')
                                                                  .format(DecimalIntl(snapshot
                                                                      .data!
                                                                      .value
                                                                      .elementAt(
                                                                          i)
                                                                      .price!)),
                                                              style: kTextStyle.copyWith(
                                                                  color:
                                                                      kPrimaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  snapshot.data!
                                                                      .value
                                                                      .elementAt(
                                                                          i)
                                                                      .createdByNavigation!
                                                                      .avatar!),
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width: 5.0),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            snapshot.data!.value
                                                                .elementAt(i)
                                                                .createdByNavigation!
                                                                .name!,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: kTextStyle.copyWith(
                                                                color:
                                                                    kNeutralColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            'Artist Rank - ${snapshot.data!.value.elementAt(i).createdByNavigation!.rank!.name!}',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: kTextStyle
                                                                .copyWith(
                                                                    color:
                                                                        kSubTitleColor),
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
                          }),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Row(
                            children: [
                              Text(
                                'Top Artists',
                                style: kTextStyle.copyWith(
                                    color: kNeutralColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => const TopSeller().launch(context),
                                child: Text(
                                  'View All',
                                  style: kTextStyle.copyWith(
                                      color: kLightNeutralColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder(
                          future: topArtists,
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              return HorizontalList(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 20,
                                    left: 15.0,
                                    right: 15.0),
                                spacing: 10.0,
                                itemCount: snapshot.data!.value.length,
                                itemBuilder: (_, i) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Container(
                                      height: 220,
                                      width: 156,
                                      decoration: BoxDecoration(
                                        color: kWhite,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                            color: kBorderColorTextField),
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
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(8.0),
                                                topLeft: Radius.circular(8.0),
                                              ),
                                              image: DecorationImage(
                                                  image: NetworkImage(snapshot
                                                      .data!.value
                                                      .elementAt(i)
                                                      .avatar!),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data!.value
                                                      .elementAt(i)
                                                      .name!,
                                                  style: kTextStyle.copyWith(
                                                      color: kNeutralColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 6.0),
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
                                                      '5.0',
                                                      style: kTextStyle.copyWith(
                                                          color: kNeutralColor),
                                                    ),
                                                    const SizedBox(width: 2.0),
                                                    Text(
                                                      '(2 review)',
                                                      style: kTextStyle.copyWith(
                                                          color:
                                                              kLightNeutralColor),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6.0),
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Artist Rank - ',
                                                    style: kTextStyle.copyWith(
                                                        color: kNeutralColor),
                                                    children: [
                                                      TextSpan(
                                                        text: '1',
                                                        style: kTextStyle.copyWith(
                                                            color:
                                                                kLightNeutralColor),
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
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                            );
                          }),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Row(
                            children: [
                              Text(
                                'New Artworks',
                                style: kTextStyle.copyWith(
                                    color: kNeutralColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () =>
                                    const RecentlyView().launch(context),
                                child: Text(
                                  'View All',
                                  style: kTextStyle.copyWith(
                                      color: kLightNeutralColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder(
                          future: newArtworks,
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              return HorizontalList(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 20,
                                    left: 15.0,
                                    right: 15.0),
                                spacing: 10.0,
                                itemCount: snapshot.data!.value.length,
                                itemBuilder: (_, i) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: GestureDetector(
                                      onTap: () => const ClientServiceDetails()
                                          .launch(context),
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: kWhite,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                              color: kBorderColorTextField),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Stack(
                                              alignment: Alignment.topLeft,
                                              children: [
                                                Container(
                                                  height: 120,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(8.0),
                                                      topLeft:
                                                          Radius.circular(8.0),
                                                    ),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            snapshot.data!.value
                                                                .elementAt(i)
                                                                .arts!
                                                                .first
                                                                .image!),
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      isFavorite = !isFavorite;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Container(
                                                      height: 25,
                                                      width: 25,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            blurRadius: 10.0,
                                                            spreadRadius: 1.0,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: isFavorite
                                                          ? const Center(
                                                              child: Icon(
                                                                Icons.favorite,
                                                                color:
                                                                    Colors.red,
                                                                size: 16.0,
                                                              ),
                                                            )
                                                          : const Center(
                                                              child: Icon(
                                                                Icons
                                                                    .favorite_border,
                                                                color:
                                                                    kNeutralColor,
                                                                size: 16.0,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flexible(
                                                    child: SizedBox(
                                                      width: 190,
                                                      child: Text(
                                                        snapshot.data!.value
                                                            .elementAt(i)
                                                            .title!,
                                                        style:
                                                            kTextStyle.copyWith(
                                                                color:
                                                                    kNeutralColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
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
                                                      const SizedBox(
                                                          width: 2.0),
                                                      Text(
                                                        '5.0',
                                                        style: kTextStyle.copyWith(
                                                            color:
                                                                kNeutralColor),
                                                      ),
                                                      const SizedBox(
                                                          width: 2.0),
                                                      Text(
                                                        '(2)',
                                                        style: kTextStyle.copyWith(
                                                            color:
                                                                kLightNeutralColor),
                                                      ),
                                                      const SizedBox(width: 40),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: 'Price: ',
                                                          style: kTextStyle
                                                              .copyWith(
                                                                  color:
                                                                      kLightNeutralColor),
                                                          children: [
                                                            TextSpan(
                                                              text: NumberFormat
                                                                      .decimalPattern(
                                                                          'vi_VN')
                                                                  .format(DecimalIntl(snapshot
                                                                      .data!
                                                                      .value
                                                                      .elementAt(
                                                                          i)
                                                                      .price!)),
                                                              style: kTextStyle.copyWith(
                                                                  color:
                                                                      kPrimaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  snapshot.data!
                                                                      .value
                                                                      .elementAt(
                                                                          i)
                                                                      .createdByNavigation!
                                                                      .avatar!),
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width: 5.0),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            snapshot.data!.value
                                                                .elementAt(i)
                                                                .createdByNavigation!
                                                                .name!,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: kTextStyle.copyWith(
                                                                color:
                                                                    kNeutralColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            'Artist Rank - ${snapshot.data!.value.elementAt(i).createdByNavigation!.rank!.name!}',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: kTextStyle
                                                                .copyWith(
                                                                    color:
                                                                        kSubTitleColor),
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
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(
            color: kPrimaryColor,
          ),
        );
      }),
    );
  }

  Future<Account> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return Account.fromJson(jsonDecode(prefs.getString('account')!));
  }

  Future<Artworks?> getPoppularArtworks() async {
    try {
      return ArtworkApi().gets(
        0,
        top: top,
        expand: 'artworkReviews,arts,createdByNavigation(expand=rank)',
      );
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get popular artworks failed');
    }

    return null;
  }

  Future<Accounts?> getTopArtists() async {
    try {
      return AccountApi().gets(
        0,
        top: 10,
        expand: 'accountReviewAccounts,rank',
        filter: "gender eq 'Male'",
      );
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get top artists failed');
    }

    return null;
  }

  Future<Artworks?> getNewArtworks() async {
    try {
      return ArtworkApi().gets(
        0,
        top: 10,
        expand: 'artworkreviews,arts,createdbynavigation(expand=rank)',
        orderBy: 'createdDate desc',
      );
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get new artworks failed');
    }

    return null;
  }
}