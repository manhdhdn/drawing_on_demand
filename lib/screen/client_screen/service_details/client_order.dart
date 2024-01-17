import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/common/common_features.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../core/utils/validation_function.dart';
import '../../../data/apis/api_config.dart';
import '../../../data/apis/ghn_api.dart';
import '../../../data/apis/handover_api.dart';
import '../../../data/apis/handoveritem_api.dart';
import '../../../data/apis/order_api.dart';
import '../../../data/apis/vnpay_api.dart';
import '../../../data/models/ghn_request.dart';
import '../../../data/models/handover.dart';
import '../../../data/models/handoveritem.dart';
import '../../../data/models/order.dart';
import '../../../data/models/order_detail.dart';
import '../../../data/models/vnpay_request.dart';
import '../../common/orders/order_list.dart';
import '../../common/popUp/popup_2.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../widgets/nothing_yet.dart';
import '../../widgets/responsive.dart';

class ClientOrder extends StatefulWidget {
  final String? id;

  const ClientOrder({Key? key, this.id}) : super(key: key);

  @override
  State<ClientOrder> createState() => _ClientOrderState();
}

class _ClientOrderState extends State<ClientOrder> {
  final _formKey = GlobalKey<FormState>();

  late Future<Order?> order;

  TextEditingController nameController = TextEditingController(
    text: jsonDecode(PrefUtils().getAccount())['Name'],
  );
  TextEditingController phoneController = TextEditingController(
    text: jsonDecode(PrefUtils().getAccount())['Phone'],
  );
  TextEditingController addressController = TextEditingController(
    text: jsonDecode(PrefUtils().getAccount())['Address'],
  );

  bool isCheck = false;

  int lightServiceTypeId = 2;
  int heavyServiceTypeId = 5;
  String requiredNote = 'KHONGCHOXEMHANG';

  String status = 'Pending';
  double total = 0;
  double discount = 0.3;
  String? discountId;
  double paid = 0;
  List<double> shippingFees = [0];
  List<String> shippingOrders = [''];

  List<Map<String, dynamic>> provinces = [];
  List<Map<String, dynamic>> districts = [];
  List<Map<String, dynamic>> wards = [];

  Map<String, dynamic>? selectedProvince;
  Map<String, dynamic>? previousSelectedDistrict = {
    'DistrictID': 0,
    'DistrictName': '',
  };
  Map<String, dynamic>? selectedDistrict;
  Map<String, dynamic>? previousSelectedWard = {
    'WardCode': 0,
    'WardName': '',
  };
  Map<String, dynamic>? selectedWard;

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

  void showProcessingPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: const ProcessingPopUp(),
            );
          },
        );
      },
    );
  }

  void showFailedPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: const FailedPopUp(),
            );
          },
        );
      },
    );
  }

  DropdownButton<Map<String, dynamic>> getProvinces() {
    List<DropdownMenuItem<Map<String, dynamic>>> dropDownItems = [];

    for (Map<String, dynamic> des in provinces) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des['ProvinceName']),
      );
      dropDownItems.add(item);
    }

    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedProvince,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) async {
        if (isCheck) {
          await getDistrict(value!['ProvinceID'] as int);

          setState(() {
            selectedProvince = value;
          });
        }
      },
    );
  }

  DropdownButton<Map<String, dynamic>> getDistricts() {
    List<DropdownMenuItem<Map<String, dynamic>>> dropDownItems = [];

    for (Map<String, dynamic> des in districts) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des['DistrictName']),
      );
      dropDownItems.add(item);
    }

    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedDistrict,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) async {
        if (isCheck) {
          await getWard(value!['DistrictID'] as int);

          setState(() {
            previousSelectedDistrict = selectedDistrict;
            selectedDistrict = value;
          });
        }
      },
    );
  }

  DropdownButton<Map<String, dynamic>> getWards() {
    List<DropdownMenuItem<Map<String, dynamic>>> dropDownItems = [];

    for (Map<String, dynamic> des in wards) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des['WardName']),
      );
      dropDownItems.add(item);
    }

    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedWard,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) {
        if (isCheck) {
          setState(() {
            previousSelectedWard = selectedWard;
            selectedWard = value!;
          });
        }
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
    return Title(
      title: '$dod | Checkout',
      color: kPrimaryColor,
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: kDarkWhite,
          centerTitle: true,
          iconTheme: const IconThemeData(color: kNeutralColor),
          title: Text(
            AppLocalizations.of(context)!.order,
            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(color: kWhite),
          child: Padding(
            padding: EdgeInsets.only(
              left: DodResponsive.isDesktop(context) ? 150.0 : 0.0,
              right: DodResponsive.isDesktop(context) ? 150.0 : 0.0,
            ),
            child: ButtonGlobalWithoutIcon(
              buttontext: AppLocalizations.of(context)!.continueOrder,
              buttonDecoration: kButtonDecoration.copyWith(
                color: !shippingFees.any((shippingFee) => shippingFee == 0) ? kPrimaryColor : kLightNeutralColor,
                borderRadius: BorderRadius.circular(30.0),
              ),
              onPressed: () {
                !shippingFees.any((shippingFee) => shippingFee == 0) ? onContinue() : null;
              },
              buttonTextColor: kWhite,
            ),
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
              child: Padding(
                padding: EdgeInsets.only(
                  left: DodResponsive.isDesktop(context) ? 150.0 : 0.0,
                  right: DodResponsive.isDesktop(context) ? 150.0 : 0.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15.0),
                    FutureBuilder(
                      future: order,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<OrderDetail> orderDetails = snapshot.data!.orderDetails!;

                          orderDetails.sort(((a, b) => a.artwork!.createdByNavigation!.email!.compareTo(b.artwork!.createdByNavigation!.email!)));

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
                                    shippingFees.add(0);
                                    shippingOrders.add('');

                                    while (shippingFees.length > packList.length) {
                                      shippingFees.removeLast();
                                      shippingOrders.removeLast();
                                    }

                                    createShippingOrder(orderDetails, packList, i);

                                    return Theme(
                                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
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
                                            itemCount: packList[i],
                                            physics: const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (_, j) {
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 10.0),
                                                child: GestureDetector(
                                                  onTap: () {},
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
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(height: 5.0),
                                                              Text(
                                                                '${AppLocalizations.of(context)!.unitPrice}: ${NumberFormat.simpleCurrency(locale: 'vi_VN').format(snapshot.data!.orderDetails![j + getCartIndex(i, packList)].price)}',
                                                                style: kTextStyle.copyWith(
                                                                  color: kSubTitleColor,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 5.0),
                                                              SizedBox(
                                                                width: DodResponsive.isDesktop(context) ? context.width() * 0.3 : context.width() * 0.5,
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      '${AppLocalizations.of(context)!.quantity}: ${snapshot.data!.orderDetails![j + getCartIndex(i, packList)].quantity}',
                                                                      style: kTextStyle.copyWith(
                                                                        color: kSubTitleColor,
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
                                          SizedBox(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                SizedBox(width: context.height() * 0.135 + 6),
                                                Text(
                                                  '${AppLocalizations.of(context)!.shippingFee}:',
                                                  style: kTextStyle.copyWith(
                                                    color: kSubTitleColor,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  NumberFormat.simpleCurrency(locale: 'vi_VN').format(shippingFees[i]),
                                                  style: kTextStyle.copyWith(
                                                    color: kPrimaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(width: DodResponsive.isDesktop(context) ? 74.0 : 18.0),
                                              ],
                                            ),
                                          ).visible(status != 'Pending'),
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
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.deliveryAddress,
                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    activeColor: kPrimaryColor,
                                    visualDensity: const VisualDensity(horizontal: -4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    value: isCheck,
                                    onChanged: (value) {
                                      setState(() {
                                        isCheck = !isCheck;
                                      });

                                      if (!isCheck) {
                                        setState(() {
                                          nameController.text = jsonDecode(PrefUtils().getAccount())['Name'];
                                          phoneController.text = jsonDecode(PrefUtils().getAccount())['Phone'];
                                          addressController.text = jsonDecode(PrefUtils().getAccount())['Address'];
                                        });

                                        getProvince();
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 2.0),
                                  Text(
                                    AppLocalizations.of(context)!.useThisAddressInstead,
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.name,
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: DodResponsive.isDesktop(context) ? context.width() * 0.35 : context.width() * 0.7,
                                child: TextFormField(
                                  keyboardType: TextInputType.name,
                                  cursorColor: kNeutralColor,
                                  textInputAction: TextInputAction.next,
                                  decoration: kInputDecoration.copyWith(
                                    labelText: AppLocalizations.of(context)!.receiverName,
                                    labelStyle: kTextStyle.copyWith(
                                      color: kNeutralColor,
                                      fontSize: 14.0,
                                    ),
                                    hintText: AppLocalizations.of(context)!.enterReceiverName,
                                    hintStyle: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                      fontSize: 14.0,
                                    ),
                                    focusColor: kNeutralColor,
                                    border: const OutlineInputBorder(),
                                  ),
                                  readOnly: !isCheck,
                                  controller: nameController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return AppLocalizations.of(context)!.enterReceiverName;
                                    }

                                    return null;
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.phone,
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: DodResponsive.isDesktop(context) ? context.width() * 0.35 : context.width() * 0.7,
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  cursorColor: kNeutralColor,
                                  textInputAction: TextInputAction.next,
                                  decoration: kInputDecoration.copyWith(
                                    labelText: AppLocalizations.of(context)!.receiverPhone,
                                    labelStyle: kTextStyle.copyWith(
                                      color: kNeutralColor,
                                      fontSize: 14.0,
                                    ),
                                    hintText: AppLocalizations.of(context)!.receiverPhone,
                                    hintStyle: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                      fontSize: 14.0,
                                    ),
                                    focusColor: kNeutralColor,
                                    border: const OutlineInputBorder(),
                                  ),
                                  readOnly: !isCheck,
                                  controller: phoneController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (!isPhone(value, isRequired: true)) {
                                      return AppLocalizations.of(context)!.enterReceiverPhone;
                                    }

                                    return null;
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.province,
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: DodResponsive.isDesktop(context) ? context.width() * 0.35 : context.width() * 0.7,
                                child: FormField(
                                    builder: (FormFieldState<dynamic> field) {
                                      return InputDecorator(
                                        decoration: kInputDecoration.copyWith(
                                          enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                            borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                          ),
                                          contentPadding: const EdgeInsets.all(7.0),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          labelText: AppLocalizations.of(context)!.chooseAProvince,
                                          labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: getProvinces(),
                                        ),
                                      );
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (selectedProvince == null) {
                                        return AppLocalizations.of(context)!.pleaseChooseProvince;
                                      }

                                      return null;
                                    }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.district,
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: DodResponsive.isDesktop(context) ? context.width() * 0.35 : context.width() * 0.7,
                                child: FormField(
                                    builder: (FormFieldState<dynamic> field) {
                                      return InputDecorator(
                                        decoration: kInputDecoration.copyWith(
                                          enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                            borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                          ),
                                          contentPadding: const EdgeInsets.all(7.0),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          labelText: AppLocalizations.of(context)!.chooseADistrict,
                                          labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: getDistricts(),
                                        ),
                                      );
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (selectedDistrict == null) {
                                        return AppLocalizations.of(context)!.pleaseChooseDistrict;
                                      }

                                      return null;
                                    }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.ward,
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: DodResponsive.isDesktop(context) ? context.width() * 0.35 : context.width() * 0.7,
                                child: FormField(
                                    builder: (FormFieldState<dynamic> field) {
                                      return InputDecorator(
                                        decoration: kInputDecoration.copyWith(
                                          enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                            borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                          ),
                                          contentPadding: const EdgeInsets.all(7.0),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          labelText: AppLocalizations.of(context)!.chooseAWard,
                                          labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: getWards(),
                                        ),
                                      );
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (selectedWard == null) {
                                        return AppLocalizations.of(context)!.pleaseChooseWard;
                                      }

                                      return null;
                                    }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.address,
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: DodResponsive.isDesktop(context) ? context.width() * 0.35 : context.width() * 0.7,
                                child: TextFormField(
                                  keyboardType: TextInputType.streetAddress,
                                  cursorColor: kNeutralColor,
                                  textInputAction: TextInputAction.done,
                                  decoration: kInputDecoration.copyWith(
                                    labelText: AppLocalizations.of(context)!.addressDetail,
                                    labelStyle: kTextStyle.copyWith(
                                      color: kNeutralColor,
                                      fontSize: 14.0,
                                    ),
                                    hintText: AppLocalizations.of(context)!.enterAddressDetail,
                                    hintStyle: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                      fontSize: 14.0,
                                    ),
                                    focusColor: kNeutralColor,
                                    border: const OutlineInputBorder(),
                                  ),
                                  readOnly: !isCheck,
                                  controller: addressController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return AppLocalizations.of(context)!.pleaseEnterAddress;
                                    }

                                    return null;
                                  },
                                  onEditingComplete: () {
                                    getProvince();
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ).visible(status != 'Pending'),
                    Text(
                      AppLocalizations.of(context)!.paymentMethod,
                      style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
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
                                  image: DecorationImage(image: AssetImage(imageList[i]), fit: BoxFit.cover),
                                ),
                              ),
                              title: Text(
                                paymentMethod[i],
                                style: kTextStyle.copyWith(color: kNeutralColor),
                              ),
                              trailing: Icon(
                                selectedPaymentMethod == i ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                                color: selectedPaymentMethod == i ? kPrimaryColor : kSubTitleColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      AppLocalizations.of(context)!.orderSummary,
                      style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.subtotal,
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                        ),
                        const Spacer(),
                        Text(
                          NumberFormat.simpleCurrency(locale: 'vi_VN').format(total),
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0).visible(status != 'Pending'),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.shippingFee,
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                        ),
                        const Spacer(),
                        Text(
                          NumberFormat.simpleCurrency(locale: 'vi_VN').format(shippingFees.length > 1 ? shippingFees.reduce((a, b) => a + b) : shippingFees[0]),
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                        ),
                      ],
                    ).visible(status != 'Pending'),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.total,
                          style: kTextStyle.copyWith(
                            color: kNeutralColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          NumberFormat.simpleCurrency(locale: 'vi_VN').format(total + (shippingFees.length > 1 ? shippingFees.reduce((a, b) => a + b) : shippingFees[0])),
                          style: kTextStyle.copyWith(
                            color: kNeutralColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ).visible(status != 'Pending'),
                    const SizedBox(height: 5.0).visible(status != 'Pending'),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.discount,
                          style: kTextStyle.copyWith(
                            color: kNeutralColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          NumberFormat.simpleCurrency(locale: 'vi_VN').format(-(total + (shippingFees.length > 1 ? shippingFees.reduce((a, b) => a + b) : shippingFees[0])) * discount),
                          style: kTextStyle.copyWith(
                            color: kNeutralColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ).visible(discount != 0 && status != 'Pending'),
                    const SizedBox(height: 10.0).visible(discount != 0 && status != 'Pending'),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: AppLocalizations.of(context)!.needToPay,
                            style: kTextStyle.copyWith(
                              color: kNeutralColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                            children: [
                              status != 'Deposited'
                                  ? status == 'Pending'
                                      ? TextSpan(
                                          text: '(${discount * 100}% of subtotal)',
                                          style: kTextStyle.copyWith(
                                            color: kNeutralColor,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14.0,
                                          ),
                                        )
                                      : const TextSpan()
                                  : TextSpan(
                                      text: AppLocalizations.of(context)!.theRest,
                                      style: kTextStyle.copyWith(
                                        color: kNeutralColor,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14.0,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          NumberFormat.simpleCurrency(locale: 'vi_VN').format(status != 'Deposited'
                              ? status == 'Pending'
                                  ? total * discount
                                  : (total + (shippingFees.length > 1 ? shippingFees.reduce((a, b) => a + b) : shippingFees[0])) * (1 - discount)
                              : ((total + (shippingFees.length > 1 ? shippingFees.reduce((a, b) => a + b) : shippingFees[0])) * (1 - discount)) - paid),
                          style: kTextStyle.copyWith(
                            color: kNeutralColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ).visible(discount != 0 || status == 'Deposited'),
                    const SizedBox(height: 10.0).visible(discount != 0 || status == 'Deposited'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void init() async {
    order = OrderApi()
        .getOne(
      widget.id!,
      'orderDetails(expand=artwork(expand=arts,sizes,createdByNavigation)),discount',
    )
        .then((order) async {
      Map<String, String> query = GoRouter.of(context).routeInformationProvider.value.uri.queryParameters;

      if (query.containsKey('vnp_TxnRef')) {
        if (query['vnp_TxnRef'] == PrefUtils().getVNPayRef() && query['vnp_ResponseCode'] == '00') {
          showProcessingPopUp();
          // PrefUtils().clearVNPayRef();

          var result = await updateData(order, double.tryParse(query['vnp_Amount']!)! / 100);

          if (result) {
            // ignore: use_build_context_synchronously
            context.goNamed(
              OrderDetailRoute.name,
              pathParameters: {'orderId': widget.id!},
            );

            return null;
          }
        } else {
          showFailedPopUp();
        }
      }

      if (order.status == 'Paid' || order.status == 'Completed' || order.status == 'Cancelled') {
        // ignore: use_build_context_synchronously
        GoRouter.of(context).pop();
        return null;
      }

      if (order.discountId != null) {
        setState(() {
          if (order.status != 'Pending') {
            discount = order.discount!.discountPercent!;
          }

          discountId = order.discountId.toString();
        });
      } else {
        Map<String, dynamic> discount = await getDiscount(order);

        // Get discount
        setState(() {
          if (order.status != 'Pending') {
            this.discount = double.tryParse(discount['discountPercent'].toString())!;
          }

          discountId = discount['discountId']?.toString();
        });
      }

      setState(() {
        status = order.status!;
      });

      setState(() {
        total = getSubtotal(order.orderDetails!);
      });

      if (order.total! > 0) {
        setState(() {
          paid = order.total!;
        });
      }

      // PrefUtils().clearVNPayRef();
      getProvince();

      return order;
    });
  }

  Future<void> getProvince() async {
    var request = GHNRequest(endpoint: ApiConfig.GHNPaths['province']);
    var respone = await GHNApi().postOne(request);

    setState(() {
      provinces = List<Map<String, dynamic>>.from(jsonDecode(respone.postJsonString!)['data']);
      selectedProvince = null;

      provinces.sort(((a, b) => a['ProvinceName'].compareTo(b['ProvinceName'])));

      Map<String, dynamic> result = {};
      double matchPoint = 0;

      for (var province in provinces) {
        var nameExs = [];

        if (province.containsKey('NameExtension')) {
          nameExs = List<String>.from(province['NameExtension']);
        }

        for (var nameEx in nameExs) {
          double point = getMatchPoint(addressController.text.trim().split(',').last, nameEx);

          if (matchPoint < point) {
            matchPoint = point;
            result = province;
          }
        }
      }

      if (result.isNotEmpty) {
        getDistrict(result['ProvinceID']).then(
          (value) => setState(() {
            selectedProvince = result;
          }),
        );
      }
    });
  }

  Future<void> getDistrict(int provinceId) async {
    var request = GHNRequest(
      endpoint: ApiConfig.GHNPaths['district'],
      postJsonString: jsonEncode(
        {'province_id': provinceId},
      ),
    );
    var respone = await GHNApi().postOne(request);

    setState(() {
      previousSelectedDistrict = selectedDistrict;
      selectedDistrict = null;
      previousSelectedWard = selectedWard;
      selectedWard = null;

      districts = List<Map<String, dynamic>>.from(jsonDecode(respone.postJsonString!)['data']);
      wards = [];

      Map<String, dynamic> result = {};
      double matchPoint = 0;

      for (var district in districts) {
        var nameExs = [];

        if (district.containsKey('NameExtension')) {
          nameExs = List<String>.from(district['NameExtension']);
        }

        for (var nameEx in nameExs) {
          double point = getMatchPoint(addressController.text.trim(), nameEx);

          if (matchPoint < point) {
            matchPoint = point;
            result = district;
          }
        }
      }

      if (result.isNotEmpty) {
        getWard(result['DistrictID']).then(
          (value) => setState(() {
            selectedDistrict = result;
          }),
        );
      }
    });
  }

  Future<void> getWard(int districtId) async {
    var request = GHNRequest(
      endpoint: ApiConfig.GHNPaths['ward'],
      postJsonString: jsonEncode(
        {'district_id': districtId},
      ),
    );
    var respone = await GHNApi().postOne(request);

    setState(() {
      previousSelectedWard = selectedWard;
      selectedWard = null;

      wards = List<Map<String, dynamic>>.from(jsonDecode(respone.postJsonString!)['data']);

      Map<String, dynamic> result = {};
      double matchPoint = 0;

      for (var ward in wards) {
        var nameExs = [];

        if (ward.containsKey('NameExtension')) {
          nameExs = List<String>.from(ward['NameExtension']);
        }

        for (var nameEx in nameExs) {
          double point = getMatchPoint(addressController.text.trim(), nameEx);

          if (matchPoint < point) {
            matchPoint = point;
            result = ward;
          }
        }
      }

      if (result.isNotEmpty) {
        setState(() {
          selectedWard = result;
        });
      }
    });
  }

  Future<void> createShippingOrder(List<OrderDetail> orderDetails, List<int> packList, int i) async {
    if (selectedDistrict != null && selectedWard != null && (previousSelectedDistrict != selectedDistrict || previousSelectedWard != selectedWard)) {
      var items = [];

      double price = 0;

      int weight = 0;
      int length = 0;
      int width = 0;
      int height = 0;

      int currentIndex = getCartIndex(i, packList);

      for (var j = currentIndex; j < currentIndex + packList[i]; j++) {
        for (var size in orderDetails[j].artwork!.sizes!) {
          weight += size.weight! * orderDetails[j].quantity!;

          height += size.height! * orderDetails[j].quantity!;

          if (length < size.length!) {
            length = size.length!;
          }

          if (width < size.width!) {
            width = size.width!;
          }

          items.add({
            'name': orderDetails[j].artwork!.title,
            'code': orderDetails[j].id.toString(),
            'quantity': orderDetails[j].quantity,
            'weight': size.weight!,
            'length': size.length!,
            'width': size.width!,
            'height': size.height!,
          });
        }

        price += orderDetails[j].price! * orderDetails[j].quantity!;
      }

      var artist = orderDetails[currentIndex].artwork!.createdByNavigation!;
      List<String> splitAddress = artist.address!.split(', ');
      int slitAddressLength = splitAddress.length;
      var fromDistrictId = await getDistrictCode(splitAddress[slitAddressLength - 2], await getProvinceCode(splitAddress[slitAddressLength - 1]));
      var fromWardCode = await getWardCode(splitAddress[slitAddressLength - 3], fromDistrictId);

      var request = GHNRequest(
        endpoint: ApiConfig.GHNPaths['fee'],
        postJsonString: jsonEncode({
          'service_type_id': weight < 20000 ? lightServiceTypeId : heavyServiceTypeId,
          'insurance_value': price.toInt(),
          'from_district_id': fromDistrictId,
          'from_ward_code': fromWardCode,
          'to_district_id': selectedDistrict!['DistrictID'],
          'to_ward_code': selectedWard!['WardCode'],
          'weight': weight,
          'length': length,
          'width': width,
          'height': height,
          'items': items,
        }),
      );

      // Call preview
      try {
        var response = await GHNApi().postOne(request);

        List<double> shippingFees = this.shippingFees;
        shippingFees[i] = double.parse(
          jsonDecode(response.postJsonString!)['data']['total'].toString(),
        );

        List<String> shippingOrders = this.shippingOrders;
        shippingOrders[i] = jsonEncode({
          'from_name': artist.name,
          'from_phone': artist.phone,
          'from_address': artist.address,
          'from_ward_code': fromWardCode,
          'from_ward_name': splitAddress[slitAddressLength - 3],
          'from_district_name': splitAddress[slitAddressLength - 2],
          'from_provice_name': splitAddress[slitAddressLength - 1],
          'to_name': nameController.text.trim(),
          'to_phone': phoneController.text.trim(),
          'to_address': addressController.text.trim(),
          'to_ward_code': selectedWard!['WardCode'],
          'to_ward_name': selectedWard!['WardName'],
          'to_district_name': selectedDistrict!['DistrictName'],
          'return_phone': artist.phone,
          'return_address': artist.address,
          'return_ward_name': splitAddress[slitAddressLength - 3],
          'return_district_name': splitAddress[slitAddressLength - 2],
          'content': 'Tranh vẽ tay',
          'weight': weight,
          'length': length,
          'width': width,
          'height': height,
          'insurance_value': price.toInt(),
          'service_type_id': weight < 20000 ? lightServiceTypeId : heavyServiceTypeId,
          'payment_type_id': 1,
          'required_note': requiredNote,
          'items': items,
        });

        setState(() {
          previousSelectedDistrict = selectedDistrict;
          previousSelectedWard = selectedWard;

          this.shippingFees = shippingFees;
          this.shippingOrders = shippingOrders;
        });
      } catch (error) {
        Fluttertoast.showToast(msg: 'Create shipping order failed');
      }
    }
  }

  void onArtworkDetail(String string) {}

  Future<void> onContinue() async {
    if (status != 'Pending') {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }

    try {
      String uri = '${ApiConfig.paymentUrl}${GoRouter.of(context).routeInformationProvider.value.uri.path}';

      Order? order = await this.order;

      double price = status != 'Deposited'
          ? status == 'Pending'
              ? total * discount
              : (total + (shippingFees.length > 1 ? shippingFees.reduce((a, b) => a + b) : shippingFees[0])) * (1 - discount)
          : ((total + (shippingFees.length > 1 ? shippingFees.reduce((a, b) => a + b) : shippingFees[0])) * (1 - discount)) - paid;

      VNPayRequest request = VNPayRequest(
        orderId: order!.id.toString().split('-').first,
        price: price.toInt(),
        method: selectedPaymentMethod > 0 ? selectedPaymentMethod + 1 : selectedPaymentMethod,
        lang: PrefUtils().getLanguage() == 'Vietnamese' ? 'vn' : 'en',
        // ignore: use_build_context_synchronously
        returnUrl: uri,
      );

      VNPayRequest response = (await VNPayApi().postOne(request));

      await PrefUtils().setVNPayRef(response.orderId!);
      await PrefUtils().setShippingOrders(jsonEncode(shippingOrders));
      if (discountId != null) {
        await PrefUtils().setDiscountId(discountId.toString());
      }

      launchUrlString(response.paymentUrl!, webOnlyWindowName: '_self');
    } catch (error) {
      Fluttertoast.showToast(
          // ignore: use_build_context_synchronously
          msg: AppLocalizations.of(context)!.createPaymentFailed);
    }
  }

  Future<bool> updateData(Order order, double total) async {
    try {
      String status = order.status!;

      if (status == 'Cart' || status == 'Deposited') {
        List<String> shippingOrders = List<String>.from(jsonDecode(PrefUtils().getShippingOrders()));

        for (var shippingOrder in shippingOrders) {
          var request = GHNRequest(
            endpoint: ApiConfig.GHNPaths['create'],
            postJsonString: shippingOrder,
          );

          var respone = await GHNApi().postOne(request);
          var decodedResponse = jsonDecode(respone.postJsonString!)['data'];
          var decodedShippingOrder = jsonDecode(shippingOrder);

          var handOver = HandOver(
            id: decodedResponse['order_code'],
            name: decodedShippingOrder['to_name'],
            phone: decodedShippingOrder['to_phone'],
            pickupAddress: decodedShippingOrder['from_address'],
            receiveAddress: decodedShippingOrder['to_address'],
            shipmentPrice: decodedResponse['total_fee'],
            estimatedDeliveryDate: DateTime.parse(decodedResponse['expected_delivery_time']),
            handOverDate: DateTime.parse(decodedResponse['expected_delivery_time']),
            status: 'Pending',
            orderId: order.id,
          );

          var decodedItems = List<Map<String, dynamic>>.from(decodedShippingOrder['items']);
          List<HandOverItem> handOverItems = [];

          for (var i = 0; i < decodedItems.length; i++) {
            if (i == 0) {
              handOverItems.add(
                HandOverItem(
                  id: Guid.newGuid,
                  handOverId: handOver.id,
                  orderDetailId: Guid(decodedItems[i]['code']),
                ),
              );
            } else {
              if (decodedItems[i]['code'] != decodedItems[i - 1]['code']) {
                handOverItems.add(
                  HandOverItem(
                    id: Guid.newGuid,
                    handOverId: handOver.id,
                    orderDetailId: Guid(decodedItems[i]['code']),
                  ),
                );
              }
            }
          }

          await HandOverApi().postOne(handOver);

          for (var handOverItem in handOverItems) {
            await HandOverItemApi().postOne(handOverItem);
          }
        }
      }

      Map<String, dynamic> body = {
        'OrderDate': status == 'Cart'
            ? DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.now())
            : order.orderDate != null
                ? DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(order.orderDate!)
                : null,
        'DepositDate': status == 'Pending'
            ? DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.now())
            : order.depositDate != null
                ? DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(order.depositDate!)
                : null,
        'CompletedDate': status == 'Cart' || status == 'Deposited' ? DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.now()) : null,
        'Status': status == 'Pending' ? 'Deposited' : 'Paid',
        'Total': order.total! + total,
        'DiscountId': PrefUtils().getDiscountId() == '' ? null : PrefUtils().getDiscountId(),
      };

      await OrderApi().patchOne(widget.id!, body);

      if (status == 'Cart') {
        await PrefUtils().clearCartId();
      }

      await PrefUtils().clearShippingOrders();
      await PrefUtils().clearDiscountId();

      setState(() {
        selectedOrderTab = status == 'Pending' ? 'Active' : 'Paid';
      });

      if (OrderList.state != null) {
        OrderList.refresh();
      }

      return true;
    } catch (error) {
      Fluttertoast.showToast(
          // ignore: use_build_context_synchronously
          msg: AppLocalizations.of(context)!.updateDataFailed);
    }

    return false;
  }
}
