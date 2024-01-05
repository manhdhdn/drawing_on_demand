import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';

import '../../../app_routes/named_routes.dart';
import '../../../data/apis/requirement_api.dart';
import '../../../data/models/requirement.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../common/popUp/popup_2.dart';
import 'job_post.dart';

class JobDetails extends StatefulWidget {
  final String? id;

  const JobDetails({Key? key, this.id}) : super(key: key);

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  late Future<Requirement?> requirement;

  String status = 'Public';

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
          builder:
              (BuildContext context, void Function(void Function()) setState) {
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
                  buttontext: 'Invite',
                  buttonDecoration: kButtonDecoration.copyWith(
                    color: kPrimaryColor,
                  ),
                  onPressed: () {
                    onInvite();
                  },
                  buttonTextColor: kWhite,
                ),
              ).visible(
                  !status.contains('Cancelled') && status.contains('Private')),
            ],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.pieces,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 8.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Pieces',
                                            style: kTextStyle.copyWith(
                                              color: index == 0
                                                  ? kSubTitleColor
                                                  : kWhite,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ':',
                                                style: kTextStyle.copyWith(
                                                  color: index == 0
                                                      ? kSubTitleColor
                                                      : kWhite,
                                                ),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Flexible(
                                                child: Text(
                                                  index == 0
                                                      ? '${snapshot.data!.pieces!} (${snapshot.data!.sizes![index].width} cm x ${snapshot.data!.sizes![index].length} cm)'
                                                      : '   (${snapshot.data!.sizes![index].width} cm x ${snapshot.data!.sizes![index].length} cm)',
                                                  style: kTextStyle.copyWith(
                                                      color: kSubTitleColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                    style: kTextStyle.copyWith(
                                        color: kSubTitleColor),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ':',
                                        style: kTextStyle.copyWith(
                                            color: kSubTitleColor),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Flexible(
                                        child: Text(
                                          snapshot.data!.quantity!.toString(),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ':',
                                        style: kTextStyle.copyWith(
                                            color: kSubTitleColor),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Flexible(
                                        child: Text(
                                          NumberFormat.simpleCurrency(
                                            locale: 'vi_VN',
                                          ).format(snapshot.data!.budget),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
      ),
    );
  }

  Future<Requirement?> getData() async {
    try {
      return RequirementApi()
          .getOne(
        widget.id!,
        'category,surface,material,sizes',
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
    context.goNamed('${ArtistRoute.name} job',
        pathParameters: {'jobId': widget.id!});
  }
}
