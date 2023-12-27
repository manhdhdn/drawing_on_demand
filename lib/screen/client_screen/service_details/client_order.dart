import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../core/common/common_features.dart';
import '../../../data/apis/api_config.dart';
import '../../../data/apis/ghn_api.dart';
import '../../../data/models/ghn_request.dart';
import '../../../data/models/order.dart';
import '../../../data/models/order_detail.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../widgets/nothing_yet.dart';
import 'client_add_card.dart';

class ClientOrder extends StatefulWidget {
  final String? id;

  const ClientOrder({Key? key, this.id}) : super(key: key);

  @override
  State<ClientOrder> createState() => _ClientOrderState();
}

class _ClientOrderState extends State<ClientOrder> {
  late Future<Order?> cart;

  double total = 0;
  double shippingFee = 180000;

  List<Map<String, dynamic>> provinces = [];
  List<Object> districts = [];
  List<Object> wards = [];

  int? selectedProvince;
  int? selectedDistrict;
  int? selectedWard;

  int selectedPaymentMethod = 0;

  List<String> paymentMethod = [
    'VNPay',
    'Credit or Debit Card',
    'Internation Card',
  ];

  List<String> imageList = [
    'images/vnpay.png',
    'images/creditcard.png',
    'images/internation.png',
  ];

  DropdownButton<int> getProvinces() {
    List<DropdownMenuItem<int>> dropDownItems = [];

    for (Map<String, dynamic> des in provinces) {
      var item = DropdownMenuItem(
        value: des['ProvinceID'] as int,
        child: Text(des['ProvinceName']),
      );
      dropDownItems.add(item);
    }

    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedProvince,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) {
        setState(() {
          selectedProvince = value!;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();

    init();
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
          'Order',
          style: kTextStyle.copyWith(
              color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(color: kWhite),
        child: ButtonGlobalWithoutIcon(
          buttontext: 'Continue',
          buttonDecoration: kButtonDecoration.copyWith(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () {
            setState(() {
              const AddNewCard().launch(context);
            });
          },
          buttonTextColor: kWhite,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Container(
          height: context.height(),
          width: context.width(),
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15.0),
                FutureBuilder(
                  future: cart,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<OrderDetail> orderDetails =
                          snapshot.data!.orderDetails!;

                      orderDetails.sort(((a, b) => a
                          .artwork!.createdByNavigation!.email!
                          .compareTo(b.artwork!.createdByNavigation!.email!)));

                      List<int> packList = [0];
                      int packCount = 0;
                      if (orderDetails.isNotEmpty) {
                        String tempEmail = orderDetails
                            .first.artwork!.createdByNavigation!.email!;

                        for (var orderDetail in orderDetails) {
                          if (orderDetail.artwork!.createdByNavigation!.email ==
                              tempEmail) {
                            packList[packCount]++;
                          } else {
                            tempEmail = orderDetail
                                .artwork!.createdByNavigation!.email!;

                            packCount++;
                            packList.add(1);
                          }
                        }
                      }

                      return Column(
                        children: [
                          NothingYet(visible: orderDetails.isEmpty),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: packList[0] != 0 ? packList.length : 0,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemBuilder: (_, i) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    initiallyExpanded: true,
                                    tilePadding:
                                        const EdgeInsets.only(bottom: 5.0),
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
                                                image: NetworkImage(
                                                    orderDetails[getCartIndex(
                                                            i, packList)]
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
                                              'Artist',
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
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                height:
                                                    context.height() * 0.135,
                                                decoration: BoxDecoration(
                                                  color: kWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  border: Border.all(
                                                      color:
                                                          kBorderColorTextField),
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Stack(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      children: [
                                                        Container(
                                                          height:
                                                              context.height() *
                                                                  0.135,
                                                          width:
                                                              context.height() *
                                                                  0.135,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      8.0),
                                                              topLeft: Radius
                                                                  .circular(
                                                                      8.0),
                                                            ),
                                                            image: DecorationImage(
                                                                image: NetworkImage(orderDetails[j +
                                                                        getCartIndex(
                                                                            i,
                                                                            packList)]
                                                                    .artwork!
                                                                    .arts!
                                                                    .first
                                                                    .image!),
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              isFavorite =
                                                                  !isFavorite;
                                                            });
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            child: Container(
                                                              height: 25,
                                                              width: 25,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                shape: BoxShape
                                                                    .circle,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black12,
                                                                    blurRadius:
                                                                        10.0,
                                                                    spreadRadius:
                                                                        1.0,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            2),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: isFavorite
                                                                  ? const Center(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .favorite,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            16.0,
                                                                      ),
                                                                    )
                                                                  : const Center(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .favorite_border,
                                                                        color:
                                                                            kNeutralColor,
                                                                        size:
                                                                            16.0,
                                                                      ),
                                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
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
                                                                maxLines: 1,
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
                                                            style: kTextStyle
                                                                .copyWith(
                                                              color:
                                                                  kSubTitleColor,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 5.0),
                                                          SizedBox(
                                                            width: context
                                                                    .width() *
                                                                0.5,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'Quantity: ${snapshot.data!.orderDetails![j + getCartIndex(i, packList)].quantity}',
                                                                  style: kTextStyle
                                                                      .copyWith(
                                                                    color:
                                                                        kSubTitleColor,
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                Text(
                                                                  NumberFormat.simpleCurrency(
                                                                          locale:
                                                                              'vi_VN')
                                                                      .format(orderDetails[j + getCartIndex(i, packList)]
                                                                              .quantity! *
                                                                          orderDetails[j + getCartIndex(i, packList)]
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
                                                          SizedBox(
                                                            width: context
                                                                    .width() *
                                                                0.5,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'Shipping fee:',
                                                                  style: kTextStyle
                                                                      .copyWith(
                                                                    color:
                                                                        kSubTitleColor,
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                Text(
                                                                  NumberFormat.simpleCurrency(
                                                                          locale:
                                                                              'vi_VN')
                                                                      .format(
                                                                          60000),
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
                const SizedBox(height: 15.0),
                Text(
                  'Delivery Address',
                  style: kTextStyle.copyWith(
                      color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text(
                      'Province',
                      style: kTextStyle.copyWith(color: kSubTitleColor),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: context.width() * 0.6,
                      child: FormField(
                        builder: (FormFieldState<dynamic> field) {
                          return InputDecorator(
                            decoration: kInputDecoration.copyWith(
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                borderSide: BorderSide(
                                    color: kBorderColorTextField, width: 2),
                              ),
                              contentPadding: const EdgeInsets.all(7.0),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Choose a Province',
                              labelStyle:
                                  kTextStyle.copyWith(color: kNeutralColor),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: getProvinces(),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text(
                      'District',
                      style: kTextStyle.copyWith(color: kSubTitleColor),
                    ),
                    const Spacer(),
                    Text(
                      'Unlimited',
                      style: kTextStyle.copyWith(color: kSubTitleColor),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text(
                      'Ward',
                      style: kTextStyle.copyWith(color: kSubTitleColor),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.check_rounded,
                      color: kPrimaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Payment Method',
                  style: kTextStyle.copyWith(
                      color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                ListView.builder(
                  itemCount: paymentMethod.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: kWhite,
                          border: Border.all(color: kBorderColorTextField),
                        ),
                        child: ListTile(
                          visualDensity: const VisualDensity(vertical: -2),
                          onTap: () {
                            setState(
                              () {
                                selectedPaymentMethod = i;
                              },
                            );
                          },
                          contentPadding: const EdgeInsets.only(right: 8.0),
                          leading: Container(
                            height: 50.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage(imageList[i]),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          title: Text(
                            paymentMethod[i],
                            style: kTextStyle.copyWith(color: kNeutralColor),
                          ),
                          trailing: Icon(
                            selectedPaymentMethod == i
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_off_rounded,
                            color: selectedPaymentMethod == i
                                ? kPrimaryColor
                                : kSubTitleColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Order Summary',
                  style: kTextStyle.copyWith(
                      color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Text(
                      'Subtotal',
                      style: kTextStyle.copyWith(color: kSubTitleColor),
                    ),
                    const Spacer(),
                    Text(
                      NumberFormat.simpleCurrency(locale: 'vi_VN')
                          .format(total),
                      style: kTextStyle.copyWith(color: kSubTitleColor),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      'Shipping fee',
                      style: kTextStyle.copyWith(color: kSubTitleColor),
                    ),
                    const Spacer(),
                    Text(
                      NumberFormat.simpleCurrency(locale: 'vi_VN')
                          .format(shippingFee),
                      style: kTextStyle.copyWith(color: kSubTitleColor),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      'Total',
                      style: kTextStyle.copyWith(
                          color: kNeutralColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    const Spacer(),
                    Text(
                      NumberFormat.simpleCurrency(locale: 'vi_VN')
                          .format(total + shippingFee),
                      style: kTextStyle.copyWith(
                          color: kNeutralColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void init() async {
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

    getProvince();
  }

  Future<void> getProvince() async {
    var request = GHNRequest(endpoint: ApiConfig.GHNPaths['province']);
    var respone = await GHNApi().postOne(request);

    setState(() {
      provinces = List<Map<String, dynamic>>.from(
          jsonDecode(respone.postJsonString!)['data']);
    });
  }

  Future<void> getDistrict(String provinceId) async {
    var request = GHNRequest(
      endpoint: ApiConfig.GHNPaths['district'],
      postJsonString: jsonEncode(
        {'province_id': provinceId},
      ),
    );
    var respone = await GHNApi().postOne(request);

    setState(() {
      districts = List<Map<String, dynamic>>.from(
          jsonDecode(respone.postJsonString!)['data']);
    });
  }

  Future<void> getWard(String districtId) async {
    var request = GHNRequest(
      endpoint: ApiConfig.GHNPaths['ward'],
      postJsonString: jsonEncode(
        {'district_id': districtId},
      ),
    );
    var respone = await GHNApi().postOne(request);

    setState(() {
      wards = List<Map<String, dynamic>>.from(
          jsonDecode(respone.postJsonString!)['data']);
    });
  }

  void onArtworkDetail(String string) {}
}
