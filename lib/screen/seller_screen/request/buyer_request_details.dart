import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';

import '../../../app_routes/named_routes.dart';
import '../../../data/apis/rank_api.dart';
import '../../../data/apis/requirement_api.dart';
import '../../../data/models/requirement.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';

class BuyerRequestDetails extends StatefulWidget {
  final String? id;

  const BuyerRequestDetails({Key? key, this.id}) : super(key: key);

  @override
  State<BuyerRequestDetails> createState() => _BuyerRequestDetailsState();
}

class _BuyerRequestDetailsState extends State<BuyerRequestDetails> {
  late Future<Requirement?> requirement;

  int maxConnect = 0;

  @override
  void initState() {
    super.initState();

    requirement = getRequirement();
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
          'Detail',
          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(color: kWhite),
        child: ButtonGlobalWithoutIcon(
          buttontext: 'Send Offer',
          buttonDecoration: kButtonDecoration.copyWith(
            color: kPrimaryColor,
          ),
          onPressed: () {
            onOffer();
          },
          buttonTextColor: kWhite,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
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
            future: requirement,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: kWhite,
                          border: Border.all(color: kBorderColorTextField),
                          boxShadow: const [
                            BoxShadow(
                              color: kBorderColorTextField,
                              spreadRadius: 0.2,
                              blurRadius: 4.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                height: 44,
                                width: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(snapshot.data!.createdByNavigation!.avatar ?? defaultImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                snapshot.data!.createdByNavigation!.name!,
                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                DateFormat('dd-MM-yyyy').format(snapshot.data!.createdDate!),
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                              ),
                            ),
                            const Divider(
                              height: 0,
                              thickness: 1.0,
                              color: kBorderColorTextField,
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              snapshot.data!.title!,
                              style: kTextStyle.copyWith(
                                color: kNeutralColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              snapshot.data!.description!,
                              style: kTextStyle.copyWith(color: kSubTitleColor),
                            ),
                            const SizedBox(height: 20.0),
                            RichText(
                              text: TextSpan(
                                text: 'Category: ',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: snapshot.data!.category!.name,
                                    style: kTextStyle.copyWith(color: kNeutralColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                text: 'Material: ',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: snapshot.data!.material!.name,
                                    style: kTextStyle.copyWith(color: kNeutralColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                text: 'Surface: ',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: snapshot.data!.surface!.name,
                                    style: kTextStyle.copyWith(color: kNeutralColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.sizes!.isNotEmpty ? snapshot.data!.sizes!.length : 1,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5.0),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Pieces: ',
                                        style: kTextStyle.copyWith(
                                          color: index == 0 ? kSubTitleColor : kWhite,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: snapshot.data!.pieces.toString(),
                                            style: kTextStyle.copyWith(
                                              color: index == 0 ? kNeutralColor : kWhite,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: snapshot.data!.sizes!.isNotEmpty ? ' (${snapshot.data!.sizes![index].width} cm x ${snapshot.data!.sizes![index].length} cm)' : null,
                                                style: kTextStyle.copyWith(
                                                  color: kNeutralColor,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                text: 'Quantity: ',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: snapshot.data!.quantity.toString(),
                                    style: kTextStyle.copyWith(color: kNeutralColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                text: 'Budget: ',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: NumberFormat.simpleCurrency(
                                      locale: 'vi-VN',
                                    ).format(snapshot.data!.budget),
                                    style: kTextStyle.copyWith(color: kNeutralColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                text: 'Connect require: ',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: calculateConnect(snapshot.data!.budget!),
                                    style: kTextStyle.copyWith(color: kNeutralColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0).visible(snapshot.data!.image != null),
                            Text(
                              'Attach file:',
                              style: kTextStyle.copyWith(
                                color: kSubTitleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ).visible(snapshot.data!.image != null),
                            const SizedBox(height: 8.0).visible(snapshot.data!.image != null),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: context.width() * 0.85,
                                  height: context.width() * 0.85 * 0.7,
                                  child: PhotoView(
                                    backgroundDecoration: BoxDecoration(
                                      color: kDarkWhite,
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    imageProvider: NetworkImage(
                                      snapshot.data!.image ?? defaultImage,
                                    ),
                                  ),
                                ),
                              ],
                            ).visible(snapshot.data!.image != null),
                          ],
                        ),
                      ),
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

  Future<Requirement?> getRequirement() async {
    try {
      await RankApi().gets(0, orderBy: 'connect').then((ranks) {
        maxConnect = ranks.value.last.connect!;
      });

      return RequirementApi().getOne(
        widget.id!,
        'createdByNavigation,category,surface,material,sizes',
      );
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get requirement detail failed');
    }

    return null;
  }

  String calculateConnect(double budget) {
    int connect = budget ~/ 1000000;

    if (connect < 1) {
      connect = 1;
    }

    if (connect > maxConnect) {
      connect = maxConnect;
    }

    return connect.toString();
  }

  void onOffer() {
    context.goNamed(JobOfferRoute.name, pathParameters: {'jobId': widget.id!});
  }
}
