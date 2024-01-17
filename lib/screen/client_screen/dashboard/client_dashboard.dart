import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/order_api.dart';
import '../../widgets/constant.dart';
import '../../widgets/data.dart';
import '../../widgets/responsive.dart';
import '../home/client_home.dart';
import '../profile/client_profile.dart';

class ClientDashBoard extends StatefulWidget {
  const ClientDashBoard({Key? key}) : super(key: key);

  @override
  State<ClientDashBoard> createState() => _ClientDashBoardState();
}

class _ClientDashBoardState extends State<ClientDashBoard> {
  double totalTransactions = 0;
  double totalDeposited = 0;
  int totalOrders = 0;
  int completedOrders = 0;
  int totalRequirements = 0;
  int completedRequirements = 0;

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      appBar: AppBar(
        backgroundColor: kDarkWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: kNeutralColor),
        leading: IconButton(
          onPressed: () {
            DodResponsive.isDesktop(context) ? ClientHome.changeProfile(const ClientProfile()) : GoRouter.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          AppLocalizations.of(context)!.dashboard,
          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          width: context.width(),
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15.0),
              Row(
                children: [
                  Expanded(
                    child: DashBoardInfo(
                      count: NumberFormat.simpleCurrency(locale: 'vi_VN').format(totalTransactions),
                      title: AppLocalizations.of(context)!.transaction,
                      image: 'images/tt.png',
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: DashBoardInfo(
                      count: NumberFormat.simpleCurrency(locale: 'vi_VN').format(totalDeposited),
                      title: AppLocalizations.of(context)!.deposited,
                      image: 'images/td.png',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: DashBoardInfo(
                      count: totalOrders.toString(),
                      title: AppLocalizations.of(context)!.orders,
                      image: 'images/to.png',
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: DashBoardInfo(
                      count: completedOrders.toString(),
                      title: AppLocalizations.of(context)!.completed,
                      image: 'images/co.png',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void getData() async {
    try {
      await OrderApi()
          .gets(
        0,
        filter: 'orderedBy eq ${jsonDecode(PrefUtils().getAccount())['Id']}',
      )
          .then(
        (orders) {
          for (var order in orders.value) {
            switch (order.status) {
              case 'Deposited':
                totalDeposited += order.total!;
                break;
              case 'Paid':
                totalTransactions += order.total!;
                break;
              case 'Completed':
                totalTransactions += order.total!;
                completedOrders++;
                break;
              case 'Reviewed':
                totalTransactions += order.total!;
                completedOrders++;
                break;
              case 'Cancelled':
                totalTransactions += order.total!;
                break;
              default:
            }

            if (order.status != 'Cart') {
              totalOrders++;
            }
          }

          setState(() {});

          return orders;
        },
      );
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get data failed');
    }
  }
}
