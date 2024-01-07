import 'package:drawing_on_demand/data/models/certificate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/common/common_features.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/account_api.dart';
import '../../../data/apis/artwork_api.dart';
import '../../../data/apis/invite_api.dart';
import '../../../data/models/account.dart';
import '../../../data/models/artwork.dart';
import '../../../data/models/category.dart';
import '../../../data/models/invite.dart';
import '../../common/popUp/popup_2.dart';
import '../../widgets/constant.dart';
import '../../widgets/data.dart';
import 'seller_edit_profile_details.dart';

class SellerProfileDetails extends StatefulWidget {
  final String? id;

  const SellerProfileDetails({Key? key, this.id}) : super(key: key);

  @override
  State<SellerProfileDetails> createState() => _SellerProfileDetailsState();
}

class _SellerProfileDetailsState extends State<SellerProfileDetails> {
  late Future<Account?> account;
  late Future<Artworks?> artworks;

  @override
  void initState() {
    super.initState();

    account = getAccount();
    artworks = getArtworks();
  }

  void showInviteSuccessPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const InviteSuccessPopUp(),
            );
          },
        );
      },
    );
  }

  Future<String?> showInvitePopUp() async {
    var result = await showDialog<String?>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const InvitePopUp(),
            );
          },
        );
      },
    );

    return result;
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
          'My Profile',
          style: kTextStyle.copyWith(
              color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                onInvite();
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.person_add_alt_1,
                    color: kPrimaryColor,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    'Invite',
                    style: kTextStyle.copyWith(
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
          height: context.height(),
          width: context.width(),
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: FutureBuilder(
            future: account,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Certificate> educations = [];
                List<Certificate> certificates = [];

                for (var certificate in snapshot.data!.certificates!) {
                  if (certificate.name!.contains('Education|')) {
                    certificate.name = certificate.name!
                        .replaceFirstMapped('Education|', (match) => '');

                    educations.add(certificate);
                  } else {
                    certificates.add(certificate);
                  }
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                                  snapshot.data!.avatar ?? defaultImage,
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
                                snapshot.data!.name!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kTextStyle.copyWith(
                                    color: kNeutralColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                              Text(
                                PrefUtils().getRole() == 'Artist'
                                    ? snapshot.data!.email!
                                    : generateHide(snapshot.data!.email!),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kTextStyle.copyWith(
                                  color: kLightNeutralColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Text(
                            'About Me',
                            style: kTextStyle.copyWith(
                                color: kNeutralColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          const Icon(
                            IconlyLight.edit,
                            size: 18.0,
                            color: kSubTitleColor,
                          ).visible(PrefUtils().getRole() == 'Artist'),
                          const SizedBox(width: 2.0)
                              .visible(PrefUtils().getRole() == 'Artist'),
                          GestureDetector(
                            onTap: () =>
                                const SellerEditProfile().launch(context),
                            child: Text(
                              'Edit',
                              style: kTextStyle.copyWith(color: kSubTitleColor),
                            ),
                          ).visible(PrefUtils().getRole() == 'Artist'),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(color: kBorderColorTextField)),
                        child: ReadMoreText(
                          snapshot.data!.bio ?? '',
                          style: kTextStyle.copyWith(color: kLightNeutralColor),
                          trimLines: 4,
                          colorClickableText: kPrimaryColor,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '..read more',
                          trimExpandedText: ' read less',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Text(
                            'Information',
                            style: kTextStyle.copyWith(
                                color: kNeutralColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 10.0),
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
                                  style: kTextStyle.copyWith(
                                      color: kSubTitleColor),
                                ),
                                const SizedBox(width: 10.0),
                                Flexible(
                                  child: Text(
                                    PrefUtils().getRole() == 'Artist'
                                        ? snapshot.data!.phone!
                                        : '**********',
                                    style: kTextStyle.copyWith(
                                        color: kSubTitleColor),
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
                                  style: kTextStyle.copyWith(
                                      color: kSubTitleColor),
                                ),
                                const SizedBox(width: 10.0),
                                Flexible(
                                  child: Text(
                                    snapshot.data!.gender!,
                                    style: kTextStyle.copyWith(
                                        color: kSubTitleColor),
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
                                  style: kTextStyle.copyWith(
                                      color: kSubTitleColor),
                                ),
                                const SizedBox(width: 10.0),
                                Flexible(
                                  child: Text(
                                    PrefUtils().getRole() == 'Artist'
                                        ? snapshot.data!.address!
                                        : generateHide(snapshot.data!.address!),
                                    style: kTextStyle.copyWith(
                                        color: kSubTitleColor),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        children: [
                          Text(
                            'Skills',
                            style: kTextStyle.copyWith(
                                color: kNeutralColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      FutureBuilder(
                        future: artworks,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Category> categories = [];

                            for (var artwork in snapshot.data!.value) {
                              if (!categories.any((category) =>
                                  category.id == artwork.category!.id)) {
                                categories.add(artwork.category!);
                              }
                            }

                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: categories.length > 3
                                    ? 3
                                    : categories.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      const SizedBox(height: 10.0),
                                      InfoShowCaseWithoutIcon(
                                        title: categories[index].name!,
                                        subTitle:
                                            categories[index].description!,
                                      ),
                                    ],
                                  );
                                });
                          }

                          return const Center(
                            child: CircularProgressIndicator(
                              color: kPrimaryColor,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 25.0)
                          .visible(educations.isNotEmpty),
                      Row(
                        children: [
                          Text(
                            'Education',
                            style: kTextStyle.copyWith(
                                color: kNeutralColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                        ],
                      ).visible(educations.isNotEmpty),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: educations.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              const SizedBox(height: 20.0),
                              SummaryWithoutIcon(
                                title: educations[index].name!,
                                subtitle: educations[index].description!,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        children: [
                          Text(
                            'Certification',
                            style: kTextStyle.copyWith(
                                color: kNeutralColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: certificates.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              const SizedBox(height: 20.0),
                              SummaryWithoutIcon(
                                title: certificates[index].name!,
                                subtitle: certificates[index].description!,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        children: [
                          Text(
                            'My artworks',
                            style: kTextStyle.copyWith(
                                color: kNeutralColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              // onViewAllArtwork();
                            },
                            child: Text(
                              'View All',
                              style: kTextStyle.copyWith(
                                  color: kLightNeutralColor),
                            ),
                          ).visible(PrefUtils().getRole() == 'Artist'),
                        ],
                      ).visible(PrefUtils().getRole() != 'Artist'),
                      const SizedBox(height: 20.0)
                          .visible(PrefUtils().getRole() != 'Artist'),
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
                                        Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Container(
                                              height: 100,
                                              width: 156,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(8.0),
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
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isFavorite = !isFavorite;
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: isFavorite
                                                      ? const Center(
                                                          child: Icon(
                                                            Icons.favorite,
                                                            color: Colors.red,
                                                            size: 18.0,
                                                          ),
                                                        )
                                                      : const Center(
                                                          child: Icon(
                                                            Icons
                                                                .favorite_border,
                                                            color:
                                                                kNeutralColor,
                                                            size: 18.0,
                                                          ),
                                                        ),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    '(${snapshot.data!.value.elementAt(index).artworkReviews!.length} review)',
                                                    style: kTextStyle.copyWith(
                                                        color:
                                                            kLightNeutralColor),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5.0),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Price: ',
                                                  style: kTextStyle.copyWith(
                                                      color:
                                                          kLightNeutralColor),
                                                  children: [
                                                    TextSpan(
                                                      text: NumberFormat
                                                              .simpleCurrency(
                                                                  locale:
                                                                      'vi_VN')
                                                          .format(snapshot
                                                              .data!.value
                                                              .elementAt(index)
                                                              .price),
                                                      style:
                                                          kTextStyle.copyWith(
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
                      ).visible(PrefUtils().getRole() != 'Artist'),
                    ],
                  ),
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
        ),
      ),
    );
  }

  Future<Account?> getAccount() async {
    try {
      return AccountApi().getOne(widget.id!, 'certificates');
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get account failed');
    }

    return null;
  }

  Future<Artworks?> getArtworks() async {
    try {
      return ArtworkApi().gets(
        0,
        filter: 'createdBy eq ${widget.id} and status ne \'Proposed\'',
        count: 'true',
        orderBy: 'createdDate desc',
        expand: 'arts,artworkReviews,category',
      );
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get artworks failed');
    }

    return null;
  }

  String generateHide(String text) {
    String result = '';

    for (int i = 0; i < text.length - 10; i++) {
      if (text[i] == ' ') {
        result += ' ';
      } else {
        result += '*';
      }
    }

    result += text.substring(text.length - 10);

    return result;
  }

  void onArtworkDetail(String id) {
    var state = GoRouterState.of(context);
    String name = '${ArtworkDetailRoute.name} artist';
    Map<String, String> pathParameters = {'id': widget.id!, 'artworkId': id};

    if (state.pathParameters['jobId'] != null) {
      name = '${ArtworkDetailRoute.name} job';
      pathParameters['jobId'] = state.pathParameters['jobId']!;
    }

    context.goNamed(name, pathParameters: pathParameters);
  }

  void onInvite() async {
    var state = GoRouterState.of(context);

    try {
      if (state.pathParameters['jobId'] != null) {
        var jobId = state.pathParameters['jobId']!;

        await createInvite(jobId);
      } else {
        var requirementId = await showInvitePopUp();

        if (requirementId != null) {
          await createInvite(requirementId);
        }
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Already invited');
    }
  }

  Future<void> createInvite(String jobId) async {
    if (!(await isInvited(jobId))) {
      Invite invite = Invite(
        id: Guid.newGuid,
        createdDate: DateTime.now(),
        status: 'Pending',
        receivedBy: Guid(widget.id),
        requirementId: Guid(jobId),
      );

      await InviteApi().postOne(invite);

      showInviteSuccessPopUp();
    } else {
      throw Exception();
    }
  }

  Future<bool> isInvited(String jobId) async {
    try {
      Invites invites = await InviteApi().gets(
        0,
        count: 'true',
        filter: 'receivedBy eq ${widget.id} and requirementId eq $jobId',
      );

      if (invites.count != 0) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Check invited failed');
    }

    return true;
  }
}
