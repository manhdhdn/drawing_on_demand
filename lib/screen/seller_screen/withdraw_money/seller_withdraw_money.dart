import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/common/common_features.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../data/apis/order_api.dart';
import '../../../data/apis/payment_api.dart';
import '../../../data/models/order.dart';
import '../../../data/models/payment.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../common/popUp/popup_1.dart';
import '../../widgets/responsive.dart';

class SellerWithdrawMoney extends StatefulWidget {
  const SellerWithdrawMoney({Key? key}) : super(key: key);

  @override
  State<SellerWithdrawMoney> createState() => _SellerWithdrawMoneyState();
}

class _SellerWithdrawMoneyState extends State<SellerWithdrawMoney> {
  TextEditingController amountController = TextEditingController(text: NumberFormat.simpleCurrency(locale: 'vi-VN').format(0));

  List<Order> orders = [];

  bool canWithdraw = false;

  void withdrawAmountPopUp() async {
    var result = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              insetPadding: DodResponsive.isDesktop(context) ? EdgeInsets.symmetric(horizontal: context.width() / 2.7) : const EdgeInsets.symmetric(horizontal: 40.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: WithdrawAmountPopUp(amount: amountController.text),
            );
          },
        );
      },
    );

    if (result == true) {
      try {
        // ignore: use_build_context_synchronously
        ProgressDialogUtils.showProgress(context);

        var transactionId = DateTime.now();
        var signature = jsonDecode(PrefUtils().getAccount())['Id'];
        var status = 'Pending';

        for (var order in orders.where((order) => (order.status == 'Completed' || order.status == 'Reviewed' || order.status == 'Cancelled') && !order.payments!.any((payment) => payment.signature == jsonDecode(PrefUtils().getAccount())['Id'])).toList()) {
          var payment = Payment(
            id: Guid.newGuid,
            transactionId: transactionId,
            signature: signature,
            tranferContent: amountController.text.removeAllWhiteSpace().replaceAll('₫', '').replaceAll('.', '').toInt().toString(),
            status: status,
            orderId: order.id,
          );

          await PaymentApi().postOne(payment);
        }

        // ignore: use_build_context_synchronously
        ProgressDialogUtils.hideProgress(context);
        getStatistics();
      } catch (error) {
        // ignore: use_build_context_synchronously
        ProgressDialogUtils.hideProgress(context);
        Fluttertoast.showToast(msg: 'Withdraw amount failed');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    getStatistics();
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
          AppLocalizations.of(context)!.withdrawMoney,
          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(color: kWhite),
        child: ButtonGlobalWithoutIcon(
          buttontext: AppLocalizations.of(context)!.submitWithdraw,
          buttonDecoration: kButtonDecoration.copyWith(
            color: canWithdraw ? kPrimaryColor : kLightNeutralColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () {
            canWithdraw ? withdrawAmountPopUp() : null;
          },
          buttonTextColor: kWhite,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
          ),
          width: context.width(),
          height: context.height(),
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
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: kWhite,
                          border: Border.all(color: kBorderColorTextField),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getBalance(orders.where((order) => order.status == 'Pending' || order.status == 'Deposited' || order.status == 'Paid').toList()),
                              style: kTextStyle.copyWith(
                                color: kNeutralColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              AppLocalizations.of(context)!.activeOrders,
                              style: kTextStyle.copyWith(color: kSubTitleColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: kWhite,
                          border: Border.all(color: kBorderColorTextField),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              amountController.text,
                              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              AppLocalizations.of(context)!.withdrawalAvai,
                              maxLines: 1,
                              style: kTextStyle.copyWith(color: kSubTitleColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Text(
                  AppLocalizations.of(context)!.withdrawAmountt,
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  keyboardType: TextInputType.number,
                  cursorColor: kNeutralColor,
                  textInputAction: TextInputAction.done,
                  decoration: kInputDecoration.copyWith(
                    // labelText: AppLocalizations.of(context)!.amount,
                    labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                    hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                    focusColor: kNeutralColor,
                    border: const OutlineInputBorder(),
                  ),
                  readOnly: true,
                  controller: amountController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getStatistics() async {
    try {
      orders = (await OrderApi().gets(
        0,
        filter: "orderDetails/any(od: od/artwork/createdBy eq ${jsonDecode(PrefUtils().getAccount())['Id']}) and status ne 'Cart'",
        expand: 'orderDetails(expand=artwork(expand=createdByNavigation)),payments',
      ))
          .value;

      setState(() {
        orders = orders;
        amountController.text = getBalance(orders.where((order) => (order.status == 'Completed' || order.status == 'Reviewed' || order.status == 'Cancelled') && !order.payments!.any((payment) => payment.signature == jsonDecode(PrefUtils().getAccount())['Id'])).toList());

        if (amountController.text != NumberFormat.simpleCurrency(locale: 'vi-VN').format(0)) {
          canWithdraw = true;
        } else {
          canWithdraw = false;
        }
      });
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get statistics failed');
    }
  }
}
