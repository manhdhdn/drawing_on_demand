import 'dart:convert';

import 'package:drawing_on_demand/data/apis/size_api.dart';
import 'package:drawing_on_demand/data/models/proposal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../data/apis/order_api.dart';
import '../../../data/apis/order_detail_api.dart';
import '../../../data/apis/proposal_api.dart';
import '../../../data/apis/requirement_api.dart';
import '../../../data/models/order.dart';
import '../../../data/models/order_detail.dart';
import '../../../data/models/requirement.dart';
import '../../../data/models/size.dart';
import '../../common/message/function/chat_function.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../common/popUp/popup_2.dart';
import '../../widgets/responsive.dart';
import 'job_post.dart';

class JobDetails extends StatefulWidget {
  final String? id;

  const JobDetails({Key? key, this.id}) : super(key: key);

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  late Future<Requirement?> requirement;

  String status = 'Cancelled';

  @override
  void initState() {
    super.initState();

    requirement = getData();
  }

  void cancelJobPopUp() async {
    var result = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: CancelJobPopUp(
                id: widget.id!,
                status: status,
              ),
            );
          },
        );
      },
    );

    // ignore: use_build_context_synchronously
    result! ? {GoRouter.of(context).pop(), JobPost.refresh()} : null;
  }

  Future<bool> acceptProposalPopUp() async {
    var result = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const AcceptProposalPopUp(),
            );
          },
        );
      },
    );

    return result!;
  }

  Future<bool> rejectProposalPopUp() async {
    var result = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const RejectProposalPopUp(),
            );
          },
        );
      },
    );

    return result!;
  }

  void acceptProposalSuccessPopUp() {
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
              child: const AcceptProposalSuccessPopUp(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: '$dod | Requirement detail',
      color: kPrimaryColor,
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          backgroundColor: kDarkWhite,
          elevation: 0,
          iconTheme: const IconThemeData(color: kNeutralColor),
          title: Text(
            'Job Details',
            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
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
                value == 'edit' ? null : cancelJobPopUp();
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(
                  Icons.more_vert_rounded,
                  color: kNeutralColor,
                ),
              ),
            ).visible(!status.contains('Cancelled')),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: kWhite,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ButtonGlobalWithoutIcon(
                  buttontext: 'Re-Post',
                  buttonDecoration: kButtonDecoration.copyWith(
                    color: kPrimaryColor,
                  ),
                  onPressed: () {
                    onRePost();
                  },
                  buttonTextColor: kWhite,
                ),
              ).visible(status.contains('Cancelled')),
              Expanded(
                child: ButtonGlobalWithoutIcon(
                  buttontext: 'Invite Artists',
                  buttonDecoration: kButtonDecoration.copyWith(
                    color: kPrimaryColor,
                  ),
                  onPressed: () {
                    onInvite();
                  },
                  buttonTextColor: kWhite,
                ),
              ).visible(!status.contains('Cancelled') && !status.contains('Processing')),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(left: DodResponsive.isDesktop(context) ? 150.0 : 15.0, right: DodResponsive.isDesktop(context) ? 150.0 : 15.0),
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
                              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
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
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
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
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Flexible(
                                        child: Text(
                                          snapshot.data!.category!.name!,
                                          style: kTextStyle.copyWith(color: kSubTitleColor),
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
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
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
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Flexible(
                                        child: Text(
                                          snapshot.data!.material!.name!,
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
                                  flex: 2,
                                  child: Text(
                                    'Surface',
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
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
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Flexible(
                                        child: Text(
                                          snapshot.data!.surface!.name!,
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
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.pieces,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Pieces',
                                            style: kTextStyle.copyWith(
                                              color: index == 0 ? kSubTitleColor : kWhite,
                                            ),
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
                                                  color: index == 0 ? kSubTitleColor : kWhite,
                                                ),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  index == 0 ? '${snapshot.data!.pieces!} (${snapshot.data!.sizes![index].width} cm x ${snapshot.data!.sizes![index].length} cm)' : '   (${snapshot.data!.sizes![index].width} cm x ${snapshot.data!.sizes![index].length} cm)',
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
                                );
                              },
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Quantity',
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
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
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Flexible(
                                        child: Text(
                                          snapshot.data!.quantity!.toString(),
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
                                  flex: 2,
                                  child: Text(
                                    'Budget',
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
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
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Flexible(
                                        child: Text(
                                          NumberFormat.simpleCurrency(
                                            locale: 'vi_VN',
                                          ).format(snapshot.data!.budget),
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
                                  flex: 2,
                                  child: Text(
                                    'Status',
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
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
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Flexible(
                                        child: Text(
                                          snapshot.data!.status!,
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
                                  flex: 2,
                                  child: Text(
                                    'Created Date',
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
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
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Flexible(
                                        child: Text(
                                          DateFormat('dd-MM-yyyy').format(snapshot.data!.createdDate!),
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
                            const SizedBox(height: 8.0).visible(snapshot.data!.image != null),
                            Text(
                              'Attach file:',
                              style: kTextStyle.copyWith(color: kSubTitleColor),
                            ).visible(snapshot.data!.image != null),
                            const SizedBox(height: 8.0).visible(snapshot.data!.image != null),
                            snapshot.data!.image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(maxHeight: 390, maxWidth: 390),
                                      child: PhotoView(
                                        imageProvider: NetworkImage(
                                          snapshot.data!.image!,
                                        ),
                                        tightMode: true,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 100,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: kDarkWhite,
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Icon(
                                      IconlyBold.document,
                                      color: kNeutralColor.withOpacity(0.7),
                                      size: 50,
                                    ),
                                  ).visible(snapshot.data!.image != null),
                            const SizedBox(height: 8.0).visible(snapshot.data!.proposals!.isNotEmpty),
                            Text(
                              'Proposals:',
                              style: kTextStyle.copyWith(
                                color: kSubTitleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ).visible(snapshot.data!.proposals!.isNotEmpty),
                            const SizedBox(height: 8.0),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.proposals!.length,
                              itemBuilder: (context, index) {
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
                                        GestureDetector(
                                          onTap: () {
                                            onArtistDetail(snapshot.data!.proposals![index].createdByNavigation!.id.toString());
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 32,
                                                width: 32,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(image: NetworkImage(snapshot.data!.proposals![index].createdByNavigation!.avatar ?? defaultImage), fit: BoxFit.cover),
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
                                                    snapshot.data!.proposals![index].createdByNavigation!.name!,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () async {
                                            if (snapshot.data!.proposals![index].status == 'Pending') {
                                              if (await rejectProposalPopUp()) {
                                                onReject(snapshot.data!.proposals![index]);
                                              }
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                        ).visible(snapshot.data!.proposals![index].status != 'Accepted'),
                                        IconButton(
                                          onPressed: () async {
                                            if (snapshot.data!.proposals![index].status == 'Pending') {
                                              if (await acceptProposalPopUp()) {
                                                onAccept(snapshot.data!.sizes!, snapshot.data!.proposals![index], snapshot.data!.proposals!);
                                              }
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.check_circle_rounded,
                                            color: kPrimaryColor,
                                          ),
                                        ).visible(snapshot.data!.proposals![index].status != 'Rejected'),
                                        Text(
                                          snapshot.data!.proposals![index].status!,
                                          style: kTextStyle.copyWith(
                                            color: kSubTitleColor,
                                            fontSize: 14,
                                          ),
                                        ).visible(snapshot.data!.proposals![index].status != 'Pending')
                                      ],
                                    ),
                                    children: [
                                      Padding(
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
                                                        image: DecorationImage(image: NetworkImage(snapshot.data!.proposals![index].artwork!.arts!.first.image!), fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 5.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Flexible(
                                                        flex: 1,
                                                        child: SizedBox(
                                                          width: 190,
                                                          child: Text(
                                                            'Introduce',
                                                            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Flexible(
                                                        flex: 4,
                                                        child: SizedBox(
                                                          width: context.width() / 2,
                                                          child: ReadMoreText(
                                                            snapshot.data!.proposals![index].introduction!,
                                                            style: kTextStyle.copyWith(color: kSubTitleColor),
                                                            trimLines: 3,
                                                            colorClickableText: kPrimaryColor,
                                                            trimMode: TrimMode.Line,
                                                            trimCollapsedText: '..read more',
                                                            trimExpandedText: ' read less',
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      SizedBox(
                                                        width: context.width() * 0.5,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'Amount: ',
                                                              style: kTextStyle.copyWith(
                                                                color: kSubTitleColor,
                                                              ),
                                                            ),
                                                            Text(
                                                              NumberFormat.simpleCurrency(locale: 'vi_VN').format(snapshot.data!.proposals![index].artwork!.price),
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
                                      ),
                                      const SizedBox(height: 10.0),
                                    ],
                                  ),
                                );
                              },
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
      ),
    );
  }

  Future<Requirement?> getData() async {
    try {
      return RequirementApi()
          .getOne(
        widget.id!,
        'category,surface,material,sizes,proposals(expand=createdByNavigation(expand=rank),artwork(expand=arts))',
      )
          .then((value) {
        setState(() {
          status = value.status!;
        });

        return value;
      });
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get requirement failed');
    }

    return null;
  }

  void onRePost() async {
    await RequirementApi().patchOne(widget.id!, {
      'Status': status.replaceAll('|Cancelled', ''),
    }).then((value) {
      JobPost.refresh();
      GoRouter.of(context).pop();
    });
  }

  void onInvite() {
    context.goNamed('${ArtistRoute.name} job', pathParameters: {'jobId': widget.id!});
  }

  void onArtistDetail(String id) {
    context.goNamed(
      '${ArtistProfileDetailRoute.name} jobOut',
      pathParameters: {
        'jobId': widget.id!,
        'id': id,
      },
    );
  }

  void onReject(Proposal proposal) async {
    if (proposal.status == 'Pending') {
      try {
        ProgressDialogUtils.showProgress(context);

        await ProposalApi().patchOne(proposal.id.toString(), {
          'Status': 'Rejected',
        });

        setState(() {
          requirement = getData();
        });

        // ignore: use_build_context_synchronously
        ProgressDialogUtils.hideProgress(context);
      } catch (error) {
        Fluttertoast.showToast(msg: 'Reject failed');
      }
    }
  }

  void onAccept(List<Size> sizes, Proposal proposal, List<Proposal> proposals) async {
    if (proposal.status == 'Pending') {
      try {
        ProgressDialogUtils.showProgress(context);

        for (var proposalIL in proposals) {
          if (proposal.id != proposalIL.id) {
            await ProposalApi().patchOne(proposalIL.id.toString(), {
              'Status': 'Rejected',
            });
          } else {
            await ProposalApi().patchOne(proposalIL.id.toString(), {
              'Status': 'Accepted',
            });
          }
        }

        for (var size in sizes) {
          await SizeApi().patchOne(size.id.toString(), {
            'ArtworkId': proposal.artworkId.toString(),
          });
        }

        await RequirementApi().patchOne(widget.id!, {
          'Status': '$status|Processing',
        });

        var order = Order(
          id: Guid.newGuid,
          orderType: 'Requirement',
          orderDate: DateTime.now(),
          status: 'Pending',
          total: 0,
          orderedBy: Guid(jsonDecode(PrefUtils().getAccount())['Id']),
        );

        var orderDetail = OrderDetail(
          id: Guid.newGuid,
          price: proposal.artwork!.price,
          quantity: 1,
          fee: proposal.createdByNavigation!.rank!.fee,
          artworkId: proposal.artworkId,
          orderId: order.id,
        );

        await OrderApi().postOne(order);
        await OrderDetailApi().postOne(orderDetail);

        setState(() {
          requirement = getData();
        });

        JobPost.refresh();

        ChatFunction.createChat(
          senderId: jsonDecode(PrefUtils().getAccount())['Id'],
          receiverId: proposal.createdByNavigation!.id.toString(),
          orderId: order.id.toString().split('-').first.toUpperCase(),
        );

        // ignore: use_build_context_synchronously
        ProgressDialogUtils.hideProgress(context);

        acceptProposalSuccessPopUp();
      } catch (error) {
        // ignore: use_build_context_synchronously
        ProgressDialogUtils.hideProgress(context);
        Fluttertoast.showToast(msg: 'Accept failed');
      }
    }
  }
}
