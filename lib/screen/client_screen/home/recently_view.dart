import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../core/common/common_features.dart';
import '../../../data/apis/artwork_api.dart';
import '../../../data/models/artwork.dart';
import '../../widgets/constant.dart';
import '../service_details/client_artwork_details.dart';
import 'client_home_screen.dart';

class RecentlyView extends StatefulWidget {
  static const String tag = '${ClientHomeScreen.tag}/artwork';

  const RecentlyView({Key? key}) : super(key: key);

  @override
  State<RecentlyView> createState() => _RecentlyViewState();
}

class _RecentlyViewState extends State<RecentlyView> {
  late Future<Artworks?> newArtworks;

  int top = 100;

  @override
  void initState() {
    super.initState();

    newArtworks = getNewArtworks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kDarkWhite,
        centerTitle: true,
        iconTheme: const IconThemeData(color: kNeutralColor),
        title: Text(
          'New Artworks',
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
            child: FutureBuilder(
              future: newArtworks,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 10,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (_, i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  onArtworkDetail();
                                },
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: kWhite,
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
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(8.0),
                                                topLeft: Radius.circular(8.0),
                                              ),
                                              image: DecorationImage(
                                                  image: NetworkImage(snapshot
                                                      .data!.value
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
                                                  const EdgeInsets.all(5.0),
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
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
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
                                                  style: kTextStyle.copyWith(
                                                      color: kNeutralColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                const SizedBox(width: 2.0),
                                                Text(
                                                  getReviewPoint(snapshot
                                                      .data!.value
                                                      .elementAt(i)
                                                      .artworkReviews!),
                                                  style: kTextStyle.copyWith(
                                                      color: kNeutralColor),
                                                ),
                                                const SizedBox(width: 2.0),
                                                Text(
                                                  '(${snapshot.data!.value.elementAt(i).artworkReviews!.length})',
                                                  style: kTextStyle.copyWith(
                                                      color:
                                                          kLightNeutralColor),
                                                ),
                                                const SizedBox(width: 40),
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Price: ',
                                                    style: kTextStyle.copyWith(
                                                        color:
                                                            kLightNeutralColor),
                                                    children: [
                                                      TextSpan(
                                                        text: NumberFormat
                                                                .decimalPattern(
                                                                    'vi_VN')
                                                            .format(snapshot
                                                                .data!.value
                                                                .elementAt(i)
                                                                .price!),
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
                                            const SizedBox(height: 5.0),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 32,
                                                  width: 32,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: NetworkImage(snapshot
                                                            .data!.value
                                                            .elementAt(i)
                                                            .createdByNavigation!
                                                            .avatar!),
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                const SizedBox(width: 5.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot.data!.value
                                                          .elementAt(i)
                                                          .createdByNavigation!
                                                          .name!,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          kTextStyle.copyWith(
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
                                                          TextOverflow.ellipsis,
                                                      style: kTextStyle.copyWith(
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
                        ),
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Future<Artworks?> getNewArtworks() async {
    try {
      return ArtworkApi().gets(
        0,
        top: top,
        expand: 'artworkreviews,arts,createdbynavigation(expand=rank)',
        orderBy: 'createdDate desc',
      );
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get new artworks failed');
    }

    return null;
  }

  void onArtworkDetail() {
    Navigator.pushNamed(context, ClientArtworkDetails.tag);
  }
}
