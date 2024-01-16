import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/common/common_features.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../data/apis/art_api.dart';
import '../../../data/apis/order_api.dart';
import '../../../data/apis/step_api.dart';
import '../../../data/models/art.dart';
import '../../../data/models/order.dart';
import '../../../data/models/order_detail.dart';
import '../../../data/models/step.dart' as modal;
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../common/popUp/popup_1.dart';
import '../../widgets/responsive.dart';
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
  String accountId = '';
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: CancelReasonPopUp(id: widget.id, accountId: accountId),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: DeliveryPopUp(id: artworkId),
            );
          },
        );
      },
    );
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
            'Order Details',
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
                      buttontext: 'Review',
                      buttonDecoration: kButtonDecoration.copyWith(color: kPrimaryColor),
                      onPressed: () {
                        onReview();
                      },
                      buttonTextColor: kWhite,
                    ),
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
                                buttontext: 'Cancel Order',
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
                                    ? 'Checkout'
                                    : role == 'Artist' && !isCreatedTimeline
                                        ? 'Create Timeline'
                                        : 'Delivery Work',
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
        body: Container(
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
                                    'Order ID #${widget.id!.split('-').first.toUpperCase()}',
                                    style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  SlideCountdownSeparated(
                                    duration: Duration(
                                        milliseconds: status == 'Pending'
                                            ? snapshot.data!.orderDate!
                                                    .add(const Duration(
                                                      days: 2,
                                                    ))
                                                    .millisecondsSinceEpoch -
                                                DateTime.now()
                                                    .add(const Duration(
                                                      hours: 7,
                                                    ))
                                                    .millisecondsSinceEpoch
                                            : 0),
                                    separatorType: SeparatorType.symbol,
                                    separatorStyle: kTextStyle.copyWith(color: Colors.transparent),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(3.0),
                                    ),
                                  )
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
                                      'Title',
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
                                      'Description',
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
                                            trimCollapsedText: '..read more',
                                            trimExpandedText: ' read less',
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
                                      'Order type',
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
                                      'Deposited',
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
                                      'Completed',
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
                                      'Status',
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
                                            status == 'Deposited' ? 'Active' : status,
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
                                    'Order Summary',
                                    style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Subtotal',
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
                                          'Shipping fee',
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
                                                    : 'Not yet calculated',
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
                                          'Discount',
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
                                          'Deposited',
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
                                          'Total',
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
                                'Order Details',
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
                                                            'Artist',
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
                                                                          child: Text(
                                                                            orderDetails[j + getCartIndex(i, packList)].artwork!.title!,
                                                                            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 5.0),
                                                                        Flexible(
                                                                            flex: 1,
                                                                            child: Text(
                                                                              'Unit price: ${NumberFormat.simpleCurrency(locale: 'vi_VN').format(snapshot.data!.orderDetails![j + getCartIndex(i, packList)].price)}',
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
                                                                                snapshot.data!.orderType == 'Artwork' ? 'Quantity: ${snapshot.data!.orderDetails![j + getCartIndex(i, packList)].quantity}' : 'Price: ',
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
                                    'Timeline',
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
                                                        'Complete step',
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
                                                        'Edit step',
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
                                                  'Start date: ${DateFormat('dd-MM-yyyy').format((steps[index].startDate!))}',
                                                  style: kTextStyle.copyWith(color: kNeutralColor),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Text(
                                                  'Estimated date: ${DateFormat('dd-MM-yyyy').format((steps[index].estimatedEndDate!))}',
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
                                                                maxHeight: 80,
                                                                maxWidth: 80,
                                                                minHeight: 80,
                                                                minWidth: 80,
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
    );
  }

  Future<Order?> getData() async {
    try {
      return OrderApi()
          .getOne(
        widget.id!,
        'orderDetails(expand=artwork(expand=arts,sizes,createdByNavigation,proposal(expand=requirement(expand=steps)))),discount,orderedByNavigation',
      )
          .then((order) {
        setState(() {
          status = order.status!;
          accountId = role == 'Customer' ? order.orderDetails!.first.artwork!.createdByNavigation!.id.toString() : order.orderedByNavigation!.id.toString();

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
      Fluttertoast.showToast(msg: 'Get order failed');
    }

    return null;
  }

  void onReview() {
    context.goNamed(ReviewRoute.name, pathParameters: {'id': widget.id!});
  }

  Future<void> onCancelOrder() async {
    await cancelOrderPopUp();

    OrderList.refresh();
  }

  void onCheckout() {
    // orderCompletePopUp();
    context.goNamed('${CheckoutRoute.name} order', pathParameters: {'id': widget.id!});
  }

  void onChat() {
    context.goNamed(ChatRoute.name, pathParameters: {'id': accountId});
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

  Future<void> onEditStep(DateTime completedDate, List<Art> arts, Guid artworkId) async {
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

  void onCompleteArtwork() {
    deliveryPopUp();
  }

  void refresh() {
    setState(() {
      order = getData();
    });
  }
}
