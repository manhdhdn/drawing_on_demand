import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/common/common_features.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/account_role_api.dart';
import '../../../data/models/account.dart';
import '../../widgets/constant.dart';

class TopSeller extends StatefulWidget {
  const TopSeller({Key? key}) : super(key: key);

  @override
  State<TopSeller> createState() => _TopSellerState();
}

class _TopSellerState extends State<TopSeller> {
  late Future<Accounts?> artists;

  int skip = 0;
  int top = 10;
  int count = 10;

  String selectedServiceList = 'Top Artists';

  List<String> serviceList = [
    'All',
    'Top Artists',
  ];

  @override
  void initState() {
    super.initState();

    artists = getArtists();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: '$dod | Artists',
      color: kPrimaryColor,
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: kDarkWhite,
          centerTitle: true,
          iconTheme: const IconThemeData(color: kNeutralColor),
          title: Text(
            'Artists',
            style: kTextStyle.copyWith(
                color: kNeutralColor, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Container(
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
                  const SizedBox(height: 15.0),
                  HorizontalList(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    itemCount: serviceList.length,
                    itemBuilder: (_, i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedServiceList = serviceList[i];
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: selectedServiceList == serviceList[i]
                                  ? kPrimaryColor
                                  : kDarkWhite,
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: Text(
                              serviceList[i],
                              style: kTextStyle.copyWith(
                                color: selectedServiceList == serviceList[i]
                                    ? kWhite
                                    : kNeutralColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 0.7,
                      crossAxisCount: 2,
                      children: List.generate(
                        count,
                        (i) => Container(
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
                          child: FutureBuilder(
                            future: artists,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return GestureDetector(
                                  onTap: () {
                                    onDetail(snapshot.data!.value
                                        .elementAt(i)
                                        .id
                                        .toString());
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 135,
                                        width: context.width(),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
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
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                                                  getAccountReviewPoint(snapshot
                                                      .data!.value
                                                      .elementAt(i)
                                                      .accountReviewAccounts!),
                                                  style: kTextStyle.copyWith(
                                                      color: kNeutralColor),
                                                ),
                                                const SizedBox(width: 2.0),
                                                Text(
                                                  '(${snapshot.data!.value.elementAt(i).accountReviewAccounts!.length} review)',
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
                                                    text: snapshot.data!.value
                                                        .elementAt(i)
                                                        .rank!
                                                        .name!,
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
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Accounts?> getArtists() async {
    try {
      var accountRoles = await AccountRoleApi()
          .gets(
        skip,
        top: top,
        filter:
            "role/name eq 'Artist' and accountId ne ${jsonDecode(PrefUtils().getAccount())['Id']}",
        count: 'true',
        expand: 'account(expand=rank, accountReviewAccounts), role',
      )
          .then((accountRoles) {
        if (accountRoles.count! < count) {
          setState(() {
            count = accountRoles.count!;
          });
        }

        return accountRoles;
      });

      List<Account> accounts =
          List<Account>.from(accountRoles.value.map((ar) => ar.account!));

      return Accounts(value: accounts);
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get artists failed');
    }

    return null;
  }

  void onDetail(String id) {
    var state = GoRouterState.of(context);
    String name = ArtistProfileDetailRoute.name;
    Map<String, String> pathParameters = {'id': id};

    if (state.pathParameters['jobId'] != null) {
      name = '$name job';
      pathParameters['jobId'] = state.pathParameters['jobId']!;
    }

    context.goNamed(name, pathParameters: pathParameters);
  }
}
