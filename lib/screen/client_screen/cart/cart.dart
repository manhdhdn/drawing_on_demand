import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/artwork_api.dart';
import '../../../data/models/artwork.dart';
import '../../common/artwork/service_details.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../home/client_home_screen.dart';
import '../service_details/client_order.dart';

class CartScreen extends StatefulWidget {
  static const String tag = '${ClientHomeScreen.tag}/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<Artworks?> newArtworks;

  double total = 3000000000.0;
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
          'Cart',
          style: kTextStyle.copyWith(
              color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
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
            future: newArtworks,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
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
                                  onNewArtworkDetail(snapshot.data!.value
                                      .elementAt(i)
                                      .id!
                                      .toString());
                                },
                                child: Container(
                                  height: context.height() * 0.135,
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
                                            height: context.height() * 0.135,
                                            width: context.height() * 0.135,
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
                                            const SizedBox(height: 5.0),
                                            SizedBox(
                                              width: context.width() * 0.58,
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            kBorderColorTextField,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          5.0,
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.remove_outlined,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5.0),
                                                  Text(
                                                    '1',
                                                    style: kTextStyle.copyWith(
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5.0),
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            kBorderColorTextField,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          5.0,
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.add_rounded,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    NumberFormat.simpleCurrency(
                                                            locale: 'vi_VN')
                                                        .format(snapshot
                                                            .data!.value
                                                            .elementAt(i)
                                                            .price!),
                                                    style: kTextStyle.copyWith(
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
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
                            );
                          },
                        ),
                      ),
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          color: kWhite,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RichText(
              text: TextSpan(
                text: 'Total:\n',
                style: kTextStyle.copyWith(color: kNeutralColor, fontSize: 16),
                children: [
                  TextSpan(
                    text: NumberFormat.simpleCurrency(locale: 'vi_VN')
                        .format(total),
                    style: kTextStyle.copyWith(
                        color: kPrimaryColor, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Container(
                width: context.width() * 0.5,
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: kButtonDecoration.copyWith(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Order now',
                      style: GoogleFonts.jost(fontSize: 20.0, color: kWhite),
                    ),
                  ],
                ),
              ),
            ),
          ],
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

  void onNewArtworkDetail(String id) {
    PrefUtils().setTermId(id);

    Navigator.pushNamed(context, ServiceDetails.tag).then(
      (value) => setState(
        () {
          newArtworks = getNewArtworks();
        },
      ),
    );
  }
}
