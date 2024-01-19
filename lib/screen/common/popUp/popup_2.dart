import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../core/utils/validation_function.dart';
import '../../../data/apis/artwork_api.dart';
import '../../../data/apis/requirement_api.dart';
import '../../../data/apis/size_api.dart';
import '../../../data/models/artwork.dart';
import '../../../data/models/order.dart';
import '../../../data/models/requirement.dart';
import '../../../data/models/size.dart' as model;
import '../../../data/notifications/firebase_api.dart';
import '../../widgets/constant.dart';
import '../../widgets/icons.dart';
import '../../client_screen/home/client_home_screen.dart';
import '../message/function/chat_function.dart';
import '../orders/order_detail.dart';

class ProcessingPopUp extends StatefulWidget {
  const ProcessingPopUp({Key? key}) : super(key: key);

  @override
  State<ProcessingPopUp> createState() => _ProcessingPopUpState();
}

class _ProcessingPopUpState extends State<ProcessingPopUp> {
  @override
  void initState() {
    super.initState();

    init();
  }

  void init() async {
    await Future.delayed(const Duration(seconds: 5), () {
      finish(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 166,
              width: 208,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/robot.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              '${AppLocalizations.of(context)!.processing}\n${AppLocalizations.of(context)!.yourOrder}',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              AppLocalizations.of(context)!.stayTuned,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kLightNeutralColor),
            ),
          ],
        ),
      ),
    );
  }
}

class FailedPopUp extends StatefulWidget {
  const FailedPopUp({Key? key}) : super(key: key);

  @override
  State<FailedPopUp> createState() => _FailedPopUpState();
}

class _FailedPopUpState extends State<FailedPopUp> {
  @override
  void initState() {
    super.initState();

    init();
  }

  void init() async {
    await Future.delayed(const Duration(seconds: 2), () {
      finish(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 166,
              width: 208,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/failed.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              '${AppLocalizations.of(context)!.paymentWas}\n${AppLocalizations.of(context)!.notSuccess}',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              AppLocalizations.of(context)!.tryAgain,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kLightNeutralColor),
            ),
          ],
        ),
      ),
    );
  }
}

class CompleteStepPopUp extends StatefulWidget {
  const CompleteStepPopUp({Key? key}) : super(key: key);

  @override
  State<CompleteStepPopUp> createState() => _CompleteStepPopUpState();
}

class _CompleteStepPopUpState extends State<CompleteStepPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Choose your Action',
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => finish(context),
                  child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(
                      FontAwesomeIcons.images,
                      color: kPrimaryColor,
                      size: 40,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Open Gallery',
                      style: kTextStyle.copyWith(color: kPrimaryColor),
                    ),
                  ],
                ),
                const SizedBox(width: 20.0),
                Column(
                  children: [
                    const Icon(
                      IconlyBold.document,
                      color: kLightNeutralColor,
                      size: 40,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Open File',
                      style: kTextStyle.copyWith(color: kLightNeutralColor),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}

class UploadCompletePopUp extends StatefulWidget {
  const UploadCompletePopUp({Key? key}) : super(key: key);

  @override
  State<UploadCompletePopUp> createState() => _UploadCompletePopUpState();
}

class _UploadCompletePopUpState extends State<UploadCompletePopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 186,
              width: 209,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(image: AssetImage('images/success.png'), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 15.0),
            Text(
              'Congratulations!',
              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Your profile is successfully completed. You can more changes after it\'s live',
              style: kTextStyle.copyWith(color: kLightNeutralColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Button(
              containerBg: kPrimaryColor,
              borderColor: Colors.transparent,
              buttonText: 'Done',
              textColor: kWhite,
              onPressed: () {
                const ClientHomeScreen().launch(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

class CancelJobPopUp extends StatefulWidget {
  final String? id;
  final String? status;

  const CancelJobPopUp({Key? key, this.id, this.status}) : super(key: key);

  @override
  State<CancelJobPopUp> createState() => _CancelJobPopUpState();
}

class _CancelJobPopUpState extends State<CancelJobPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.areCancel}\n${AppLocalizations.of(context)!.jobPosts}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    onNo();
                  },
                  child: const Icon(
                    FeatherIcons.x,
                    color: kSubTitleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Text(
              AppLocalizations.of(context)!.thisAction,
              style: kTextStyle.copyWith(color: kLightNeutralColor),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: Button(
                    containerBg: kWhite,
                    borderColor: redColor,
                    buttonText: AppLocalizations.of(context)!.no,
                    textColor: Colors.red,
                    onPressed: () {
                      onNo();
                    },
                  ),
                ),
                Expanded(
                  child: Button(
                    containerBg: kPrimaryColor,
                    borderColor: Colors.transparent,
                    buttonText: AppLocalizations.of(context)!.yes,
                    textColor: kWhite,
                    onPressed: () {
                      setState(() {
                        onYes();
                      });
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void onNo() {
    GoRouter.of(context).pop(false);
  }

  void onYes() async {
    try {
      ProgressDialogUtils.showProgress(context);

      await RequirementApi().patchOne(widget.id!, {
        'Status': '${widget.status}|Cancelled',
      });

      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);

      // ignore: use_build_context_synchronously
      GoRouter.of(context).pop(true);
    } catch (error) {
      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);

      Fluttertoast.showToast(msg: errorSomethingWentWrong);
    }
  }
}

class AcceptProposalPopUp extends StatefulWidget {
  final String? id;
  final String? status;

  const AcceptProposalPopUp({Key? key, this.id, this.status}) : super(key: key);

  @override
  State<AcceptProposalPopUp> createState() => _AcceptProposalPopUpState();
}

class _AcceptProposalPopUpState extends State<AcceptProposalPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.areAccept}\n${AppLocalizations.of(context)!.thisProposal}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    onNo();
                  },
                  child: const Icon(
                    FeatherIcons.x,
                    color: kSubTitleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Text(
              AppLocalizations.of(context)!.actionAccept,
              style: kTextStyle.copyWith(color: kLightNeutralColor),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: Button(
                    containerBg: kWhite,
                    borderColor: redColor,
                    buttonText: AppLocalizations.of(context)!.no,
                    textColor: Colors.red,
                    onPressed: () {
                      onNo();
                    },
                  ),
                ),
                Expanded(
                  child: Button(
                    containerBg: kPrimaryColor,
                    borderColor: Colors.transparent,
                    buttonText: AppLocalizations.of(context)!.yes,
                    textColor: kWhite,
                    onPressed: () {
                      setState(() {
                        onYes();
                      });
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void onNo() {
    GoRouter.of(context).pop(false);
  }

  void onYes() async {
    GoRouter.of(context).pop(true);
  }
}

class RejectProposalPopUp extends StatefulWidget {
  final String? id;
  final String? status;

  const RejectProposalPopUp({Key? key, this.id, this.status}) : super(key: key);

  @override
  State<RejectProposalPopUp> createState() => _RejectProposalPopUpState();
}

class _RejectProposalPopUpState extends State<RejectProposalPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.areReject}\n${AppLocalizations.of(context)!.thisProposal}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    onNo();
                  },
                  child: const Icon(
                    FeatherIcons.x,
                    color: kSubTitleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Text(
              AppLocalizations.of(context)!.actionReject,
              style: kTextStyle.copyWith(color: kLightNeutralColor),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: Button(
                    containerBg: kWhite,
                    borderColor: redColor,
                    buttonText: AppLocalizations.of(context)!.no,
                    textColor: Colors.red,
                    onPressed: () {
                      onNo();
                    },
                  ),
                ),
                Expanded(
                  child: Button(
                    containerBg: kPrimaryColor,
                    borderColor: Colors.transparent,
                    buttonText: AppLocalizations.of(context)!.yes,
                    textColor: kWhite,
                    onPressed: () {
                      setState(() {
                        onYes();
                      });
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void onNo() {
    GoRouter.of(context).pop(false);
  }

  void onYes() async {
    GoRouter.of(context).pop(true);
  }
}

class InvitePopUp extends StatefulWidget {
  const InvitePopUp({Key? key}) : super(key: key);

  @override
  State<InvitePopUp> createState() => _InvitePopUpState();
}

class _InvitePopUpState extends State<InvitePopUp> {
  List<Requirement> requirements = [];

  Guid? selectedRequirement;

  @override
  void initState() {
    super.initState();

    getRequirements();
  }

  DropdownButton<Guid> getRequirement() {
    List<DropdownMenuItem<Guid>> dropDownItems = [];
    for (Requirement des in requirements) {
      var item = DropdownMenuItem(
        value: des.id,
        child: Text(des.status == 'Private' ? '${des.title!} - ${AppLocalizations.of(context)!.private}' : des.title!),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedRequirement,
      style: kTextStyle.copyWith(
        color: kLightNeutralColor,
      ),
      isExpanded: true,
      menuMaxHeight: menuMaxHeight,
      onChanged: (value) {
        setState(() {
          selectedRequirement = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.chooseRequirement,
                  style: kTextStyle.copyWith(
                    color: kNeutralColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    onCancel();
                  },
                  child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            FormField(
              builder: (FormFieldState<dynamic> field) {
                return InputDecorator(
                  decoration: kInputDecoration.copyWith(
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                    ),
                    contentPadding: const EdgeInsets.all(7.0),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: AppLocalizations.of(context)!.requirement2,
                    labelStyle: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                  ),
                  child: DropdownButtonHideUnderline(child: getRequirement()),
                );
              },
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: Button(
                    containerBg: kWhite,
                    borderColor: Colors.red,
                    buttonText: AppLocalizations.of(context)!.cancel,
                    textColor: Colors.red,
                    onPressed: () {
                      onCancel();
                    },
                  ),
                ),
                Expanded(
                  child: Button(
                    containerBg: kPrimaryColor,
                    borderColor: Colors.transparent,
                    buttonText: AppLocalizations.of(context)!.invite,
                    textColor: kWhite,
                    onPressed: () {
                      onInvite();
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void getRequirements() async {
    try {
      var response = await RequirementApi().gets(
        0,
        orderBy: 'status,title',
        filter: 'createdBy eq ${jsonDecode(PrefUtils().getAccount())['Id']} and status ne \'Processing\' and status ne \'Completed\' and not endswith(status, \'Cancelled\') and not endswith(status, \'Processing\')',
      );

      if (response.value.isNotEmpty) {
        setState(() {
          requirements = response.value;
          selectedRequirement = response.value.first.id!;
        });
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get requirement failed');
    }
  }

  void onCancel() {
    GoRouter.of(context).pop(null);
  }

  void onInvite() {
    GoRouter.of(context).pop(selectedRequirement.toString());
  }
}

class InviteSuccessPopUp extends StatefulWidget {
  const InviteSuccessPopUp({Key? key}) : super(key: key);

  @override
  State<InviteSuccessPopUp> createState() => _InviteSuccessPopUpState();
}

class _InviteSuccessPopUpState extends State<InviteSuccessPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.inviteSuccess,
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => finish(context),
                  child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                ),
              ],
            ),
            const Divider(
              thickness: 1.0,
              color: kBorderColorTextField,
            ),
            const SizedBox(height: 20.0),
            Container(
              height: 124,
              width: 124,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: kPrimaryColor,
                size: 50,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              AppLocalizations.of(context)!.inviteHasSent,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kLightNeutralColor),
            ),
            const SizedBox(height: 10.0),
            Text(
              AppLocalizations.of(context)!.pleaseWaitResponse,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                setState(
                  () {
                    finish(context);
                  },
                );
              },
              child: Container(
                height: 40,
                width: 135,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: kPrimaryColor),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.gotIt,
                    style: kTextStyle.copyWith(color: kWhite, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AcceptProposalSuccessPopUp extends StatefulWidget {
  const AcceptProposalSuccessPopUp({Key? key}) : super(key: key);

  @override
  State<AcceptProposalSuccessPopUp> createState() => _AcceptProposalSuccessPopUpState();
}

class _AcceptProposalSuccessPopUpState extends State<AcceptProposalSuccessPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.acceptSuccess,
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => finish(context),
                  child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                ),
              ],
            ),
            const Divider(
              thickness: 1.0,
              color: kBorderColorTextField,
            ),
            const SizedBox(height: 20.0),
            Container(
              height: 124,
              width: 124,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: kPrimaryColor,
                size: 50,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              AppLocalizations.of(context)!.orderHasCreated,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kLightNeutralColor),
            ),
            const SizedBox(height: 10.0),
            Text(
              '${AppLocalizations.of(context)!.makeDeposit}\n${AppLocalizations.of(context)!.takeContactArtist}',
              maxLines: 3,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                setState(
                  () {
                    finish(context);
                  },
                );
              },
              child: Container(
                height: 40,
                width: 135,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: kPrimaryColor),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.gotIt,
                    style: kTextStyle.copyWith(color: kWhite, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateTimelineSuccessPopUp extends StatefulWidget {
  const CreateTimelineSuccessPopUp({Key? key}) : super(key: key);

  @override
  State<CreateTimelineSuccessPopUp> createState() => _CreateTimelineSuccessPopUpState();
}

class _CreateTimelineSuccessPopUpState extends State<CreateTimelineSuccessPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.createTimelineSuccess,
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => finish(context),
                  child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                ),
              ],
            ),
            const Divider(
              thickness: 1.0,
              color: kBorderColorTextField,
            ),
            const SizedBox(height: 20.0),
            Container(
              height: 124,
              width: 124,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: kPrimaryColor,
                size: 50,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              AppLocalizations.of(context)!.timlineHasCreated,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kLightNeutralColor),
            ),
            const SizedBox(height: 10.0),
            Text(
              '${AppLocalizations.of(context)!.pleaseWaitCustomer}\n${AppLocalizations.of(context)!.working}',
              maxLines: 3,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                setState(
                  () {
                    finish(context);
                  },
                );
              },
              child: Container(
                height: 40,
                width: 135,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: kPrimaryColor),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.gotIt,
                    style: kTextStyle.copyWith(color: kWhite, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveryPopUp extends StatefulWidget {
  final String? id;
  final Future<Order?> order;

  const DeliveryPopUp({Key? key, this.id, required this.order}) : super(key: key);

  @override
  State<DeliveryPopUp> createState() => _DeliveryPopUpState();
}

class _DeliveryPopUpState extends State<DeliveryPopUp> {
  final _formKey = GlobalKey<FormState>();

  late Future<Artwork?> artwork;

  int selectedPieces = 0;
  List<model.Size> sizes = [];

  List<int> weights = [];
  List<int> heights = [];

  @override
  void initState() {
    super.initState();

    artwork = getArtwork();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: FutureBuilder(
          future: artwork,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.addDelivery,
                        style: kTextStyle.copyWith(
                          color: kNeutralColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => finish(context),
                        child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                      ),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20.0),
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
                        const SizedBox(height: 10.0),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: selectedPieces,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                const SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    Text(
                                      '${index + 1}: ',
                                      style: kTextStyle.copyWith(
                                        color: kSubTitleColor,
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        cursorColor: kNeutralColor,
                                        textInputAction: TextInputAction.next,
                                        decoration: kInputDecoration.copyWith(
                                          labelText: AppLocalizations.of(context)!.weight,
                                          labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                          hintText: 'g',
                                          hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                          focusColor: kNeutralColor,
                                          border: const OutlineInputBorder(),
                                        ),
                                        onChanged: (value) {
                                          try {
                                            setState(() {
                                              weights[index] = int.tryParse(value)!;
                                            });
                                          } catch (error) {
                                            setState(() {
                                              weights.add(int.tryParse(value)!);
                                            });
                                          }
                                        },
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (!isFloatNumber(value, isRequired: true)) {
                                            return AppLocalizations.of(context)!.numberRequire;
                                          }

                                          if (int.tryParse(value!)! < 100) {
                                            return '${AppLocalizations.of(context)!.minimumWeight}\n100g';
                                          }

                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        cursorColor: kNeutralColor,
                                        textInputAction: TextInputAction.next,
                                        decoration: kInputDecoration.copyWith(
                                          labelText: AppLocalizations.of(context)!.height,
                                          labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                          hintText: 'cm',
                                          hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                          focusColor: kNeutralColor,
                                          border: const OutlineInputBorder(),
                                        ),
                                        onChanged: (value) {
                                          try {
                                            setState(() {
                                              heights[index] = int.tryParse(value)!;
                                            });
                                          } catch (error) {
                                            setState(() {
                                              heights.add(int.tryParse(value)!);
                                            });
                                          }
                                        },
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (!isFloatNumber(value, isRequired: true)) {
                                            return AppLocalizations.of(context)!.numberRequire;
                                          }

                                          if (int.tryParse(value!)! < 1) {
                                            return '${AppLocalizations.of(context)!.minimumHeight} \n${AppLocalizations.of(context)!.is1Cm}';
                                          }

                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: Button(
                          containerBg: kWhite,
                          borderColor: Colors.red,
                          buttonText: AppLocalizations.of(context)!.cancel,
                          textColor: Colors.red,
                          onPressed: () {
                            finish(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: Button(
                          containerBg: kPrimaryColor,
                          borderColor: Colors.transparent,
                          buttonText: AppLocalizations.of(context)!.deliver,
                          textColor: kWhite,
                          onPressed: () {
                            onDeliver();
                          },
                        ),
                      )
                    ],
                  )
                ],
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
    );
  }

  Future<Artwork?> getArtwork() async {
    try {
      return ArtworkApi().getOne(widget.id!, 'sizes').then((artwork) {
        setState(() {
          selectedPieces = artwork.pieces!;
          sizes.addAll(artwork.sizes!);
        });

        return artwork;
      });
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get pieces failed');
    }

    return null;
  }

  void onDeliver() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      ProgressDialogUtils.showProgress(context);

      for (int i = 0; i < selectedPieces; i++) {
        await SizeApi().patchOne(sizes[i].id.toString(), {
          'Weight': weights[i],
          'Height': heights[i],
        });
      }

      OrderDetailScreen.refresh();

      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);

      var order = await widget.order;
      var requirement = order!.orderDetails!.first.artwork!.proposal!.requirement;

      var user = await ChatFunction.getUserData(order.orderedBy.toString());

      FirebaseApi().sendNotification(
        // ignore: use_build_context_synchronously
        title: '${requirement!.title} ${AppLocalizations.of(context)!.orderCompletions}',
        // ignore: use_build_context_synchronously
        body: AppLocalizations.of(context)!.deliverBodyNot,
        receiverDeviceId: user.deviceId!,
        pageName: OrderDetailRoute.name,
        pathName: 'orderId',
        referenceId: order.id.toString(),
      );

      // ignore: use_build_context_synchronously
      finish(context);
    } catch (error) {
      Fluttertoast.showToast(msg: 'Update pieces failed');
    }
  }
}

class VerifyEmailSuccessPopUp extends StatefulWidget {
  const VerifyEmailSuccessPopUp({Key? key}) : super(key: key);

  @override
  State<VerifyEmailSuccessPopUp> createState() => _VerifyEmailSuccessPopUpState();
}

class _VerifyEmailSuccessPopUpState extends State<VerifyEmailSuccessPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.emailVerifiedSuccess,
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => finish(context),
                  child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                ),
              ],
            ),
            const Divider(
              thickness: 1.0,
              color: kBorderColorTextField,
            ),
            const SizedBox(height: 20.0),
            Container(
              height: 124,
              width: 124,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: kPrimaryColor,
                size: 50,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              AppLocalizations.of(context)!.thankYouVerify,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kLightNeutralColor),
            ),
            const SizedBox(height: 10.0),
            Text(
              AppLocalizations.of(context)!.pleaseLogin,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                setState(
                  () {
                    finish(context);
                  },
                );
              },
              child: Container(
                height: 40,
                width: 135,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: kPrimaryColor),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.gotIt,
                    style: kTextStyle.copyWith(color: kWhite, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
