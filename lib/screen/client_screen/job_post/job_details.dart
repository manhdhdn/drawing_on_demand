import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../data/apis/order_api.dart';
import '../../../data/apis/order_detail_api.dart';
import '../../../data/apis/proposal_api.dart';
import '../../../data/apis/requirement_api.dart';
import '../../../data/apis/size_api.dart';
import '../../../data/models/order.dart';
import '../../../data/models/order_detail.dart';
import '../../../data/models/proposal.dart';
import '../../../data/models/requirement.dart';
import '../../../data/models/size.dart';
import '../../../data/notifications/firebase_api.dart';
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
              insetPadding: DodResponsive.isDesktop(context) ? EdgeInsets.symmetric(horizontal: context.width() / 2.7) : const EdgeInsets.symmetric(horizontal: 40.0),
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
              insetPadding: DodResponsive.isDesktop(context) ? EdgeInsets.symmetric(horizontal: context.width() / 2.7) : const EdgeInsets.symmetric(horizontal: 40.0),
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
              insetPadding: DodResponsive.isDesktop(context) ? EdgeInsets.symmetric(horizontal: context.width() / 2.7) : const EdgeInsets.symmetric(horizontal: 40.0),
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
              insetPadding: DodResponsive.isDesktop(context) ? EdgeInsets.symmetric(horizontal: context.width() / 2.7) : const EdgeInsets.symmetric(horizontal: 40.0),
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
            AppLocalizations.of(context)!.jobDetails,
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
                    AppLocalizations.of(context)!.edit,
                    style: kTextStyle.copyWith(color: kNeutralColor),
                  ),
                ),
                PopupMenuItem(
                  value: 'cancel',
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
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
          child: Padding(
            padding: EdgeInsets.only(
              left: DodResponsive.isDesktop(context) ? 150.0 : 0.0,
              right: DodResponsive.isDesktop(context) ? 150.0 : 0.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ButtonGlobalWithoutIcon(
                    buttontext: AppLocalizations.of(context)!.rePost,
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
                    buttontext: AppLocalizations.of(context)!.inviteArtists,
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
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
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
                                  trimCollapsedText: AppLocalizations.of(context)!.readMore,
                                  trimExpandedText: AppLocalizations.of(context)!.readLess,
                                ),
                                const SizedBox(height: 15.0),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLocalizations.of(context)!.category2,
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                    ),
                                    Expanded(
                                      flex: DodResponsive.isDesktop(context) ? 6 : 3,
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
                                      flex: 1,
                                      child: Text(
                                        AppLocalizations.of(context)!.material,
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                    ),
                                    Expanded(
                                      flex: DodResponsive.isDesktop(context) ? 6 : 3,
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
                                      flex: 1,
                                      child: Text(
                                        AppLocalizations.of(context)!.surface,
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                    ),
                                    Expanded(
                                      flex: DodResponsive.isDesktop(context) ? 6 : 3,
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
                                              flex: 1,
                                              child: Text(
                                                AppLocalizations.of(context)!.pieces,
                                                style: kTextStyle.copyWith(
                                                  color: index == 0 ? kSubTitleColor : kWhite,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: DodResponsive.isDesktop(context) ? 6 : 3,
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
                                      flex: 1,
                                      child: Text(
                                        AppLocalizations.of(context)!.quantity,
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                    ),
                                    Expanded(
                                      flex: DodResponsive.isDesktop(context) ? 6 : 3,
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
                                      flex: 1,
                                      child: Text(
                                        AppLocalizations.of(context)!.budget,
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                    ),
                                    Expanded(
                                      flex: DodResponsive.isDesktop(context) ? 6 : 3,
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
                                      flex: 1,
                                      child: Text(
                                        AppLocalizations.of(context)!.status,
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                    ),
                                    Expanded(
                                      flex: DodResponsive.isDesktop(context) ? 6 : 3,
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
                                              snapshot.data!.status! == 'Public'
                                                  ? AppLocalizations.of(context)!.public
                                                  : snapshot.data!.status! == 'Private'
                                                      ? AppLocalizations.of(context)!.private
                                                      : AppLocalizations.of(context)!.cancelled,
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
                                        AppLocalizations.of(context)!.createDate,
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                    ),
                                    Expanded(
                                      flex: DodResponsive.isDesktop(context) ? 6 : 3,
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
                                  AppLocalizations.of(context)!.attachFile,
                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                ).visible(snapshot.data!.image != null),
                                const SizedBox(height: 8.0).visible(snapshot.data!.image != null),
                                snapshot.data!.image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxHeight: 359,
                                            maxWidth: 359,
                                          ),
                                          child: PhotoView(
                                            imageProvider: NetworkImage(
                                              snapshot.data!.image ?? defaultImage,
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
                                const SizedBox(height: 20.0).visible(snapshot.data!.proposals!.isNotEmpty),
                                Text(
                                  AppLocalizations.of(context)!.proposals,
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
                                                      image: DecorationImage(
                                                        image: NetworkImage(snapshot.data!.proposals![index].createdByNavigation!.avatar ?? defaultImage),
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
                                                            image: DecorationImage(
                                                              image: NetworkImage(snapshot.data!.proposals![index].artwork!.arts!.first.image!),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 5.0),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Flexible(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              child: Text(
                                                                AppLocalizations.of(context)!.introduce,
                                                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 5.0),
                                                          Flexible(
                                                            flex: 3,
                                                            child: SizedBox(
                                                              width: DodResponsive.isDesktop(context) ? context.width() / 3 : context.width() / 2,
                                                              child: ReadMoreText(
                                                                snapshot.data!.proposals![index].introduction!,
                                                                style: kTextStyle.copyWith(color: kSubTitleColor),
                                                                trimLines: 3,
                                                                colorClickableText: kPrimaryColor,
                                                                trimMode: TrimMode.Line,
                                                                trimCollapsedText: AppLocalizations.of(context)!.readMore,
                                                                trimExpandedText: AppLocalizations.of(context)!.readLess,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 5.0),
                                                          Flexible(
                                                            flex: 1,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  AppLocalizations.of(context)!.amountProposal,
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
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.getRequirementFailed);
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
          this.requirement = getData();
        });

        // ignore: use_build_context_synchronously
        ProgressDialogUtils.hideProgress(context);
        var requirement = await this.requirement;

        var user = await ChatFunction.getUserData(proposal.createdBy.toString());

        FirebaseApi().sendNotification(
          // ignore: use_build_context_synchronously
          title: '${AppLocalizations.of(context)!.rejectTilteNot1} ${requirement!.title} ${AppLocalizations.of(context)!.rejectTitleNot2}',
          // ignore: use_build_context_synchronously
          body: AppLocalizations.of(context)!.rejectBodyNot,
          receiverDeviceId: user.deviceId!,
          pageName: JobDetailRoute.name,
          pathName: 'jobId',
          referenceId: widget.id!,
        );
      } catch (error) {
        Fluttertoast.showToast(msg: 'Reject failed');
      }
    }
  }

  void onAccept(List<Size> sizes, Proposal proposal, List<Proposal> proposals) async {
    if (proposal.status == 'Pending') {
      try {
        ProgressDialogUtils.showProgress(context);

        var requirement = await this.requirement;

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
          this.requirement = getData();
        });

        JobPost.refresh();

        // ignore: use_build_context_synchronously
        ProgressDialogUtils.hideProgress(context);

        acceptProposalSuccessPopUp();

        for (var proposalIL in proposals) {
          if (proposal.id != proposalIL.id) {
            await ProposalApi().patchOne(proposalIL.id.toString(), {
              'Status': 'Rejected',
            });

            var user = await ChatFunction.getUserData(proposal.createdBy.toString());

            FirebaseApi().sendNotification(
              // ignore: use_build_context_synchronously
              title: '${AppLocalizations.of(context)!.rejectTilteNot1} ${requirement!.title} ${AppLocalizations.of(context)!.rejectTitleNot2}',
              // ignore: use_build_context_synchronously
              body: AppLocalizations.of(context)!.rejectBodyNot,
              receiverDeviceId: user.deviceId!,
              pageName: JobDetailRoute.name,
              pathName: 'jobId',
              referenceId: widget.id!,
            );
          } else {
            await ProposalApi().patchOne(proposalIL.id.toString(), {
              'Status': 'Accepted',
            });

            var user = await ChatFunction.getUserData(proposal.createdBy.toString());

            FirebaseApi().sendNotification(
              // ignore: use_build_context_synchronously
              title: '${AppLocalizations.of(context)!.rejectTilteNot1} ${requirement!.title} ${AppLocalizations.of(context)!.acceptTitleNot}',
              // ignore: use_build_context_synchronously
              body: AppLocalizations.of(context)!.acceptBodyNot,
              receiverDeviceId: user.deviceId!,
              pageName: OrderDetailRoute.name,
              pathName: 'orderId',
              referenceId: order.id.toString(),
            );
          }
        }
      } catch (error) {
        // ignore: use_build_context_synchronously
        ProgressDialogUtils.hideProgress(context);
        Fluttertoast.showToast(msg: 'Accept failed');
      }
    }
  }
}
