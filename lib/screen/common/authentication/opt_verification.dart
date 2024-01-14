import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pinput/pinput.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../widgets/constant.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({Key? key}) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationId = '';

  final defaultPinTheme = const PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      color: kNeutralColor,
      fontWeight: FontWeight.w600,
    ),
  );

  Duration duration = const Duration(minutes: 1);

  @override
  void initState() {
    super.initState();

    PrefUtils().clearToken();
    sendCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: kNeutralColor),
        backgroundColor: kDarkWhite,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          'Verification',
          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'We’ve send the code to your phone',
                style: kTextStyle.copyWith(color: kSubTitleColor),
              ),
              Text(
                PrefUtils().getSignUpInfor()['Phone'],
                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    border: Border.all(color: kBorderColorTextField),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    border: Border.all(color: kNeutralColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                showCursor: false,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a code';
                  }

                  if (value.length < 6) {
                    return 'Please enter a valid code';
                  }

                  verifyCode(value);

                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              SlideCountdownSeparated(
                duration: duration,
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                ),
                onChanged: (value) {
                  setState(() {
                    duration = value;
                  });
                },
                shouldShowMinutes: (p0) {
                  return true;
                },
                shouldShowSeconds: (p0) {
                  return true;
                },
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn’t receive code? ',
                    style: kTextStyle.copyWith(color: kSubTitleColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      onResend();
                    },
                    child: Text(
                      'Resend Code',
                      style: kTextStyle.copyWith(color: kPrimaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendCode() async {
    await auth.verifyPhoneNumber(
      timeout: const Duration(minutes: 1),
      phoneNumber: '+84 ${PrefUtils().getSignUpInfor()['Phone']}',
      verificationCompleted: (PhoneAuthCredential credential) {
        context.goNamed(CreateProfileRoute.name);
      },
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(msg: e.message.toString());
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
      },
    );
  }

  void verifyCode(String code) async {
    try {
      ProgressDialogUtils.showProgress(context);

      var credential = await auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: code,
        ),
      );

      if (credential.user != null) {
        await PrefUtils().setToken((await credential.user!.getIdToken())!);
        // ignore: use_build_context_synchronously
        context.goNamed(CreateProfileRoute.name);
      }

      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);
    } catch (error) {
      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);
      Fluttertoast.showToast(msg: 'Invalid code');
    }
  }

  void onResend() {
    if (duration.inSeconds < 31) {
      setState(() {
        duration = const Duration(minutes: 1);
      });
    } else {
      Fluttertoast.showToast(msg: 'Please wait for at least 30 seconds before resend code');
    }
  }
}
