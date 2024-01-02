import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/common/common_features.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/order_api.dart';
import '../../../data/models/order.dart';
import '../../widgets/constant.dart';

class OrderList extends StatefulWidget {
  static dynamic state;

  final String? tab;

  const OrderList({Key? key, this.tab = 'Pending'}) : super(key: key);

  @override
  State<OrderList> createState() => _OrderListState();

  static void refresh() {
    state.refresh();
  }
}

class _OrderListState extends State<OrderList> {
  late Future<Orders?> orders;

  @override
  void initState() {
    super.initState();

    OrderList.state = this;
    orders = getData();
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
          'Orders',
          style: kTextStyle.copyWith(
              color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
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
          child: FutureBuilder(
            future: orders,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Order> pendingOrders = snapshot.data!.value
                    .where(((order) => order.status == 'Pending'))
                    .toList();
                List<Order> depositedOrders = snapshot.data!.value
                    .where(((order) => order.status == 'Deposited'))
                    .toList();
                List<Order> paidOrders = snapshot.data!.value
                    .where(((order) => order.status == 'Paid'))
                    .toList();
                List<Order> completedOrders = snapshot.data!.value
                    .where(((order) =>
                        order.status == 'Completed' ||
                        order.status == 'Reviewed'))
                    .toList();
                List<Order> cancelledOrders = snapshot.data!.value
                    .where(((order) => order.status == 'Cancelled'))
                    .toList();

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HorizontalList(
                        padding: const EdgeInsets.only(top: 15.0),
                        itemCount: titleList.length,
                        itemBuilder: (_, i) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                isSelected = titleList[i];
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: isSelected == titleList[i]
                                    ? kPrimaryColor
                                    : kDarkWhite,
                              ),
                              child: Text(
                                titleList[i],
                                style: kTextStyle.copyWith(
                                    color: isSelected == titleList[i]
                                        ? kWhite
                                        : kNeutralColor),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15.0),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: pendingOrders.length,
                        itemBuilder: (_, i) {
                          List<String> artistsName =
                              getArtistsName(pendingOrders[i].orderDetails!);

                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                onDetail(pendingOrders[i].id.toString());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                width: context.width(),
                                decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: kBorderColorTextField),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: kDarkWhite,
                                          spreadRadius: 4.0,
                                          blurRadius: 4.0,
                                          offset: Offset(0, 2))
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Order ID #${pendingOrders[i].id.toString().split('-').first.toUpperCase()}',
                                          style: kTextStyle.copyWith(
                                              color: kNeutralColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        SlideCountdownSeparated(
                                          showZeroValue: true,
                                          duration: Duration(
                                              milliseconds: pendingOrders[i]
                                                      .orderDate!
                                                      .add(const Duration(
                                                        days: 2,
                                                      ))
                                                      .millisecondsSinceEpoch -
                                                  DateTime.now()
                                                      .add(const Duration(
                                                        hours: 7,
                                                      ))
                                                      .millisecondsSinceEpoch),
                                          separatorType: SeparatorType.symbol,
                                          separatorStyle: kTextStyle.copyWith(
                                              color: Colors.transparent),
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: artistsName.length,
                                      itemBuilder: (_, i) {
                                        List<TextSpan> children = [
                                          TextSpan(
                                            text: artistsName[i],
                                            style: kTextStyle.copyWith(
                                                color: kNeutralColor),
                                          ),
                                        ];

                                        if (i == 0) {
                                          children.addAll([
                                            TextSpan(
                                              text: '  |  ',
                                              style: kTextStyle.copyWith(
                                                  color: kLightNeutralColor),
                                            ),
                                            TextSpan(
                                              text: DateFormat('dd-MM-yyyy')
                                                  .format(pendingOrders[i]
                                                      .orderDate!),
                                              style: kTextStyle.copyWith(
                                                  color: kLightNeutralColor),
                                            ),
                                          ]);
                                        }

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: 'Artist: ',
                                                style: kTextStyle.copyWith(
                                                    color: kLightNeutralColor),
                                                children: children,
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                          ],
                                        );
                                      },
                                    ),
                                    const Divider(
                                      thickness: 1.0,
                                      color: kBorderColorTextField,
                                      height: 1.0,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Order type',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  pendingOrders[i].orderType!,
                                                  style: kTextStyle.copyWith(
                                                      color: kSubTitleColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Amount',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  NumberFormat.simpleCurrency(
                                                    locale: 'vi_VN',
                                                  ).format(
                                                    getSubtotal(pendingOrders[i]
                                                        .orderDetails!),
                                                  ),
                                                  style: kTextStyle.copyWith(
                                                      color: kSubTitleColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Status',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  'Pending',
                                                  style: kTextStyle.copyWith(
                                                      color: kNeutralColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ).visible(isSelected == 'Pending'),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: depositedOrders.length,
                        itemBuilder: (_, i) {
                          List<String> artistsName =
                              getArtistsName(depositedOrders[i].orderDetails!);

                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                onDetail(depositedOrders[i].id.toString());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                width: context.width(),
                                decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: kBorderColorTextField),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: kDarkWhite,
                                          spreadRadius: 4.0,
                                          blurRadius: 4.0,
                                          offset: Offset(0, 2))
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Order ID #${depositedOrders[i].id.toString().split('-').first.toUpperCase()}',
                                          style: kTextStyle.copyWith(
                                              color: kNeutralColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        SlideCountdownSeparated(
                                          showZeroValue: true,
                                          duration: const Duration(days: 3),
                                          separatorType: SeparatorType.symbol,
                                          separatorStyle: kTextStyle.copyWith(
                                              color: Colors.transparent),
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: artistsName.length,
                                      itemBuilder: (_, i) {
                                        List<TextSpan> children = [
                                          TextSpan(
                                            text: artistsName[i],
                                            style: kTextStyle.copyWith(
                                                color: kNeutralColor),
                                          ),
                                        ];

                                        if (i == 0) {
                                          children.addAll([
                                            TextSpan(
                                              text: '  |  ',
                                              style: kTextStyle.copyWith(
                                                  color: kLightNeutralColor),
                                            ),
                                            TextSpan(
                                              text: DateFormat('dd-MM-yyyy')
                                                  .format(
                                                      paidOrders[i].orderDate!),
                                              style: kTextStyle.copyWith(
                                                  color: kLightNeutralColor),
                                            ),
                                          ]);
                                        }

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: 'Artist: ',
                                                style: kTextStyle.copyWith(
                                                    color: kLightNeutralColor),
                                                children: children,
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                          ],
                                        );
                                      },
                                    ),
                                    const Divider(
                                      thickness: 1.0,
                                      color: kBorderColorTextField,
                                      height: 1.0,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Order type',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  depositedOrders[i].orderType!,
                                                  style: kTextStyle.copyWith(
                                                      color: kSubTitleColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Amount',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  NumberFormat.simpleCurrency(
                                                    locale: 'vi_VN',
                                                  ).format(
                                                    getSubtotal(
                                                        depositedOrders[i]
                                                            .orderDetails!),
                                                  ),
                                                  style: kTextStyle.copyWith(
                                                      color: kSubTitleColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0).visible(
                                        depositedOrders[i].discount != null),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Discount',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  '${depositedOrders[i].discount != null ? depositedOrders[i].discount!.discountPercent! * 100 : 0}%',
                                                  style: kTextStyle.copyWith(
                                                      color: kSubTitleColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ).visible(
                                        depositedOrders[i].discount != null),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Status',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  'Active',
                                                  style: kTextStyle.copyWith(
                                                      color: kNeutralColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ).visible(isSelected == 'Active'),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: paidOrders.length,
                        itemBuilder: (_, i) {
                          List<String> artistsName =
                              getArtistsName(paidOrders[i].orderDetails!);

                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                onDetail(paidOrders[i].id.toString());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                width: context.width(),
                                decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: kBorderColorTextField),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: kDarkWhite,
                                          spreadRadius: 4.0,
                                          blurRadius: 4.0,
                                          offset: Offset(0, 2))
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Order ID #${paidOrders[i].id.toString().split('-').first.toUpperCase()}',
                                          style: kTextStyle.copyWith(
                                              color: kNeutralColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        SlideCountdownSeparated(
                                          showZeroValue: true,
                                          duration: const Duration(days: 0),
                                          separatorType: SeparatorType.symbol,
                                          separatorStyle: kTextStyle.copyWith(
                                              color: Colors.transparent),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFBFBFBF),
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: artistsName.length,
                                      itemBuilder: (_, i) {
                                        List<TextSpan> children = [
                                          TextSpan(
                                            text: artistsName[i],
                                            style: kTextStyle.copyWith(
                                                color: kNeutralColor),
                                          ),
                                        ];

                                        if (i == 0) {
                                          children.addAll([
                                            TextSpan(
                                              text: '  |  ',
                                              style: kTextStyle.copyWith(
                                                  color: kLightNeutralColor),
                                            ),
                                            TextSpan(
                                              text: DateFormat('dd-MM-yyyy')
                                                  .format(
                                                      paidOrders[i].orderDate!),
                                              style: kTextStyle.copyWith(
                                                  color: kLightNeutralColor),
                                            ),
                                          ]);
                                        }

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: 'Artist: ',
                                                style: kTextStyle.copyWith(
                                                    color: kLightNeutralColor),
                                                children: children,
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                          ],
                                        );
                                      },
                                    ),
                                    const Divider(
                                      thickness: 1.0,
                                      color: kBorderColorTextField,
                                      height: 1.0,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Order type',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  paidOrders[i].orderType!,
                                                  style: kTextStyle.copyWith(
                                                      color: kSubTitleColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Amount',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  NumberFormat.simpleCurrency(
                                                          locale: 'vi_VN')
                                                      .format(
                                                          paidOrders[i].total),
                                                  style: kTextStyle.copyWith(
                                                      color: kSubTitleColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0).visible(
                                        paidOrders[i].discount != null),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Discount',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  '${paidOrders[i].discount != null ? paidOrders[i].discount!.discountPercent! * 100 : 0}%',
                                                  style: kTextStyle.copyWith(
                                                      color: kSubTitleColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ).visible(paidOrders[i].discount != null),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Status',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  'Paid',
                                                  style: kTextStyle.copyWith(
                                                      color: kNeutralColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ).visible(isSelected == 'Paid'),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: completedOrders.length,
                        itemBuilder: (_, i) {
                          List<String> artistsName =
                              getArtistsName(completedOrders[i].orderDetails!);

                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                onDetail(completedOrders[i].id.toString());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                width: context.width(),
                                decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: kBorderColorTextField),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: kDarkWhite,
                                          spreadRadius: 4.0,
                                          blurRadius: 4.0,
                                          offset: Offset(0, 2))
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Order ID #${completedOrders[i].id.toString().split('-').first.toUpperCase()}',
                                          style: kTextStyle.copyWith(
                                              color: kNeutralColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        SlideCountdownSeparated(
                                          showZeroValue: true,
                                          duration: const Duration(days: 0),
                                          separatorType: SeparatorType.symbol,
                                          separatorStyle: kTextStyle.copyWith(
                                              color: Colors.transparent),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFBFBFBF),
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: artistsName.length,
                                      itemBuilder: (_, i) {
                                        List<TextSpan> children = [
                                          TextSpan(
                                            text: artistsName[i],
                                            style: kTextStyle.copyWith(
                                                color: kNeutralColor),
                                          ),
                                        ];

                                        if (i == 0) {
                                          children.addAll([
                                            TextSpan(
                                              text: '  |  ',
                                              style: kTextStyle.copyWith(
                                                  color: kLightNeutralColor),
                                            ),
                                            TextSpan(
                                              text: DateFormat('dd-MM-yyyy')
                                                  .format(completedOrders[i]
                                                      .orderDate!),
                                              style: kTextStyle.copyWith(
                                                  color: kLightNeutralColor),
                                            ),
                                          ]);
                                        }

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: 'Artist: ',
                                                style: kTextStyle.copyWith(
                                                    color: kLightNeutralColor),
                                                children: children,
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                          ],
                                        );
                                      },
                                    ),
                                    const Divider(
                                      thickness: 1.0,
                                      color: kBorderColorTextField,
                                      height: 1.0,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Order type',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  completedOrders[i].orderType!,
                                                  style: kTextStyle.copyWith(
                                                      color: kSubTitleColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Amount',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  NumberFormat.simpleCurrency(
                                                          locale: 'vi_VN')
                                                      .format(completedOrders[i]
                                                          .total),
                                                  style: kTextStyle.copyWith(
                                                      color: kSubTitleColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0).visible(
                                        completedOrders[i].discount != null),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Discount',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  '${completedOrders[i].discount != null ? completedOrders[i].discount!.discountPercent! * 100 : 0}%',
                                                  style: kTextStyle.copyWith(
                                                      color: kSubTitleColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ).visible(
                                        completedOrders[i].discount != null),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Status',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  completedOrders[i].status!,
                                                  style: kTextStyle.copyWith(
                                                      color: kNeutralColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ).visible(isSelected == 'Completed'),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: cancelledOrders.length,
                        itemBuilder: (_, i) {
                          List<String> artistsName =
                              getArtistsName(cancelledOrders[i].orderDetails!);
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                onDetail(cancelledOrders[i].id.toString());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                width: context.width(),
                                decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: kBorderColorTextField),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: kDarkWhite,
                                          spreadRadius: 4.0,
                                          blurRadius: 4.0,
                                          offset: Offset(0, 2))
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Order ID #${cancelledOrders[i].id.toString().split('-').first.toUpperCase()}',
                                          style: kTextStyle.copyWith(
                                              color: kNeutralColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        SlideCountdownSeparated(
                                          showZeroValue: true,
                                          duration: const Duration(days: 0),
                                          separatorType: SeparatorType.symbol,
                                          separatorStyle: kTextStyle.copyWith(
                                              color: Colors.transparent),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFBFBFBF),
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: artistsName.length,
                                      itemBuilder: (_, i) {
                                        List<TextSpan> children = [
                                          TextSpan(
                                            text: artistsName[i],
                                            style: kTextStyle.copyWith(
                                                color: kNeutralColor),
                                          ),
                                        ];

                                        if (i == 0) {
                                          children.addAll([
                                            TextSpan(
                                              text: '  |  ',
                                              style: kTextStyle.copyWith(
                                                  color: kLightNeutralColor),
                                            ),
                                            TextSpan(
                                              text: DateFormat('dd-MM-yyyy')
                                                  .format(cancelledOrders[i]
                                                      .orderDate!),
                                              style: kTextStyle.copyWith(
                                                  color: kLightNeutralColor),
                                            ),
                                          ]);
                                        }

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: 'Artist: ',
                                                style: kTextStyle.copyWith(
                                                    color: kLightNeutralColor),
                                                children: children,
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                          ],
                                        );
                                      },
                                    ),
                                    const Divider(
                                      thickness: 1.0,
                                      color: kBorderColorTextField,
                                      height: 1.0,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Order type',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  cancelledOrders[i].orderType!,
                                                  style: kTextStyle.copyWith(
                                                      color: kSubTitleColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Amount',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  NumberFormat.simpleCurrency(
                                                    locale: 'vi_VN',
                                                  ).format(
                                                    getSubtotal(
                                                        cancelledOrders[i]
                                                            .orderDetails!),
                                                  ),
                                                  style: kTextStyle.copyWith(
                                                      color: kSubTitleColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0).visible(
                                        cancelledOrders[i].discount != null),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Discount',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  '${cancelledOrders[i].discount != null ? cancelledOrders[i].discount!.discountPercent! * 100 : 0}%',
                                                  style: kTextStyle.copyWith(
                                                      color: kSubTitleColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ).visible(
                                        cancelledOrders[i].discount != null),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Status',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  'Cancelled',
                                                  style: kTextStyle.copyWith(
                                                      color: kNeutralColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ).visible(isSelected == 'Cancelled'),
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
    );
  }

  Future<Orders?> getData() async {
    try {
      return OrderApi().gets(
        0,
        filter:
            "orderedBy eq ${jsonDecode(PrefUtils().getAccount())['Id']} and status ne 'Cart'",
        orderBy: 'orderDate desc',
        expand:
            'orderDetails(expand=artwork(expand=createdByNavigation)),discount',
      );
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get orders failed');
    }

    return null;
  }

  void onDetail(String id) {
    context.goNamed(OrderDetailRoute.name, pathParameters: {'id': id});
  }

  void refresh() {
    setState(() {
      orders = getData();
    });
  }
}
