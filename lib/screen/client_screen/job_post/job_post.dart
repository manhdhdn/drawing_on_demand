import 'dart:convert';

import 'package:drawing_on_demand/data/models/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/requirement_api.dart';
import '../../../data/models/requirement.dart';
import '../../widgets/constant.dart';
import 'create_new_job_post.dart';
import 'job_details.dart';

class JobPost extends StatefulWidget {
  const JobPost({Key? key}) : super(key: key);

  @override
  State<JobPost> createState() => _JobPostState();
}

class _JobPostState extends State<JobPost> {
  late Future<Requirements?> requirements;

  int skip = 0;
  int top = 9;

  @override
  void initState() {
    super.initState();

    requirements = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kDarkWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: kNeutralColor),
        title: Text(
          'Requirements',
          style: kTextStyle.copyWith(
              color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => const CreateNewJobPost(),
                  ),
                )
                .then((value) => setState(
                      () {
                        requirements = getData();
                      },
                    ));
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
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                                  fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            'Nothing just yet',
                            textAlign: TextAlign.center,
                            style: kTextStyle.copyWith(
                                color: kNeutralColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0),
                          ),
                        ],
                      ).visible(snapshot.data!.value.isEmpty),
                      Text(
                        'Total requirement post (${snapshot.data!.count})',
                        style: kTextStyle.copyWith(
                            color: kNeutralColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15.0),
                      ListView.builder(
                        itemCount: snapshot.data!.value.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 10.0),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) => JobDetails(
                                          requirementId: snapshot.data!.value
                                              .elementAt(index)
                                              .id!,
                                        ),
                                      ),
                                    )
                                    .then((value) => setState(
                                          () {
                                            requirements = getData();
                                          },
                                        ));
                              },
                              child: Container(
                                width: context.width(),
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: kWhite,
                                  border:
                                      Border.all(color: kBorderColorTextField),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.value
                                          .elementAt(index)
                                          .title!,
                                      style: kTextStyle.copyWith(
                                          color: kNeutralColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      snapshot.data!.value
                                          .elementAt(index)
                                          .description!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: kTextStyle.copyWith(
                                          color: kSubTitleColor),
                                    ),
                                    const SizedBox(height: 10.0),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Category: ',
                                        style: kTextStyle.copyWith(
                                            color: kNeutralColor),
                                        children: [
                                          TextSpan(
                                            text: snapshot.data!.value
                                                .elementAt(index)
                                                .category!
                                                .name,
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              top: 5.0,
                                              bottom: 5.0,
                                              left: 10,
                                              right: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              color: kDarkWhite),
                                          child: Text(
                                            snapshot.data!.value
                                                .elementAt(index)
                                                .status!,
                                            style: kTextStyle.copyWith(
                                                color: kNeutralColor),
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'Date: ${DateFormat('dd-MM-yyyy').format(snapshot.data!.value.elementAt(index).createdDate!)}',
                                          style: kTextStyle.copyWith(
                                              color: kLightNeutralColor),
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
    );
  }

  Future<Requirements?> getData() async {
    try {
      var accountId = Account.fromJson(jsonDecode(PrefUtils().getAccount())).id;

      return RequirementApi().gets(
        skip,
        top: top,
        filter: 'createdBy eq $accountId',
        expand: 'category',
        orderBy: 'createdDate desc',
        count: 'true',
      );
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get requirement failed');
    }

    return null;
  }
}
