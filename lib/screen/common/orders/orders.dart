import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/order_api.dart';
import '../../../data/models/order.dart';
import '../../widgets/constant.dart';
import 'order_detail.dart';

class OrderList extends StatefulWidget {
  static dynamic state;

  const OrderList({Key? key}) : super(key: key);

  @override
  State<OrderList> createState() => _OrderListState();
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
                List<Order> completedOrders = snapshot.data!.value
                    .where(((order) => order.status == 'Completed'))
                    .toList();
                List<Order> cancelledOrders = snapshot.data!.value
                    .where(((order) => order.status == 'Cancelled'))
                    .toList();

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HorizontalList(
                        padding: const EdgeInsets.only(left: 15.0, top: 15.0),
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
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  const OrderDetailScreen().launch(context);
                                });
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
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Order ID #F025E15',
                                          style: kTextStyle.copyWith(
                                              color: kNeutralColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        SlideCountdownSeparated(
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
                                    RichText(
                                      text: TextSpan(
                                        text: 'Seller: ',
                                        style: kTextStyle.copyWith(
                                            color: kLightNeutralColor),
                                        children: [
                                          TextSpan(
                                            text: 'Shaidul Islam',
                                            style: kTextStyle.copyWith(
                                                color: kNeutralColor),
                                          ),
                                          TextSpan(
                                            text: '  |  ',
                                            style: kTextStyle.copyWith(
                                                color: kLightNeutralColor),
                                          ),
                                          TextSpan(
                                            text: '24 Jun 2023',
                                            style: kTextStyle.copyWith(
                                                color: kLightNeutralColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
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
                                            'Title',
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
                                                  'Mobile UI UX design or app UI UX design',
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
                                            'Duration',
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
                                                  '3 Days',
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
                                                  '$currencySign 5.00',
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
                        itemCount: depositedOrders.length,
                        itemBuilder: (_, i) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  const OrderDetailScreen().launch(context);
                                });
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
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Order ID #F025E15',
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
                                    RichText(
                                      text: TextSpan(
                                        text: 'Seller: ',
                                        style: kTextStyle.copyWith(
                                            color: kLightNeutralColor),
                                        children: [
                                          TextSpan(
                                            text: 'Shaidul Islam',
                                            style: kTextStyle.copyWith(
                                                color: kNeutralColor),
                                          ),
                                          TextSpan(
                                            text: '  |  ',
                                            style: kTextStyle.copyWith(
                                                color: kLightNeutralColor),
                                          ),
                                          TextSpan(
                                            text: '24 Jun 2023',
                                            style: kTextStyle.copyWith(
                                                color: kLightNeutralColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
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
                                            'Title',
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
                                                  'Mobile UI UX design or app UI UX design',
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
                                            'Duration',
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
                                                  '3 Days',
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
                                                  '$currencySign 5.00',
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
                        itemCount: completedOrders.length,
                        itemBuilder: (_, i) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  const OrderDetailScreen().launch(context);
                                });
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
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Order ID #F025E15',
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
                                    RichText(
                                      text: TextSpan(
                                        text: 'Seller: ',
                                        style: kTextStyle.copyWith(
                                            color: kLightNeutralColor),
                                        children: [
                                          TextSpan(
                                            text: 'Shaidul Islam',
                                            style: kTextStyle.copyWith(
                                                color: kNeutralColor),
                                          ),
                                          TextSpan(
                                            text: '  |  ',
                                            style: kTextStyle.copyWith(
                                                color: kLightNeutralColor),
                                          ),
                                          TextSpan(
                                            text: '24 Jun 2023',
                                            style: kTextStyle.copyWith(
                                                color: kLightNeutralColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
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
                                            'Title',
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
                                                  'Mobile UI UX design or app UI UX design',
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
                                            'Duration',
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
                                                  '3 Days',
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
                                                  '$currencySign 5.00',
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
                                                  'Completed',
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
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                onDetail('id');
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
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Order ID #F025E15',
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
                                    RichText(
                                      text: TextSpan(
                                        text: 'Seller: ',
                                        style: kTextStyle.copyWith(
                                            color: kLightNeutralColor),
                                        children: [
                                          TextSpan(
                                            text: 'Shaidul Islam',
                                            style: kTextStyle.copyWith(
                                                color: kNeutralColor),
                                          ),
                                          TextSpan(
                                            text: '  |  ',
                                            style: kTextStyle.copyWith(
                                                color: kLightNeutralColor),
                                          ),
                                          TextSpan(
                                            text: '24 Jun 2023',
                                            style: kTextStyle.copyWith(
                                                color: kLightNeutralColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
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
                                            'Title',
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
                                                  'Mobile UI UX design or app UI UX design',
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
                                            'Duration',
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
                                                  '3 Days',
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
                                                  '$currencySign 5.00',
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
