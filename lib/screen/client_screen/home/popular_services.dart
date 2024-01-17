import 'package:drawing_on_demand/app_routes/named_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/common/common_features.dart';
import '../../../data/apis/artwork_api.dart';
import '../../../data/models/artwork.dart';
import '../../widgets/constant.dart';
import '../../widgets/responsive.dart';

// ignore: must_be_immutable
class PopularServices extends StatefulWidget {
  String? tab;

  PopularServices({Key? key, this.tab}) : super(key: key);

  @override
  State<PopularServices> createState() => _PopularServicesState();
}

class _PopularServicesState extends State<PopularServices> {
  final ScrollController _scrollController = ScrollController();

  bool isScrollDown = false;
  int height = 390;

  List<String> serviceList = [
    'All',
    'Popular',
    'New',
  ];

  late Future<Artworks?> artworks;

  int skip = 0;
  int top = 10;
  int count = 10;

  bool get _isShrink {
    return _scrollController.hasClients && _scrollController.offset > (height - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();

    artworks = getArtworks();

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
      title: '$dod | Popular artworks',
      color: kPrimaryColor,
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: kDarkWhite,
          centerTitle: true,
          iconTheme: const IconThemeData(color: kNeutralColor),
          title: Text(
            AppLocalizations.of(context)!.artworks,
            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(
                FeatherIcons.sliders,
                color: kNeutralColor,
              ),
            )
          ],
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
                                    onChangeTab(serviceList[i]);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: widget.tab == serviceList[i] ? kPrimaryColor : kDarkWhite,
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    child: Text(
                                      serviceList[i] == 'All'
                                          ? AppLocalizations.of(context)!.all
                                          : serviceList[i] == 'Popular'
                                              ? AppLocalizations.of(context)!.popular
                                              : AppLocalizations.of(context)!.newAw,
                                      style: kTextStyle.copyWith(
                                        color: widget.tab == serviceList[i] ? kWhite : kNeutralColor,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: count,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
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
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                    const SizedBox(width: 15),
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
                            ),
                          ),
                        ],
                      ),
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
    );
  }

  Future<Artworks?> getArtworks() async {
    try {
      String? orderBy;

      switch (widget.tab) {
        case 'All':
          orderBy = 'createdDate desc';
          break;
        case 'Popular':
          break;
        case 'New':
          orderBy = 'createdDate desc';
          break;
        default:
      }

      return ArtworkApi()
          .gets(
        skip,
        top: top,
        filter: 'status eq \'Available\'',
        count: 'true',
        orderBy: orderBy,
        expand: 'artworkReviews,arts,createdByNavigation(expand=rank)',
      )
          .then((artworks) {
        if (top > artworks.count!) {
          top = artworks.count!;
        }

        return artworks;
      });
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get artworks failed');
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
          artworks = artworks.then((artworks) async {
            artworks!.value.addAll((await getArtworks())!.value);

            count += artworks.value.length - count;

            return artworks;
          });
        });
      }
    }
  }

  void onArtworkDetail(String id) {
    context.goNamed(
      '${ArtworkDetailRoute.name} in',
      pathParameters: {'artworkId': id},
      queryParameters: {'tab': widget.tab},
    );
  }

  void onChangeTab(String tab) {
    context.goNamed(ArtworkRoute.name, queryParameters: {'tab': tab});

    skip = 0;
    top = 10;
    count = 10;

    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        setState(() {
          artworks = getArtworks();
        });
      },
    );
  }
}
