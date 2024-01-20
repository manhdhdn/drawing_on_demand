import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:order_tracker_zen/order_tracker_zen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/common/common_features.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../data/apis/api_config.dart';
import '../../../data/apis/art_api.dart';
import '../../../data/apis/ghn_api.dart';
import '../../../data/apis/order_api.dart';
import '../../../data/apis/step_api.dart';
import '../../../data/models/art.dart';
import '../../../data/models/ghn_request.dart';
import '../../../data/models/order.dart';
import '../../../data/models/order_detail.dart';
import '../../../data/models/step.dart' as modal;
import '../../../data/notifications/firebase_api.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../common/popUp/popup_1.dart';
import '../../widgets/responsive.dart';
import '../message/function/chat_function.dart';
import '../popUp/popup_2.dart';
import 'order_list.dart';

class OrderDetailScreen extends StatefulWidget {
  static dynamic state;
  final String? id;

  const OrderDetailScreen({Key? key, this.id}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();

  static void refresh() {
    state.refresh();
  }
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Future<Order?> order;

  String role = PrefUtils().getRole();

  String status = 'Cancelled';
  List<String> accountIds = [];
  String artworkId = '';

  String requirementId = '';
  bool isCreatedTimeline = true;
  bool isCompletedTimeline = false;
  bool isUpdatePackage = false;

  List<modal.Step> steps = [
    modal.Step(
      id: Guid.newGuid,
      number: 0,
      detail: '',
      startDate: DateTime.now(),
      estimatedEndDate: DateTime.now(),
    )
  ];
  List<List<Art>> arts = [[]];

  int stepIndex = 0;
  int nextStep = 0;

  @override
  void initState() {
    super.initState();

    OrderDetailScreen.state = this;
    order = getData();

    images.clear();
  }

  Future<void> cancelOrderPopUp() async {
    await showDialog(
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
              child: CancelReasonPopUp(id: widget.id),
            );
          },
        );
      },
    );
  }

  void orderCompletePopUp() {
    showDialog(
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
              child: const OrderCompletePopUp(),
            );
          },
        );
      },
    );
  }

  void deliveryPopUp() {
    showDialog(
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
              child: DeliveryPopUp(
                id: artworkId,
                order: order,
              ),
            );
          },
        );
      },
    );
  }

  Future<List<TrackerData>> getTrackers(String handOverId) async {
    List<TrackerData> element = [];

    try {
      var request = GHNRequest(
        endpoint: ApiConfig.GHNPaths['detail'],
        postJsonString: jsonEncode({
          'order_code': handOverId,
        }),
      );

      var response = await GHNApi().postOne(request);
      var decodedResponse = jsonDecode(response.postJsonString!);
      var data = decodedResponse['data'];

      element.addAll(
        [
          TrackerData(
            // ignore: use_build_context_synchronously
            title: AppLocalizations.of(context)!.orderSuccess,
            date: '',
            tracker_details: [
              TrackerDetails(
                // ignore: use_build_context_synchronously
                title: AppLocalizations.of(context)!.orderHasPlaced,
                datetime: DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(data['order_date']).add(const Duration(hours: 7))),
              ),
              TrackerDetails(
                // ignore: use_build_context_synchronously
                title: AppLocalizations.of(context)!.estimatedDelivery,
                datetime: DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(data['leadtime']).add(const Duration(hours: 7))),
              ),
              TrackerDetails(
                // ignore: use_build_context_synchronously
                title: AppLocalizations.of(context)!.receiver,
                // ignore: use_build_context_synchronously
                datetime: '${AppLocalizations.of(context)!.name}: ${data['to_name']}\n${AppLocalizations.of(context)!.phone}: ${data['to_phone']}\n${AppLocalizations.of(context)!.address}: ${data['to_address']}',
              ),
            ],
          ),
          TrackerData(
            // ignore: use_build_context_synchronously
            title: AppLocalizations.of(context)!.beingPrepared,
            date: '',
            tracker_details: [
              TrackerDetails(
                // ignore: use_build_context_synchronously
                title: AppLocalizations.of(context)!.artistPrepared,
                datetime: DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(data['pickup_time']).add(const Duration(hours: 7))),
              ),
            ],
          ),
        ],
      );

      if (data['log'] == null) {}
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get Trackers Failed');
    }

    return element;
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: '$dod | Order details',
      color: kPrimaryColor,
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          backgroundColor: kDarkWhite,
          elevation: 0,
          iconTheme: const IconThemeData(color: kNeutralColor),
          title: Text(
            AppLocalizations.of(context)!.orderDetails,
            style: kTextStyle.copyWith(
              color: kNeutralColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                onPressed: () {
                  onChat();
                },
                icon: const Icon(
                  IconlyBold.chat,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: kWhite,
          child: Padding(
            padding: EdgeInsets.only(
              left: DodResponsive.isDesktop(context) ? 150.0 : 0.0,
              right: DodResponsive.isDesktop(context) ? 150.0 : 0.0,
            ),
            child: status == 'Completed'
                ? Container(
                    decoration: const BoxDecoration(
                      color: kWhite,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: ButtonGlobalWithoutIcon(
                      buttontext: AppLocalizations.of(context)!.review,
                      buttonDecoration: kButtonDecoration.copyWith(color: kPrimaryColor),
                      onPressed: () {
                        onReview();
                      },
                      buttonTextColor: kWhite,
                    ).visible(PrefUtils().getRole() == 'Customer'),
                  )
                : status == 'Pending' || status == 'Deposited'
                    ? Container(
                        decoration: const BoxDecoration(
                          color: kWhite,
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: ButtonGlobalWithoutIcon(
                                buttontext: AppLocalizations.of(context)!.cancelOrder,
                                buttonDecoration: kButtonDecoration.copyWith(
                                  color: kWhite,
                                  border: Border.all(color: Colors.red),
                                ),
                                onPressed: () {
                                  onCancelOrder();
                                },
                                buttonTextColor: Colors.red,
                              ),
                            ),
                            Expanded(
                              child: ButtonGlobalWithoutIcon(
                                buttontext: role == 'Customer'
                                    ? AppLocalizations.of(context)!.checkOut
                                    : role == 'Artist' && !isCreatedTimeline
                                        ? AppLocalizations.of(context)!.createTimeline
                                        : AppLocalizations.of(context)!.deliveryWork,
                                buttonDecoration: kButtonDecoration.copyWith(
                                  color: (role == 'Customer' && status == 'Pending') || (role == 'Customer' && status == 'Deposited' && isUpdatePackage)
                                      ? kPrimaryColor
                                      : role == 'Artist' && !isCreatedTimeline
                                          ? kPrimaryColor
                                          : role == 'Artist' && isCompletedTimeline
                                              ? kPrimaryColor
                                              : kLightNeutralColor,
                                ),
                                onPressed: () {
                                  (role == 'Customer' && status == 'Pending') || (role == 'Customer' && status == 'Deposited' && isUpdatePackage)
                                      ? onCheckout()
                                      : role == 'Artist' && !isCreatedTimeline
                                          ? onCreateTimeline()
                                          : role == 'Artist' && isCompletedTimeline
                                              ? onCompleteArtwork()
                                              : null;
                                },
                                buttonTextColor: kWhite,
                              ),
                            ),
                          ],
                        ),
                      ).visible((role == 'Artist' && !isUpdatePackage) || role == 'Customer')
                    : null,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            width: context.width(),
            height: context.height(),
            decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: FutureBuilder(
              future: order,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: DodResponsive.isDesktop(context) ? 150.0 : 0.0,
                        right: DodResponsive.isDesktop(context) ? 150.0 : 0.0,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 15.0),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            width: context.width(),
                            decoration: BoxDecoration(
                              color: kWhite,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: kBorderColorTextField),
                              boxShadow: const [
                                BoxShadow(
                                  color: kDarkWhite,
                                  spreadRadius: 4.0,
                                  blurRadius: 4.0,
                                  offset: Offset(0, 2),
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
                                      '${AppLocalizations.of(context)!.orderId} #${widget.id!.split('-').first.toUpperCase()}',
                                      style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    SlideCountdownSeparated(
                                      duration: Duration(
                                          milliseconds: status == 'Pending'
                                              ? snapshot.data!.orderDate!
                                                      .add(
                                                        const Duration(days: 2),
                                                      )
                                                      .millisecondsSinceEpoch -
                                                  DateTime.now()
                                                      .add(
                                                        const Duration(hours: 7),
                                                      )
                                                      .millisecondsSinceEpoch
                                              : 0),
                                      separatorType: SeparatorType.symbol,
                                      separatorStyle: kTextStyle.copyWith(color: Colors.transparent),
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(3.0),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        onCompleteOrder();
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)!.received,
                                            style: kTextStyle.copyWith(
                                              color: kNeutralColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ).visible(PrefUtils().getRole() == 'Customer' && status == 'Paid'),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                const Divider(
                                  thickness: 1.0,
                                  color: kBorderColorTextField,
                                  height: 1.0,
                                ),
                                const SizedBox(height: 8.0).visible(snapshot.data!.orderType == 'Requirement'),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLocalizations.of(context)!.title,
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ':',
                                            style: kTextStyle.copyWith(color: kSubTitleColor),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Flexible(
                                            child: Text(
                                              snapshot.data!.orderDetails!.first.artwork!.title!,
                                              style: kTextStyle.copyWith(color: kSubTitleColor),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ).visible(snapshot.data!.orderType == 'Requirement'),
                                const SizedBox(height: 8.0).visible(snapshot.data!.orderType == 'Requirement'),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLocalizations.of(context)!.description,
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ':',
                                            style: kTextStyle.copyWith(color: kSubTitleColor),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Flexible(
                                            child: ReadMoreText(
                                              snapshot.data!.orderDetails!.first.artwork!.description!,
                                              style: kTextStyle.copyWith(color: kLightNeutralColor),
                                              trimLines: 3,
                                              colorClickableText: kPrimaryColor,
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText: AppLocalizations.of(context)!.readMore,
                                              trimExpandedText: AppLocalizations.of(context)!.readLess,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ).visible(snapshot.data!.orderType == 'Requirement'),
                                const SizedBox(height: 8.0),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLocalizations.of(context)!.orderType,
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ':',
                                            style: kTextStyle.copyWith(color: kSubTitleColor),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Flexible(
                                            child: Text(
                                              snapshot.data!.orderType!,
                                              style: kTextStyle.copyWith(
                                                color: kSubTitleColor,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0).visible(snapshot.data!.depositDate != null),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLocalizations.of(context)!.deposited,
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ':',
                                            style: kTextStyle.copyWith(color: kSubTitleColor),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Flexible(
                                            child: Text(
                                              DateFormat('dd-MM-yyyy HH:mm').format(snapshot.data!.depositDate != null ? snapshot.data!.depositDate! : DateTime.now()),
                                              style: kTextStyle.copyWith(color: kNeutralColor),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ).visible(snapshot.data!.depositDate != null),
                                const SizedBox(height: 8.0).visible(snapshot.data!.completedDate != null),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLocalizations.of(context)!.checkOut,
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ':',
                                            style: kTextStyle.copyWith(color: kSubTitleColor),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Flexible(
                                            child: Text(
                                              DateFormat('dd-MM-yyyy HH:mm').format(snapshot.data!.completedDate != null ? snapshot.data!.completedDate! : DateTime.now()),
                                              style: kTextStyle.copyWith(color: kNeutralColor),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ).visible(snapshot.data!.completedDate != null),
                                const SizedBox(height: 8.0),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLocalizations.of(context)!.status,
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ':',
                                            style: kTextStyle.copyWith(color: kSubTitleColor),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Flexible(
                                            child: Text(
                                              status == 'Deposited'
                                                  ? AppLocalizations.of(context)!.active
                                                  : status == 'Pending'
                                                      ? AppLocalizations.of(context)!.pending
                                                      : status == 'Paid'
                                                          ? AppLocalizations.of(context)!.paid
                                                          : status == 'Completed'
                                                              ? AppLocalizations.of(context)!.completed
                                                              : status == 'Reviewed'
                                                                  ? AppLocalizations.of(context)!.reviewed
                                                                  : AppLocalizations.of(context)!.cancelled,
                                              style: kTextStyle.copyWith(color: kNeutralColor),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 15.0),
                                    Text(
                                      AppLocalizations.of(context)!.orderSummary,
                                      style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            AppLocalizations.of(context)!.subtotal,
                                            style: kTextStyle.copyWith(color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  NumberFormat.simpleCurrency(
                                                    locale: 'vi_VN',
                                                  ).format(
                                                    getSubtotal(
                                                      snapshot.data!.orderDetails!,
                                                    ),
                                                  ),
                                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                                  overflow: TextOverflow.ellipsis,
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            AppLocalizations.of(context)!.shippingFee,
                                            style: kTextStyle.copyWith(color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  status == 'Paid' || status == 'Completed'
                                                      ? NumberFormat.simpleCurrency(
                                                          locale: 'vi_VN',
                                                        ).format(snapshot.data!.discountId != null ? snapshot.data!.total! / (1 - snapshot.data!.discount!.discountPercent!) - getSubtotal(snapshot.data!.orderDetails!) : snapshot.data!.total! - getSubtotal(snapshot.data!.orderDetails!))
                                                      : AppLocalizations.of(context)!.notYetCalculated,
                                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0).visible(snapshot.data!.discount != null && status != 'Deposited'),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            AppLocalizations.of(context)!.discount,
                                            style: kTextStyle.copyWith(color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  NumberFormat.simpleCurrency(
                                                    locale: 'vi_VN',
                                                  ).format(snapshot.data!.discount != null ? -(snapshot.data!.total! / (1 - snapshot.data!.discount!.discountPercent!) - snapshot.data!.total!) : -0),
                                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ).visible(snapshot.data!.discount != null && status != 'Deposited'),
                                    const SizedBox(height: 8.0).visible(status == 'Deposited'),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            AppLocalizations.of(context)!.deposited,
                                            style: kTextStyle.copyWith(color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  NumberFormat.simpleCurrency(
                                                    locale: 'vi_VN',
                                                  ).format(snapshot.data!.total),
                                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ).visible(status == 'Deposited'),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            AppLocalizations.of(context)!.total,
                                            style: kTextStyle.copyWith(color: kSubTitleColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(color: kSubTitleColor),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  status == 'Paid' || status == 'Completed'
                                                      ? NumberFormat.simpleCurrency(
                                                          locale: 'vi_VN',
                                                        ).format(snapshot.data!.total)
                                                      : NumberFormat.simpleCurrency(
                                                          locale: 'vi_VN',
                                                        ).format(getSubtotal(snapshot.data!.orderDetails!)),
                                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ).visible(role == 'Customer'),
                                const SizedBox(height: 15.0),
                                Text(
                                  AppLocalizations.of(context)!.orderDetails,
                                  style: kTextStyle.copyWith(
                                    color: kNeutralColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
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
                                          Padding(
                                            padding: EdgeInsets.zero,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: packList[0] != 0 ? packList.length : 0,
                                              physics: const NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (_, i) {
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
                                                              image: NetworkImage(
                                                                orderDetails[getCartIndex(i, packList)].artwork!.createdByNavigation!.avatar!,
                                                              ),
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
                                                              onTap: () {
                                                                onArtworkDetail(orderDetails[j + getCartIndex(i, packList)].artwork!.id.toString());
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
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      height: context.height() * 0.135,
                                                                      width: context.height() * 0.135,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: const BorderRadius.only(
                                                                          bottomLeft: Radius.circular(8.0),
                                                                          topLeft: Radius.circular(8.0),
                                                                        ),
                                                                        image: DecorationImage(
                                                                          image: NetworkImage(orderDetails[j + getCartIndex(i, packList)].artwork!.arts!.first.image!),
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(5.0),
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Flexible(
                                                                            flex: 1,
                                                                            child: SizedBox(
                                                                              width: DodResponsive.isDesktop(context) ? context.width() * 0.3 : context.width() * 0.5,
                                                                              // width: double.minPositive,
                                                                              child: Text(
                                                                                orderDetails[j + getCartIndex(i, packList)].artwork!.title!,
                                                                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 5.0),
                                                                          Flexible(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                '${AppLocalizations.of(context)!.unitPrice}: ${NumberFormat.simpleCurrency(locale: 'vi_VN').format(snapshot.data!.orderDetails![j + getCartIndex(i, packList)].price)}',
                                                                                style: kTextStyle.copyWith(
                                                                                  color: kSubTitleColor,
                                                                                ),
                                                                              )).visible(snapshot.data!.orderType == 'Artwork'),
                                                                          const SizedBox(height: 5.0),
                                                                          SizedBox(
                                                                            width: DodResponsive.isDesktop(context) ? context.width() * 0.3 : context.width() * 0.5,
                                                                            // width: double.minPositive,
                                                                            child: Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Text(
                                                                                  snapshot.data!.orderType == 'Artwork' ? '${AppLocalizations.of(context)!.quantity}: ${snapshot.data!.orderDetails![j + getCartIndex(i, packList)].quantity}' : AppLocalizations.of(context)!.price,
                                                                                  style: kTextStyle.copyWith(
                                                                                    color: kSubTitleColor,
                                                                                  ),
                                                                                ),
                                                                                const Spacer().visible(snapshot.data!.orderType == 'Artwork'),
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
                                                      if (orderDetails[getCartIndex(i, packList)].handOverItem != null)
                                                        FutureBuilder(
                                                          future: getTrackers(orderDetails[getCartIndex(i, packList)].handOverItem!.handOverId!),
                                                          builder: (context, snapshot) {
                                                            if (snapshot.hasData) {
                                                              return OrderTrackerZen(
                                                                tracker_data: snapshot.data!,
                                                              );
                                                            }

                                                            return const Center(
                                                              child: CircularProgressIndicator(
                                                                color: kPrimaryColor,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      const SizedBox(height: 10.0),
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.timeline,
                                      style: kTextStyle.copyWith(
                                        color: kNeutralColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: kPrimaryColor,
                                        ),
                                      ),
                                      child: Stepper(
                                        physics: const NeverScrollableScrollPhysics(),
                                        currentStep: stepIndex,
                                        controlsBuilder: (context, details) {
                                          return const SizedBox.shrink();
                                        },
                                        onStepTapped: (index) {
                                          setState(() {
                                            stepIndex = index;
                                          });
                                        },
                                        steps: List.generate(
                                          steps.length,
                                          (index) {
                                            return Step(
                                              state: nextStep > index ? StepState.complete : StepState.editing,
                                              isActive: nextStep > index,
                                              title: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      onDeliverStep(steps[index].id!, snapshot.data!.orderDetails!.first.artwork!.id!);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.update,
                                                          color: kPrimaryColor,
                                                        ),
                                                        Text(
                                                          AppLocalizations.of(context)!.completeStep,
                                                          style: kTextStyle.copyWith(color: kPrimaryColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ).visible(nextStep == index && status == 'Deposited' && role == 'Artist'),
                                                  GestureDetector(
                                                    onTap: () {
                                                      onEditStep(steps[index].completedDate!, arts[index], snapshot.data!.orderDetails!.first.artwork!.id!);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.mode_edit_outlined,
                                                          color: kPrimaryColor,
                                                          size: 18,
                                                        ),
                                                        Text(
                                                          AppLocalizations.of(context)!.editStep,
                                                          style: kTextStyle.copyWith(color: kPrimaryColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ).visible(nextStep > index && status == 'Deposited' && role == 'Artist'),
                                                ],
                                              ),
                                              content: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${AppLocalizations.of(context)!.startDate} ${DateFormat('dd-MM-yyyy').format((steps[index].startDate!))}',
                                                    style: kTextStyle.copyWith(color: kNeutralColor),
                                                  ),
                                                  const SizedBox(height: 8.0),
                                                  Text(
                                                    '${AppLocalizations.of(context)!.estimatedDate} ${DateFormat('dd-MM-yyyy').format((steps[index].estimatedEndDate!))}',
                                                    style: kTextStyle.copyWith(color: kNeutralColor),
                                                  ),
                                                  const SizedBox(height: 8.0),
                                                  Text(
                                                    steps[index].detail!,
                                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                                  ),
                                                  const SizedBox(height: 10.0),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: List.generate(
                                                      arts[index].length,
                                                      (outdex) {
                                                        return Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(10.0),
                                                              child: ConstrainedBox(
                                                                constraints: const BoxConstraints(
                                                                  maxHeight: 86,
                                                                  maxWidth: 86,
                                                                  minHeight: 86,
                                                                  minWidth: 86,
                                                                ),
                                                                child: PhotoView(
                                                                  backgroundDecoration: const BoxDecoration(color: kDarkWhite),
                                                                  imageProvider: NetworkImage(
                                                                    arts[index][outdex].image!,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 5.0),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ).visible(steps.first.number != 0 && (status == 'Pending' || status == 'Deposited')),
                              ],
                            ),
                          ),
                        ],
                      ),
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
      ),
    );
  }

  Future<Order?> getData() async {
    try {
      return OrderApi()
          .getOne(
        widget.id!,
        'orderDetails(expand=artwork(expand=arts,sizes,createdByNavigation,proposal(expand=requirement(expand=steps))),handOverItem),discount,orderedByNavigation',
      )
          .then((order) {
        setState(() {
          status = order.status!;
          if (role == 'Customer') {
            for (var orderDetail in order.orderDetails!) {
              if (!accountIds.contains(orderDetail.artwork!.createdByNavigation!.id.toString())) {
                accountIds.add(orderDetail.artwork!.createdByNavigation!.id.toString());
              }
            }
          } else {
            accountIds.add(order.orderedByNavigation!.id.toString());
          }

          if (order.orderType == 'Requirement') {
            requirementId = order.orderDetails!.first.artwork!.proposal!.requirement!.id.toString();
            isCreatedTimeline = order.orderDetails!.first.artwork!.proposal!.requirement!.steps!.isNotEmpty;

            var stepsData = order.orderDetails!.first.artwork!.proposal!.requirement!.steps!.toList();

            if (stepsData.isNotEmpty) {
              steps.clear();
              arts.clear();
              steps.addAll(stepsData);
              steps.sort(((a, b) => a.number!.compareTo(b.number!)));
              stepIndex = steps.lastIndexWhere((step) => step.status == 'Completed');

              if (stepIndex != -1) {
                nextStep = stepIndex + 1;
              } else {
                stepIndex = 0;
              }

              for (var step in steps) {
                arts.add(order.orderDetails!.first.artwork!.arts!.where((art) => art.createdDate == step.completedDate).toList());
              }
            }

            isCompletedTimeline = !steps.any((step) => step.status == 'Pending');
            artworkId = order.orderDetails!.first.artwork!.id.toString();
            isUpdatePackage = !order.orderDetails!.first.artwork!.sizes!.any((size) => size.height == 1 && size.weight == 1000);
          }
        });

        return order;
      });
    } catch (error) {
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.getOrderFailed);
    }

    return null;
  }

  void onReview() {
    context.goNamed(ReviewRoute.name, pathParameters: {'id': widget.id!});
  }

  void onCancelOrder() async {
    await cancelOrderPopUp();

    OrderList.refresh();
  }

  void onCheckout() {
    // orderCompletePopUp();
    context.goNamed('${CheckoutRoute.name} order', pathParameters: {'id': widget.id!});
  }

  void onChat() {
    for (var accountId in accountIds) {
      ChatFunction.createChat(
        senderId: jsonDecode(PrefUtils().getAccount())['Id'],
        receiverId: accountId,
        orderId: widget.id!.split('-').first.toUpperCase(),
      );
    }

    context.goNamed(MessageRoute.name);
  }

  void onCreateTimeline() {
    context.goNamed(
      CreateTimelineRoute.name,
      pathParameters: {
        'orderId': widget.id!,
        'requirementId': requirementId,
      },
    );
  }

  void onArtworkDetail(String id) {
    context.goNamed('${ArtworkDetailRoute.name} order', pathParameters: {'orderId': widget.id!, 'artworkId': id});
  }

  void onDeliverStep(Guid stepId, Guid artworkId) async {
    await pickMultipleImages();

    if (images.isNotEmpty) {
      try {
        // ignore: use_build_context_synchronously
        ProgressDialogUtils.showProgress(context);

        var completedDate = DateTime.now();

        for (var image in images) {
          var imageUrl = await uploadImage(image);

          var art = Art(
            id: Guid.newGuid,
            image: imageUrl,
            createdDate: completedDate,
            artworkId: artworkId,
          );

          await ArtApi().postOne(art);
        }

        images.clear();

        await StepApi().patchOne(stepId.toString(), {
          'CompletedDate': DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(completedDate),
          'Status': 'Completed',
        });

        refresh();

        // ignore: use_build_context_synchronously
        ProgressDialogUtils.hideProgress(context);
      } catch (error) {
        // ignore: use_build_context_synchronously
        ProgressDialogUtils.hideProgress(context);
        Fluttertoast.showToast(msg: 'Deliver step failed');
      }
    }
  }

  void onEditStep(DateTime completedDate, List<Art> arts, Guid artworkId) async {
    await pickMultipleImages();

    if (images.isNotEmpty) {
      try {
        // ignore: use_build_context_synchronously
        ProgressDialogUtils.showProgress(context);

        for (var art in arts) {
          await ArtApi().deleteOne(art.id.toString());
        }

        for (var image in images) {
          var imageUrl = await uploadImage(image);

          var art = Art(
            id: Guid.newGuid,
            image: imageUrl,
            createdDate: completedDate,
            artworkId: artworkId,
          );

          await ArtApi().postOne(art);
        }

        images.clear();

        refresh();

        // ignore: use_build_context_synchronously
        ProgressDialogUtils.hideProgress(context);
      } catch (error) {
        Fluttertoast.showToast(msg: 'Edit step failed');
      }
    }
  }

  void onCompleteArtwork() {
    deliveryPopUp();
  }

  void onCompleteOrder() async {
    try {
      await OrderApi().patchOne(widget.id!, {
        'Status': 'Completed',
      });

      refresh();

      OrderList.refresh();

      var order = await this.order;

      for (var accountId in accountIds) {
        var user = await ChatFunction.getUserData(accountId);

        FirebaseApi().sendNotification(
          // ignore: use_build_context_synchronously
          title: '${AppLocalizations.of(context)!.order} ${order!.id.toString().split('-').first.toUpperCase()} ${AppLocalizations.of(context)!.orderCompletions}',
          // ignore: use_build_context_synchronously
          body: '${AppLocalizations.of(context)!.orderCompletedNot} ${getBalacnceArtist([order], accountId)}',
          receiverDeviceId: user.deviceId!,
          pageName: OrderDetailRoute.name,
          pathName: 'orderId',
          referenceId: widget.id!,
        );
      }
    } catch (error) {
      //
    }
  }

  void refresh() {
    setState(() {
      order = getData();
    });
  }
}
