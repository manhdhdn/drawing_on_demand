import 'package:drawing_on_demand/core/common/common_features.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/order_detail_api.dart';
import '../../../data/models/order.dart';
import '../../common/artwork/service_details.dart';
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
  late Future<Order?> cart;

  double total = 0;

  @override
  void initState() {
    super.initState();

    refresh();
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
            future: cart,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 50.0),
                          Container(
                            height: 213,
                            width: 269,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/emptyservice.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            'Nothing just yet',
                            textAlign: TextAlign.center,
                            style: kTextStyle.copyWith(
                                color: kNeutralColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0),
                          ),
                        ],
                      ).visible(snapshot.data!.orderDetails!.isEmpty),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.orderDetails!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (_, i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  onNewArtworkDetail(snapshot
                                      .data!.orderDetails![i].artworkId
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
                                                      .data!
                                                      .orderDetails![i]
                                                      .artwork!
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
                                                  snapshot
                                                      .data!
                                                      .orderDetails![i]
                                                      .artwork!
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
                                            // Row(
                                            //   children: [
                                            //     Container(
                                            //       height: 32,
                                            //       width: 32,
                                            //       decoration: BoxDecoration(
                                            //         shape: BoxShape.circle,
                                            //         image: DecorationImage(
                                            //             image: NetworkImage(snapshot
                                            //                 .data!.value
                                            //                 .elementAt(i)
                                            //                 .createdByNavigation!
                                            //                 .avatar!),
                                            //             fit: BoxFit.cover),
                                            //       ),
                                            //     ),
                                            //     const SizedBox(width: 5.0),
                                            //     Column(
                                            //       crossAxisAlignment:
                                            //           CrossAxisAlignment.start,
                                            //       children: [
                                            //         Text(
                                            //           snapshot.data!.value
                                            //               .elementAt(i)
                                            //               .createdByNavigation!
                                            //               .name!,
                                            //           maxLines: 1,
                                            //           overflow:
                                            //               TextOverflow.ellipsis,
                                            //           style:
                                            //               kTextStyle.copyWith(
                                            //                   color:
                                            //                       kNeutralColor,
                                            //                   fontWeight:
                                            //                       FontWeight
                                            //                           .bold),
                                            //         ),
                                            //         Text(
                                            //           'Artist Rank - ${snapshot.data!.value.elementAt(i).createdByNavigation!.rank!.name!}',
                                            //           maxLines: 1,
                                            //           overflow:
                                            //               TextOverflow.ellipsis,
                                            //           style: kTextStyle.copyWith(
                                            //               color:
                                            //                   kSubTitleColor),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   ],
                                            // ),
                                            Text(
                                              'Unit price: ${NumberFormat.simpleCurrency(locale: 'vi_VN').format(snapshot.data!.orderDetails![i].price)}',
                                              style: kTextStyle.copyWith(
                                                  color: kSubTitleColor),
                                            ),
                                            const SizedBox(height: 5.0),
                                            SizedBox(
                                              width: context.width() * 0.58,
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (snapshot
                                                              .data!
                                                              .orderDetails![i]
                                                              .quantity! >
                                                          1) {
                                                        decreaseQuantity(
                                                                snapshot
                                                                    .data!
                                                                    .orderDetails![
                                                                        i]
                                                                    .id
                                                                    .toString(),
                                                                snapshot
                                                                    .data!
                                                                    .orderDetails![
                                                                        i]
                                                                    .quantity!)
                                                            .then((value) =>
                                                                refresh());
                                                      }
                                                    },
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
                                                    snapshot
                                                        .data!
                                                        .orderDetails![i]
                                                        .quantity
                                                        .toString(),
                                                    style: kTextStyle.copyWith(
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5.0),
                                                  GestureDetector(
                                                    onTap: () {
                                                      increaseQuantity(
                                                              snapshot
                                                                  .data!
                                                                  .orderDetails![
                                                                      i]
                                                                  .id
                                                                  .toString(),
                                                              snapshot
                                                                  .data!
                                                                  .orderDetails![
                                                                      i]
                                                                  .quantity!)
                                                          .then((value) =>
                                                              refresh());
                                                    },
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
                                                  const SizedBox(width: 10.0),
                                                  GestureDetector(
                                                    onTap: () {
                                                      onRemove(snapshot
                                                              .data!
                                                              .orderDetails![i]
                                                              .id
                                                              .toString())
                                                          .then((value) =>
                                                              refresh());
                                                    },
                                                    child: Container(
                                                      height: 27,
                                                      width: 20,
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
                                                        Icons.delete,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    NumberFormat.simpleCurrency(
                                                            locale: 'vi_VN')
                                                        .format(snapshot
                                                                .data!
                                                                .orderDetails![
                                                                    i]
                                                                .quantity! *
                                                            snapshot
                                                                .data!
                                                                .orderDetails![
                                                                    i]
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
              onPressed: () {
                onOrderNow();
              },
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

  void onNewArtworkDetail(String id) {
    PrefUtils().setTermId(id);

    Navigator.pushNamed(context, ServiceDetails.tag).then((value) => refresh());
  }

  void refresh() {
    setState(() {
      cart = getCart().then((order) {
        double total = 0;

        for (var orderDetail in order.orderDetails!) {
          total += orderDetail.price! * orderDetail.quantity!;
        }

        setState(() {
          this.total = total;
        });

        return order;
      });
    });
  }

  void onOrderNow() {
    Navigator.pushNamed(context, ClientOrder.tag);
  }

  Future<void> onRemove(String id) async {
    await OrderDetailApi().deleteOne(id);
  }
}
