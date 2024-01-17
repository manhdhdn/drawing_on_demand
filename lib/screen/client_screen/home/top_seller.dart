import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/common/common_features.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/account_role_api.dart';
import '../../../data/models/account.dart';
import '../../widgets/constant.dart';
import '../../widgets/responsive.dart';

class TopSeller extends StatefulWidget {
  const TopSeller({Key? key}) : super(key: key);

  @override
  State<TopSeller> createState() => _TopSellerState();
}

class _TopSellerState extends State<TopSeller> {
  final ScrollController _scrollController = ScrollController();

  bool isScrollDown = false;
  int height = 390;

  late Future<Accounts?> artists;

  int skip = 0;
  int top = 12;
  int count = 12;

  List<String> serviceList = [
    'All',
    'Top Artists',
  ];

  bool get _isShrink {
    return _scrollController.hasClients && _scrollController.offset > (height - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();

    artists = getArtists();

    _scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollListener);
    _scrollController.dispose();

    super.dispose();
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
            AppLocalizations.of(context)!.artists,
            style: kTextStyle.copyWith(
              color: kNeutralColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          child: const Icon(
            Icons.arrow_upward,
          ),
          onPressed: () {
            scrollUp();
          },
        ).visible(isScrollDown),
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
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.only(
                  left: DodResponsive.isDesktop(context) ? 150.0 : 0.0,
                  right: DodResponsive.isDesktop(context) ? 150.0 : 0.0,
                ),
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
                                selectedTopSeller = serviceList[i];
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: selectedTopSeller == serviceList[i] ? kPrimaryColor : kDarkWhite,
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: Text(
                                serviceList[i],
                                style: kTextStyle.copyWith(
                                  color: selectedTopSeller == serviceList[i] ? kWhite : kNeutralColor,
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
                        childAspectRatio: DodResponsive.isDesktop(context) ? 0.75 : 0.79,
                        crossAxisCount: DodResponsive.isDesktop(context) ? 3 : 2,
                        children: List.generate(
                          count,
                          (i) => Container(
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
                                      onDetail(snapshot.data!.value.elementAt(i).id.toString());
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          height: DodResponsive.isDesktop(context) ? 200 : 150,
                                          width: context.width(),
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
                                                maxLines: 2,
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
      ),
    );
  }

  Future<Accounts?> getArtists() async {
    try {
      var accountRoles = await AccountRoleApi()
          .gets(
        skip,
        top: top,
        filter: "role/name eq 'Artist' and status eq 'Active' and account/status eq 'Active' and accountId ne ${jsonDecode(PrefUtils().getAccount())['Id']}",
        count: 'true',
        expand: 'account(expand=rank, accountReviewAccounts), role',
      )
          .then((accountRoles) {
        if (accountRoles.count! < count) {
          count = accountRoles.count!;
        }

        return accountRoles;
      });

      List<Account> accounts = List<Account>.from(accountRoles.value.map((ar) => ar.account!));

      return Accounts(value: accounts);
    } catch (error) {
      // ignore: use_build_context_synchronously
      Fluttertoast.showToast(
          // ignore: use_build_context_synchronously
          msg: AppLocalizations.of(context)!.getTopArtistFailed);
    }

    return null;
  }

  void scrollUp() {
    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void scrollListener() {
    if (_isShrink != isScrollDown) {
      setState(() {
        isScrollDown = _isShrink;
      });
    }

    if (_scrollController.offset == _scrollController.position.maxScrollExtent) {
      if (count % top == 0) {
        skip = count;

        setState(() {
          artists = artists.then((artists) async {
            artists!.value.addAll((await getArtists())!.value);

            setState(() {
              count += artists.value.length - count;
            });

            return artists;
          });
        });
      }
    }
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
