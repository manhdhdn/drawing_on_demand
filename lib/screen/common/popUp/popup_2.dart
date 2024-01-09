import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/utils/pref_utils.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../data/apis/requirement_api.dart';
import '../../../data/models/requirement.dart';
import '../../widgets/constant.dart';
import '../../widgets/icons.dart';
import '../../client_screen/home/client_home_screen.dart';

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
                  image: AssetImage('images/robot.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'We’re processing\nyour Order',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Stay tuned...',
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
              'Your payment was\nnot successful',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Try again...',
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
                  'Are You Sure Cancel Your\nJob Post!',
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
              'This action will hide your requirement from artist. Do you want to continue?',
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
                    buttonText: 'No',
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
                    buttonText: 'Yes',
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
                  'Are You Sure Accept\nThis Proposal!',
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
              'This action will be permanent and also create an order. Do you want to continue?',
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
                    buttonText: 'No',
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
                    buttonText: 'Yes',
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
                  'Are You Sure Reject\nThis Proposal!',
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
              'This action will be permanent. Do you want to continue?',
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
                    buttonText: 'No',
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
                    buttonText: 'Yes',
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
                  'Choose Requirement',
                  style: kTextStyle.copyWith(color: kNeutralColor),
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
                    labelText: 'Requirement',
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
                    buttonText: 'Cancel',
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
                    buttonText: 'Invite',
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
                  'Invite Successful',
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
              'Your invite has been sent successfully',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kLightNeutralColor),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Please wait for Artist\'s response!',
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
                    'Got it!',
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
                  'Accept Successful',
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
              'Your order has also been created',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kLightNeutralColor),
            ),
            const SizedBox(height: 10.0),
            Text(
              'You can make a deposit now or after the Artist creates the timeline\nTake your time to contact with Artist',
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
                    'Got it!',
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
                  'Create Timeline Successful',
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
              'The timeline for your order has been created',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kLightNeutralColor),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Please wait for Customer make a deposit\nThen working and update the timeline with images',
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
                    'Got it!',
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
