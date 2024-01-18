import 'package:drawing_on_demand/data/models/certificate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/common/common_features.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/account_api.dart';
import '../../../data/apis/artwork_api.dart';
import '../../../data/apis/invite_api.dart';
import '../../../data/models/account.dart';
import '../../../data/models/account_review.dart';
import '../../../data/models/artwork.dart';
import '../../../data/models/category.dart';
import '../../../data/models/invite.dart';
import '../../common/popUp/popup_2.dart';
import '../../widgets/constant.dart';
import '../../widgets/data.dart';
import '../../widgets/responsive.dart';
import '../../widgets/review.dart';
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

  int flexTitle = 3;
  int flexContent = 8;

  int totalReview = 0;

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
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              insetPadding: DodResponsive.isDesktop(context) ? EdgeInsets.symmetric(horizontal: context.width() / 2.7) : const EdgeInsets.symmetric(horizontal: 40.0),
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
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              insetPadding: DodResponsive.isDesktop(context) ? EdgeInsets.symmetric(horizontal: context.width() / 2.7) : const EdgeInsets.symmetric(horizontal: 40.0),
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

  ListView getReviews(List<AccountReview> artworkReviews) {
    return ListView.builder(
      itemCount: totalReview,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            ReviewDetails(
              avatar: artworkReviews.elementAt(index).createdByNavigation!.avatar,
              name: artworkReviews.elementAt(index).createdByNavigation!.name,
              star: artworkReviews.elementAt(index).star,
              comment: artworkReviews.elementAt(index).comment,
              date: DateFormat('dd-MM-yyyy').format(artworkReviews.elementAt(index).createdDate!).toString(),
            ),
            const SizedBox(height: 10.0),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: '$dod | Profile',
      color: kPrimaryColor,
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          backgroundColor: kDarkWhite,
          elevation: 0,
          iconTheme: const IconThemeData(color: kNeutralColor),
          title: Text(
            AppLocalizations.of(context)!.myProfile,
            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
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
                      AppLocalizations.of(context)!.invite,
                      style: kTextStyle.copyWith(
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ).visible(PrefUtils().getRole() == 'Customer'),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
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
                      certificate.name = certificate.name!.replaceFirstMapped('Education|', (match) => '');

                      educations.add(certificate);
                    } else {
                      certificates.add(certificate);
                    }
                  }

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: DodResponsive.isDesktop(context) ? 150.0 : 0.0,
                        right: DodResponsive.isDesktop(context) ? 150.0 : 0.0,
                      ),
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
                                    style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                  ),
                                  Text(
                                    PrefUtils().getRole() == 'Artist' ? snapshot.data!.email! : generateHide(snapshot.data!.email!),
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
                                AppLocalizations.of(context)!.aboutMe,
                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              const Icon(
                                IconlyLight.edit,
                                size: 18.0,
                                color: kSubTitleColor,
                              ).visible(PrefUtils().getRole() == 'Artist'),
                              const SizedBox(width: 2.0).visible(PrefUtils().getRole() == 'Artist'),
                              GestureDetector(
                                onTap: () => const SellerEditProfile().launch(context),
                                child: Text(
                                  AppLocalizations.of(context)!.editProfile,
                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                ),
                              ).visible(PrefUtils().getRole() == 'Artist'),
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.0), border: Border.all(color: kBorderColorTextField)),
                            child: ReadMoreText(
                              snapshot.data!.bio ?? '',
                              style: kTextStyle.copyWith(color: kLightNeutralColor),
                              trimLines: 4,
                              colorClickableText: kPrimaryColor,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: AppLocalizations.of(context)!.readMore,
                              trimExpandedText: AppLocalizations.of(context)!.readLess,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.information,
                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: DodResponsive.isDesktop(context) ? 2 : flexTitle,
                                child: Text(
                                  AppLocalizations.of(context)!.phoneNumber,
                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                ),
                              ),
                              Expanded(
                                flex: DodResponsive.isDesktop(context) ? 11 : flexContent,
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
                                        PrefUtils().getRole() == 'Artist' ? snapshot.data!.phone! : '*******${snapshot.data!.phone!.substring(7)}',
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
                                flex: DodResponsive.isDesktop(context) ? 2 : flexTitle,
                                child: Text(
                                  AppLocalizations.of(context)!.gender,
                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                ),
                              ),
                              Expanded(
                                flex: DodResponsive.isDesktop(context) ? 11 : flexContent,
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
                                        snapshot.data!.gender!,
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
                                flex: DodResponsive.isDesktop(context) ? 2 : flexTitle,
                                child: Text(
                                  AppLocalizations.of(context)!.address,
                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                ),
                              ),
                              Expanded(
                                flex: DodResponsive.isDesktop(context) ? 11 : flexContent,
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
                                        PrefUtils().getRole() == 'Artist' ? snapshot.data!.address! : generateHide(snapshot.data!.address!),
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
                          const SizedBox(height: 25.0),
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.skills,
                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
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
                                  if (!categories.any((category) => category.id == artwork.category!.id)) {
                                    categories.add(artwork.category!);
                                  }
                                }

                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: categories.length > 3 ? 3 : categories.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          const SizedBox(height: 10.0),
                                          InfoShowCaseWithoutIcon(
                                            title: categories[index].name!,
                                            subTitle: categories[index].description!,
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
                          const SizedBox(height: 25.0).visible(educations.isNotEmpty),
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.education,
                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
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
                                AppLocalizations.of(context)!.certification,
                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
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
                                AppLocalizations.of(context)!.myArtworks,
                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  // onViewAllArtwork();
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.viewAll,
                                  style: kTextStyle.copyWith(color: kLightNeutralColor),
                                ),
                              ).visible(PrefUtils().getRole() == 'Artist'),
                            ],
                          ).visible(PrefUtils().getRole() != 'Artist'),
                          const SizedBox(height: 20.0).visible(PrefUtils().getRole() != 'Artist'),
                          FutureBuilder(
                            future: artworks,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                int itemCount = snapshot.data!.count! < 10 ? snapshot.data!.count! : 10;

                                return HorizontalList(
                                  spacing: 10.0,
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  itemCount: itemCount,
                                  itemBuilder: (_, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        onArtworkDetail(snapshot.data!.value.elementAt(index).id.toString());
                                      },
                                      child: Container(
                                        height: 205,
                                        width: 156,
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
                                                  height: 100,
                                                  width: 156,
                                                  decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.only(
                                                      topRight: Radius.circular(8.0),
                                                      topLeft: Radius.circular(8.0),
                                                    ),
                                                    image: DecorationImage(
                                                      image: NetworkImage(snapshot.data!.value.elementAt(index).arts!.first.image!),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    onAddToCart(snapshot.data!.value.elementAt(index));
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 5.0, right: 5.0),
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
                                                      text: AppLocalizations.of(context)!.price,
                                                      style: kTextStyle.copyWith(color: kLightNeutralColor),
                                                      children: [
                                                        TextSpan(
                                                          text: NumberFormat.simpleCurrency(locale: 'vi_VN').format(snapshot.data!.value.elementAt(index).price),
                                                          style: kTextStyle.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
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
                          const SizedBox(height: 15.0),
                          Text(
                            AppLocalizations.of(context)!.reviews,
                            maxLines: 1,
                            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20.0),
                          Review(
                            rating: getAccountReviewPoint(snapshot.data!.accountReviewAccounts!),
                            total: snapshot.data!.accountReviewAccounts!.length,
                            five: snapshot.data!.accountReviewAccounts!.where((awr) => awr.star == 5).length,
                            four: snapshot.data!.accountReviewAccounts!.where((awr) => awr.star == 4).length,
                            three: snapshot.data!.accountReviewAccounts!.where((awr) => awr.star == 3).length,
                            two: snapshot.data!.accountReviewAccounts!.where((awr) => awr.star == 2).length,
                            one: snapshot.data!.accountReviewAccounts!.where((awr) => awr.star == 1).length,
                          ),
                          const SizedBox(height: 20.0),
                          getReviews(snapshot.data!.accountReviewAccounts!),
                          const SizedBox(height: 10.0),
                          Container(
                            height: 40.0,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), border: Border.all(color: kSubTitleColor)),
                            child: GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.viewAllReviews,
                                    maxLines: 1,
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                  ),
                                  const Icon(
                                    FeatherIcons.chevronDown,
                                    color: kSubTitleColor,
                                  ),
                                ],
                              ),
                              onTap: () {
                                onViewAllReview(snapshot.data!.accountReviewAccounts!.length);
                              },
                            ),
                          ).visible(snapshot.data!.accountReviewAccounts!.length > totalReview)
                        ],
                      ),
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
      ),
    );
  }

  Future<Account?> getAccount() async {
    try {
      return AccountApi().getOne(widget.id!, 'certificates, accountReviewAccounts(expand=createdByNavigation)').then(
        (account) {
          totalReview = account.accountReviewAccounts!.isEmpty ? 0 : 1;

          return account;
        },
      );
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get account failed');
    }

    return null;
  }

  Future<Artworks?> getArtworks() async {
    try {
      return ArtworkApi().gets(
        0,
        filter: 'createdBy eq ${widget.id} and status ne \'Proposed\' and status ne \'Paused\' and status ne \'Deleted\'',
        count: 'true',
        orderBy: 'createdDate desc',
        expand: 'arts,artworkReviews,category',
      );
    } catch (error) {
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.getArtworkFailed);
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

  void onViewAllReview(int totalReview) {
    setState(() {
      this.totalReview = totalReview;
    });
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
      // ignore: use_build_context_synchronously
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.alreadyInvite);
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
