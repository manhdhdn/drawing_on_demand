import 'package:flutter/material.dart';
import 'package:drawing_on_demand/screen/widgets/button_global.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../app_routes/named_routes.dart';
import '../../../data/apis/account_review_api.dart';
import '../../../data/apis/order_api.dart';
import '../../../data/models/account.dart';
import '../../../data/models/account_review.dart';
import '../../../data/models/order.dart';
import '../../widgets/constant.dart';
import '../../common/popUp/popup_1.dart';
import '../../widgets/responsive.dart';
import 'order_list.dart';

class OrderReview extends StatefulWidget {
  final String? id;

  const OrderReview({Key? key, this.id}) : super(key: key);

  @override
  State<OrderReview> createState() => _OrderReviewState();
}

class _OrderReviewState extends State<OrderReview> {
  final _formKey = GlobalKey<FormState>();

  late Future<Order?> order;

  TextEditingController reviewController = TextEditingController();
  double star = 5;

  Guid? createdBy;
  Guid? accountId;

  void reviewSubmittedPopUp() {
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
              child: const ReviewSubmittedPopUp(),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    order = getData();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: '$dod | Review',
      color: kPrimaryColor,
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          backgroundColor: kDarkWhite,
          elevation: 0,
          iconTheme: const IconThemeData(color: kNeutralColor),
          title: Text(
            'Write a Review',
            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(color: kWhite),
          child: ButtonGlobalWithoutIcon(
              buttontext: 'Publish Review',
              buttonDecoration: kButtonDecoration.copyWith(color: kPrimaryColor, borderRadius: BorderRadius.circular(30.0)),
              onPressed: () {
                onSubmit();
              },
              buttonTextColor: kWhite),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
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
                  Account account = snapshot.data!.orderDetails!.first.artwork!.createdByNavigation!;

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15.0),
                          Text(
                            'Review your experience',
                            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            'How would you rate your overall experience with this artist?',
                            style: kTextStyle.copyWith(color: kSubTitleColor),
                          ),
                          const SizedBox(height: 20.0),
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(account.avatar!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  account.name!,
                                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Select Rating',
                            style: kTextStyle.copyWith(color: kNeutralColor),
                          ),
                          const SizedBox(height: 5.0),
                          RatingBarWidget(
                            itemCount: 5,
                            rating: star,
                            activeColor: ratingBarColor,
                            inActiveColor: kBorderColorTextField,
                            onRatingChanged: (rating) {
                              setState(() {
                                star = rating;
                              });
                            },
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            cursorColor: kNeutralColor,
                            maxLines: 3,
                            decoration: kInputDecoration.copyWith(
                              border: const OutlineInputBorder(),
                              labelText: 'Write a Comment',
                              labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                              hintText: 'Share your experience...',
                              hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                              focusColor: kNeutralColor,
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                            controller: reviewController,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'Please enter your review';
                              }

                              return null;
                            },
                            onChanged: (value) {
                              _formKey.currentState!.validate();
                            },
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
        'orderDetails(expand=artwork(expand=createdByNavigation))',
      )
          .then((order) {
        setState(() {
          createdBy = order.orderedBy;
          accountId = order.orderDetails!.first.artwork!.createdByNavigation!.id;
        });

        return order;
      });
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get order failed');
    }

    return null;
  }

  Future<void> onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      AccountReview accountReview = AccountReview(
        id: Guid.newGuid,
        star: star.toInt(),
        comment: reviewController.text.trim(),
        createdDate: DateTime.now(),
        status: 'Approved',
        createdBy: createdBy,
        accountId: accountId,
      );

      await AccountReviewApi().postOne(accountReview);

      await OrderApi().patchOne(widget.id!, {
        'status': 'Reviewed',
      });

      OrderList.refresh();

      setState(() {
        selectedOrderTab = 'Completed';
      });

      reviewSubmittedPopUp();
    } catch (error) {
      Fluttertoast.showToast(msg: 'Create review failed');
    }
  }
}
