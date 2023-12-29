import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../core/utils/progress_dialog_utils.dart';
import '../../../data/apis/requirement_api.dart';
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
              style: kTextStyle.copyWith(
                  color: kNeutralColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
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
    await Future.delayed(const Duration(seconds: 3), () {
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
              'Your payment was not\nsuccessful',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(
                  color: kNeutralColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
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

class UploadRequirementsPopUp extends StatefulWidget {
  const UploadRequirementsPopUp({Key? key}) : super(key: key);

  @override
  State<UploadRequirementsPopUp> createState() =>
      _UploadRequirementsPopUpState();
}

class _UploadRequirementsPopUpState extends State<UploadRequirementsPopUp> {
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
                  style: kTextStyle.copyWith(
                      color: kNeutralColor, fontWeight: FontWeight.bold),
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
                image: DecorationImage(
                    image: AssetImage('images/success.png'), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 15.0),
            Text(
              'Congratulations!',
              style: kTextStyle.copyWith(
                  color: kNeutralColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Your profile is successfully completed. You can more changes after it\'s live.',
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
  final String id;

  const CancelJobPopUp({Key? key, required this.id}) : super(key: key);

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
                  style: kTextStyle.copyWith(
                      color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Icon(
                  FeatherIcons.x,
                  color: kSubTitleColor,
                )
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
    context.pop(false);
  }

  void onYes() async {
    try {
      await ProgressDialogUtils.showProgress(context);
      await RequirementApi().deleteOne(widget.id);

      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);

      // ignore: use_build_context_synchronously
      context.pop(true);
    } catch (error) {
      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);

      Fluttertoast.showToast(msg: errorSomethingWentWrong);
    }
  }
}

class CancelOrderPopUp extends StatefulWidget {
  const CancelOrderPopUp({Key? key}) : super(key: key);

  @override
  State<CancelOrderPopUp> createState() => _CancelOrderPopUpState();
}

class _CancelOrderPopUpState extends State<CancelOrderPopUp> {
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
            Text(
              'Why are you Cancel Order?',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: kTextStyle.copyWith(
                  color: kNeutralColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            const Divider(
              height: 1.0,
              thickness: 1.0,
              color: kBorderColorTextField,
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 2,
              cursorColor: kNeutralColor,
              textInputAction: TextInputAction.next,
              decoration: kInputDecoration.copyWith(
                  labelText: 'Enter Reason',
                  labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                  hintText:
                      'Lorem ipsum dolor sit amet, cons ectetur adipiscing elit.',
                  hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                  focusColor: kNeutralColor,
                  border: const OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: Button(
                    containerBg: kWhite,
                    borderColor: redColor,
                    buttonText: 'Cancel',
                    textColor: Colors.red,
                    onPressed: () {
                      setState(() {
                        finish(context);
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Button(
                    containerBg: kPrimaryColor,
                    borderColor: Colors.transparent,
                    buttonText: 'Confirm',
                    textColor: kWhite,
                    onPressed: () {
                      setState(() {
                        finish(context);
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
}
