import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/common/common_features.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/order_detail_api.dart';
import '../../../data/models/order.dart';
import '../../../data/models/order_detail.dart';
import '../../widgets/constant.dart';
import '../../widgets/nothing_yet.dart';
import '../../widgets/responsive.dart';

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
    return Title(
      title: '$dod | Cart',
      color: kPrimaryColor,
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: kDarkWhite,
          centerTitle: true,
          iconTheme: const IconThemeData(color: kNeutralColor),
          title: Text(
            AppLocalizations.of(context)!.cart,
            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: kWhite,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: DodResponsive.isDesktop(context) ? 50.0 : 0.0,
              right: DodResponsive.isDesktop(context) ? 50.0 : 0.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      text: '${AppLocalizations.of(context)!.total}:\n',
                      style: kTextStyle.copyWith(color: kNeutralColor, fontSize: 16),
                      children: [
                        TextSpan(
                          text: NumberFormat.simpleCurrency(locale: 'vi_VN').format(total),
                          style: kTextStyle.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 50),
                Flexible(
                  child: TextButton(
                    onPressed: () {
                      total != 0 ? onOrderNow() : null;
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: kButtonDecoration.copyWith(
                        color: total != 0 ? kPrimaryColor : kLightNeutralColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.orderNow,
                            style: GoogleFonts.jost(fontSize: 20.0, color: kWhite),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
              future: cart,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<OrderDetail> orderDetails = snapshot.data!.orderDetails!;

                  orderDetails.sort((a, b) => a.artwork!.createdByNavigation!.email!.compareTo(b.artwork!.createdByNavigation!.email!));

                  List<int> packList = [0];
                  int packCount = 0;

                  if (orderDetails.isNotEmpty) {
                    String tempEmail = orderDetails.first.artwork!.createdByNavigation!.email!;

                    for (var orderDetail in orderDetails) {
                      if (orderDetail.artwork!.createdByNavigation!.email == tempEmail) {
                        packList[packCount]++;
                      } else {
                        tempEmail = orderDetail.artwork!.createdByNavigation!.email!;

                        packCount++;
                        packList.add(1);
                      }
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
                        children: [
                          NothingYet(visible: orderDetails.isEmpty),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: packList[0] != 0 ? packList.length : 0,
                              itemBuilder: (_, i) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    dividerColor: Colors.transparent,
                                  ),
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
                                              image: NetworkImage(orderDetails[getCartIndex(i, packList)].artwork!.createdByNavigation!.avatar!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.artist,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: kTextStyle.copyWith(color: kSubTitleColor),
                                            ),
                                            Text(
                                              orderDetails[getCartIndex(i, packList)].artwork!.createdByNavigation!.name!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemCount: packList[i],
                                        itemBuilder: (_, j) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                onArtworkDetail(
                                                  orderDetails[j + getCartIndex(i, packList)].artworkId.toString(),
                                                );
                                              },
                                              child: Container(
                                                height: context.height() * 0.135,
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
                                                          height: context.height() * 0.135,
                                                          width: context.height() * 0.135,
                                                          decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius.only(
                                                              bottomLeft: Radius.circular(8.0),
                                                              topLeft: Radius.circular(8.0),
                                                            ),
                                                            image: DecorationImage(image: NetworkImage(orderDetails[j + getCartIndex(i, packList)].artwork!.arts!.first.image!), fit: BoxFit.cover),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              isFavorite = !isFavorite;
                                                            });
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
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
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Flexible(
                                                            child: SizedBox(
                                                              width: 190,
                                                              child: Text(
                                                                orderDetails[j + getCartIndex(i, packList)].artwork!.title!,
                                                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 5.0),
                                                          Text(
                                                            '${AppLocalizations.of(context)!.unitPrice}: ${NumberFormat.simpleCurrency(locale: 'vi_VN').format(snapshot.data!.orderDetails![j + getCartIndex(i, packList)].price)}',
                                                            style: kTextStyle.copyWith(color: kSubTitleColor),
                                                          ),
                                                          const SizedBox(height: 5.0),
                                                          SizedBox(
                                                            width: DodResponsive.isDesktop(context) ? context.width() * 0.31 : context.width() * 0.58,
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    if (orderDetails[j + getCartIndex(i, packList)].quantity! > 1) {
                                                                      decreaseQuantity(orderDetails[j + getCartIndex(i, packList)].id.toString(), orderDetails[j + getCartIndex(i, packList)].quantity!).then((value) => refresh());
                                                                    }
                                                                  },
                                                                  child: Container(
                                                                    width: 20,
                                                                    height: 20,
                                                                    decoration: BoxDecoration(
                                                                      color: kBorderColorTextField,
                                                                      borderRadius: BorderRadius.circular(
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
                                                                  orderDetails[j + getCartIndex(i, packList)].quantity.toString(),
                                                                  style: kTextStyle.copyWith(
                                                                    color: kPrimaryColor,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 5.0),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    increaseQuantity(orderDetails[j + getCartIndex(i, packList)].id.toString(), orderDetails[j + getCartIndex(i, packList)].quantity!).then((value) => refresh());
                                                                  },
                                                                  child: Container(
                                                                    width: 20,
                                                                    height: 20,
                                                                    decoration: BoxDecoration(
                                                                      color: kBorderColorTextField,
                                                                      borderRadius: BorderRadius.circular(
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
                                                                    onRemove(orderDetails[j + getCartIndex(i, packList)].id.toString()).then((value) => refresh());
                                                                  },
                                                                  child: Container(
                                                                    height: 27,
                                                                    width: 20,
                                                                    decoration: BoxDecoration(
                                                                      color: kBorderColorTextField,
                                                                      borderRadius: BorderRadius.circular(
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
                                                                  NumberFormat.simpleCurrency(locale: 'vi_VN').format(orderDetails[j + getCartIndex(i, packList)].quantity! * orderDetails[j + getCartIndex(i, packList)].price!),
                                                                  style: kTextStyle.copyWith(
                                                                    color: kPrimaryColor,
                                                                    fontWeight: FontWeight.bold,
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

  void onArtworkDetail(String id) {
    context.goNamed('${ArtworkDetailRoute.name} cart', pathParameters: {'artworkId': id});
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
    context.goNamed(CheckoutRoute.name, pathParameters: {'id': PrefUtils().getCartId()});
  }

  Future<void> onRemove(String id) async {
    await OrderDetailApi().deleteOne(id);
  }
}
