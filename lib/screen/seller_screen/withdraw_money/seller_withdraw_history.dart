import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/payment_api.dart';
import '../../../data/models/payment.dart';
import '../../widgets/constant.dart';

class SellerWithDrawHistory extends StatefulWidget {
  const SellerWithDrawHistory({Key? key}) : super(key: key);

  @override
  State<SellerWithDrawHistory> createState() => _SellerWithDrawHistoryState();
}

class _SellerWithDrawHistoryState extends State<SellerWithDrawHistory> {
  List<Payment> payments = [];

  @override
  void initState() {
    super.initState();

    getHistory();
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
          AppLocalizations.of(context)!.withdrawHistory,
          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
              children: [
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: payments.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 10.0),
                  itemBuilder: (_, i) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(6.0),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context)!.withdrawHis} ${payments[i].status == 'Pending' ? AppLocalizations.of(context)!.intiated : AppLocalizations.of(context)!.completed2}',
                                    style: kTextStyle.copyWith(
                                      color: payments[i].status == 'Pending' ? kNeutralColor : kPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    NumberFormat.simpleCurrency(locale: 'vi-VN').format(payments[i].tranferContent.toInt()),
                                    style: kTextStyle.copyWith(
                                      color: payments[i].status == 'Pending' ? kNeutralColor : kPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                DateFormat('dd-MM-yyyy HH:mm').format(payments[i].transactionId!),
                                style: kTextStyle.copyWith(color: kLightNeutralColor),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getHistory() async {
    try {
      var payments = await PaymentApi().gets(
        0,
        filter: 'signature eq \'${jsonDecode(PrefUtils().getAccount())['Id']}\'',
        orderBy: 'transactionId desc',
      );

      setState(() {
        this.payments.add(payments.value.first);

        for (var i = 1; i < payments.value.length; i++) {
          if (payments.value[i].transactionId != payments.value[i - 1].transactionId) {
            this.payments.add(payments.value[i]);
          }
        }
      });
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get history failed');
    }
  }
}
