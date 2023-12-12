import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';

import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/requirement_api.dart';
// import '../../widgets/button_global.dart';
import '../../../data/models/requirement.dart';
import '../../widgets/constant.dart';
import '../../common/popUp/popup_2.dart';
import 'job_post.dart';

class JobDetails extends StatefulWidget {
  static const String tag = '${JobPost.tag}/detail';

  const JobDetails({Key? key}) : super(key: key);

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  late Future<Requirement?> requirement;

  @override
  void initState() {
    super.initState();

    requirement = getData();
  }

  @override
  void dispose() {
    if (mounted) {
      PrefUtils().clearTermId();
    }

    super.dispose();
  }

  //__________cancel_order_reason_popup________________________________________________
  void cancelJobPopUp(String id) async {
    await showDialog(
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
              child: CancelJobPopUp(
                id: id,
              ),
            );
          },
        );
      },
    );
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
                value: 'edit',
                child: Text(
                  'Edit',
                  style: kTextStyle.copyWith(color: kNeutralColor),
                ),
              ),
              PopupMenuItem(
                value: 'cancel',
                child: Text(
                  'Cancel',
                  style: kTextStyle.copyWith(color: kNeutralColor),
                ),
              ),
            ],
            onSelected: (value) {
              value == 'edit' ? null : cancelJobPopUp(PrefUtils().getTermId());
            },
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
                child: FutureBuilder(
                  future: requirement,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
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
                            trimCollapsedText: '..read more',
                            trimExpandedText: ' read less',
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
                                  'Pieces',
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
                                        snapshot.data!.pieces!.toString(),
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
                                            .format(snapshot.data!.budget),
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              snapshot.data!.image != null
                                  ? SizedBox(
                                      width: context.width() * 0.85,
                                      height: context.width() * 0.85 * 0.7,
                                      child: PhotoView(
                                        backgroundDecoration: BoxDecoration(
                                          color: kDarkWhite,
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        imageProvider: NetworkImage(
                                          snapshot.data!.image!,
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
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Requirement?> getData() async {
    try {
      return RequirementApi().getOne(
        PrefUtils().getTermId(),
        'category,surface,material,createdByNavigation,proposals,sizes,steps',
      );
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get requirement failed');
    }

    return null;
  }
}
