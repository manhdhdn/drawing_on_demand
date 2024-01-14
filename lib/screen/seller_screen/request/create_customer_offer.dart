import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pinput/pinput.dart';

import '../../../core/common/common_features.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../core/utils/validation_function.dart';
import '../../../data/apis/art_api.dart';
import '../../../data/apis/artwork_api.dart';
import '../../../data/apis/proposal_api.dart';
import '../../../data/apis/requirement_api.dart';
import '../../../data/models/art.dart';
import '../../../data/models/artwork.dart';
import '../../../data/models/proposal.dart';
import '../../../data/models/requirement.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';

class CreateCustomerOffer extends StatefulWidget {
  final String? id;

  const CreateCustomerOffer({Key? key, this.id}) : super(key: key);

  @override
  State<CreateCustomerOffer> createState() => _CreateCustomerOfferState();
}

class _CreateCustomerOfferState extends State<CreateCustomerOffer> {
  final _formKey = GlobalKey<FormState>();

  late Future<Requirement?> requirement;

  TextEditingController introduceController = TextEditingController();
  TextEditingController budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();

    requirement = getRequirement();

    images.clear();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();

    super.dispose();
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
          'Create a custom Offer',
          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(color: kWhite),
        child: ButtonGlobalWithoutIcon(
          buttontext: 'Submit Offer',
          buttonDecoration: kButtonDecoration.copyWith(color: kPrimaryColor, borderRadius: BorderRadius.circular(30.0)),
          onPressed: () {
            onSubmitOffer();
          },
          buttonTextColor: kWhite,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
          ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20.0),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
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
                            borderRadius: BorderRadius.circular(10.0)),
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
                                    image: NetworkImage(
                                      snapshot.data!.createdByNavigation!.avatar ?? defaultImage,
                                    ),
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
                              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5.0),
                            ReadMoreText(
                              snapshot.data!.description!,
                              style: kTextStyle.copyWith(color: kLightNeutralColor),
                              trimLines: 2,
                              colorClickableText: kPrimaryColor,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: '..read more',
                              trimExpandedText: ' read less',
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Description',
                        style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 15.0),
                            TextFormField(
                                keyboardType: TextInputType.multiline,
                                cursorColor: kNeutralColor,
                                textInputAction: TextInputAction.newline,
                                maxLength: 300,
                                maxLines: 3,
                                decoration: kInputDecoration.copyWith(
                                  hintText: 'I fit your request because...',
                                  hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                  focusColor: kNeutralColor,
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  border: const OutlineInputBorder(),
                                ),
                                controller: introduceController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter description';
                                  }

                                  return null;
                                }),
                            const SizedBox(height: 15.0),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              cursorColor: kNeutralColor,
                              decoration: kInputDecoration.copyWith(
                                labelText: 'Total Offer Amount',
                                labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                hintText: 'Enter amount',
                                hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                focusColor: kNeutralColor,
                                border: const OutlineInputBorder(),
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: budgetController,
                              onChanged: (value) {
                                if (isCurrency(value, isRequired: true)) {
                                  int budget = int.tryParse(value.replaceAll('.', ''))!;

                                  if (budget > snapshot.data!.budget!) {
                                    budget = snapshot.data!.budget!.toInt();
                                  }

                                  String budgetString = budget.toString();
                                  int count = 0;
                                  String budgetWithDot = '';

                                  for (int i = budgetString.length - 1; i > 0; i--) {
                                    count++;

                                    if (count == 3) {
                                      count = 0;
                                      budgetWithDot = '.${budgetString[i]}$budgetWithDot';
                                    } else {
                                      budgetWithDot = budgetString[i] + budgetWithDot;
                                    }
                                  }

                                  budgetWithDot = budgetString[0] + budgetWithDot;

                                  setState(() {
                                    budgetController.text = budgetWithDot;
                                    budgetController.moveCursorToEnd();
                                  });
                                }
                              },
                              validator: (value) {
                                if (!isCurrency(value, isRequired: true)) {
                                  return 'Please enter budget\nNumber only';
                                }

                                if (int.parse(value!.replaceAll('.', '')) < 100000) {
                                  return 'Minimum amount is ${NumberFormat.simpleCurrency(locale: 'vi_VN').format(100000)}';
                                }

                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: GestureDetector(
                          onTap: () async {
                            await showImportPicturePopUp(context);

                            setState(() {
                              images = images;
                            });
                          },
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: kBorderColorTextField),
                            ),
                            child: images.isEmpty
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        IconlyBold.image,
                                        color: kLightNeutralColor,
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        ' Upload Image ',
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                      ),
                                      const SizedBox(height: 10.0),
                                    ],
                                  )
                                : FutureBuilder(
                                    future: images.last.readAsBytes(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              Image.memory(
                                                snapshot.data!,
                                                scale: 5,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    images.clear();
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.cancel,
                                                  color: Colors.red[700],
                                                  size: 27.0,
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
      return RequirementApi().getOne(widget.id!, 'createdByNavigation');
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get requirement failed');
    }

    return null;
  }

  void onSubmitOffer() async {
    if (!_formKey.currentState!.validate() || images.isEmpty) {
      return;
    }

    try {
      ProgressDialogUtils.showProgress(context);

      if (await isOffered()) {
        throw Exception();
      }

      var requirement = await this.requirement;
      var artwork = Artwork(
        id: Guid.newGuid,
        title: requirement!.title,
        description: requirement.description,
        price: double.tryParse(budgetController.text.replaceAll('.', '')),
        pieces: requirement.pieces,
        inStock: requirement.quantity,
        createdDate: DateTime.now(),
        status: 'Proposed',
        categoryId: requirement.categoryId,
        surfaceId: requirement.surfaceId,
        materialId: requirement.materialId,
        createdBy: Guid(jsonDecode(PrefUtils().getAccount())['Id']),
      );

      String? image = await uploadImage(images.first);

      var art = Art(
        id: Guid.newGuid,
        image: image,
        createdDate: artwork.createdDate,
        artworkId: artwork.id,
      );
      var proposal = Proposal(
        id: Guid.newGuid,
        introduction: introduceController.text.trim(),
        createdDate: artwork.createdDate,
        status: 'Pending',
        requirementId: requirement.id,
        createdBy: Guid(jsonDecode(PrefUtils().getAccount())['Id']),
        artworkId: artwork.id,
      );

      await ArtworkApi().postOne(artwork);
      await ArtApi().postOne(art);
      await ProposalApi().postOne(proposal);

      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);
      // ignore: use_build_context_synchronously
      context.pop();
    } catch (error) {
      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);
      Fluttertoast.showToast(msg: 'Already have an offer');
    }
  }

  Future<bool> isOffered() async {
    try {
      var proposals = await ProposalApi().gets(
        0,
        count: 'true',
        filter: 'requirementId eq ${widget.id} and createdBy eq ${jsonDecode(PrefUtils().getAccount())['Id']}',
      );

      if (proposals.count != 0) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Check offer failed');
    }

    return true;
  }
}
