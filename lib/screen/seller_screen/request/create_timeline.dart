import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/utils/progress_dialog_utils.dart';
import '../../../core/utils/validation_function.dart';
import '../../../data/apis/requirement_api.dart';
import '../../../data/apis/step_api.dart';
import '../../../data/models/requirement.dart';
import '../../../data/models/step.dart' as model;
import '../../common/orders/order_detail.dart';
import '../../common/popUp/popup_2.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';

class CreateTimeline extends StatefulWidget {
  final String? id;

  const CreateTimeline({Key? key, this.id}) : super(key: key);

  @override
  State<CreateTimeline> createState() => _CreateTimelineState();
}

class _CreateTimelineState extends State<CreateTimeline> {
  final _formKey = GlobalKey<FormState>();

  late Future<Requirement?> requirement;

  TextEditingController numberController = TextEditingController(text: '0');

  List<DateTime?> startDates = [];
  List<DateTime?> endDates = [];
  List<String> describles = [];

  Future<void> createTimelineSuccessPopUp() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const CreateTimelineSuccessPopUp(),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    requirement = getRequirement();
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
          AppLocalizations.of(context)!.createATimeline,
          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(color: kWhite),
        child: ButtonGlobalWithoutIcon(
          buttontext: AppLocalizations.of(context)!.create,
          buttonDecoration: kButtonDecoration.copyWith(color: kPrimaryColor, borderRadius: BorderRadius.circular(30.0)),
          onPressed: () {
            onCreate();
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
                              trimCollapsedText: AppLocalizations.of(context)!.readMore,
                              trimExpandedText: AppLocalizations.of(context)!.readLess,
                            ),
                            const SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                text: '${AppLocalizations.of(context)!.category2}: ',
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
                                text: '${AppLocalizations.of(context)!.material}: ',
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
                                text: '${AppLocalizations.of(context)!.surface}: ',
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
                            const SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                text: '${AppLocalizations.of(context)!.quantity}: ',
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
                                        text: '${AppLocalizations.of(context)!.pieces}: ',
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        AppLocalizations.of(context)!.description,
                        style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 15.0),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              cursorColor: kNeutralColor,
                              decoration: kInputDecoration.copyWith(
                                labelText: AppLocalizations.of(context)!.totalStep,
                                labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                hintText: AppLocalizations.of(context)!.enterNumberSteps,
                                hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                focusColor: kNeutralColor,
                                border: const OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                if (int.tryParse(value) != null) {
                                  if (int.parse(value) <= 10) {
                                    setState(() {
                                      numberController.text = value;
                                    });
                                  }
                                }
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (!isNumber(value, isRequired: true)) {
                                  return '${AppLocalizations.of(context)!.pleaseEnterNumberSteps}\n${AppLocalizations.of(context)!.numberOnly}';
                                }

                                if (int.parse(value!) < 1) {
                                  return AppLocalizations.of(context)!.timelineMinStep;
                                }

                                if (int.parse(value) > 10) {
                                  return AppLocalizations.of(context)!.timelineMaxStep;
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 5.0),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: int.tryParse(numberController.text) ?? 0,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8.0),
                                    Text(
                                      '${AppLocalizations.of(context)!.step} ${index + 1}',
                                      style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: DateTimeFormField(
                                            decoration: kInputDecoration.copyWith(
                                              labelText: AppLocalizations.of(context)!.startDate,
                                              labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                              focusColor: kNeutralColor,
                                              border: const OutlineInputBorder(),
                                            ),
                                            firstDate: index < 1
                                                ? DateTime.now().add(const Duration(seconds: 1))
                                                : endDates.length > index - 1
                                                    ? endDates[index - 1]!.add(const Duration(seconds: 1))
                                                    : null,
                                            lastDate: index < 1
                                                ? DateTime.now().add(const Duration(days: 14))
                                                : endDates.length > index - 1
                                                    ? endDates[index - 1]!.add(const Duration(days: 14))
                                                    : null,
                                            initialValue: startDates.length > index ? startDates[index] : null,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: (value) {
                                              if (value == null) {
                                                return AppLocalizations.of(context)!.chooseStartDate;
                                              }

                                              return null;
                                            },
                                            onChanged: (value) {
                                              try {
                                                setState(() {
                                                  startDates[index] = value;
                                                  endDates[index] = value!.add(const Duration(days: 1));
                                                });
                                              } catch (error) {
                                                setState(() {
                                                  startDates.add(value);
                                                  endDates.add(value!.add(const Duration(days: 1)));
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 3.0),
                                        Expanded(
                                          child: DateTimeFormField(
                                            decoration: kInputDecoration.copyWith(
                                              labelText: AppLocalizations.of(context)!.endDate,
                                              labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                              focusColor: kNeutralColor,
                                              border: const OutlineInputBorder(),
                                            ),
                                            firstDate: startDates.length > index && startDates[index] != null ? startDates[index]!.add(const Duration(days: 1)) : null,
                                            lastDate: null,
                                            initialValue: startDates.length > index && startDates[index] != null ? endDates[index] : null,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: (value) {
                                              if (value == null) {
                                                return AppLocalizations.of(context)!.chooseEndDate;
                                              }

                                              return null;
                                            },
                                            onChanged: (value) {
                                              try {
                                                setState(() {
                                                  endDates[index] = value;
                                                });
                                              } catch (error) {
                                                setState(() {
                                                  endDates.add(value);
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      cursorColor: kNeutralColor,
                                      textInputAction: TextInputAction.newline,
                                      maxLength: 300,
                                      maxLines: 3,
                                      decoration: kInputDecoration.copyWith(
                                        labelText: AppLocalizations.of(context)!.describe,
                                        labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                        hintText: AppLocalizations.of(context)!.describeStep,
                                        hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                        focusColor: kNeutralColor,
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        border: const OutlineInputBorder(),
                                      ),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value!.trim().isEmpty) {
                                          return AppLocalizations.of(context)!.enterDescribe;
                                        }

                                        return null;
                                      },
                                      onChanged: (value) {
                                        try {
                                          describles[index] = value;
                                        } catch (error) {
                                          describles.add(value);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
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
      return RequirementApi().getOne(widget.id!, 'createdByNavigation,category,surface,material,sizes');
    } catch (error) {
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.getRequirementFailed);
    }

    return null;
  }

  void onCreate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      ProgressDialogUtils.showProgress(context);

      for (var i = 0; i < numberController.text.toInt(); i++) {
        var step = model.Step(
          id: Guid.newGuid,
          number: i + 1,
          detail: describles[i],
          startDate: startDates[i],
          estimatedEndDate: endDates[i],
          createdDate: DateTime.now(),
          status: 'Pending',
          requirementId: Guid(widget.id),
        );

        await StepApi().postOne(step);
      }

      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);

      OrderDetailScreen.refresh();

      await createTimelineSuccessPopUp();

      // ignore: use_build_context_synchronously
      context.pop();
    } catch (error) {
      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);
      // ignore: use_build_context_synchronously
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.createTimelineFailed);
    }
  }
}
