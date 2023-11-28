import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:decimal/intl.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../data/apis/requirement_api.dart';
// import '../../widgets/button_global.dart';
import '../../../data/models/requirement.dart';
import '../../widgets/constant.dart';
import '../popup/client_popup.dart';

class JobDetails extends StatefulWidget {
  final Guid requirementId;

  const JobDetails({Key? key, required this.requirementId}) : super(key: key);

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  late Future<Requirement> requirement;

  @override
  void initState() {
    super.initState();

    requirement = getData();
  }

  //__________cancel_order_reason_popup________________________________________________
  void cancelOrderPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const CancelJobPopUp(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: requirement,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: kDarkWhite,
            appBar: AppBar(
              backgroundColor: kDarkWhite,
              elevation: 0,
              iconTheme: const IconThemeData(color: kNeutralColor),
              title: Text(
                'Job Details',
                style: kTextStyle.copyWith(
                    color: kNeutralColor, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                PopupMenuButton(
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      // onTap: (){
                      //   cancelOrderPopUp();
                      // },
                      child: Text(
                        'Cancel',
                        style: kTextStyle.copyWith(color: kNeutralColor),
                      ).onTap(
                        () => cancelOrderPopUp(),
                      ),
                    )
                  ],
                  onSelected: (value) {},
                  child: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: kNeutralColor,
                    ),
                  ),
                ),
              ],
            ),
            // bottomNavigationBar: Container(
            //   decoration: const BoxDecoration(
            //     color: kWhite,
            //   ),
            //   child: ButtonGlobalWithoutIcon(
            //     buttontext: 'Re-Post',
            //     buttonDecoration: kButtonDecoration.copyWith(
            //       color: kPrimaryColor,
            //     ),
            //     onPressed: () {
            //       setState(() {
            //         cancelOrderPopUp();
            //       });
            //     },
            //     buttonTextColor: kWhite,
            //   ),
            // ),
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                        children: [
                          Text(
                            snapshot.data!.title!,
                            style: kTextStyle.copyWith(
                                color: kNeutralColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          ReadMoreText(
                            snapshot.data!.description!,
                            style: kTextStyle.copyWith(color: kSubTitleColor),
                            trimLines: 2,
                            colorClickableText: kPrimaryColor,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: '..Read more',
                            trimExpandedText: ' Read less',
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Category',
                                  style: kTextStyle.copyWith(
                                      color: kSubTitleColor),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ':',
                                      style: kTextStyle.copyWith(
                                          color: kSubTitleColor),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Flexible(
                                      child: Text(
                                        snapshot.data!.category!.name!,
                                        style: kTextStyle.copyWith(
                                            color: kSubTitleColor),
                                        overflow: TextOverflow.ellipsis,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Material',
                                  style: kTextStyle.copyWith(
                                      color: kSubTitleColor),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ':',
                                      style: kTextStyle.copyWith(
                                          color: kSubTitleColor),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Flexible(
                                      child: Text(
                                        snapshot.data!.material!.name!,
                                        style: kTextStyle.copyWith(
                                            color: kSubTitleColor),
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
                                flex: 2,
                                child: Text(
                                  'Surface',
                                  style: kTextStyle.copyWith(
                                      color: kSubTitleColor),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ':',
                                      style: kTextStyle.copyWith(
                                          color: kSubTitleColor),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Flexible(
                                      child: Text(
                                        snapshot.data!.surface!.name!,
                                        style: kTextStyle.copyWith(
                                            color: kSubTitleColor),
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
                                flex: 2,
                                child: Text(
                                  'Budget',
                                  style: kTextStyle.copyWith(
                                      color: kSubTitleColor),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ':',
                                      style: kTextStyle.copyWith(
                                          color: kSubTitleColor),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Flexible(
                                      child: Text(
                                        NumberFormat.decimalPattern('vi_VN')
                                            .format(DecimalIntl(
                                                snapshot.data!.budget!)),
                                        style: kTextStyle.copyWith(
                                            color: kSubTitleColor),
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
                                flex: 2,
                                child: Text(
                                  'Status',
                                  style: kTextStyle.copyWith(
                                      color: kSubTitleColor),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ':',
                                      style: kTextStyle.copyWith(
                                          color: kSubTitleColor),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Flexible(
                                      child: Text(
                                        snapshot.data!.status!,
                                        style: kTextStyle.copyWith(
                                            color: kSubTitleColor),
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
                                flex: 2,
                                child: Text(
                                  'Created Date',
                                  style: kTextStyle.copyWith(
                                      color: kSubTitleColor),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ':',
                                      style: kTextStyle.copyWith(
                                          color: kSubTitleColor),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Flexible(
                                      child: Text(
                                        DateFormat('dd-MM-yyyy').format(
                                            snapshot.data!.createdDate!),
                                        style: kTextStyle.copyWith(
                                            color: kSubTitleColor),
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
                          Text(
                            'Attach file:',
                            style: kTextStyle.copyWith(color: kSubTitleColor),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              const SizedBox(width: 10.0),
                              snapshot.data!.image != null
                                  ? Container(
                                      width: 100,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              snapshot.data!.image!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 100,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: kDarkWhite,
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Icon(
                                        IconlyBold.document,
                                        color: kNeutralColor.withOpacity(0.7),
                                        size: 50,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(
            color: kPrimaryColor,
          ),
        );
      }),
    );
  }

  Future<Requirement> getData() async {
    return RequirementApi().getOne(widget.requirementId.toString(),
        'category,surface,material,createdByNavigation,proposals,sizes,steps');
  }
}
