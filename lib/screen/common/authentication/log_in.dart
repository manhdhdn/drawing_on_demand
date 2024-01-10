import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../core/utils/validation_function.dart';
import '../../../data/apis/account_api.dart';
import '../../../data/apis/api_config.dart';
import '../../../main.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../widgets/icons.dart';
import '../message/function/chat_function.dart';
import '../popUp/popup_2.dart';
import 'forgot_password.dart';

class Login extends StatefulWidget {
  final String? apiKey;
  final String? oobCode;

  const Login({Key? key, this.apiKey, this.oobCode}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController(text: PrefUtils().getSignInInfor()['Email'] ?? '');
  TextEditingController passwordController = TextEditingController(text: PrefUtils().getSignInInfor()['Password'] ?? '');

  bool hidePassword = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      if (widget.apiKey != null && widget.oobCode != null) {
        verifyEmailSuccessPopUp();
      }
    });
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();

    super.dispose();
  }

  void verifyEmailSuccessPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: const VerifyEmailSuccessPopUp(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: '$dod | Login',
      color: kPrimaryColor,
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: kDarkWhite,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0),
            ),
          ),
          toolbarHeight: 180,
          flexibleSpace: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 85,
                  width: 110,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('images/logo2.png'), fit: BoxFit.cover),
                  ),
                ),
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  Center(
                    child: Text(
                      'Log In Your Account',
                      style: kTextStyle.copyWith(
                        color: kNeutralColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: kNeutralColor,
                    textInputAction: TextInputAction.next,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Email',
                      labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                      hintText: 'Enter your email',
                      hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                      focusColor: kNeutralColor,
                      border: const OutlineInputBorder(),
                    ),
                    controller: emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      List<String> result = [];

                      if (value!.isEmpty) {
                        result.add('Please enter your email');
                      }

                      if (!isValidEmail(value)) {
                        result.add('Please enter a valid email address');
                      }

                      return result.isNotEmpty ? result.join('\n') : null;
                    },
                    autofillHints: const [AutofillHints.username],
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    cursorColor: kNeutralColor,
                    obscureText: hidePassword,
                    textInputAction: TextInputAction.done,
                    decoration: kInputDecoration.copyWith(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                      hintText: 'Please enter your password',
                      hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: Icon(
                          hidePassword ? Icons.visibility_off : Icons.visibility,
                          color: kLightNeutralColor,
                        ),
                      ),
                    ),
                    controller: passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }

                      return null;
                    },
                    autofillHints: const [AutofillHints.password],
                    onEditingComplete: () {
                      onLogin();
                    },
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => const ForgotPassword().launch(context),
                        child: Text(
                          'Forgot Password?',
                          style: kTextStyle.copyWith(color: kLightNeutralColor),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  ButtonGlobalWithoutIcon(
                      buttontext: 'Log In',
                      buttonDecoration: kButtonDecoration.copyWith(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      onPressed: () {
                        onLogin();
                      },
                      buttonTextColor: kWhite),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 1.0,
                          color: kBorderColorTextField,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text(
                          'Or Sign up with',
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 1.0,
                          color: kBorderColorTextField,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialIcon(
                          bgColor: kNeutralColor,
                          iconColor: kWhite,
                          icon: FontAwesomeIcons.facebookF,
                          borderColor: Colors.transparent,
                        ),
                        SizedBox(width: 15.0),
                        SocialIcon(
                          bgColor: kWhite,
                          iconColor: kNeutralColor,
                          icon: FontAwesomeIcons.google,
                          borderColor: kBorderColorTextField,
                        ),
                        // SocialIcon(
                        //   bgColor: kWhite,
                        //   iconColor: Color(0xFF76A9EA),
                        //   icon: FontAwesomeIcons.twitter,
                        //   borderColor: kBorderColorTextField,
                        // ),
                        // SocialIcon(
                        //   bgColor: kWhite,
                        //   iconColor: Color(0xFFFF554A),
                        //   icon: FontAwesomeIcons.instagram,
                        //   borderColor: kBorderColorTextField,
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        onCreateNewAccount();
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Don’t have an account? ',
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                          children: [
                            TextSpan(
                              text: 'Create New Account',
                              style: kTextStyle.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await PrefUtils().setSignInInfor({
        'Email': emailController.text.trim(),
        'Password': passwordController.text.trim(),
      });

      // ignore: use_build_context_synchronously
      ProgressDialogUtils.showProgress(context);

      await auth.signInWithEmailAndPassword(
        email: PrefUtils().getSignInInfor()['Email']!,
        password: PrefUtils().getSignInInfor()['Password']!,
      );

      var account = await AccountApi().gets(
        0,
        filter: "email eq '${PrefUtils().getSignInInfor()['Email']}'",
        expand: 'accountRoles(expand=role),rank',
      );

      if (account.value.first.status == 'Pending') {
        if (widget.apiKey == null && widget.oobCode == null) {
          // ignore: use_build_context_synchronously
          ProgressDialogUtils.hideProgress(context);
          Fluttertoast.showToast(msg: 'Please verify your email');

          auth.sendSignInLinkToEmail(
            email: PrefUtils().getSignInInfor()['Email']!,
            actionCodeSettings: ActionCodeSettings(
              url: '${ApiConfig.paymentUrl}${LoginRoute.tag}',
              handleCodeInApp: true,
            ),
          );

          return;
        } else {
          // ignore: use_build_context_synchronously
          String? uri = GoRouterState.of(context).uri.toString();

          if (auth.isSignInWithEmailLink('${ApiConfig.paymentUrl}$uri')) {
            AccountApi().patchOne(
              account.value.first.id.toString(),
              {
                'Status': 'Active',
              },
            );
          } else {
            throw Exception();
          }
        }
      }

      // Save account information
      await PrefUtils().setAccount(account.value.first);

      // Save token
      var token = await auth.currentUser!.getIdToken();
      await PrefUtils().setToken(token!);

      // Navigator
      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);

      var roles = account.value.first.accountRoles!.map((accountRole) => accountRole.role!.name).toSet();

      if (roles.contains('Artist')) {
        await PrefUtils().setRole('Artist');
        await PrefUtils().setRank(account.value.first.rank!.name!);
      } else if (roles.contains('Customer')) {
        await PrefUtils().setRole('Customer');
      } else {
        throw 'Account is not supported';
      }

      await PrefUtils().clearSignInInfor();

      onLogedIn();
    } catch (error) {
      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);
      // ignore: use_build_context_synchronously
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Invalid email or password'),
      //     closeIconColor: Colors.red,
      //   ),
      // );
      Fluttertoast.showToast(msg: 'Invalid email or password');
    }
  }

  void onLogedIn() {
    MyApp.refreshRoutes(context);

    ChatFunction.updateUserData({
      'isOnline': true,
    });

    context.goNamed(HomeRoute.name);
  }

  void onCreateNewAccount() {
    context.goNamed(WelcomeRoute.name);
  }
}
