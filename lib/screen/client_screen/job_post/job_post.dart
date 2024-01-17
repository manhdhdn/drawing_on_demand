import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/requirement_api.dart';
import '../../../data/models/requirement.dart';
import '../../widgets/constant.dart';
import '../../widgets/responsive.dart';

class JobPost extends StatefulWidget {
  static dynamic state;

  const JobPost({Key? key}) : super(key: key);

  @override
  State<JobPost> createState() => _JobPostState();

  static void refresh() {
    state.refresh();
  }
}

class _JobPostState extends State<JobPost> {
  late Future<Requirements?> requirements;

  List<String> serviceList = [
    'All',
    'Public',
    'Private',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();

    JobPost.state = this;
    requirements = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: '$dod | Requirements',
      color: kPrimaryColor,
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kDarkWhite,
          elevation: 0,
          iconTheme: const IconThemeData(color: kNeutralColor),
          title: Text(
            AppLocalizations.of(context)!.requirement,
            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: FloatingActionButton(
            onPressed: () {
              onCreate();
            },
            backgroundColor: kPrimaryColor,
            child: const Icon(
              FeatherIcons.plus,
              color: kWhite,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
            child: FutureBuilder(
              future: requirements,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: DodResponsive.isDesktop(context) ? 150.0 : 0.0,
                        right: DodResponsive.isDesktop(context) ? 150.0 : 0.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15.0),
                          HorizontalList(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                            itemCount: serviceList.length,
                            itemBuilder: (_, i) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    onChangeTab(i);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: selectedServiceList == serviceList[i] ? kPrimaryColor : kDarkWhite,
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    child: Text(
                                      serviceList[i] == 'All'
                                          ? AppLocalizations.of(context)!.all
                                          : serviceList[i] == 'Public'
                                              ? AppLocalizations.of(context)!.public
                                              : serviceList[i] == 'Private'
                                                  ? AppLocalizations.of(context)!.private
                                                  : AppLocalizations.of(context)!.cancelled,
                                      style: kTextStyle.copyWith(
                                        color: selectedServiceList == serviceList[i] ? kWhite : kNeutralColor,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 15.0),
                          Column(
                            children: [
                              const SizedBox(height: 50.0),
                              Container(
                                height: 213,
                                width: 269,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('images/emptyservice.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                AppLocalizations.of(context)!.nothingJustYet,
                                textAlign: TextAlign.center,
                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 24.0),
                              ),
                            ],
                          ).visible(snapshot.data!.value.isEmpty),
                          Text(
                            '${AppLocalizations.of(context)!.totalRequirementPost} (${snapshot.data!.count})',
                            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15.0),
                          ListView.builder(
                            itemCount: snapshot.data!.value.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(10.0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    onDetail(snapshot.data!.value.elementAt(index).id!.toString());
                                  },
                                  child: Container(
                                    width: context.width(),
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: kWhite,
                                      border: Border.all(color: kBorderColorTextField),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.value.elementAt(index).title!,
                                          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          snapshot.data!.value.elementAt(index).description!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: kTextStyle.copyWith(color: kSubTitleColor),
                                        ),
                                        const SizedBox(height: 10.0),
                                        RichText(
                                          text: TextSpan(
                                            text: AppLocalizations.of(context)!.category,
                                            style: kTextStyle.copyWith(color: kNeutralColor),
                                            children: [
                                              TextSpan(
                                                text: snapshot.data!.value.elementAt(index).category!.name,
                                                style: kTextStyle.copyWith(color: kSubTitleColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10, right: 10),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: kDarkWhite),
                                              child: Text(
                                                snapshot.data!.value.elementAt(index).status!,
                                                style: kTextStyle.copyWith(color: kNeutralColor),
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              '${AppLocalizations.of(context)!.date} ${DateFormat('dd-MM-yyyy').format(snapshot.data!.value.elementAt(index).createdDate!)}',
                                              style: kTextStyle.copyWith(color: kLightNeutralColor),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
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
              }),
            ),
          ),
        ),
      ),
    );
  }

  Future<Requirements?> getData() async {
    try {
      return RequirementApi().gets(
        0,
        filter: selectedServiceList != 'All' ? 'createdBy eq ${jsonDecode(PrefUtils().getAccount())['Id']} and endswith(status, \'$selectedServiceList\')' : 'createdBy eq ${jsonDecode(PrefUtils().getAccount())['Id']} and status ne \'Completed\' and not endswith(status, \'Cancelled\') and not endswith(status, \'Processing\')',
        expand: 'category',
        orderBy: 'createdDate desc',
        count: 'true',
      );
    } catch (error) {
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.getRequirementFailed);
    }

    return null;
  }

  void onDetail(String id) {
    context.goNamed(JobDetailRoute.name, pathParameters: {'jobId': id});
  }

  void onCreate() {
    context.goNamed(JobCreateRoute.name);
  }

  void refresh() {
    setState(() {
      requirements = getData();
    });
  }

  void onChangeTab(int i) {
    setState(() {
      selectedServiceList = serviceList[i];
      requirements = getData();
    });
  }
}
