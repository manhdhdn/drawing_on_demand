import 'package:drawing_on_demand/core/common/common_features.dart';
import 'package:drawing_on_demand/data/models/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../data/apis/order_detail_api.dart';
import '../../../data/models/order.dart';
import '../../widgets/constant.dart';

class CartScreen extends StatefulWidget {
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
                List<OrderDetail> orderDetails = snapshot.data!.orderDetails!;

                orderDetails.sort(((a, b) => a
                    .artwork!.createdByNavigation!.email!
                    .compareTo(b.artwork!.createdByNavigation!.email!)));

                List<int> packList = [0];
                int packCount = 0;
                if (orderDetails.isNotEmpty) {
                  String tempEmail =
                      orderDetails.first.artwork!.createdByNavigation!.email!;

                  for (var orderDetail in orderDetails) {
                    if (orderDetail.artwork!.createdByNavigation!.email ==
                        tempEmail) {
                      packList[packCount]++;
                    } else {
                      tempEmail =
                          orderDetail.artwork!.createdByNavigation!.email!;

                      packCount++;
                      packList.add(1);
                    }
                  }
                }

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
                      ).visible(orderDetails.isEmpty),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: packList[0] != 0 ? packList.length : 0,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (_, i) {
                            return Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                tilePadding: const EdgeInsets.only(bottom: 5.0),
                                childrenPadding: EdgeInsets.zero,
                                collapsedIconColor: kLightNeutralColor,
                                iconColor: kLightNeutralColor,
                                title: Row(
                                  children: [
                                    Container(
                                      height: 32,
                                      width: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(orderDetails[
                                                    getCartIndex(i, packList)]
                                                .artwork!
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
                                          'Author',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: kTextStyle.copyWith(
                                              color: kSubTitleColor),
                                        ),
                                        Text(
                                          orderDetails[
                                                  getCartIndex(i, packList)]
                                              .artwork!
                                              .createdByNavigation!
                                              .name!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: kTextStyle.copyWith(
                                              color: kNeutralColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: packList[i],
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (_, j) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            onArtworkDetail(
                                              orderDetails[j +
                                                      getCartIndex(i, packList)]
                                                  .artworkId
                                                  .toString(),
                                            );
                                          },
                                          child: Container(
                                            height: context.height() * 0.135,
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
                                                      height: context.height() *
                                                          0.135,
                                                      width: context.height() *
                                                          0.135,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  8.0),
                                                        ),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                orderDetails[j +
                                                                        getCartIndex(
                                                                            i,
                                                                            packList)]
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
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Flexible(
                                                        child: SizedBox(
                                                          width: 190,
                                                          child: Text(
                                                            orderDetails[j +
                                                                    getCartIndex(
                                                                        i,
                                                                        packList)]
                                                                .artwork!
                                                                .title!,
                                                            style: kTextStyle.copyWith(
                                                                color:
                                                                    kNeutralColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 5.0),
                                                      Text(
                                                        'Unit price: ${NumberFormat.simpleCurrency(locale: 'vi_VN').format(snapshot.data!.orderDetails![j + getCartIndex(i, packList)].price)}',
                                                        style: kTextStyle.copyWith(
                                                            color:
                                                                kSubTitleColor),
                                                      ),
                                                      const SizedBox(
                                                          height: 5.0),
                                                      SizedBox(
                                                        width: context.width() *
                                                            0.58,
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (orderDetails[j +
                                                                            getCartIndex(i,
                                                                                packList)]
                                                                        .quantity! >
                                                                    1) {
                                                                  decreaseQuantity(
                                                                          orderDetails[j + getCartIndex(i, packList)]
                                                                              .id
                                                                              .toString(),
                                                                          orderDetails[j + getCartIndex(i, packList)]
                                                                              .quantity!)
                                                                      .then((value) =>
                                                                          refresh());
                                                                }
                                                              },
                                                              child: Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      kBorderColorTextField,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    5.0,
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .remove_outlined,
                                                                  size: 16,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 5.0),
                                                            Text(
                                                              orderDetails[j +
                                                                      getCartIndex(
                                                                          i,
                                                                          packList)]
                                                                  .quantity
                                                                  .toString(),
                                                              style: kTextStyle
                                                                  .copyWith(
                                                                color:
                                                                    kPrimaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 5.0),
                                                            GestureDetector(
                                                              onTap: () {
                                                                increaseQuantity(
                                                                        orderDetails[j + getCartIndex(i, packList)]
                                                                            .id
                                                                            .toString(),
                                                                        orderDetails[j + getCartIndex(i, packList)]
                                                                            .quantity!)
                                                                    .then((value) =>
                                                                        refresh());
                                                              },
                                                              child: Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      kBorderColorTextField,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    5.0,
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .add_rounded,
                                                                  size: 16,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 10.0),
                                                            GestureDetector(
                                                              onTap: () {
                                                                onRemove(orderDetails[j +
                                                                            getCartIndex(i,
                                                                                packList)]
                                                                        .id
                                                                        .toString())
                                                                    .then((value) =>
                                                                        refresh());
                                                              },
                                                              child: Container(
                                                                height: 27,
                                                                width: 20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      kBorderColorTextField,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    5.0,
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons.delete,
                                                                  size: 18,
                                                                ),
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              NumberFormat.simpleCurrency(locale: 'vi_VN').format(orderDetails[j +
                                                                          getCartIndex(
                                                                              i,
                                                                              packList)]
                                                                      .quantity! *
                                                                  orderDetails[j +
                                                                          getCartIndex(
                                                                              i,
                                                                              packList)]
                                                                      .price!),
                                                              style: kTextStyle
                                                                  .copyWith(
                                                                color:
                                                                    kPrimaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                ],
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
                total != 0 ? onOrderNow() : null;
              },
              child: Container(
                width: context.width() * 0.5,
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: kButtonDecoration.copyWith(
                  color: total != 0 ? kPrimaryColor : kLightNeutralColor,
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

  void onArtworkDetail(String id) {
    // PrefUtils().setTermId(id);

    // Navigator.pushNamed(context, ServiceDetails.tag);
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
    // PrefUtils().setTermId(PrefUtils().getCartId());

    // Navigator.pushNamed(context, ClientOrder.tag);
  }

  Future<void> onRemove(String id) async {
    await OrderDetailApi().deleteOne(id);
  }
}