import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../app_routes/named_routes.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/invite_api.dart';
import '../../../data/apis/requirement_api.dart';
import '../../../data/models/invite.dart';
import '../../../data/models/requirement.dart';
import '../../widgets/constant.dart';
import '../../widgets/icons.dart';
import '../../common/popUp/popup_1.dart';

class SellerBuyerReq extends StatefulWidget {
  const SellerBuyerReq({Key? key}) : super(key: key);

  @override
  State<SellerBuyerReq> createState() => _SellerBuyerReqState();
}

class _SellerBuyerReqState extends State<SellerBuyerReq> {
  final ScrollController _scrollController = ScrollController();

  bool isScrollDown = false;
  int height = 790;

  late Future<Requirements?> requirements;
  late Future<Invites?> invites;

  List<String> listTab = [
    'Public',
    'Invites',
  ];

  int requirementSkip = 0;
  int requirementTop = 10;
  int requirementCount = 10;

  int inviteSkip = 0;
  int inviteTop = 10;
  int inviteCount = 10;

  bool get _isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (height - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();

    requirements = getRequirements();
    invites = getInvites();

    _scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollListener);
    _scrollController.dispose();

    super.dispose();
  }

  void sendOfferPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const SendOfferPopUp(),
            );
          },
        );
      },
    );
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
          'Requirements',
          style: kTextStyle.copyWith(
              color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
          width: context.width(),
          height: context.height(),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                HorizontalList(
                  padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                  itemCount: listTab.length,
                  itemBuilder: (_, i) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedJobApplyTab = listTab[i];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: selectedJobApplyTab == listTab[i]
                              ? kPrimaryColor
                              : kDarkWhite,
                        ),
                        child: Text(
                          listTab[i],
                          style: kTextStyle.copyWith(
                            color: selectedJobApplyTab == listTab[i]
                                ? kWhite
                                : kNeutralColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                FutureBuilder(
                  future: requirements,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: requirementCount,
                        itemBuilder: (_, i) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                onDetail(snapshot.data!.value[i].id.toString());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: kWhite,
                                  border:
                                      Border.all(color: kBorderColorTextField),
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: Container(
                                              height: 44,
                                              width: 44,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    snapshot
                                                            .data!
                                                            .value[i]
                                                            .createdByNavigation!
                                                            .avatar ??
                                                        defaultImage,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              snapshot.data!.value[i]
                                                  .createdByNavigation!.name!,
                                              style: kTextStyle.copyWith(
                                                color: kNeutralColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(
                                              timeago.format(snapshot
                                                  .data!.value[i].createdDate!),
                                              style: kTextStyle.copyWith(
                                                color: kSubTitleColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: context.width() / 3,
                                          child: Button(
                                            containerBg: kWhite,
                                            borderColor: kPrimaryColor,
                                            buttonText: 'Send Offer',
                                            textColor: kPrimaryColor,
                                            onPressed: () {
                                              onSendOffer();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      height: 0,
                                      thickness: 1.0,
                                      color: kBorderColorTextField,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      snapshot.data!.value[i].title!,
                                      style: kTextStyle.copyWith(
                                          color: kNeutralColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5.0),
                                    ReadMoreText(
                                      snapshot.data!.value[i].description!,
                                      style: kTextStyle.copyWith(
                                          color: kLightNeutralColor),
                                      trimLines: 3,
                                      colorClickableText: kPrimaryColor,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: '..read more',
                                      trimExpandedText: ' read less',
                                    ),
                                    const SizedBox(height: 10.0),
                                    RichText(
                                      text: TextSpan(
                                          text: 'Category: ',
                                          style: kTextStyle.copyWith(
                                              color: kNeutralColor,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                            TextSpan(
                                              text: snapshot.data!.value[i]
                                                  .category!.name,
                                              style: kTextStyle.copyWith(
                                                  color: kSubTitleColor),
                                            )
                                          ]),
                                    ),
                                    const SizedBox(height: 10.0),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ).visible(selectedJobApplyTab == 'Public');
                    }

                    return SizedBox(
                      width: context.width(),
                      height: context.height() - 270.0,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      ),
                    );
                  },
                ),
                FutureBuilder(
                  future: invites,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: inviteCount,
                        itemBuilder: (_, i) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                onDetail(snapshot.data!.value[i].requirement!.id
                                    .toString());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: kWhite,
                                  border:
                                      Border.all(color: kBorderColorTextField),
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: Container(
                                              height: 44,
                                              width: 44,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    snapshot
                                                            .data!
                                                            .value[i]
                                                            .requirement!
                                                            .createdByNavigation!
                                                            .avatar ??
                                                        defaultImage,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              snapshot
                                                  .data!
                                                  .value[i]
                                                  .requirement!
                                                  .createdByNavigation!
                                                  .name!,
                                              style: kTextStyle.copyWith(
                                                color: kNeutralColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(
                                              timeago.format(snapshot
                                                  .data!.value[i].createdDate!),
                                              style: kTextStyle.copyWith(
                                                color: kSubTitleColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: context.width() / 3,
                                          child: Button(
                                            containerBg: kWhite,
                                            borderColor: kPrimaryColor,
                                            buttonText: 'Send Offer',
                                            textColor: kPrimaryColor,
                                            onPressed: () {
                                              setState(() {
                                                sendOfferPopUp();
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      height: 0,
                                      thickness: 1.0,
                                      color: kBorderColorTextField,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      snapshot
                                          .data!.value[i].requirement!.title!,
                                      style: kTextStyle.copyWith(
                                          color: kNeutralColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5.0),
                                    ReadMoreText(
                                      snapshot.data!.value[i].requirement!
                                          .description!,
                                      style: kTextStyle.copyWith(
                                          color: kLightNeutralColor),
                                      trimLines: 3,
                                      colorClickableText: kPrimaryColor,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: '..read more',
                                      trimExpandedText: ' read less',
                                    ),
                                    const SizedBox(height: 10.0),
                                    RichText(
                                      text: TextSpan(
                                          text: 'Category: ',
                                          style: kTextStyle.copyWith(
                                              color: kNeutralColor,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                            TextSpan(
                                              text: snapshot.data!.value[i]
                                                  .requirement!.category!.name,
                                              style: kTextStyle.copyWith(
                                                  color: kSubTitleColor),
                                            )
                                          ]),
                                    ),
                                    const SizedBox(height: 10.0),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ).visible(selectedJobApplyTab == 'Invites');
                    }

                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Requirements?> getRequirements() async {
    try {
      return RequirementApi()
          .gets(
        requirementSkip,
        top: requirementTop,
        filter: 'status eq \'Public\'',
        count: 'true',
        orderBy: 'createdDate desc',
        expand: 'createdByNavigation,category',
      )
          .then((requirements) {
        if (requirements.count! < requirementCount) {
          requirementCount = requirements.count!;
        }

        return requirements;
      });
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get requirements failed');
    }

    return null;
  }

  Future<Invites?> getInvites() async {
    try {
      return InviteApi()
          .gets(
        inviteSkip,
        top: inviteTop,
        filter:
            'receivedBy eq ${jsonDecode(PrefUtils().getAccount())['Id']} and requirement/status in (\'Private\',\'Public\')',
        count: 'true',
        orderBy: 'createdDate desc',
        expand: 'requirement(expand=createdByNavigation,category)',
      )
          .then((invites) {
        if (invites.count! < inviteCount) {
          inviteCount = invites.count!;
        }

        return invites;
      });
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get invites failed');
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

    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      if (requirementCount % requirementTop == 0) {
        requirementSkip = requirementCount;

        setState(() {
          requirements = requirements.then((requirements) async {
            requirements!.value.addAll((await getRequirements())!.value);

            requirementCount += requirements.value.length - requirementCount;

            return requirements;
          });
        });
      }

      if (inviteCount % inviteTop == 0) {
        inviteSkip = inviteCount;

        setState(() {
          invites = invites.then((invites) async {
            invites!.value.addAll((await getInvites())!.value);

            inviteCount += invites.value.length - inviteCount;

            return invites;
          });
        });
      }
    }
  }

  void onDetail(String id) {
    context.goNamed(JobDetailRoute.name, pathParameters: {'jobId': id});
  }

  void onSendOffer() {
    // sendOfferPopUp();
  }
}
